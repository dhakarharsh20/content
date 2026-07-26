const fetch = require('node-fetch');

async function test() {
  try {
    const r = await fetch('https://text.pollinations.ai/', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({
        messages: [{role: 'user', content: 'hello'}],
        model: 'openai'
      })
    });
    console.log(r.status);
    console.log(await r.text());
  } catch(e) {
    console.error(e);
  }
}
test();
