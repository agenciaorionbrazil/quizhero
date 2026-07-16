# Check-up de Performance HERO

MVP estatico do quiz HERO criado do zero a partir do briefing anexado.

## Como abrir

Abra `index.html` no navegador. O app funciona sem instalacao e salva leads/eventos no `localStorage` do navegador.

## O que ja esta implementado

- Landing page premium com cadastro obrigatorio para liberar acesso ao quiz.
- Quiz mobile-first com uma pergunta por tela.
- Segmentacao por perfil masculino/feminino.
- Formatos variados: multipla escolha, escala deslizante e resposta aberta.
- Autoavanco em perguntas de multipla escolha apos o toque na resposta.
- Cards de evidencia por sexo, com imagem realista, estatisticas reais e fontes oficiais.
- Resultado com Indice HERO, dimensoes, classificacao, diagnostico e plano de acao.
- Oferta com CTA para WhatsApp configurado em `5511924787933`.
- Painel admin local em `?admin`.
- Paginas de privacidade, termos e aviso de saude.

## Configuracoes rapidas

No arquivo `app.js`:

- Troque `WHATSAPP_NUMBER` pelo numero oficial com DDI e DDD, se necessario.
- Preencha `integrations.webhookUrl` para enviar eventos a um webhook.
- Use `supabase-schema.sql` para criar as tabelas quando migrar o armazenamento do navegador para Supabase.

## Deploy na Netlify

Este projeto inclui um `netlify.toml` minimo, valido e sem caracteres especiais.

O erro anterior acontecia porque o arquivo `netlify.toml` do GitHub estava com conteudo de JavaScript dentro dele. A Netlify precisa que esse arquivo tenha apenas TOML valido.

Conteudo correto do `netlify.toml`:

```toml
[build]
  publish = "."
  functions = "netlify/functions"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

Configuracao recomendada na Netlify:

- Build command: deixe vazio.
- Publish directory: `.`
- Functions directory: `netlify/functions`.
- Environment variables:
  - `OPENAI_API_KEY`: sua chave da OpenAI.
  - `OPENAI_MODEL`: opcional, padrao `gpt-5-mini`.

Com `OPENAI_API_KEY` configurada, o diagnostico final chama a IA pela Function `/.netlify/functions/diagnosis`. Sem a chave, o app usa o diagnostico local como fallback.

Importante para deploy via GitHub: substitua todo o conteudo do `netlify.toml` no GitHub pelo bloco acima, faca commit e rode o deploy novamente.

## Proxima etapa recomendada

Conectar Supabase, CRM e WhatsApp API usando o mesmo payload gerado pela funcao `persistEvent()` em `app.js`.
