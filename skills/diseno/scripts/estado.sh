#!/usr/bin/env bash
# estado.sh [ruta-del-proyecto]: ¿están instalados los paquetes que orquesta /diseno y qué hay en el proyecto?
# Imprime KEY=VALOR por línea. exit 1 si falta un paquete requerido (y muestra el comando de instalación).
C="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
S="$C/skills"
P="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
miss=0; need_taste=0; need_emil=0

chk() { # chk KEY carpeta  → busca SKILL.md en el proyecto y luego en global
  for d in "$P/.claude/skills/$2" "$S/$2"; do
    if [ -f "$d/SKILL.md" ]; then echo "$1=$d"; return 0; fi
  done
  echo "$1=MISSING"; return 1
}

echo "DISENO=$HERE"
chk IMPECCABLE impeccable \
  || { miss=1; echo "  instalar: (cd ~ && npx -y impeccable install --providers=claude --scope=global --no-hooks)"; }
chk TASTE design-taste-frontend || { miss=1; need_taste=1; }
chk REDESIGN redesign-existing-projects || { miss=1; need_taste=1; }
[ "$need_taste" = 1 ] && echo "  instalar: (cd ~ && npx -y skills@latest add Leonxlnx/taste-skill -g -a claude-code -y -s design-taste-frontend redesign-existing-projects)"
chk ANIMATE animate || { miss=1; need_emil=1; }
chk REVIEW_ANIM review-animations || { miss=1; need_emil=1; }
chk PROTOTYPE prototype || need_emil=1   # opcional (solo ruta de variantes); no bloquea
[ "$need_emil" = 1 ] && echo "  instalar: (cd ~ && npx -y skills@latest add emilkowalski/skills -g -a claude-code -y -s animate review-animations prototype)"

echo "NODE=$(node -v 2>/dev/null || echo MISSING)"

# Impeccable instalado además como plugin (quedaría con namespace impeccable:... y Skill no lo encuentra)
if grep -qsi impeccable "$C/plugins/installed_plugins.json" \
   || ls -d "$C"/plugins/cache/*/impeccable* >/dev/null 2>&1 \
   || ls -d "$C"/plugins/marketplaces/*impeccable* >/dev/null 2>&1; then
  echo "AVISO=Impeccable también está instalado como plugin. Desinstálalo desde /plugin y usa solo la instalación por npx."
fi
# Hook global de Impeccable (corre en todos los proyectos; lo instala npx impeccable install/update sin --no-hooks)
if grep -qs 'impeccable/scripts/hook.mjs' "$C/settings.local.json" "$C/settings.json" 2>/dev/null; then
  echo "AVISO=Hay un hook global de Impeccable en $C/settings.local.json o settings.json; corre en todos tus proyectos. Borra ese bloque hooks si no lo quieres."
fi

for f in PRODUCT.md DESIGN.md; do
  if [ -f "$P/$f" ]; then echo "$f=si"; else echo "$f=no"; fi
done
[ -f "$P/package.json" ] && echo "PACKAGE_JSON=si" || echo "PACKAGE_JSON=no"

# ¿hay decisiones visuales en código? (css, scss, vue, svelte, astro, html, tailwind), ignorando dependencias y builds
hit="$(find "$P" -maxdepth 4 \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name .nuxt -o -name .output -o -name vendor -o -name .impeccable -o -name test -o -name tests -o -name __tests__ -o -name fixtures -o -name coverage \) -prune -o -type f \( -name '*.css' -o -name '*.scss' -o -name '*.sass' -o -name '*.less' -o -name '*.vue' -o -name '*.svelte' -o -name '*.astro' -o -name '*.html' -o -name 'tailwind.config.*' \) -print 2>/dev/null | head -1)"
if [ -n "$hit" ]; then echo "UI_CODE=si (${hit#"$P"/})"; else echo "UI_CODE=no"; fi
exit $miss
