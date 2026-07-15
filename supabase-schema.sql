# Check-up de Performance HERO

MVP estático do quiz HERO criado do zero a partir do briefing anexado.

## Como abrir

Abra `index.html` no navegador. O app funciona sem instalação e salva leads/eventos no `localStorage` do navegador.

## O que já está implementado

- Landing page premium com asset visual próprio.
- Cadastro obrigatório na tela inicial para liberar acesso ao quiz.
- Quiz mobile-first com uma pergunta por tela.
- Segmentação por perfil masculino/feminino.
- Formatos variados: múltipla escolha, escala deslizante e resposta aberta.
- Autoavanço em perguntas de múltipla escolha após o toque na resposta.
- Cards de evidência por sexo, com imagem realista, estatísticas reais e fontes oficiais.
- Perguntas gerais, específicas e de objetivo.
- Processamento com mensagens curtas, sem promessa clínica.
- Resultado com Índice HERO, dimensões, classificação, diagnóstico e plano de ação.
- Oferta com CTA para WhatsApp.
- Painel admin local em `?admin`.
- Páginas de privacidade, termos e aviso de saúde.

## Configurações rápidas

No arquivo `app.js`:

- Troque `WHATSAPP_NUMBER` pelo número oficial com DDI e DDD.
- O WhatsApp atual do CTA final está configurado como `5511924787933`.
- Preencha `integrations.webhookUrl` para enviar eventos a um webhook.
- Use `supabase-schema.sql` para criar as tabelas quando migrar o armazenamento do navegador para Supabase.

## Deploy na Netlify

O projeto já inclui `netlify.toml` e a Function `netlify/functions/diagnosis.mjs`.

Configuração recomendada na Netlify:

- Build command: deixe vazio.
- Publish directory: `.`
- Functions directory: `netlify/functions`
- Environment variables:
  - `OPENAI_API_KEY`: sua chave da OpenAI.
  - `OPENAI_MODEL`: opcional, padrão `gpt-5-mini`.

Com `OPENAI_API_KEY` configurada, o diagnóstico final chama a IA pela Function `/.netlify/functions/diagnosis`. Sem a chave, o app usa o diagnóstico local como fallback.

## Próxima etapa recomendada

Conectar Supabase, CRM e WhatsApp API usando o mesmo payload gerado pela função `persistEvent()` em `app.js`.
