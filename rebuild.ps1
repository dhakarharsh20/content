# Read original file as bytes to preserve encoding
$bytes = [System.IO.File]::ReadAllBytes('d:\h\anti\Agent\index.html')
$content = [System.Text.Encoding]::UTF8.GetString($bytes)

# Find the markers
$startMarker = "// Aggregator`r`nlet resolveAggregator"
$altStartMarker = "// Aggregator`nlet resolveAggregator"

# Try to find the aggregator section
$aggIdx = $content.IndexOf("// Aggregator")
if ($aggIdx -lt 0) {
    Write-Output "ERROR: Could not find '// Aggregator' marker"
    exit 1
}

# Find the mock generators section start (after the AI research functions end)
$mockStart = $content.IndexOf("// Mock Content Generators")
if ($mockStart -lt 0) {
    # Try corrupted version
    $mockStart = $content.IndexOf("Mock Content Generators")
}
if ($mockStart -lt 0) {
    Write-Output "ERROR: Could not find Mock Content Generators"
    exit 1
}

# Go back to the line start before the comment block
$lineStart = $content.LastIndexOf("`n", $mockStart)
if ($lineStart -lt 0) { $lineStart = $mockStart } else { $lineStart++ }

# Find the section comment line BEFORE the mock generators
$sectionCommentStart = $content.LastIndexOf("`n", $lineStart - 2)
if ($sectionCommentStart -lt 0) { $sectionCommentStart = $lineStart } else { $sectionCommentStart++ }

# Find Pipeline Execution section
$pipelineStart = $content.IndexOf("Pipeline Execution")
if ($pipelineStart -lt 0) {
    Write-Output "ERROR: Could not find Pipeline Execution"
    exit 1
}

# Find the async function startPipeline line
$startPipelineIdx = $content.IndexOf("async function startPipeline()")
if ($startPipelineIdx -lt 0) {
    Write-Output "ERROR: Could not find startPipeline"
    exit 1
}

# Find stopPipeline function
$stopPipelineIdx = $content.IndexOf("function stopPipeline()")
if ($stopPipelineIdx -lt 0) {
    Write-Output "ERROR: Could not find stopPipeline"
    exit 1
}

# Go back to get the line before stopPipeline
$stopLineStart = $content.LastIndexOf("`n", $stopPipelineIdx)

Write-Output "Mock generators start at char: $sectionCommentStart"
Write-Output "Aggregator at char: $aggIdx"
Write-Output "Pipeline start at char: $startPipelineIdx"
Write-Output "Stop pipeline at char: $stopPipelineIdx"

# Build the new content:
# 1. Everything before the mock generators section
$before = $content.Substring(0, $sectionCommentStart)

# 2. New mock generators + new pipeline
$newCode = @'
// ═══════════════════════════════════════
// Turbo Mock Generators (topic-aware)
// ═══════════════════════════════════════
function generateMockBlog(topic) {
  return `# Comprehensive Guide to ${topic}

## Introduction

${topic} represents a critical area in modern industry. This guide explores the technical foundations, practical applications, and best practices for professionals.

## Technical Overview

| Parameter | Specification | Standard |
|-----------|--------------|----------|
| Operating Range | Application-specific | ISO/IEC |
| Accuracy | ±0.1% to ±1.0% | Calibrated |
| Response Time | Varies | Per spec |
| Service Life | 2-10 years | Maintained |

### Selection Criteria

* **Environmental conditions** - Temperature, humidity, chemical exposure
* **Accuracy requirements** - Process control tolerance
* **Installation constraints** - Physical space, mounting
* **Budget** - Initial cost vs. total cost of ownership
* **Compliance** - Industry-specific regulations

## Applications

1. **Manufacturing** - Process control, quality assurance
2. **Energy & Power** - Efficiency, safety
3. **Chemical Processing** - Reaction monitoring, safety
4. **Pharmaceuticals** - GMP compliance, batch consistency
5. **Food & Beverage** - HACCP, pasteurization control

## Conclusion

Proper ${topic} solutions deliver measurable returns through reduced downtime, improved quality, and regulatory compliance.

---

### FAQ

**How to select the right solution?**
Define accuracy requirements, environmental conditions, and budget first.

**What maintenance is required?**
Regular calibration (annual), visual inspections, component replacement.

**What standards apply?**
ISO 9001, IEC specifications, and industry-specific regulations.`;
}

function generateMockSocialCopy(topic) {
  return `# Social Media Content Pack: ${topic}

---

## LinkedIn Post

**Understanding ${topic}: What Industry Leaders Need to Know**

Key insights:
- Proper implementation reduces costs 15-30%
- Industry compliance requires certified solutions
- ROI typically within 12-18 months

#Industry #Engineering #B2B #Innovation

---

## Twitter/X Post

${topic} is evolving fast. Better accuracy, longer life, lower TCO. #Engineering #Innovation

---

## Facebook Post

**${topic}: A Complete Guide**

Technical specs, real-world examples, cost optimization, and latest trends.

---

## Instagram Caption

Precision matters. Quality delivers.
${topic} - the technology behind reliable operations worldwide.

#Engineering #Precision #B2B #Manufacturing

---

## WhatsApp Forward

*${topic} - Quick Reference*
- Key selection criteria
- Cost comparison insights
- Compliance checklist
- Top manufacturer overview`;
}

function generateMockNewsletter(topic) {
  return `# Email Newsletter: ${topic}

---

**Subject Line:** ${topic} - Technical Insights & Industry Updates

**Preheader:** Expert analysis, selection guides, latest developments.

---

Dear [First Name],

${topic} continues to evolve as industries demand higher performance and lower TCO.

---

### Featured: Complete Guide to ${topic}

- **Selection Matrix** - Match solutions to requirements
- **Technical Comparison** - Side-by-side analysis
- **Best Practices** - Proven methods for optimal performance
- **Cost Optimization** - Reduce TCO without sacrificing quality

---

### Industry Trends

- Digital integration and IoT connectivity
- Predictive maintenance capabilities
- Enhanced accuracy and reliability
- Sustainability focus
- Stricter compliance requirements

---

Best regards,
**The Technical Team**

_Unsubscribe: [link]_`;
}

// Aggregator
let resolveAggregator = null;
function handleAggregateSubmit() {
  if (resolveAggregator) {
    const editedText = document.getElementById('aggTextarea').value;
    resolveAggregator(editedText);
    resolveAggregator = null;
    closeP();
  }
}

// ═══════════════════════════════════════
// Pipeline Execution
// ═══════════════════════════════════════
async function startPipeline() {
  if (running) return;
  running = true;
  
  const turbo = document.getElementById('turboToggle').checked;
  const delayTime = turbo ? 10 : 800;
  
  const topic = document.getElementById('topicInput').value.trim() || 'Thermocouples for Glass Industry';
  document.getElementById('startBtn').disabled = true;
  R = {};
  
  document.getElementById('log').innerHTML = '';
  uS('Executing Workflow...', 'y');
  lg(`Pipeline started: ${topic}`, 'i');
  toast('Pipeline execution launched!');
  
  let pCount = 0;
  function bump() {
    pCount++;
    document.getElementById('aC').textContent = String(pCount);
  }
  
  // ── Node 1: Start ──
  setS('start', 'running...', 'active');
  await delay(delayTime);
  R['start'] = { err: false, text: `Triggered on topic: "${topic}"` };
  setS('start', 'done', 'done');
  bump();
  
  // ── Node 2: AI Deep Research ──
  setS('searchGoogle', 'researching...', 'active');
  lg('AI Deep Research: analyzing topic...', 'i');
  let researchResult;
  if (turbo) {
    await delay(50);
    researchResult = { err: false, text: `[AI Research Brief for "${topic}"]\n\n${topic} is a critical area in industrial applications. Research covers technical specs, market landscape, key manufacturers, standards, applications, and best practices.\n\nKey areas:\n- Technical parameters and specs\n- Industry standards (ISO, IEC, ASTM)\n- Leading manufacturers and products\n- Market size and trends\n- Application sectors\n- Installation best practices` };
  } else {
    researchResult = await aiDeepResearch(topic);
  }
  R['searchGoogle'] = researchResult;
  if (researchResult.err) {
    setS('searchGoogle', 'failed', 'err');
    toast('AI Research failed!', false);
    stopPipeline(); return;
  }
  setS('searchGoogle', 'done', 'done');
  bump();
  lg('AI deep research completed.', 'o');
  
  // ── Node 3: Technical Analysis ──
  setS('extractUrls', 'analyzing...', 'active');
  lg('Running technical deep-dive...', 'i');
  let techResult;
  if (turbo) {
    await delay(30);
    techResult = { err: false, text: `[Technical Analysis for "${topic}"]\n\nDetailed specs, comparison tables, material science data, benchmarks, and selection criteria for ${topic}.` };
  } else {
    techResult = await aiTechnicalAnalysis(topic, researchResult.text);
  }
  R['extractUrls'] = techResult;
  setS('extractUrls', 'done', 'done');
  bump();
  lg('Technical analysis completed.', 'o');
  
  // ── Node 4: Market Intelligence ──
  setS('fetchUrlContent', 'gathering intel...', 'active');
  lg('Gathering market intelligence...', 'i');
  let marketResult;
  if (turbo) {
    await delay(30);
    marketResult = { err: false, text: `[Market Intelligence for "${topic}"]\n\nMarket size, growth projections, competitive landscape, key players, pricing, and future outlook for ${topic}.` };
  } else {
    marketResult = await aiMarketIntelligence(topic, researchResult.text);
  }
  R['fetchUrlContent'] = marketResult;
  setS('fetchUrlContent', 'done', 'done');
  bump();
  lg('Market intelligence gathered.', 'o');
  
  // ── Node 5: Compile Brief ──
  setS('extractText', 'compiling...', 'active');
  await delay(turbo ? 10 : 500);
  const compiledBrief = [
    '# RESEARCH BRIEF: ' + topic,
    '',
    '## Section 1: Deep Research',
    researchResult.text,
    '',
    '## Section 2: Technical Analysis',
    techResult.text,
    '',
    '## Section 3: Market Intelligence',
    marketResult.text
  ].join('\n');
  R['extractText'] = { err: false, text: compiledBrief };
  setS('extractText', 'done', 'done');
  bump();
  lg('Research brief compiled - ' + compiledBrief.length + ' chars.', 'o');
  
  // ── Node 6: Aggregate & Review ──
  setS('aggregateContent', 'review required...', 'active');
  uS('Manual Approval Required', 'y');
  
  let approvedText;
  if (turbo) {
    lg('Turbo: Auto-approving.', 'i');
    await delay(50);
    approvedText = compiledBrief;
  } else {
    lg('Research brief ready. Waiting for approval...', 'y');
    showOut('aggregateContent');
    approvedText = await new Promise(resolve => { resolveAggregator = resolve; });
  }
  R['aggregateContent'] = { err: false, text: approvedText };
  setS('aggregateContent', 'done', 'done');
  bump();
  lg('Brief approved. Launching generation...', 'o');
  uS('Generating Content...', 'y');
  
  // ═══════════════════════════════════════
  // PARALLEL FAN-OUT: 6 output nodes
  // ═══════════════════════════════════════
  const context = approvedText.substring(0, 6000);
  
  // ── Task: Generate Blog ──
  async function taskBlog() {
    setS('generateBlog', 'writing article...', 'active');
    lg('Writing blog from research...', 'i');
    let res;
    if (turbo) {
      await delay(100);
      res = { err: false, text: generateMockBlog(topic) };
    } else {
      const prompt = `Using this research, write a comprehensive blog post about "${topic}".

RESEARCH:
${context}

REQUIREMENTS:
- 1000-1500 words, professional B2B tone
- Use SPECIFIC data, numbers, facts from the research
- Include: SEO headings, comparison table, bullet points
- Include 3 FAQ questions with detailed answers from the research
- Reference real companies, products, standards from the research
- Every paragraph must contain specific factual information
- Write as a knowledgeable industry expert`;
      res = await callFreeLLM(prompt, 'You are a senior B2B technical writer. Write with authority using real data from the research. Every claim must be backed by facts.');
    }
    R['generateBlog'] = res;
    if (res.err) { setS('generateBlog', 'failed', 'err'); }
    else { setS('generateBlog', 'done', 'done'); bump(); lg('Blog completed.', 'o'); }
  }
  
  // ── Task: Social Media Copy ──
  async function taskSocial() {
    setS('socialCopy', 'writing posts...', 'active');
    lg('Generating social copy from research...', 'i');
    let res;
    if (turbo) {
      await delay(80);
      res = { err: false, text: generateMockSocialCopy(topic) };
    } else {
      const prompt = `Using this research about "${topic}", create social media posts:

RESEARCH:
${context.substring(0, 3000)}

Create for each platform:
1. **LinkedIn** (200+ words) - Professional thought leadership with specific data
2. **Twitter/X** (under 280 chars) - Punchy insight with hashtags
3. **Facebook** - Engaging, highlight key benefits
4. **Instagram** - Visual caption with emojis and hashtags
5. **WhatsApp** - Short shareable forward with key facts

Each post must use SPECIFIC facts from the research.`;
      res = await callFreeLLM(prompt, 'You are a B2B social media strategist. Create engaging posts using real data. No generic fluff.');
    }
    R['socialCopy'] = res;
    if (res.err) { setS('socialCopy', 'failed', 'err'); }
    else { setS('socialCopy', 'done', 'done'); bump(); lg('Social copy completed.', 'o'); }
  }
  
  // ── Task: Email Newsletter ──
  async function taskEmail() {
    setS('emailNewsletter', 'drafting...', 'active');
    lg('Generating newsletter from research...', 'i');
    let res;
    if (turbo) {
      await delay(90);
      res = { err: false, text: generateMockNewsletter(topic) };
    } else {
      const prompt = `Using this research about "${topic}", create email newsletter copy for CRM (Zoho, HubSpot):

RESEARCH:
${context.substring(0, 3000)}

Include:
- Subject line (compelling, specific)
- Preheader text
- Opening paragraph with a specific insight
- 3-4 key highlights with REAL data from research
- Comparison table if relevant
- Clear CTA
- Professional closing

PLAIN TEXT copy for CRM email campaigns. Use specific facts.`;
      res = await callFreeLLM(prompt, 'You are a B2B email marketing specialist. Write newsletter copy using real data. Plain text for CRM tools.');
    }
    R['emailNewsletter'] = res;
    if (res.err) { setS('emailNewsletter', 'failed', 'err'); }
    else { setS('emailNewsletter', 'done', 'done'); bump(); lg('Newsletter completed.', 'o'); }
  }
  
  // ── Task: Blog Images (3) ──
  async function taskBlogImages() {
    setS('blogImages', 'generating 3 images...', 'active');
    lg('Generating 3 blog hero images...', 'i');
    const prompts = [
      `Photorealistic wide-angle photograph of a modern industrial facility showcasing ${topic}, advanced equipment and technology in operation, clean well-lit environment with blue and white color scheme, 4K commercial photography, no text or watermarks`,
      `Close-up macro photograph of precision ${topic} components arranged on a dark slate surface, dramatic side lighting creating depth and shadows, professional product photography, ultra-detailed textures, no text`,
      `Engineering team reviewing ${topic} data on large digital displays in a modern control room, warm professional lighting, corporate photography showing collaboration and expertise, no text`
    ];
    const images = [];
    for (let i = 0; i < prompts.length; i++) {
      setS('blogImages', `rendering ${i+1}/3...`, 'active');
      if (turbo) {
        images.push({ url: `https://image.pollinations.ai/prompt/${encodeURIComponent(prompts[i])}?width=1024&height=576&nologo=true&seed=${Date.now()+i}`, prompt: prompts[i] });
        await delay(10);
      } else {
        const r = await callGeminiImagen(prompts[i], 1024, 576);
        images.push({ url: r.fallback ? r.url : r.b64, prompt: prompts[i] });
      }
    }
    R['blogImages'] = { err: false, text: `Generated ${images.length} blog images.`, images };
    setS('blogImages', 'done', 'done');
    bump();
    lg('Blog images generated.', 'o');
  }
  
  // ── Task: Social Images (2) ──
  async function taskSocialImages() {
    setS('socialImages', 'generating 2 images...', 'active');
    lg('Generating 2 social media images...', 'i');
    const prompts = [
      `Bold infographic-style social media visual about ${topic}, central icon with radiating data points, modern flat design with vibrant blue and teal gradient, clean typography spaces, square 1:1 format, professional B2B style, no text`,
      `Split-screen comparison visual for ${topic}, left side traditional approach in muted tones, right side modern solution in vibrant colors, clean dividing line, square format, marketing style, no text`
    ];
    const images = [];
    for (let i = 0; i < prompts.length; i++) {
      setS('socialImages', `rendering ${i+1}/2...`, 'active');
      if (turbo) {
        images.push({ url: `https://image.pollinations.ai/prompt/${encodeURIComponent(prompts[i])}?width=1024&height=1024&nologo=true&seed=${Date.now()+i+10}`, prompt: prompts[i] });
        await delay(10);
      } else {
        const r = await callGeminiImagen(prompts[i], 1024, 1024);
        images.push({ url: r.fallback ? r.url : r.b64, prompt: prompts[i] });
      }
    }
    R['socialImages'] = { err: false, text: `Generated ${images.length} social images.`, images };
    setS('socialImages', 'done', 'done');
    bump();
    lg('Social images generated.', 'o');
  }
  
  // ── Task: Email Images (2) ──
  async function taskEmailImages() {
    setS('emailImages', 'generating 2 images...', 'active');
    lg('Generating 2 email banner images...', 'i');
    const prompts = [
      `Wide panoramic email banner for ${topic}, sleek abstract visualization with flowing blue light trails and geometric shapes, dark navy background fading to white, professional premium feel, ultrawide format, no text`,
      `Professional product showcase banner for ${topic}, components in elegant grid on clean white background with subtle shadows, catalog-quality photography, wide format, no text`
    ];
    const images = [];
    for (let i = 0; i < prompts.length; i++) {
      setS('emailImages', `rendering ${i+1}/2...`, 'active');
      if (turbo) {
        images.push({ url: `https://image.pollinations.ai/prompt/${encodeURIComponent(prompts[i])}?width=1024&height=576&nologo=true&seed=${Date.now()+i+20}`, prompt: prompts[i] });
        await delay(10);
      } else {
        const r = await callGeminiImagen(prompts[i], 1024, 576);
        images.push({ url: r.fallback ? r.url : r.b64, prompt: prompts[i] });
      }
    }
    R['emailImages'] = { err: false, text: `Generated ${images.length} email images.`, images };
    setS('emailImages', 'done', 'done');
    bump();
    lg('Email images generated.', 'o');
  }

'@

# 3. Everything from stopPipeline onwards
$after = $content.Substring($stopLineStart)

# Combine
$newContent = $before + $newCode + $after

# Write with proper UTF-8 encoding
[System.IO.File]::WriteAllText('d:\h\anti\Agent\index.html', $newContent, (New-Object System.Text.UTF8Encoding $true))
Write-Output "SUCCESS: File rebuilt. Old chars: $($content.Length), New chars: $($newContent.Length)"
