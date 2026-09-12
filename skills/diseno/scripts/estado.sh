#!/usr/bin/env bash
# estado.sh [ruta-del-proyecto]: ¿están instalados los paquetes que orquesta /diseno y qué hay en el proyecto?
# Imprime KEY=VALOR por línea. exit 1 si falta un paquete requerido (y muestra el comando de instalación).
# Funciona en cualquier agente: busca los paquetes en las rutas de Claude y en el canónico universal .agents/skills.
C="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
P="${1:-${CLAUDE_PROJECT_DIR:-$PWD}}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAME="$(basename "$HERE")"
miss=0; need_taste=0; need_emil=0; PKG_ROOT=""

# ¿Claude Code? Solo ahí tienen sentido los avisos de plugin y de hooks, y el flag -a claude-code.
if [ -n "$CLAUDECODE" ] || [ -n "$CLAUDE_CONFIG_DIR" ] || [ -n "$CLAUDE_PROJECT_DIR" ]; then EN_CLAUDE=1; else EN_CLAUDE=0; fi
[ "$EN_CLAUDE" = 1 ] && AG="claude-code" || AG="universal"

# Raíces donde puede vivir una skill, en orden de precedencia: proyecto antes que global,
# Claude antes que el canónico universal (para no cambiar el comportamiento actual en Claude).
ROOTS="$P/.claude/skills
$P/.agents/skills
$C/skills
$HOME/.agents/skills"
# Carpetas propias de agentes no universales dentro del proyecto: la CLI skills deja ahí un symlink al canónico.
for extra in "$P/.opencode/skills" "$P/.codex/skills" "$P/.cursor/skills" "$P/.gemini/skills" "$P/.github/skills"; do
  [ -d "$extra" ] && ROOTS="$ROOTS
$extra"
done

chk() { # chk KEY carpeta  → busca SKILL.md en cada raíz, en orden; deja la ruta en $FOUND
  FOUND=""
  while IFS= read -r r; do
    [ -n "$r" ] || continue
    if [ -f "$r/$2/SKILL.md" ]; then
      FOUND="$r/$2"; [ -n "$PKG_ROOT" ] || PKG_ROOT="$r"; echo "$1=$FOUND"; return 0
    fi
  done <<EOF
$ROOTS
EOF
  echo "$1=MISSING"; return 1
}

# ¿Desde dónde se resolvió esta misma skill? Primero por ruta lógica (única forma de distinguir
# raíces que son symlinks al mismo canónico) y, como respaldo, por ruta física: así se reconoce
# igual el caso ~/.claude/skills/diseno → el repo. Es informativo, no decide capacidades.
agente="otro"
HERE_P="$(cd "$HERE" && pwd -P)"
P_P="$(cd "$P" 2>/dev/null && pwd -P)"
HOME_P="$(cd "$HOME" 2>/dev/null && pwd -P)"
PARES="$P/.claude/skills:claude-proyecto
$P/.agents/skills:agents-proyecto
$C/skills:claude-global
$HOME/.agents/skills:agents-global"
# Si el directorio de trabajo ES el HOME, sus raíces no son "de proyecto": son las globales.
if [ -n "$P_P" ] && [ "$P_P" = "$HOME_P" ]; then
  PARES="$C/skills:claude-global
$HOME/.agents/skills:agents-global"
fi
while IFS= read -r par; do
  [ -n "$par" ] || continue
  d="${par%:*}"; k="${par##*:}"
  if [ "$HERE" = "$d/$NAME" ]; then agente="$k"; break; fi
done <<EOF
$PARES
EOF
if [ "$agente" = "otro" ]; then
  while IFS= read -r par; do
    [ -n "$par" ] || continue
    d="${par%:*}"; k="${par##*:}"
    [ -d "$d/$NAME" ] || continue
    if [ "$(cd "$d/$NAME" 2>/dev/null && pwd -P)" = "$HERE_P" ]; then agente="$k"; break; fi
  done <<EOF
$PARES
EOF
fi

echo "DISENO=$HERE"
echo "AGENTE=$agente"
chk IMPECCABLE impeccable || { miss=1
  if [ "$EN_CLAUDE" = 1 ]; then
    echo "  instalar: (cd ~ && npx -y impeccable install --providers=claude --scope=global --no-hooks)"
  else
    echo "  instalar: (cd ~ && npx -y impeccable install --providers=claude --scope=global --no-hooks) y luego (cd ~ && npx -y skills@latest add ~/.claude/skills/impeccable -g -a $AG)"
  fi; }
IMP="$FOUND"   # capturar aquí: las siguientes llamadas a chk sobrescriben $FOUND
chk TASTE design-taste-frontend || { miss=1; need_taste=1; }
chk REDESIGN redesign-existing-projects || { miss=1; need_taste=1; }
[ "$need_taste" = 1 ] && echo "  instalar: (cd ~ && npx -y skills@latest add Leonxlnx/taste-skill -g -a $AG -y -s design-taste-frontend redesign-existing-projects)"
chk ANIMATE animate || { miss=1; need_emil=1; }
chk REVIEW_ANIM review-animations || { miss=1; need_emil=1; }
chk PROTOTYPE prototype || need_emil=1   # opcional (solo ruta de variantes); no bloquea
[ "$need_emil" = 1 ] && echo "  instalar: (cd ~ && npx -y skills@latest add emilkowalski/skills -g -a $AG -y -s animate review-animations prototype)"
echo "SKILLS_DIR=${PKG_ROOT:-no}"

# UI/UX Pro Max: opcional (piso de conocimiento en Fase 2b y referencias externas). Nunca bloquea.
uipro=""
while IFS= read -r r; do
  [ -n "$r" ] || continue
  for d in "$r/ui-ux-pro-max/scripts/search.py" "$r"/ui-ux-pro-max/*/scripts/search.py; do
    if [ -f "$d" ]; then uipro="$d"; break; fi
  done
  [ -n "$uipro" ] && break
done <<EOF
$ROOTS
EOF
if [ -n "$uipro" ]; then
  echo "UIPRO=$uipro"
else
  echo "UIPRO=no"
  echo "  opcional: (cd ~ && npx -y ui-ux-pro-max-cli init --ai claude --global)"
fi

echo "NODE=$(node -v 2>/dev/null || echo MISSING)"
command -v python3 >/dev/null 2>&1 && echo "PYTHON3=si" || echo "PYTHON3=no"

# Qué CLI de Impeccable hay: 4.3 trae un launcher binario; 4.1 trae scripts Node (detect.mjs)
if [ -n "$IMP" ] && [ -f "$IMP/scripts/impeccable" ]; then echo "IMPECCABLE_CLI=launcher"
elif [ -n "$IMP" ] && [ -f "$IMP/scripts/detect.mjs" ]; then echo "IMPECCABLE_CLI=node"
else echo "IMPECCABLE_CLI=MISSING"; fi
impv=""
# 4.1.x trae version: al nivel superior; 4.3.x la movio dentro de metadata:, indentada.
[ -n "$IMP" ] && impv="$(grep -m1 -E '^[[:space:]]*version:' "$IMP/SKILL.md" 2>/dev/null | sed -E 's/^[[:space:]]*version:[[:space:]]*//; s/[[:space:]"]//g')"
echo "IMPECCABLE_VERSION=${impv:-?}"

if [ "$EN_CLAUDE" = 1 ]; then
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
fi

for f in PRODUCT.md DESIGN.md; do
  if [ -f "$P/$f" ]; then echo "$f=si"; else echo "$f=no"; fi
done
[ -f "$P/package.json" ] && echo "PACKAGE_JSON=si" || echo "PACKAGE_JSON=no"

# Librerías de movimiento y 3D ya declaradas en el proyecto (sin jq): decide si hay que instalar algo
libs=""
if [ -f "$P/package.json" ]; then
  for l in gsap lenis three @barba/core motion framer-motion swiper; do
    grep -qE "\"$l\"[[:space:]]*:" "$P/package.json" 2>/dev/null && libs="${libs:+$libs,}$l"
  done
fi
echo "LIBS=${libs:-ninguna}"

# ¿hay decisiones visuales en código? (css, scss, vue, svelte, astro, html, tailwind), ignorando dependencias y builds
hit="$(find "$P" -maxdepth 4 \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name .nuxt -o -name .output -o -name vendor -o -name .impeccable -o -name test -o -name tests -o -name __tests__ -o -name fixtures -o -name coverage \) -prune -o -type f \( -name '*.css' -o -name '*.scss' -o -name '*.sass' -o -name '*.less' -o -name '*.vue' -o -name '*.svelte' -o -name '*.astro' -o -name '*.html' -o -name 'tailwind.config.*' \) -print 2>/dev/null | head -1)"
if [ -n "$hit" ]; then echo "UI_CODE=si (${hit#"$P"/})"; else echo "UI_CODE=no"; fi
exit $miss
