const OPENAI_ENDPOINT = "https://api.openai.com/v1/responses";
const DEFAULT_MODEL = "gpt-5-mini";

export async function handler(event) {
  if (event.httpMethod !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  if (!process.env.OPENAI_API_KEY) {
    return json({ error: "OPENAI_API_KEY is not configured" }, 503);
  }

  try {
    const payload = JSON.parse(event.body || "{}");
    const compact = compactPayload(payload);

    const response = await fetch(OPENAI_ENDPOINT, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.OPENAI_API_KEY}`,
      },
      body: JSON.stringify({
        model: process.env.OPENAI_MODEL || DEFAULT_MODEL,
        input: [
          {
            role: "system",
            content:
              "Você é a Inteligência HERO, uma camada de análise de performance não médica. Gere diagnóstico humano, específico e prudente em português do Brasil. Não faça diagnóstico clínico, hormonal, psicológico ou nutricional. Não prometa resultado. Seja direto, premium e individualizado.",
          },
          {
            role: "user",
            content: buildPrompt(compact),
          },
        ],
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      return json({ error: "OpenAI request failed", detail: errorText.slice(0, 500) }, 502);
    }

    const data = await response.json();
    const output = extractOutputText(data);
    const parsed = parseJsonOutput(output);

    return json({
      aiGenerated: true,
      diagnosis: normalizeList(parsed.diagnosis, 5),
      actions: normalizeList(parsed.actions, 5),
      summary: String(parsed.summary || "").slice(0, 420),
    });
  } catch (error) {
    return json({ error: "Could not generate diagnosis", detail: String(error.message || error) }, 500);
  }
}

function compactPayload(payload) {
  const result = payload.result || {};
  const answers = Object.entries(payload.answers || {}).map(([id, answer]) => ({
    id,
    question: answer.question,
    answer: answer.answer,
    score: answer.score,
    tag: answer.tag,
  }));

  return {
    leadFirstName: payload.lead?.firstName || "",
    profile: payload.profile || "",
    overall: result.overall,
    classification: result.classification,
    metrics: result.metrics,
    tags: result.tags || [],
    answers,
  };
}

function buildPrompt(compact) {
  return `
Analise este check-up HERO e devolva apenas JSON válido.

Estrutura obrigatória:
{
  "summary": "1 frase curta com a leitura central",
  "diagnosis": [
    "O que identificamos...",
    "Como isso aparece na vida real...",
    "Principal risco...",
    "Potencial...",
    "Próximo passo..."
  ],
  "actions": [
    "ação inicial 1",
    "ação inicial 2",
    "ação inicial 3",
    "ação inicial 4",
    "ação inicial 5"
  ]
}

Regras:
- Use o primeiro nome se fizer sentido.
- Considere respostas abertas literalmente.
- Diferencie homem/mulher apenas pela jornada informada, sem estereótipos.
- Seja específico, emocionalmente inteligente e aplicável em 7 dias.
- Não use linguagem médica, diagnóstico clínico, prescrição alimentar ou promessa de cura.
- Não cite que é IA.

Dados do lead e quiz:
${JSON.stringify(compact, null, 2)}
`.trim();
}

function extractOutputText(data) {
  if (typeof data.output_text === "string") return data.output_text;

  const parts = [];
  for (const item of data.output || []) {
    for (const content of item.content || []) {
      if (content.type === "output_text" && content.text) parts.push(content.text);
      if (content.type === "text" && content.text) parts.push(content.text);
    }
  }
  return parts.join("\n").trim();
}

function parseJsonOutput(text) {
  const cleaned = String(text || "")
    .replace(/^```json\s*/i, "")
    .replace(/^```\s*/i, "")
    .replace(/```$/i, "")
    .trim();
  try {
    return JSON.parse(cleaned);
  } catch {
    const start = cleaned.indexOf("{");
    const end = cleaned.lastIndexOf("}");
    if (start >= 0 && end > start) {
      return JSON.parse(cleaned.slice(start, end + 1));
    }
    throw new Error("AI output was not valid JSON");
  }
}

function normalizeList(value, count) {
  if (!Array.isArray(value)) return [];
  return value.map((item) => String(item || "").trim()).filter(Boolean).slice(0, count);
}

function json(body, statusCode = 200) {
  return {
    statusCode,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
    },
    body: JSON.stringify(body),
  };
}
