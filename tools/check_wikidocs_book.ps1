$ErrorActionPreference = "Stop"

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$root = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$errors = New-Object System.Collections.Generic.List[string]

function Get-RelativePath([string]$Path) {
  $prefix = $root.Path.TrimEnd([char[]]@([char]92, [char]47)) + [System.IO.Path]::DirectorySeparatorChar
  if ($Path.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
    return $Path.Substring($prefix.Length)
  }
  return $Path
}

function Remove-MarkdownCodeBlocks([string]$Text) {
  return [regex]::Replace(
    $Text,
    '(?ms)^```.*?^```',
    ""
  )
}

function Resolve-MarkdownTarget([string]$BaseDir, [string]$Target) {
  $parts = $Target -split '#'
  $clean = $parts[0]
  if ([string]::IsNullOrWhiteSpace($clean)) {
    return $null
  }
  return Join-Path $BaseDir $clean
}

$required = @("README.md", "TOC.md", "pages", "assets")
foreach ($item in $required) {
  $path = Join-Path $root.Path $item
  if (-not (Test-Path -LiteralPath $path)) {
    $errors.Add("Missing required item: $item")
  }
}

$markdownFiles = Get-ChildItem -LiteralPath $root.Path -Recurse -File -Filter "*.md"
$allowedAuthor = "AI_Innovation_Studio"
$allowedAuthorPattern = "(?im)^\s*(?:[-*]\s*)?(\uC800\uC790|author)\s*:\s*$([regex]::Escape($allowedAuthor))\s*$"
$githubClassicTokenPrefix = "g" + "hp_"
$githubOauthTokenPrefix = "g" + "ho_"
$githubUserTokenPrefix = "g" + "hu_"
$githubServerTokenPrefix = "g" + "hs_"
$githubFineGrainedTokenPrefix = "github" + "_pat_"
$openAiTokenPrefix = "s" + "k-"
$googleApiKeyPrefix = "A" + "Iza"
$awsAccessKeyPrefix = "A" + "KIA"

$secretPatterns = @(
  "$githubClassicTokenPrefix[A-Za-z0-9_]{20,}",
  "$githubOauthTokenPrefix[A-Za-z0-9_]{20,}",
  "$githubUserTokenPrefix[A-Za-z0-9_]{20,}",
  "$githubServerTokenPrefix[A-Za-z0-9_]{20,}",
  "$githubFineGrainedTokenPrefix[A-Za-z0-9_]{20,}",
  "$openAiTokenPrefix[A-Za-z0-9]{20,}",
  "xox[baprs]-[A-Za-z0-9-]{10,}",
  "$googleApiKeyPrefix[0-9A-Za-z_-]{20,}",
  "$awsAccessKeyPrefix[0-9A-Z]{16}",
  "-----BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----"
)

$secretAssignmentNames = @(
  "api[_-]?key",
  "access[_-]?token",
  "refresh[_-]?token",
  "client[_-]?secret",
  "private[_-]?key",
  "password",
  "passwd",
  "secret"
)
$secretAssignmentPattern = "(?i)(" + ($secretAssignmentNames -join "|") + ")\s*[:=]\s*[^\s``""']+"

$personalDataPatterns = @(
  "(?<![A-Za-z0-9._%+-])[A-Za-z0-9._%+-]{1,64}@[A-Za-z0-9.-]{1,253}\.[A-Za-z]{2,}(?![A-Za-z0-9._%+-])",
  "open\.kakao\.com/o/[A-Za-z0-9]+",
  "01[016789]-?[0-9]{3,4}-?[0-9]{4}"
)

$binaryPersonalDataPatterns = @(
  ("lee" + "manrank"),
  "open\.kakao\.com/o/[A-Za-z0-9]+"
)

$bannedPatterns = @(
  @{ Pattern = '\*\*'; Label = 'Markdown bold marker' },
  @{ Pattern = '[\uD800-\uDFFF]'; Label = 'emoji marker' },
  @{ Pattern = '\uC644\uBCBD|\uC644\uC804'; Label = 'overstated expression' }
)

$blockedExtensions = @(
  ".pdf",
  ".doc",
  ".docx",
  ".hwp",
  ".hwpx",
  ".xlsx",
  ".pptx",
  ".pem",
  ".key",
  ".p12",
  ".pfx",
  ".zip",
  ".7z",
  ".rar"
)

foreach ($file in $markdownFiles) {
  $relativeFile = Get-RelativePath $file.FullName
  $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $body = Remove-MarkdownCodeBlocks $text

  $authorMatches = [regex]::Matches($body, '(?im)^\s*(?:[-*]\s*)?(\uC800\uC790|author)\s*:\s*(.+?)\s*$')
  if (-not ($body -match $allowedAuthorPattern)) {
    $errors.Add("Missing required author in ${relativeFile}: expected $allowedAuthor")
  }
  foreach ($authorMatch in $authorMatches) {
    $authorValue = $authorMatch.Groups[2].Value.Trim()
    if ($authorValue -ne $allowedAuthor) {
      $errors.Add("Unauthorized author in ${relativeFile}: expected $allowedAuthor")
    }
  }

  foreach ($banned in $bannedPatterns) {
    if ($text -match $banned.Pattern) {
      $errors.Add("Forbidden style marker in ${relativeFile}: $($banned.Label)")
    }
  }

  foreach ($secretPattern in $secretPatterns) {
    if ($text -match $secretPattern) {
      $errors.Add("Secret-like pattern in ${relativeFile}")
    }
  }
  if ($text -match $secretAssignmentPattern) {
    $errors.Add("Secret-assignment-like pattern in ${relativeFile}")
  }

  foreach ($personalDataPattern in $personalDataPatterns) {
    if ($text -match $personalDataPattern) {
      $errors.Add("Personal-data-like pattern in ${relativeFile}")
    }
  }

  if ($relativeFile -match '(^|[\\/])[0-9]{3}-part\.md$' -and $text -match '(?m)^## Part [1-9]\.') {
    $errors.Add("Unpadded part number in ${relativeFile}: use Part 01 through Part 09")
  }

  if ($relativeFile -match '^pages\\([0-9]{3})-' -or $relativeFile -match '^pages/([0-9]{3})-') {
    $fileNumber = $Matches[1]
    $firstLine = ($text -split "(`r`n|`n|`r)", 2)[0]
    if ($fileNumber -notin @("900", "999") -and $firstLine -notmatch "^## $fileNumber(\.| |-)") {
      if ($relativeFile -notmatch '\\[0-9]{3}-part\.md$' -and $relativeFile -notmatch '/[0-9]{3}-part\.md$' -and $relativeFile -notmatch '101-appendix\.md$') {
        $errors.Add("Page heading number mismatch in ${relativeFile}: expected $fileNumber")
      }
    }
  }

  $matches = [regex]::Matches($body, '(!?\[[^\]]*\]\(([^)]+)\))')

  foreach ($match in $matches) {
    $target = $match.Groups[2].Value.Trim()
    if ($target -match '^(https?:|mailto:|#)' -or [string]::IsNullOrWhiteSpace($target)) {
      continue
    }

    $resolved = Resolve-MarkdownTarget (Split-Path -Parent $file.FullName) $target
    if ($null -ne $resolved -and -not (Test-Path -LiteralPath $resolved)) {
      $errors.Add("Broken markdown target in ${relativeFile}: $target")
    }
  }
}

$tocPath = Join-Path $root.Path "TOC.md"
if (Test-Path -LiteralPath $tocPath) {
  $tocText = [System.IO.File]::ReadAllText($tocPath, [System.Text.Encoding]::UTF8)
  $tocBody = Remove-MarkdownCodeBlocks $tocText
  if ($tocText -match '(?m)^- \[Part [1-9]\.') {
    $errors.Add("TOC has unpadded part number: use Part 01 through Part 09")
  }
  $tocMatches = [regex]::Matches($tocBody, '\[[^\]]+\]\((pages/[^)]+\.md)\)')
  foreach ($match in $tocMatches) {
    $target = Join-Path $root.Path $match.Groups[1].Value
    if (-not (Test-Path -LiteralPath $target)) {
      $errors.Add("TOC points to missing page: $($match.Groups[1].Value)")
    }
  }

  $tocNumbers = New-Object System.Collections.Generic.List[int]
  foreach ($match in $tocMatches) {
    $path = $match.Groups[1].Value
    if ($path -match 'pages/([0-9]{3})-' -and $Matches[1] -notin @("900", "999") -and $path -notmatch '/[0-9]{3}-part\.md$' -and $path -notmatch '/101-appendix\.md$') {
      $tocNumbers.Add([int]$Matches[1])
    }
  }
  foreach ($expected in 0..120) {
    if ($expected -eq 0) {
      $expectedString = "000"
    } else {
      $expectedString = "{0:000}" -f $expected
    }
    if (-not ($tocNumbers -contains $expected)) {
      $errors.Add("TOC is missing page number: $expectedString")
    }
  }
  for ($i = 0; $i -lt $tocNumbers.Count; $i++) {
    if ($i -le 120 -and $tocNumbers[$i] -ne $i) {
      $errors.Add("TOC page order mismatch at position ${i}: expected $("{0:000}" -f $i), found $("{0:000}" -f $tocNumbers[$i])")
      break
    }
  }
  $duplicateTocNumbers = $tocNumbers | Group-Object | Where-Object { $_.Count -gt 1 }
  foreach ($duplicate in $duplicateTocNumbers) {
    $errors.Add("TOC has duplicate page number: $("{0:000}" -f [int]$duplicate.Name)")
  }
}

$readmePath = Join-Path $root.Path "README.md"
if (Test-Path -LiteralPath $readmePath) {
  $readmeText = [System.IO.File]::ReadAllText($readmePath, [System.Text.Encoding]::UTF8)
  if ($readmeText -notmatch "(?m)^- \uC800\uC790: $([regex]::Escape($allowedAuthor))$") {
    $errors.Add("README.md must declare author as $allowedAuthor")
  }
}

$generatorPath = Join-Path $root.Path "tools/generate_wikidocs_book.ps1"
if (Test-Path -LiteralPath $generatorPath) {
  $generatorText = [System.IO.File]::ReadAllText($generatorPath, [System.Text.Encoding]::UTF8)
  if ($generatorText -notmatch "(?m)^\`$author\s*=\s*`"$([regex]::Escape($allowedAuthor))`"\s*$") {
    $errors.Add("generate_wikidocs_book.ps1 must set author to $allowedAuthor")
  }
}

$pageNumbers = New-Object System.Collections.Generic.HashSet[int]
$seenPageNumbers = New-Object 'System.Collections.Generic.Dictionary[int,string]'
$pageFiles = Get-ChildItem -LiteralPath (Join-Path $root.Path "pages") -File -Filter "*.md" -ErrorAction SilentlyContinue
foreach ($pageFile in $pageFiles) {
  if ($pageFile.Name -match '^([0-9]{3})-' -and $Matches[1] -notin @("900", "999") -and $pageFile.Name -notmatch '^[0-9]{3}-part\.md$' -and $pageFile.Name -ne '101-appendix.md') {
    $number = [int]$Matches[1]
    if ($seenPageNumbers.ContainsKey($number)) {
      $errors.Add("Duplicate numbered page file: $("{0:000}" -f $number) in $($seenPageNumbers[$number]) and $(Get-RelativePath $pageFile.FullName)")
    } else {
      $seenPageNumbers.Add($number, (Get-RelativePath $pageFile.FullName))
    }
    [void]$pageNumbers.Add($number)
  }
}
foreach ($expected in 0..120) {
  if (-not $pageNumbers.Contains($expected)) {
    $errors.Add("Missing numbered page file: $("{0:000}" -f $expected)")
  }
}

$assetFiles = Get-ChildItem -LiteralPath (Join-Path $root.Path "assets") -File -ErrorAction SilentlyContinue
foreach ($asset in $assetFiles) {
  if ($asset.Extension -ieq ".png" -and $asset.Length -le 0) {
    $errors.Add("Empty image asset: $(Get-RelativePath $asset.FullName)")
  }
}

$allFiles = Get-ChildItem -LiteralPath $root.Path -Recurse -File -Force |
  Where-Object { $_.FullName -notmatch '\\.git\\' }
foreach ($file in $allFiles) {
  if ($blockedExtensions -contains $file.Extension.ToLowerInvariant()) {
    $errors.Add("Blocked file extension found: $(Get-RelativePath $file.FullName)")
  }

  $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
  $asciiText = [System.Text.Encoding]::ASCII.GetString($bytes)
  foreach ($secretPattern in $secretPatterns) {
    if ($asciiText -match $secretPattern) {
      $errors.Add("Secret-like pattern in $(Get-RelativePath $file.FullName)")
    }
  }
  foreach ($personalDataPattern in $binaryPersonalDataPatterns) {
    if ($asciiText -match $personalDataPattern) {
      $errors.Add("Personal-data-like pattern in $(Get-RelativePath $file.FullName)")
    }
  }

  if ($file.Extension.ToLowerInvariant() -in @(".md", ".ps1", ".json", ".txt", ".yml", ".yaml")) {
    $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
    foreach ($secretPattern in $secretPatterns) {
      if ($text -match $secretPattern) {
        $errors.Add("Secret-like pattern in $(Get-RelativePath $file.FullName)")
      }
    }
    if ($text -match $secretAssignmentPattern) {
      $errors.Add("Secret-assignment-like pattern in $(Get-RelativePath $file.FullName)")
    }
    foreach ($personalDataPattern in $personalDataPatterns) {
      if ($text -match $personalDataPattern) {
        $errors.Add("Personal-data-like pattern in $(Get-RelativePath $file.FullName)")
      }
    }
  }
}

if ($errors.Count -gt 0) {
  Write-Host "WikiDocs book check failed:" -ForegroundColor Red
  foreach ($errorItem in $errors) {
    Write-Host "- $errorItem"
  }
  exit 1
}

Write-Host "WikiDocs book check passed."
Write-Host "Markdown files: $($markdownFiles.Count)"
Write-Host "Asset files: $($assetFiles.Count)"
