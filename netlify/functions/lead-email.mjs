const DEFAULT_DESTINATION = "marcosestevees@icloud.com";
const RESEND_ENDPOINT = "https://api.resend.com/emails";

export async function handler(event) {
  if (event.httpMethod !== "POST") {
    return json({ error: "Method not allowed" }, 405);
  }

  try {
    const lead = JSON.parse(event.body || "{}");
    const destination = process.env.LEAD_EMAIL || DEFAULT_DESTINATION;

    if (!process.env.RESEND_API_KEY) {
      return json(
        {
          ok: false,
          delivered: false,
          destination,
          reason: "RESEND_API_KEY is not configured. Lead was still submitted to Netlify Forms.",
        },
        202,
      );
    }

    const response = await fetch(RESEND_ENDPOINT, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
      },
      body: JSON.stringify({
        from: process.env.RESEND_FROM_EMAIL || "HERO Quiz <onboarding@resend.dev>",
        to: [destination],
        subject: `Novo lead HERO: ${lead.firstName || "sem nome"}`,
        text: leadText(lead),
        html: leadHtml(lead),
      }),
    });

    if (!response.ok) {
      const detail = await response.text();
      return json({ ok: false, delivered: false, error: detail.slice(0, 500) }, 502);
    }

    const data = await response.json();
    return json({ ok: true, delivered: true, destination, providerId: data.id || "" });
  } catch (error) {
    return json({ ok: false, delivered: false, error: String(error.message || error) }, 500);
  }
}

function leadText(lead) {
  return [
    "Novo lead do Check-up HERO",
    "",
    `Nome: ${lead.firstName || "-"}`,
    `WhatsApp: ${lead.whatsapp || "-"}`,
    `E-mail: ${lead.email || "-"}`,
    `Perfil: ${lead.profile || "-"}`,
    `Etapa: ${lead.stage || "-"}`,
    `Consentimento: ${lead.consent || "-"}`,
    `Pagina: ${lead.pageUrl || "-"}`,
    `Data: ${lead.createdAt || "-"}`,
  ].join("\n");
}

function leadHtml(lead) {
  const rows = [
    ["Nome", lead.firstName],
    ["WhatsApp", lead.whatsapp],
    ["E-mail", lead.email],
    ["Perfil", lead.profile],
    ["Etapa", lead.stage],
    ["Consentimento", lead.consent],
    ["Pagina", lead.pageUrl],
    ["Data", lead.createdAt],
  ];

  return `
    <div style="font-family:Arial,sans-serif;color:#111827;line-height:1.5">
      <h1 style="font-size:22px;margin:0 0 16px">Novo lead do Check-up HERO</h1>
      <table cellpadding="8" cellspacing="0" style="border-collapse:collapse;width:100%;max-width:640px">
        ${rows
          .map(
            ([label, value]) => `
              <tr>
                <td style="font-weight:700;background:#f3f4f6;width:160px">${escapeHtml(label)}</td>
                <td>${escapeHtml(value || "-")}</td>
              </tr>
            `,
          )
          .join("")}
      </table>
    </div>
  `;
}

function escapeHtml(value) {
  return String(value || "")
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
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
