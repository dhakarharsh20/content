$lines = Get-Content 'd:\h\anti\Agent\index.html'
$newLines = $lines[0..1325] + $lines[1591..($lines.Length-1)]
Set-Content -Path 'd:\h\anti\Agent\index.html' -Value $newLines -Encoding UTF8
Write-Output "Done. Lines before: $($lines.Length), after: $($newLines.Length)"
