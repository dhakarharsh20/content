$openaiKey = "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"
$googleKey = "AIzaSyBX2EVmJg2ZCiylHBzZRilrDXvKZhP5x7o"

Write-Host "Testing Google Gemini API..."
try {
    $body = @{ contents = @( @{ parts = @( @{ text = "Say Hello" } ) } ) } | ConvertTo-Json -Depth 5
    $res = Invoke-RestMethod -Uri "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$googleKey" -Method Post -ContentType "application/json" -Body $body
    Write-Host "Google Success: $($res.candidates[0].content.parts[0].text)"
} catch {
    Write-Host "Google Error: $_"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody"
    }
}

Write-Host "`nTesting OpenAI API..."
try {
    $headers = @{ Authorization = "Bearer $openaiKey" }
    $body = @{ model = "gpt-4o-mini"; messages = @( @{ role = "user"; content = "Say Hello" } ) } | ConvertTo-Json -Depth 5
    $res = Invoke-RestMethod -Uri "https://api.openai.com/v1/chat/completions" -Method Post -ContentType "application/json" -Headers $headers -Body $body
    Write-Host "OpenAI Success: $($res.choices[0].message.content)"
} catch {
    Write-Host "OpenAI Error: $_"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Response Body: $responseBody"
    }
}
