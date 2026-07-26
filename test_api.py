import urllib.request
import json
import ssl

req = urllib.request.Request('https://text.pollinations.ai/', method='POST')
req.add_header('Content-Type', 'application/json')
data = json.dumps({"messages": [{"role": "user", "content": "hello"}], "model": "mistral"})
try:
    with urllib.request.urlopen(req, data=data.encode('utf-8'), context=ssl._create_unverified_context()) as response:
        print(response.status)
        print(response.read().decode('utf-8'))
except urllib.error.HTTPError as e:
    print(f"HTTP Error: {e.code}")
    print(e.read().decode('utf-8'))
except Exception as e:
    print(e)
