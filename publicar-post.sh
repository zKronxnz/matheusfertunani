#!/bin/bash

# Script completo para criar post E fazer commit automaticamente
# Uso: ./publicar-post.sh "Título do Post" "url-amigavel" (opcional)

set -e

# Cores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}📝 Criando novo post...${NC}"

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Uso: ./publicar-post.sh \"Título do Post\" \"url-amigavel\"${NC}"
    echo -e "${YELLOW}Exemplo: ./publicar-post.sh \"Meu Novo Post\" \"meu-novo-post\"${NC}"
    exit 1
fi

TITLE="$1"
SLUG="${2:-$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')}"
YEAR=$(date +%Y)
DATE=$(date '+%Y-%m-%dT%H:%M:%S-00:00')
DATE_FORMATTED=$(date '+%d/%m/%Y')

# Criar diretório
POST_DIR="content/$YEAR/$SLUG"
mkdir -p "$POST_DIR"

# Criar arquivo do post
cat > "$POST_DIR/index.md" << EOF
---
title: $TITLE
date: '$DATE'
slug: $SLUG
tags:
- novo-post
type: post
draft: false
---

# $TITLE

Escreva seu conteúdo aqui...

EOF

echo -e "${GREEN}✅ Post criado: $POST_DIR/index.md${NC}"

# Atualizar página inicial
echo -e "${BLUE}📝 Atualizando página inicial...${NC}"
if [ -f "content/_index.md" ]; then
    # Criar backup
    cp content/_index.md content/_index.md.bak
    
    # Adicionar novo post após "## Posts Recentes"
    NEW_POST_LINE="- [$TITLE](/$YEAR/$SLUG/) - $DATE_FORMATTED"
    
    # Usar awk para adicionar linha após "## Posts Recentes"
    awk '
    /^## Posts Recentes$/ { 
        print; 
        print "'"$NEW_POST_LINE"'"; 
        next 
    } 
    { print } 
    ' content/_index.md > content/_index_temp.md
    
    mv content/_index_temp.md content/_index.md
    echo -e "${GREEN}✅ Página inicial atualizada!${NC}"
    
    # Remover backup se tudo deu certo
    rm content/_index.md.bak
else
    echo -e "${RED}❌ Arquivo content/_index.md não encontrado${NC}"
    exit 1
fi

# Atualizar página do blog
echo -e "${BLUE}📝 Atualizando página do blog...${NC}"
if [ -f "content/blog/_index.md" ]; then
    # Criar backup
    cp content/blog/_index.md content/blog/_index.md.bak
    
    # Adicionar novo post antes da última linha
    NEW_BLOG_ENTRY="## [$TITLE](/$YEAR/$SLUG/)
**Publicado em:** $DATE_FORMATTED
**Tags:** novo-post
---"
    
    # Inserir antes da linha final
    head -n -1 content/blog/_index.md > content/blog_temp.md
    echo "$NEW_BLOG_ENTRY" >> content/blog_temp.md
    echo "" >> content/blog_temp.md
    echo "*Novos posts aparecerão aqui automaticamente quando você os criar!*" >> content/blog_temp.md
    mv content/blog_temp.md content/blog/_index.md
    
    echo -e "${GREEN}✅ Página do blog atualizada!${NC}"
    rm content/blog/_index.md.bak
else
    echo -e "${RED}❌ Arquivo content/blog/_index.md não encontrado${NC}"
    exit 1
fi

# Fazer commit e push automaticamente
echo -e "${BLUE}🚀 Fazendo commit e push...${NC}"
git add .
git commit -m "Novo post: $TITLE"

# Verificar se tem remote configurado
if git remote get-url origin >/dev/null 2>&1; then
    echo -e "${BLUE}📤 Enviando para GitHub...${NC}"
    git push origin master
    echo -e "${GREEN}🎉 Post publicado com sucesso!${NC}"
    echo -e "${BLUE}🌐 Acesse em: https://matheusfertunani.squareweb.app/$YEAR/$SLUG/${NC}"
    echo -e "${GREEN}⏳ O site estará atualizado em 1-2 minutos!${NC}"
else
    echo -e "${RED}❌ Remote 'origin' não configurado${NC}"
    echo -e "${YELLOW}Configure com: git remote add origin <seu-repo-url>${NC}"
    echo -e "${YELLOW}Depois rode: git push origin master${NC}"
fi

echo -e "${GREEN}✨ Pronto! Seu post está online! ✨${NC}"