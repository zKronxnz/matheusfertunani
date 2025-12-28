# Square Cloud Setup Guide

## Passos para Configurar o Deploy Automático

### 1. Configurar Secrets no GitHub
No seu repositório GitHub, vá em Settings > Secrets and variables > Actions e adicione:

- `SQUARE_TOKEN`: Token da API da Square Cloud
  - Como pegar: vá em https://squarecloud.app/dashboard > API
- `SQUARE_APPLICATION_ID`: ID da sua aplicação
  - Depois do primeiro upload, aparecerá no dashboard

### 2. Primeiro Deploy Manual
Rode o primeiro deploy manualmente para criar a aplicação:

```bash
# Instalar CLI da Square Cloud (se não tiver)
curl -fsSL https://cli.squarecloud.app/install | bash

# Gerar site estático
hugo --gc --minify

# Fazer primeiro upload
cd public
squarecloud upload
```

Copie o ID da aplicação que aparecer no terminal e adicione ao secret `SQUARE_APPLICATION_ID`.

### 3. Testar Deploy Automático
Faça um commit para testar:
```bash
git add .
git commit -m "Configurar deploy automático Square Cloud"
git push origin master
```

Acompanhe o deploy em GitHub Actions. Após sucesso, seu site estará em:
https://matheusfertunani.squareweb.app

## Troubleshooting

### Erro comum: "SQUARE_APPLICATION_ID not found"
- Faça o primeiro upload manual primeiro
- Copie o ID correto do dashboard
- Verifique se o secret está configurado exatamente

### Deploy não atualiza
- Verifique se os secrets estão corretos
- Verifique o log do GitHub Actions
- Confirme se está fazendo push na branch `master`

---

Agora é só escrever posts e dar git push! 🚀