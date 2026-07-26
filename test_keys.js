const fetch = require('node-fetch');

const OPENAI_KEY = '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';
const GOOGLE_KEY = 'AIzaSyBX2EVmJg2ZCiylHBzZRilrDXvKZhP5x7o';

async function testGoogle() {
  console.log('Testing Google Key...');
  try {
    const r = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GOOGLE_KEY}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: 'Say hello' }] }]
      })
    });
    console.log('Google Status:', r.status);
    const json = await r.json();
    console.log('Google Response:', JSON.stringify(json).substring(0, 200));
  } catch (e) {
    console.error('Google Error:', e);
  }
}

async function testOpenAI() {
  console.log('Testing OpenAI Key...');
  try {
    const r = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${OPENAI_KEY}`
      },
      body: JSON.stringify({
        model: 'gpt-4o-mini',
        messages: [{ role: 'user', content: 'Say hello' }]
      })
    });
    console.log('OpenAI Status:', r.status);
    const json = await r.json();
    console.log('OpenAI Response:', JSON.stringify(json).substring(0, 200));
  } catch (e) {
    console.error('OpenAI Error:', e);
  }
}

async function main() {
  await testGoogle();
  await testOpenAI();
}

main();
