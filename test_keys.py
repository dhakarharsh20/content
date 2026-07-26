import urllib.request
import json
import ssl

OPENAI_KEY = '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'
GOOGLE_KEY = 'AIzaSyBX2EVmJg2ZCiylHBzZRilrDXvKZhP5x7o'
context = ssl._create_unverified_context()

def test_google():
    print("Testing Google Key...")
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={GOOGLE_KEY}"
    req = urllib.request.Request(url, method='POST')
    req.add_header('Content-Type', 'application/json')
    data = json.dumps({"contents": [{"parts": [{"text": "Say hello"}]}]})
    try:
        with urllib.request.urlopen(req, data=data.encode('utf-8'), context=context) as response:
            print("Google Status:", response.status)
            print("Google Response:", response.read().decode('utf-8')[:200])
    except Exception as e:
        print("Google Error:", e)

def test_openai():
    print("Testing OpenAI Key...")
    url = "https://api.openai.com/v1/chat/completions"
    req = urllib.request.Request(url, method='POST')
    req.add_header('Content-Type', 'application/json')
    req.add_header('Authorization', f'Bearer {OPENAI_KEY}')
    data = json.dumps({
        "model": "gpt-4o-mini",
        "messages": [{"role": "user", "content": "Say hello"}]
    })
    try:
        with urllib.request.urlopen(req, data=data.encode('utf-8'), context=context) as response:
            print("OpenAI Status:", response.status)
            print("OpenAI Response:", response.read().decode('utf-8')[:200])
    except Exception as e:
        if hasattr(e, 'read'):
            print("OpenAI Error:", e.code, e.read().decode('utf-8')[:200])
        else:
            print("OpenAI Error:", e)

test_google()
test_openai()
