#!/usr/bin/env bash
# Instala /diseno y los paquetes que orquesta, en global, para uno o varios agentes.
#
# Uso:  bash install.sh                                  -> instala para claude-code desde este clon
#       bash install.sh --agent codex gemini-cli cursor  -> instala ademas para esos agentes
#       bash install.sh /ruta/al/repo --agent opencode   -> la ruta (o owner/repo) va ANTES de --agent
#       AGENTS="claude-code codex" bash install.sh       -> misma lista por variable de entorno
#       bash install.sh --dry-run --agent codex          -> imprime los comandos y no ejecuta nada
#
# Los nombres de agente son los de la CLI skills y van separados por ESPACIOS, nunca por comas.
# Para verlos todos: npx -y skills@latest add . -a lista-invalida -s diseno -y
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AGENTS_IN="${AGENTS:-}"
SRC_ARG=""
DRY=0

pathish() {  # ¿parece una ruta o un owner/repo y no un nombre de agente?
  case "$1" in */*|.|..|~*) return 0 ;; esac
  [ -e "$1" ] && return 0
  return 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    -a|--agent)
      shift
      while [ $# -gt 0 ]; do
        case "$1" in -*) break ;; esac
        pathish "$1" && break
        AGENTS_IN="${AGENTS_IN:+$AGENTS_IN }$1"; shift
      done
      ;;
    --agent=*|-a=*) AGENTS_IN="${AGENTS_IN:+$AGENTS_IN }${1#*=}"; shift ;;
    --dry-run) DRY=1; shift ;;
    -h|--help) sed -n '2,11p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Opcion desconocida: $1. Usa --agent <nombre> [<nombre>...] o --dry-run."; exit 2 ;;
    *)
      if [ -z "$SRC_ARG" ]; then SRC_ARG="$1"; shift
      else echo "Sobra el argumento: $1. La ruta del repo va una sola vez y antes de --agent."; exit 2; fi
      ;;
  esac
done

case "$AGENTS_IN" in
  *,*) AGENTS_IN="${AGENTS_IN//,/ }"
       echo "Aviso: -a de la CLI skills separa por ESPACIOS, no por comas. Uso: $AGENTS_IN" ;;
esac
AGENTS_IN="$(printf '%s\n' $AGENTS_IN | awk 'NF && !seen[$0]++' | tr '\n' ' ')"
AGENTS_IN="${AGENTS_IN% }"
[ -n "$AGENTS_IN" ] || AGENTS_IN="claude-code"

if [ -n "$SRC_ARG" ]; then SRC="$SRC_ARG"
elif [ -f "$HERE/skills/diseno/SKILL.md" ]; then SRC="$HERE"
else SRC="Luizun777/style-agent"; fi
if [ -d "$SRC" ]; then SRC="$(cd "$SRC" && pwd)"; fi
C="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

run() {  # ejecuta, o solo imprime con --dry-run
  if [ "$DRY" = 1 ]; then printf '  [dry-run] %s\n' "$*"; return 0; fi
  "$@"
}

# Nombre del agente en la CLI skills -> nombre del proveedor en el instalador de Impeccable.
# Verificado contra impeccable 4.1.0: acepta claude, codex, cursor, gemini, copilot, opencode,
# antigravity, kiro, trae, qoder, grok, hermes, dsh. No acepta windsurf ni los demas.
imp_provider() {
  case "$1" in
    claude-code) echo claude ;;
    codex) echo codex ;;
    cursor) echo cursor ;;
    gemini-cli) echo gemini ;;
    github-copilot) echo copilot ;;
    opencode) echo opencode ;;
    antigravity|antigravity-cli) echo antigravity ;;
    kiro-cli) echo kiro ;;
    trae|trae-cn) echo trae ;;
    qoder|qoder-cn) echo qoder ;;
    grok) echo grok ;;
    hermes-agent) echo hermes ;;
    *) echo "" ;;
  esac
}

# Nombre del agente en la CLI skills -> valor de --ai del instalador de UI/UX Pro Max (paso 5).
uipro_ai() {
  case "$1" in
    claude-code) echo claude ;;
    cursor) echo cursor ;;
    windsurf) echo windsurf ;;
    antigravity|antigravity-cli) echo antigravity ;;
    github-copilot) echo copilot ;;
    kiro-cli) echo kiro ;;
    codex) echo codex ;;
    qoder|qoder-cn) echo qoder ;;
    gemini-cli) echo gemini ;;
    trae|trae-cn) echo trae ;;
    opencode) echo opencode ;;
    continue) echo continue ;;
    codebuddy) echo codebuddy ;;
    droid) echo droid ;;
    kilo) echo kilocode ;;
    warp) echo warp ;;
    augment) echo augment ;;
    roo) echo roocode ;;
    universal) echo universal ;;
    *) echo "" ;;
  esac
}

como_invocar() {
  case "$1" in
    claude-code) echo "escribe /diseno (reinicia Claude Code antes)" ;;
    cursor) echo "escribe /diseno en el chat del Agent, o @diseno para adjuntarla" ;;
    codex) echo "escribe \$diseno (con simbolo dolar; en Codex las skills no llevan barra)" ;;
    gemini-cli) echo "pidela por su nombre y Gemini la activa con activate_skill; para tener /diseno crea ~/.gemini/commands/diseno.toml (receta en el README)" ;;
    opencode) echo "pidela por su nombre; para tener /diseno crea .opencode/command/diseno.md (receta en el README)" ;;
    *) echo "pidela por su nombre: el agente la elige por la descripcion del frontmatter" ;;
  esac
}

command -v node >/dev/null 2>&1 || { echo "Falta Node 22.20 o superior: https://nodejs.org"; exit 2; }
command -v npx  >/dev/null 2>&1 || { echo "Falta npx. Instala Node desde https://nodejs.org (incluye npm y npx)."; exit 2; }
node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a>22||(a===22&&b>=20)?0:2)' \
  || { echo "Node $(node -v) es menor que 22.20. Actualiza Node y repite."; exit 2; }

echo "Agentes: $AGENTS_IN"
[ "$DRY" = 1 ] && echo "Modo --dry-run: no se ejecuta nada."

# Paso 1. Impeccable: instalador propio, con --providers separado por COMAS y solo los que soporta.
PROV=""; SIN_IMP=""
for a in $AGENTS_IN; do
  p="$(imp_provider "$a")"
  if [ -n "$p" ]; then
    case ",$PROV," in *",$p,"*) ;; *) PROV="${PROV:+$PROV,}$p" ;; esac
  else
    SIN_IMP="${SIN_IMP:+$SIN_IMP }$a"
  fi
done

cd ~
echo "1/5 Impeccable (proceso + detector)"
if [ -n "$PROV" ]; then
  run npx -y impeccable install --providers="$PROV" --scope=global --no-hooks
else
  echo "   Impeccable no soporta ninguno de los agentes pedidos: se salta."
fi
if [ -n "$SIN_IMP" ]; then
  echo "   Aviso: Impeccable no tiene proveedor para $SIN_IMP; ahi /diseno corre sin critique ni detector por skill, pero \`npx impeccable detect <archivo>\` sigue disponible si hay Node."
fi

# Impeccable escribe en la carpeta propia de cada proveedor (claude -> ~/.claude/skills,
# opencode -> ~/.config/opencode/skills, cursor -> ~/.cursor/skills...), no en el canonico
# ~/.agents/skills que comparten los agentes universales. Se republica con la CLI skills para
# que estado.sh y los demas agentes lo encuentren por la misma ruta que el resto de paquetes.
if [ "$DRY" = 0 ] && [ ! -f "$HOME/.agents/skills/impeccable/SKILL.md" ]; then
  IMPSRC=""
  for d in "$C/skills/impeccable" "$HOME/.config/opencode/skills/impeccable" "$HOME/.opencode/skills/impeccable" \
           "$HOME/.cursor/skills/impeccable" "$HOME/.gemini/skills/impeccable" "$HOME/.codex/skills/impeccable" \
           "$HOME/.github/skills/impeccable" "$HOME/.antigravity/skills/impeccable"; do
    [ -f "$d/SKILL.md" ] && { IMPSRC="$d"; break; }
  done
  if [ -n "$IMPSRC" ] && [ "$AGENTS_IN" != "claude-code" ]; then
    echo "   Republico Impeccable desde $IMPSRC al canonico ~/.agents/skills"
    # shellcheck disable=SC2086
    npx -y skills@latest add "$IMPSRC" -g -a $AGENTS_IN -y -s impeccable \
      || echo "   Aviso: no se pudo republicar Impeccable; estado.sh puede decir IMPECCABLE=MISSING aunque este instalado."
  fi
fi

# Pasos 2 a 4. CLI skills: -a es variadico y separa por ESPACIOS (por eso $AGENTS_IN va sin comillas).
# shellcheck disable=SC2086
echo "2/5 taste-skill (direccion visual y auditoria de rediseno)"
run npx -y skills@latest add Leonxlnx/taste-skill -g -a $AGENTS_IN -y -s design-taste-frontend redesign-existing-projects
# shellcheck disable=SC2086
echo "3/5 emilkowalski/skills (animacion y variantes)"
run npx -y skills@latest add emilkowalski/skills -g -a $AGENTS_IN -y -s animate review-animations prototype
# shellcheck disable=SC2086
echo "4/5 /diseno desde $SRC"
run npx -y skills@latest add "$SRC" -g -a $AGENTS_IN -y -s diseno

echo "5/5 UI/UX Pro Max (opcional: piso de conocimiento local, MIT, sin red)"
echo "   Aviso: ademas de ui-ux-pro-max instala banner-design, brand, design, design-system, slides y ui-styling."
echo "   /diseno no las usa; puedes borrar esas carpetas y conservar solo ui-ux-pro-max."
for a in $AGENTS_IN; do
  ai="$(uipro_ai "$a")"
  if [ -z "$ai" ]; then echo "   $a: UI/UX Pro Max no lo soporta, se salta."; continue; fi
  run npx -y ui-ux-pro-max-cli init --ai "$ai" --global \
    || echo "   Aviso: UI/UX Pro Max no se instalo para $a. /diseno funciona igual (estado.sh dira UIPRO=no)."
done

echo
EST=""
for d in "$C/skills/diseno" "$HOME/.agents/skills/diseno" "$HOME/.config/opencode/skills/diseno" "$SRC/skills/diseno"; do
  if [ -f "$d/scripts/estado.sh" ]; then EST="$d/scripts/estado.sh"; break; fi
done
if [ -n "$EST" ]; then run bash "$EST" || true
else echo "No encuentro estado.sh: la skill no quedo instalada en ninguna ruta conocida."; fi

echo
echo "Listo. Si el informe de arriba muestra lineas \"instalar:\", ejecutalas antes."
for a in $AGENTS_IN; do printf '  %s: %s\n' "$a" "$(como_invocar "$a")"; done
