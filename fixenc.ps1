$content = [System.IO.File]::ReadAllText('d:\h\anti\Agent\index.html', [System.Text.Encoding]::GetEncoding('utf-8'))
$content = $content -replace 'â€"', '—'
$content = $content -replace 'â€™', "'"
$content = $content -replace 'â€œ', '"'
$content = $content -replace 'â€', '"'
$content = $content -replace 'Â°', '°'
$content = $content -replace 'â•', '═'
$content = $content -replace 'â""', '─'
$content = $content -replace 'âœ"', '✓'
$content = $content -replace 'âœ—', '✗'
$content = $content -replace 'â±³', '⏳'
$content = $content -replace 'âš¡', '⚡'
$content = $content -replace 'âš ï¸', '⚠️'
$content = $content -replace 'â""', '─'
[System.IO.File]::WriteAllText('d:\h\anti\Agent\index.html', $content, [System.Text.Encoding]::UTF8)
Write-Output "Encoding fixed"
