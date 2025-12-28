# Matheus Fertunani Blog

Blog estático desenvolvido com Hugo e deploy automático via GitHub Actions para Square Cloud.

## 🚀 Como Criar Novos Posts

### Método 1: Automático (Recomendado)
```bash
./publicar-post.sh "Título do meu post" "url-amigavel"
```

### Método 2: Manual
1. Criar diretório: `content/ANO/url-amigavel/`
2. Criar arquivo `index.md` com template
3. Atualizar `content/_index.md` e `content/blog/_index.md`
4. Fazer commit e push

## 📁 Estrutura do Projeto

```
├── content/              # Conteúdo do site
│   ├── _index.md        # Página inicial
│   ├── blog/
│   │   └── _index.md   # Página do blog
│   └── 2025/
│       └── post-1/
│           └── index.md
├── layouts/              # Templates personalizados
├── static/              # Arquivos estáticos
├── hugo.yaml           # Configuração do Hugo
├── squarecloud.app      # Configuração da Square Cloud
├── .github/
│   └── workflows/
│       └── deploy.yml   # GitHub Actions
├── criar-post.sh       # Script para criar posts
└── publicar-post.sh    # Script completo (criar + publicar)
```

## 🔧 Configuração de Deploy

O site faz deploy automático via GitHub Actions para Square Cloud:
- **Trigger**: Push na branch `master`
- **Build**: Hugo generates static site
- **Deploy**: Square Cloud CLI
- **URL**: https://matheusfertunani.squareweb.app

## ⚙️ Variáveis de Ambiente Necessárias

No repositório GitHub, configure os Secrets:
- `SQUARE_TOKEN`: Token da API da Square Cloud
- `SQUARE_APPLICATION_ID`: ID da aplicação na Square Cloud

## 📝 Exemplo de Post Front Matter

```yaml
---
title: Título do Post
date: '2025-12-28T10:00:00-00:00'
slug: url-amigavel
tags:
- tag1
- tag2
type: post
draft: false
---
```

## 🌐 Deploy Automático

1. Escreva post com `./publicar-post.sh "Título" "slug"`
2. Pronto! O site atualiza automaticamente após o push.

---

*Este README será útil para futuro desenvolvimento e manutenção.*
