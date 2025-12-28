#!/bin/bash

# Script para criar posts automaticamente
# Uso: ./criar-post.sh "Título do Post" "url-amigavel"

set -e

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar argumentos
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Uso: ./criar-post.sh \"Título do Post\" \"url-amigavel\"${NC}"
    echo -e "${YELLOW}Exemplo: ./criar-post.sh \"Meu Novo Post\" \"meu-novo-post\"${NC}"
    exit 1
fi

TITLE="$1"
SLUG="${2:-$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//;s/-$//')}"
YEAR=$(date +%Y)
DATE=$(date '+%Y-%m-%dT%H:%M:%S-00:00')

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

echo -e "${GREEN}✅ Post criado com sucesso!${NC}"
echo -e "${BLUE}📁 Localização: $POST_DIR/index.md${NC}"
echo -e "${BLUE}🌐 URL: https://matheusfertunani.squareweb.app/$YEAR/$SLUG/${NC}"
echo -e "${YELLOW}💡 Para publicar: git add . && git commit -m \"Novo post: $TITLE\" && git push${NC}"

# Atualizar página inicial automaticamente
if [ -f "content/_index.md" ]; then
    # Adicionar post à lista de posts recentes
    DATE_FORMATTED=$(date '+%d/%m/%Y')
    NEW_POST_LINE="- [$TITLE](/$YEAR/$SLUG/) - $DATE_FORMATTED"
    
    # Verificar se já existe a linha de Posts Recentes
    if grep -q "## Posts Recentes" content/_index.md; then
        # Inserir após a linha "## Posts Recentes"
        sed -i "/## Posts Recentes/a $NEW_POST_LINE" content/_index.md
        echo -e "${GREEN}✅ Página inicial atualizada!${NC}"
    else
        echo -e "${YELLOW}⚠️  Verifique a página inicial manualmente${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Arquivo content/_index.md não encontrado${NC}"
fi

echo -e "${GREEN}🚀 Pronto para fazer commit e push!${NC}"