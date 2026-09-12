# style-agent

Repo de la skill `/diseno`: un orquestador de diseño escrito en Markdown y bash, sin código de aplicación. Se desarrolla en Claude Code, que es donde da el máximo, pero la misma fuente se instala en Codex, Gemini CLI, Cursor, GitHub Copilot, opencode, Windsurf y el resto de agentes que acepta la CLI `skills`. Aquí se edita `skills/diseno/` (`SKILL.md`, `entrevista.md`, `reference/`, `scripts/`), `install.sh` y `README.md`.

Los paquetes que orquesta (`impeccable`, `design-taste-frontend`, `redesign-existing-projects`, `animate`, `review-animations`, `prototype` y el opcional `ui-ux-pro-max`) viven en `~/.claude/skills` (y en `~/.agents/skills`, el canónico que comparten los demás agentes) y no se modifican desde este repo: se leen para saber qué hacen y se citan por ruta y sección. En esta máquina `~/.claude/skills/diseno` es un symlink a `skills/diseno` de este clon, así que editar aquí cambia la skill instalada.

## Cómo probar

```bash
bash skills/diseno/scripts/estado.sh                                # desde el repo: exit 0 con los paquetes instalados
mkdir -p /tmp/vacio && bash skills/diseno/scripts/estado.sh /tmp/vacio   # carpeta vacía: PRODUCT.md=no, UI_CODE=no, LIBS=ninguna
bash -n install.sh skills/diseno/scripts/estado.sh                  # sintaxis de los dos scripts
bash install.sh                                                     # instalación completa; el paso 5 es opcional y no debe abortarla
bash install.sh --agent codex,opencode --dry-run                    # convierte las comas en espacios, avisa y no ejecuta nada
LC_ALL=C grep -rnE $'\xe2\x80\x94|\xe2\x80\x93' skills README.md CLAUDE.md install.sh   # em-dash y en-dash
LC_ALL=C grep -rnE 'CLAUDE_SKILL_DIR|CLAUDE_PROJECT_DIR|AskUserQuestion|WebFetch|mcp__|`(Read|Write|Edit|Glob|Grep|Bash|Skill)`' skills   # portabilidad
R=$PWD; S=$(mktemp -d); (cd "$S" && env -u CLAUDE_CONFIG_DIR HOME="$S" bash "$R/install.sh" --agent opencode)   # instalación multiagente real sin tocar ~/.claude
```

`estado.sh` debe imprimir las claves del contrato: `IMPECCABLE_CLI` (`launcher|node|MISSING`), `IMPECCABLE_VERSION`, `UIPRO`, `PYTHON3` y `LIBS`. `UIPRO` y `PYTHON3` son opcionales y nunca provocan exit 1.

El grep de portabilidad sí devuelve coincidencias (hoy 32, en `SKILL.md`, `entrevista.md`, `reference/referencias-externas.md` y `scripts/estado.sh`) y cada una tiene que caer en uno de estos cuatro sitios: el frontmatter de `SKILL.md`, una fila de la tabla de la Fase 0b, una frase que dé la alternativa para otros agentes ("en Claude Code `X`; en otro agente, Y"), o una variable con valor por defecto dentro de `estado.sh` (`${CLAUDE_PROJECT_DIR:-$PWD}`, la detección de `CLAUDECODE`). Cualquier otra es un acoplamiento a Claude Code y se corrige antes de seguir.

El grep de em-dash y en-dash debe salir **vacío (rc=1)** en todo el repo y así debe seguir: cualquier coincidencia es un fallo, incluidas las líneas que enuncian la regla. Para hablar de estos caracteres se escribe su código (`U+2014`, `U+2013`) o su secuencia de bytes, nunca el glifo. Muestra siempre la salida real de cada comando: aquí no vale un "ya lo verifiqué".

## Convenciones

- Español en todo el repo. Cero em-dash y en-dash en los archivos del repo y en la UI que la skill genera: punto, coma o dos puntos.
- Nombres del contrato, no sinónimos: Registro (`estándar | inmersivo`), ruta X (experiencia inmersiva; sustituye a C y E en marketing), Firma (una sola por página), Instrumentos (preloader, cursor, marquee, sonido, índice).
- `reference/inmersivo.md` y `reference/escenografia.md` son la autoridad de la ruta X. `SKILL.md` decide cuándo se leen; no duplica su contenido.
- `SKILL.md` por debajo de 300 líneas. Si una fase crece, se mueve a `reference/` y `SKILL.md` la referencia por archivo y título `##`.
- La skill tiene que seguir siendo portable: una sola fuente en `skills/diseno/`, sin generador ni `dist/`, instalable en cualquier agente con la CLI `skills`. En el cuerpo no se nombra una herramienta de Claude Code sin su alternativa ("en Claude Code `X`; en otro agente, Y"), y los nombres propios de Claude viven en dos sitios y solo dos: el frontmatter (`allowed-tools`, que fuera de Claude Code se ignora en silencio) y la tabla de la Fase 0b de `SKILL.md`, que es donde se traduce cada rol. Un rol nuevo se añade a esa tabla antes de usarlo.
- Rutas de la skill por el marcador `<DISENO>`, resuelto con la línea `DISENO=` de `estado.sh`, nunca por `${CLAUDE_SKILL_DIR}`, que solo se menciona una vez en las Reglas de sesión como atajo de Claude Code. Lo mismo con `${CLAUDE_PROJECT_DIR}`: la carpeta del proyecto es el directorio de trabajo actual y `estado.sh` sin argumento ya lo resuelve.
- Rutas en backticks y absolutas cuando se pasan al rol de leer archivo (`Read` en Claude Code). Versiones de librerías fijadas y verificadas en npm el día que se escriben.
- Cada patrón del playbook inmersivo cita cuántos de los 7 sitios de referencia lo usan y uno o dos ejemplos por nombre. Sin evidencia no entra.
- Estilo de la documentación: denso e imperativo, fases numeradas, tablas cortas. Ni marketing ni adjetivos de relleno.

## Qué no hacer

- No instalar Impeccable como plugin (`/plugin marketplace add`): pasaría a llamarse `impeccable:impeccable` y `/diseno` no lo encontraría.
- No correr `npx impeccable install` ni `update` sin `--no-hooks`: deja un hook global que se ejecuta en todos los proyectos del usuario.
- No editar, mover ni parchear nada dentro de `~/.claude/skills` desde este repo (el symlink de `diseno` es la única relación, y apunta hacia aquí).
- No añadir dependencias, build ni lockfiles: este repo es Markdown y bash.
- No separar los nombres de agente por comas en `-a` de la CLI `skills`: es variádico y separa por ESPACIOS (`-a claude-code codex cursor`). Las comas solo valen en `--providers` del instalador de Impeccable. `install.sh` convierte las comas y avisa, pero el README y los ejemplos se escriben ya con espacios.

## Lecciones aprendidas

(vacío; añade una línea por error repetido)
