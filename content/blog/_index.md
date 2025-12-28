---
title: Blog
---

# Todos os Posts

{{ range (where site.RegularPages "Section" "in" (slice "2025" "2024" "2023" "2022" "2021")) }}
## [{{ .Title }}]({{ .RelPermalink }})
**Publicado em:** {{ .Date.Format "02/01/2006" }} 

{{ if .Params.tags }}**Tags:** {{ delimit .Params.tags ", " }}{{ end }}

---

{{ end }}