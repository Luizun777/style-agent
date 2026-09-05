#!/usr/bin/env bash
# Instala /diseno y los tres paquetes que orquesta, en global, para Claude Code.
# Uso:  bash install.sh                 → instala la skill desde este clon (si no hay clon, desde GitHub)
#       bash install.sh /ruta/al/repo   → instala la skill desde esa ruta local (relativa o absoluta) o desde owner/repo
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${1:-}" ]; then SRC="$1"
elif [ -f "$HERE/skills/diseno/SKILL.md" ]; then SRC="$HERE"
else SRC="Luizun777/style-agent"; fi
if [ -d "$SRC" ]; then SRC="$(cd "$SRC" && pwd)"; fi
C="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

command -v node >/dev/null 2>&1 || { echo "Falta Node 22.20 o superior: https://nodejs.org"; exit 2; }
command -v npx  >/dev/null 2>&1 || { echo "Falta npx. Instala Node desde https://nodejs.org (incluye npm y npx)."; exit 2; }
node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a>22||(a===22&&b>=20)?0:2)' \
  || { echo "Node $(node -v) es menor que 22.20. Actualiza Node y repite."; exit 2; }

cd ~
echo "1/4 Impeccable (proceso + detector)"
npx -y impeccable install --providers=claude --scope=global --no-hooks
echo "2/4 taste-skill (dirección visual y auditoría de rediseño)"
npx -y skills@latest add Leonxlnx/taste-skill -g -a claude-code -y -s design-taste-frontend redesign-existing-projects
echo "3/4 emilkowalski/skills (animación y variantes)"
npx -y skills@latest add emilkowalski/skills -g -a claude-code -y -s animate review-animations prototype
echo "4/4 /diseno desde $SRC"
npx -y skills@latest add "$SRC" -g -a claude-code -y -s diseno

echo
bash "$C/skills/diseno/scripts/estado.sh" && echo && echo "Listo. Reinicia Claude Code y escribe /diseno"
