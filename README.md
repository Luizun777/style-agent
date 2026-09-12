# style-agent · `/diseno`

Diseña y rediseña pantallas, componentes y landing pages sin que parezcan "hechas por IA".
Una skill que te entrevista, fija el sistema visual del proyecto (tipografía, paleta, forma, modo) para que todas las pantallas lo hereden, y orquesta tres paquetes públicos de diseño (más un cuarto opcional) en el orden correcto.

Está escrita para Claude Code, que es donde da el máximo, y es **una sola fuente que funciona en los demás agentes de terminal**: Codex, Gemini CLI, Cursor, GitHub Copilot, opencode, Windsurf y el resto de los 79 que acepta la CLI `skills`. No hay copias ni `dist/`: el propio `SKILL.md` declara las capacidades que necesita por su rol y degrada cuando el agente no tiene una. Ver [Instalar en otros agentes](#instalar-en-otros-agentes).

*English: an agent skill (Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot, opencode and any agent that reads `.agents/skills`) that interviews you, standardizes your project's design system, and orchestrates Impeccable, taste-skill and Emil Kowalski's skills so your UI does not look AI-generated. Prompts and docs are in Spanish.*

## Qué hace

- **Te pregunta poco y bien.** Dos o tres preguntas con opciones antes de tocar código; si das contexto en la misma línea, se las salta.
- **Estandariza el proyecto la primera vez.** Tipografía, paleta, radios, modo claro u oscuro e iconos quedan en `DESIGN.md` (formato oficial DESIGN.md) y los hechos de producto en `PRODUCT.md`. Las siguientes pantallas los heredan sin volver a preguntar.
- **Tres formas de trabajar:** desde cero, rediseño de lo que ya existe, o con referencias (URLs, capturas, imágenes).
- **Registro inmersivo para páginas de marca.** Si pides una página al nivel de [biologica.com](https://biologica.com/), [drinkpouch.com](https://www.drinkpouch.com/), [yucca.co.za](https://yucca.co.za/), [sylverrappresentanze.it](https://sylverrappresentanze.it/), [eatnaked.co](https://eatnaked.co/), [skanvi.com](https://skanvi.com/) u [oddritualgolf.com](https://oddritualgolf.com/), la skill cambia de registro: hero a pantalla completa con foto o vídeo real (los 7 lo hacen; 3 con vídeo en el hero), tipografía de autor con escala extrema, GSAP y Lenis instalados con versión fijada, y una sola firma de movimiento por página. Nunca en pantallas de app.
- **Verifica con evidencia.** Corre el detector de anti-patrones de "diseño IA" de Impeccable antes y después, revisa el movimiento y muestra el `git diff`.
- **No rompe nada.** Conserva rutas, nombres de campos, textos legales y logo salvo que lo apruebes. No migra frameworks. Instala librerías solo en registro inmersivo, solo las que el brief lista en su línea `Cargaré:` y solo después de que confirmes.

Los paquetes que orquesta:

| Paquete | Para qué sirve | Qué hace dentro de /diseno |
|---|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) | Proceso y control de calidad | Contexto del producto (`PRODUCT.md`, `DESIGN.md`), crítica, pulido y el detector de anti-patrones |
| [taste-skill](https://github.com/Leonxlnx/taste-skill) | Dirección visual de landings y portafolios | "Lectura de diseño", tres diales (variación, movimiento, densidad), reglas anti-plantilla y auditoría de rediseño |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) | Animación y variantes | Movimiento que se siente bien (`animate`, `review-animations`) y tres variantes con selector (`prototype`) |
| [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) (opcional) | Base de datos local de estilos, paletas, pares tipográficos, presets GSAP y reglas UX | Piso del "Sistema propuesto" cuando no hay `DESIGN.md` ni referencias, y vocabulario de estilos para nombrar direcciones. Nunca manda sobre el brief ni sobre el playbook inmersivo |

Fuentes de referencia que puede consultar (ninguna es obligatoria):

| Fuente | Cómo se usa | Límite |
|---|---|---|
| [Mobbin](https://mobbin.com/) | Solo sus páginas públicas `/explore/sites/...` por `curl`, y solo si no diste URLs ni capturas: te propone 8 a 12 candidatas con nombre de sitio y eliges 2 o 3 | Referencia con crédito, sin re-publicar capturas. Sin Pro y sin MCP. Su catálogo tira a SaaS, no a Awwwards |
| UI/UX Pro Max | Local, con `search.py`, una sola consulta por sesión | Requiere Python 3. Sus paletas y pares tipográficos tiran al look de IA: van como piso, no como gusto |
| [Cosmos](https://www.cosmos.so/) | Solo si tú pegas una URL suya en el pedido. No se automatiza: sus términos lo prohíben | Moodboard de dirección de arte, nunca assets del entregable |
| [Three.js](https://threejs.org/) | Solo si el brief pide 3D de verdad, con `three` fijado por versión | 0 de los 7 sitios de referencia usan Three.js. Antes se prueba CSS, vídeo o canvas 2D |

## Instalación (una vez, vale para todos tus proyectos)

Requisitos: un agente de terminal ([Claude Code](https://claude.com/claude-code) por defecto; para otro, ver [Instalar en otros agentes](#instalar-en-otros-agentes)) y Node 22.20 o superior con npm (`node -v`, `npx -v`).

**Opción A, un comando** (clona el repo e instala todo desde el clon):

```bash
git clone https://github.com/Luizun777/style-agent.git && bash style-agent/install.sh
```

Sin `--agent` instala para Claude Code. Para otro agente, o para varios a la vez, ver [Instalar en otros agentes](#instalar-en-otros-agentes).

**Opción B, paso a paso** (desde tu carpeta de usuario, `cd ~`):

```bash
npx -y impeccable install --providers=claude --scope=global --no-hooks
npx -y skills@latest add Leonxlnx/taste-skill -g -a claude-code -y -s design-taste-frontend redesign-existing-projects
npx -y skills@latest add emilkowalski/skills -g -a claude-code -y -s animate review-animations prototype
npx -y skills@latest add Luizun777/style-agent -g -a claude-code -y -s diseno
```

**Paso 5, opcional** (UI/UX Pro Max, la base de datos local de estilos y paletas):

```bash
npx -y ui-ux-pro-max-cli init --ai claude --global
```

`install.sh` lo intenta como paso "5/5" y sigue adelante si falla, porque no es requisito. Ese comando no instala solo `ui-ux-pro-max`: deja también `banner-design`, `brand`, `design`, `design-system`, `slides` y `ui-styling` en `~/.claude/skills`. `/diseno` solo usa `ui-ux-pro-max`. Ojo con `design`: su descripción solapa con `/diseno` y Claude puede activarla en su lugar, así que conviene borrarla. Para quitar las otras seis:

```bash
rm -rf ~/.claude/skills/{banner-design,brand,design,design-system,slides,ui-styling}
```

Añade `ui-ux-pro-max` a esa lista si quieres quitarlo todo. Necesita Python 3 en el PATH (`python3 -V`); sin él, `estado.sh` lo marca y la skill sigue sin él.

**Comprobar:**

```bash
bash ~/.claude/skills/diseno/scripts/estado.sh          # Claude Code
bash ~/.agents/skills/diseno/scripts/estado.sh          # cualquier otro agente
```

Las líneas de paquetes (`DISENO`, `IMPECCABLE`, `TASTE`, `REDESIGN`, `ANIMATE`, `REVIEW_ANIM`, `PROTOTYPE`) deben mostrar una ruta y ninguna `MISSING`. `AGENTE` dice desde qué raíz se resolvió la skill (`claude-global`, `agents-global`, `claude-proyecto`, `agents-proyecto` u `otro`) y `SKILLS_DIR` la raíz donde están los paquetes: son las dos líneas que usa la skill para resolver rutas en agentes que no son Claude Code. `IMPECCABLE_CLI` dice `launcher` o `node` según la versión de Impeccable que tengas; si dice `MISSING`, la instalación de Impeccable está incompleta y `estado.sh` sale con 1: repite su comando del paso 1. `IMPECCABLE_VERSION` es informativo. `UIPRO` (ruta de `search.py` o `no`) y `PYTHON3` (`si` o `no`) son del paso 5 opcional: `no` no bloquea nada. Las demás (`NODE`, `PRODUCT.md`, `DESIGN.md`, `PACKAGE_JSON`, `UI_CODE`, `LIBS`) describen la carpeta desde la que lo ejecutas y pueden decir `no` o `ninguna`; `LIBS` lista las librerías de movimiento que ya hay en tu `package.json` (gsap, lenis, three, @barba/core, motion, framer-motion, swiper). Reinicia Claude Code, escribe `/` y comprueba que aparece `diseno`.

Notas:
- Con esos flags el instalador de Impeccable no pregunta nada. Si lo ejecutas sin ellos, elige `global` (no `project`) y en "Customize" marca solo Claude Code; sin `--no-hooks` deja un hook en `~/.claude/settings.local.json` que corre en todos tus proyectos.
- No instales Impeccable también como plugin (`/plugin marketplace add`): el nombre cambiaría a `impeccable:impeccable` y `/diseno` no lo encontraría.
- Todo queda en `~/.claude/skills/` (y los ayudantes de Impeccable en `~/.claude/agents/`). No se escribe nada en tus proyectos hasta que uses el comando. Si usas `CLAUDE_CONFIG_DIR`, sustituye `~/.claude` por esa carpeta.

Opcional. Para que no pida permiso en cada verificación, agrega a `~/.claude/settings.json` (cambia `<tu-usuario>` por tu usuario del sistema; Impeccable ejecuta sus scripts con la ruta absoluta):

```json
{
  "permissions": {
    "allow": [
      "Bash(bash ~/.claude/skills/diseno/scripts/estado.sh*)",
      "Bash(node ~/.claude/skills/impeccable/scripts/*)",
      "Bash(node /Users/<tu-usuario>/.claude/skills/impeccable/scripts/*)",
      "Bash(npx impeccable *)"
    ]
  }
}
```

En registro inmersivo la skill pide permiso además para instalar lo que anunció en el brief (`npm install gsap lenis`, o nada si vas por import map), para `curl` de referencias públicas y, si lo tienes, para `python3 .../search.py`. Concédelo en el momento o añade tú esas entradas: son comandos que escriben o salen a la red, así que el README no los preautoriza por ti.

## Instalar en otros agentes

`/diseno` es una sola carpeta de Markdown y bash: no hay generador, ni `dist/`, ni copias por agente. El mismo árbol se reparte con la CLI [`skills`](https://github.com/vercel-labs/skills), que acepta 79 agentes, y el propio `SKILL.md` degrada cuando al agente le falta una herramienta: su "Fase 0b · Capacidades del agente" manda leer `reference/capacidades.md`, donde cada rol (leer, leer mostrando imágenes, recibir imágenes pegadas, escribir, editar, buscar, consola, proceso en segundo plano, URL, preguntar con opciones, cargar otra skill, lanzar un subagente, generar imágenes, navegador) tiene su herramienta preferida en Claude Code y su degradación.

```bash
bash install.sh --agent claude-code codex gemini-cli cursor opencode
```

`install.sh` instala **siempre en global**: hace `cd ~` y pasa `-g` a todas las llamadas de la CLI, así que escribe en `~/.claude/skills` y `~/.agents/skills` y nunca en el proyecto. Para probarlo sin tocar tu configuración, córrelo con un `HOME` falso (`HOME=/tmp/prueba bash install.sh --agent codex`). Para scope de proyecto usa la CLI a pelo, sin `-g`, desde la raíz del proyecto: `npx -y skills@latest add <fuente> -a <agentes> -y -s diseno`.

Sin clonar el repo, solo la skill (sin los paquetes que orquesta):

```bash
npx -y skills@latest add Luizun777/style-agent -g -a claude-code codex gemini-cli cursor opencode -y -s diseno
```

**Los nombres de agente van separados por espacios, nunca por comas.** `-a` es variádico: `codex,cursor` se lee como un único nombre que no existe y la instalación falla. `install.sh` convierte las comas en espacios y te lo avisa por pantalla, pero la CLI a secas no lo hace. Para ver la lista completa de nombres válidos, pide uno inválido a propósito. La fuente tiene que contener un `SKILL.md` válido: con un `.` que no lo sea, la CLI responde "No valid skills found" y nunca llega a validar el agente, así que apunta al repo o a la skill ya instalada:

```bash
npx -y skills@latest add Luizun777/style-agent -a lista-invalida -s diseno -y
npx -y skills@latest add ~/.agents/skills/diseno -a lista-invalida -s diseno -y   # si ya la instalaste
```

### Dónde acaba instalada

22 agentes comparten el directorio canónico `~/.agents/skills/diseno` (global) o `.agents/skills/diseno` (dentro de un proyecto). Los otros 57 reciben un **symlink** desde su carpeta propia hacia ese canónico, así que sigue habiendo un solo árbol en disco y ninguna copia que se desincronice.

| Reparto | Agentes |
|---|---|
| Canónico `.agents/skills` (sin symlink) | `amp`, `antigravity`, `antigravity-cli`, `cline`, `codex`, `cursor`, `deepagents`, `dexto`, `droid`, `firebender`, `gemini-cli`, `github-copilot`, `kilo`, `kimi-code-cli`, `loaf`, `opencode`, `replit`, `sarvam-code`, `warp`, `zed`, `promptscript`, `universal` |
| Carpeta propia + symlink al canónico | `claude-code` (`~/.claude/skills/diseno`), `windsurf` y los 55 restantes |

En scope de proyecto la CLI deja además un `skills-lock.json` en la raíz del proyecto destino (origen y hash de cada skill instalada). Añádelo a `.gitignore` o commitéalo, pero no lo edites a mano.

Si tu agente no sigue symlinks, añade `--copy` al final del comando: copia el árbol entero en cada carpeta y no crea canónico. Se copia byte a byte (`scripts/estado.sh` conserva el bit de ejecución) y se excluyen `.git` y `metadata.json`.

Comprobar después de instalar:

```bash
bash ~/.agents/skills/diseno/scripts/estado.sh     # cualquier agente que use el canónico
bash ~/.claude/skills/diseno/scripts/estado.sh     # Claude Code
```

### Cómo se invoca en cada agente

| Agente | Se invoca así | Nota |
|---|---|---|
| Claude Code | `/diseno` | reinicia Claude Code después de instalar |
| Cursor | `/diseno`, o `@diseno` para adjuntarla | desde Cursor 2.4, en el editor y en `cursor-agent` |
| Codex | `$diseno` (símbolo dólar) | en Codex las skills no llevan barra: `/` son comandos internos. También la activa sola por la `description` |
| Gemini CLI | pídela por su nombre | la activa con `activate_skill` y te pide confirmación. `/skills` solo gestiona; para tener `/diseno`, la receta de abajo |
| opencode | pídela por su nombre | también lee `~/.claude/skills`, así que puede verla dos veces y avisar de `duplicate skill name`; gana la del proyecto. Para tener `/diseno`, la receta de abajo |
| Los demás | pídela por su nombre | la eligen por la `description` del frontmatter, que es lo único obligatorio y lo único que leen todos |

`/diseno` en **Gemini CLI**, archivo `~/.gemini/commands/diseno.toml` (o `<proyecto>/.gemini/commands/diseno.toml`, que manda sobre el global):

```toml
description = "Disena o redisena pantallas, landings y componentes con la skill diseno."
prompt = """
Activa la skill `diseno` con la herramienta activate_skill y sigue su SKILL.md al pie de la letra.
La peticion del usuario viene a continuacion:
{{args}}
"""
```

No metas ahí `@{~/.agents/skills/diseno/SKILL.md}`: la inyección `@{...}` solo admite rutas dentro del workspace. Tampoco hace falta, porque al activar la skill Gemini inyecta el cuerpo y añade su carpeta a las rutas permitidas, que es lo que `/diseno` necesita para leer `reference/` y correr `scripts/estado.sh`.

`/diseno` en **opencode**, archivo `<proyecto>/.opencode/command/diseno.md`:

```markdown
---
description: Disena o redisena pantallas, landings y componentes con la skill diseno.
---
Carga la skill `diseno` (herramienta skill, name=diseno) y sigue su SKILL.md al pie de la letra.
Peticion del usuario: $ARGUMENTS
```

`$ARGUMENTS` se sustituye en los archivos de comando, no dentro de un `SKILL.md`.

### Qué se pierde en cada caso

La skill lo declara en la entrega en vez de disimularlo. Nada de esto la rompe.

| Le falta al agente | Qué pasa |
|---|---|
| Herramienta para cargar otra skill (`Skill` en Claude Code) | `/diseno` lee el `SKILL.md` del paquete y lo aplica, y dice en la entrega que fue por lectura y no por carga. Por eso los paquetes tienen que estar instalados **para los mismos agentes**: `install.sh` lo hace en el mismo comando |
| Preguntar con opciones (`AskUserQuestion`) | escribe las preguntas con las opciones numeradas, mismo tope de 4, y espera respuesta. En Codex `request_user_input` no bloquea el turno y no existe en `codex exec`: ahí la skill toma la lectura más probable, la marca como SUPUESTO en el brief y sigue la ruta conservadora |
| Navegador | la escenografía de la ruta X se entrega marcada como **no verificada**, con la lista de puntos del checklist que quedan sin marcar |
| Consola | no se pueden correr `estado.sh` ni el detector de anti-patrones: el conteo se marca como **no disponible** y no se inventa. Puedes pegar tú la salida de `bash ~/.agents/skills/diseno/scripts/estado.sh` |
| Impeccable | su instalador solo soporta `claude`, `codex`, `cursor`, `gemini`, `copilot`, `opencode`, `antigravity`, `kiro`, `trae`, `qoder`, `grok`, `hermes` y `dsh`. `install.sh` mapea los nombres que coinciden y avisa de los demás: ahí `/diseno` corre sin `critique` ni detector por skill, pero `npx impeccable detect <archivo>` sigue disponible si hay Node |
| UI/UX Pro Max | paso 5, opcional. Su CLI tiene su propio mapa de `--ai`; `install.sh` se lo salta sin abortar para los agentes que no soporta, y `estado.sh` dirá `UIPRO=no` |

Del frontmatter, `name` y `description` son lo único obligatorio y lo único que leen todos. `allowed-tools` y `argument-hint` los ignora en silencio cualquier agente que no sea Claude Code: fuera de Claude Code los permisos los decide el agente (el sandbox y `config.toml` en Codex, el policy engine en Gemini CLI, los permisos del agente en opencode), no el frontmatter de la skill.

## Cómo usarlo

Abre Claude Code dentro del proyecto (`cd mi-proyecto && claude`) y escribe uno de estos comandos.

### 1. Diseño desde cero

```
/diseno crea una landing para <tu producto en una frase>
/diseno crea la pantalla de ajustes de notificaciones
```

Qué pasa:
1. Lee lo que haya (`package.json`, tokens, `PRODUCT.md`, `DESIGN.md`) sin preguntar.
2. Te hace 2 o 3 preguntas: para quién es, qué debe lograr la persona, qué sensación buscas, qué es único del producto.
3. **Primera vez en el proyecto:** te pregunta por el sistema (fuente de marca o elegir una, colores de marca o neutros más un acento, forma de los componentes, modo claro u oscuro) y, si la carpeta está vacía, con qué stack construir. Aunque des todo el contexto en la línea de comando, esta parte se hace igual la primera vez.
4. Te muestra la "Lectura de diseño" con los diales y te pide una confirmación.
5. Si no existe `PRODUCT.md`, Impeccable hace una ronda corta de preguntas de producto y lo crea (queda para siempre).
6. Construye, corre el detector, revisa el movimiento y guarda el sistema en `DESIGN.md` para las próximas pantallas.

Landing, portafolio y páginas de marketing van por taste-skill (dirección visual fuerte). Pantallas de app (login, formularios, paneles, ajustes) van por Impeccable en modo Operate (claridad y consistencia primero); si la pantalla necesita un mundo visual nuevo, Impeccable puede abrir una página de decisión en tu navegador: elige ahí y vuelve.

### 2. Rediseño de una pantalla existente

```
/diseno rediseña src/pages/Login.tsx
/diseno rediseña la página de precios
```

Qué pasa:
1. Te pregunta si **conservar la identidad y pulir** (misma marca; arregla jerarquía, espaciado, tipografía y estados sin romper nada) o **cambiar el look** (nueva dirección visual; se mantienen contenido, rutas y funciones). La primera vez elige conservar.
2. Si conservas y el proyecto no tiene `DESIGN.md`, extrae el sistema real del código con `impeccable document` (una ronda corta, hasta tres preguntas sobre el carácter del sistema) y lo confirma. Desde entonces todas las pantallas lo respetan. Si cambias el look, te hace la ronda de sistema (puedes mantener la fuente o la paleta actuales) y el sistema nuevo se guarda al final.
   Conservar significa conservar: la fuente y la paleta de marca solo cambian si el brief lo propone en la línea "Cambios de sistema propuestos" y tú lo confirmas.
3. Audita con Impeccable `critique` y la lista de rediseño de taste-skill, y arregla en orden de impacto: fuente, paleta, hover y active, layout, componentes, estados, escala tipográfica.
4. Detector antes y después, y `git diff --stat`.

Consejo: nombra el archivo. Si describes la pantalla sin ruta, la buscará por nombre.

### 3. Diseño con referencias

```
/diseno crea una landing para <producto> como https://linear.app y https://vercel.com
/diseno rediseña index.html con esta referencia: capturas/referencia.png
/diseno crea el dashboard inspirado en Stripe, más denso
```

Para pasar una captura: arrastra el archivo a la terminal de Claude Code (inserta la ruta), escribe la ruta, o pega la imagen en el chat. Máximo tres referencias.

Qué pasa:
1. Lee cada referencia: imágenes con `Read`; URLs con el navegador de Claude Code si está disponible. Sin navegador, de una URL solo puede leer estructura y textos; te pedirá una captura si quieres que tome también colores, tipografía y movimiento.
2. Escribe una "Lectura de referencia" por cada una: estructura, tipografía, color, densidad, movimiento, y una línea con lo que **no** se copia (logo, marca, copy, fotos, fuentes con licencia).
3. Si de una URL no pudo ver colores o tipografía, te pregunta si pasas una captura o sigue solo con la estructura. Si dos referencias se contradicen, te pregunta cuál manda o si mezclar (estructura de una, color de otra).
4. Sigue el flujo de "desde cero" o "rediseño" usando esa lectura como autoridad visual. Si el proyecto ya tiene `DESIGN.md`, sus tokens mandan y la referencia aporta estructura, ritmo y movimiento; solo con "cambiar el look" la referencia puede redefinir la paleta o la fuente. Se inspira; no clona.

### 4. Estandarizar el proyecto (sistema)

```
/diseno sistema
```

Solo documenta o define el sistema y para. Si hay código, lo extrae con `impeccable document` y escribe `DESIGN.md`. Si el proyecto está vacío, te pregunta el stack y la ronda de tipografía, paleta, forma y modo, y escribe un `DESIGN.md` marcado como `status: seed` ("acordado, aún sin código") que se reescribe con los tokens reales tras la primera pantalla. Si ya existe `DESIGN.md`, te pregunta si refrescarlo desde el código, mezclarlo, reemplazarlo o dejarlo.

`DESIGN.md` sigue el [formato oficial DESIGN.md](https://github.com/google-labs-code/design.md): tokens en el frontmatter y ocho secciones. Lo leen `/diseno`, Impeccable y Google Stitch. Edítalo a mano cuando cambies de fuente o de paleta.

### 5. Registro inmersivo (página de marca, nivel Awwwards)

```
/diseno crea una landing inmersiva para <marca de bebida> como https://www.drinkpouch.com/ y https://yucca.co.za/
/diseno crea la home de <marca> con vídeo en el hero, estilo Awwwards
```

Se activa con cualquiera de estas señales: modo Experience; la vibra "Inmersiva y cinematográfica"; `MOTION_INTENSITY` de 8 o más (salvo con la vibra "Atrevida y creativa", que va por la ruta C); las palabras inmersivo, cinematográfico, awwwards o editorial premium en tu pedido; o una referencia cuyo código use GSAP, Lenis, scrub, vídeo en el hero o canvas. Solo en marketing: un login, un panel o unos ajustes nunca son inmersivos, por muy premium que sea la marca.

Qué pasa:
1. El brief añade dos líneas (`Firma:`, una sola, e `Instrumentos:` con preloader, cursor, marquee, sonido o índice, cada uno con su condición o "ninguno") y rellena las dos que ya existen siempre: `Registro: inmersivo` y `Cargaré:` con las librerías y su versión exacta.
2. Firma: eliges tú o elige la skill entre vídeo macro en hero, producto 3D o secuencia atada al scroll, scrub tipográfico, scroll horizontal por paneles, transiciones de página, o ninguna. Una por página, no cinco.
3. Assets: te pregunta por la ruta de tus fotos y tu vídeo, o deja placeholders con medidas y la toma descrita.
4. Cargaré: `gsap` 3.15.0 y `lenis` 1.3.26 con versión fijada (import map si es estático, npm si hay build). Confirmar el brief es la autorización; si respondes "sin librerías", `Cargaré:` pasa a `ninguna` y se construye por la misma ruta X con CSS scroll-driven animations e `IntersectionObserver`, sin pin ni scrub, y la skill te dice qué comprobaciones de escenografía se omiten por eso. Si la Firma es transiciones de página, se suma `@barba/core` 2.10.3, y antes se te ofrece la View Transitions API, que es gratis.
5. Construye por la ruta X con el playbook propio de la skill: `inmersivo.md` para la dirección visual y `escenografia.md` para el scroll. Verifica con los greps de escenografía (sincronía de Lenis con ScrollTrigger, `prefers-reduced-motion`, vídeo con `poster`, `muted` y `playsinline`, cupo de marquees, degradación en móvil) y, si tu sesión tiene herramienta de navegador, con capturas de desktop y móvil. Sin navegador la escenografía se entrega marcada como no verificada y te lo dice.

Qué no hace:
- **No clona.** De las referencias toma estructura, ritmo, escala tipográfica y movimiento; nunca logo, copy, fotos ni fuente con licencia ajena.
- **No descarga fuentes de pago.** Trabaja con un pool libre (Fontshare y Google) o con tu fuente de marca. Si propone un trial de Pangram, te avisa de que esa licencia no cubre producción.
- **No inventa fotos ni cifras.** Te pide las tuyas o deja placeholders etiquetados con medidas y la toma descrita. El hero de estas páginas se sostiene con imagen real, no con un gradiente.

### Otros comandos

| Comando | Qué hace |
|---|---|
| `/diseno variantes del hero` | Tres direcciones distintas detrás de un selector; respondes `keep <variante>` y se integra |
| `/diseno revisa src/components/Modal.tsx` | Solo diagnóstico; no toca tu código. Deja el informe en `.impeccable/critique/` (añádelo a `.gitignore` si no quieres versionarlo) |
| `/diseno ajusta el botón primario, se ve plano` | Modo rápido: sin preguntas, aplica las reglas rápidas y corre el detector |
| `/diseno` | Menú y estado de instalación |

Puedes dar contexto en la misma línea para saltarte preguntas:
`/diseno rediseña src/pages/Login.tsx, app de gastos para freelancers, conservar la marca, look sobrio, movimiento mínimo`

## Qué te pregunta y por qué

| Ronda | Cuándo | Preguntas |
|---|---|---|
| 1. Propósito | Siempre que el prompt sea escueto | Qué debe lograr quien llega (decidir, completar una tarea, entender, ver la obra), quién es, conservar o cambiar el look, qué sensación, qué es único; en registro inmersivo se suman la firma de movimiento y los assets (tus fotos y vídeo, o placeholders) |
| Sistema | La primera vez en el proyecto si no hay `DESIGN.md` ni código de UI, y cuando eliges cambiar el look | Fuente de marca o elegir una, colores de marca o neutros más un acento, forma de los componentes, modo claro u oscuro; en un proyecto vacío, también con qué stack construir |
| 2. Dirección | Solo si queda un hueco | Referencias, qué no tocar, cuánta animación, si quieres tres variantes |
| Confirmar | Siempre, una sola | Adelante, más sobrio, más atrevido, o un cambio concreto |

Nunca pregunta valores CSS, hex ni píxeles. Nunca repite lo que ya dicen `PRODUCT.md`, `DESIGN.md` o tu línea de comando. Lo habitual son dos rondas y la confirmación; la primera vez en un proyecto se suman la ronda de sistema (o una o dos preguntas cortas de `impeccable document` si extrae el sistema del código) y la ronda de producto de `impeccable init`. Después de eso, ninguna pantalla vuelve a preguntar lo ya guardado.

## Ejemplo de conversación

```
Tú:     /diseno rediseña src/pages/Login.tsx
Claude: Lectura previa: pantalla de app (Operate), React + Tailwind v3, sin DESIGN.md, usa Inter y lucide, sin estados de error.
        [Pregunta] ¿Quién llega?                  → Usuario que ya lo usa a diario
        [Pregunta] ¿Conservamos la identidad?     → Conservar y pulir
Claude: No hay DESIGN.md: extraigo el sistema del código con impeccable document…
        [Pregunta] ¿Cómo describirías el carácter del sistema?  → Sobrio y de trabajo
        Sistema: Inter, azul #2563eb como único acento, radios 8 px, modo claro.
        Lectura de diseño: login para usuarios recurrentes, lenguaje sobrio, apoyado en los tokens actuales.
        Modo Operate · Diales 4/2/4 · Ruta B · No se toca: rutas, nombres de campos, copy.
        Cambios de sistema propuestos: reemplazar Inter por Satoshi (el detector marca Inter; di "mantén Inter" si es de marca).
        [Pregunta] ¿Avanzamos con este brief?     → Sí, adelante
Claude: critique + auditoría: 9 hallazgos → edito → detector: 7 hallazgos antes, 0 después → build OK.
        Cambié la fuente por Satoshi, un solo acento, estados focus/error/loading y feedback :active en el botón.
        DESIGN.md refrescado con Satoshi; las próximas pantallas lo heredan.
```

## Cómo funciona por dentro

Fases: estado de instalación → contexto sin preguntar → entrevista → sistema del proyecto → brief y confirmación → ejecución por ruta → verificación → entrega.

| Ruta | Cuándo | Quién construye |
|---|---|---|
| R | Ajuste puntual | Reglas rápidas de la skill + detector |
| B | Rediseño conservando | Impeccable `critique` + auditoría de taste + Impeccable `polish` |
| C | Landing o portafolio nuevo | taste-skill con diales y sistema fijo + `craft-floor` de Impeccable |
| D | Pantalla de app nueva, o cambio de look en una pantalla de app | Impeccable (modo Operate), con lo que fijaste como pinned |
| E | Cambiar el look de marketing | Auditoría de taste + taste en modo overhaul |
| X | Registro inmersivo en marketing, nuevo o rediseño (sustituye a C y E) | Playbook propio (`inmersivo.md` y `escenografia.md`) + `craft-floor` de Impeccable + GSAP y Lenis |
| F | Variantes | `prototype` de Emil (tres direcciones) y luego B, C, D o X |
| G | Con referencias | Lectura de referencia y luego B, C, D, E o X |
| S | Sistema | `impeccable document` o ronda de sistema, escribe `DESIGN.md` |

Cuando los paquetes se contradicen manda, en este orden: tu brief, el playbook `inmersivo.md` si el registro es inmersivo, el proceso y el detector de Impeccable, las reglas de taste en marketing (Impeccable en UI de app), y las reglas de Emil en todo lo que se mueve; en la ruta X la escenografía de scroll se rige por `escenografia.md` y Emil sigue mandando en botones, menús, acordeones y carruseles. Detalle completo en [`skills/diseno/SKILL.md`](skills/diseno/SKILL.md).

## Consejos para buenos resultados

- Una pantalla por sesión. Entre dos, `/compact`.
- Nombra archivos y rutas. "El login" funciona; `src/pages/Login.tsx` funciona mejor.
- Si el proyecto ya tiene marca, pásale el logo y los colores la primera vez; quedan en `DESIGN.md`.
- Si propone migrar a Next, dile "stack fijo". La skill ya lo pide, pero tu brief manda. En registro inmersivo GSAP y Lenis sí se instalan: van en la línea `Cargaré:` del brief y puedes vetarlos ahí.
- Con referencias, di qué te gusta de cada una ("la estructura de Linear, el color de Stripe"). Ahorra una pregunta.
- Para una página inmersiva, ten los assets a mano antes de empezar: una foto o un vídeo de producto real cambian más el resultado que cualquier librería.

## Problemas frecuentes

| Síntoma | Qué hacer |
|---|---|
| No aparece `/diseno` al escribir `/` | Reinicia Claude Code. Comprueba que existe `~/.claude/skills/diseno/SKILL.md`. |
| En otro agente no hay `/diseno` | Normal: solo Claude Code y Cursor le dan barra. En Codex es `$diseno`; en Gemini CLI y opencode se pide por su nombre o se crea el comando puntero de [Instalar en otros agentes](#instalar-en-otros-agentes). Comprueba con `bash ~/.agents/skills/diseno/scripts/estado.sh`. |
| `npx: command not found` o Node menor a 22.20 | Instala Node 22.20 o superior desde nodejs.org (incluye npm y npx) y repite la instalación. |
| Pide permiso en cada comando | Agrega el bloque de permisos de la sección de instalación (con tu usuario en la ruta absoluta). |
| "skill impeccable not found" o aparece `impeccable:impeccable` | Lo instalaste como plugin. Desinstálalo desde `/plugin` y reinstala con el comando de Impeccable de la Opción B. `estado.sh` lo avisa. |
| Aparecen hooks de Impeccable en `~/.claude/settings.local.json` | Corriste `npx impeccable install` o `update` sin `--no-hooks`. Borra el bloque `hooks` de ese archivo si no lo quieres en todos tus proyectos. `estado.sh` lo avisa. |
| Se abre una página en el navegador al crear una pantalla de app | Es la página de decisión de Impeccable: elige una dirección ahí y vuelve a Claude. |
| El detector dice "DEGRADED" | Claude usó el script local de respaldo (mismas reglas, sin parser HTML, cuenta de menos). Pídele que repita con `npx impeccable detect <archivo>`; ese es el completo. |
| La respuesta se corta o el contexto está muy largo | `/compact` y repite el comando. Una pantalla por sesión. |
| Una skill dice `MISSING` aunque la carpeta existe | Reinstala añadiendo `--copy` al final del comando `npx skills add …`. |
| Claude propone migrar a Next o instalar una librería de animación | Dile "stack fijo". La skill ya lo pide, pero el brief manda. Excepción: en registro inmersivo GSAP y Lenis están previstos y se anuncian en `Cargaré:`; di "sin librerías" antes de confirmar si no los quieres. |
| `UIPRO=no` o `PYTHON3=no` en `estado.sh` | Es el paso 5 opcional: no bloquea nada. Instálalo con `npx -y ui-ux-pro-max-cli init --ai claude --global` y comprueba `python3 -V`. |
| Pidió una página inmersiva y salió sobria | Revisa el brief: `Registro` tiene que decir `inmersivo`. Repite el pedido con la palabra inmersivo, con `MOTION_INTENSITY` 8 o con una URL de referencia. En pantallas de app el registro inmersivo está bloqueado a propósito. |

## Actualizar y desinstalar

```bash
cd ~ && npx -y impeccable update --no-hooks && npx -y skills@latest update -g -y && bash ~/.claude/skills/diseno/scripts/estado.sh
```

En otro agente, la última comprobación es `bash ~/.agents/skills/diseno/scripts/estado.sh`. `skills update` actualiza todo lo instalado con esa CLI, sin importar para cuántos agentes.

Desinstalar:

```bash
npx -y skills@latest remove -g -y -s diseno design-taste-frontend redesign-existing-projects animate review-animations prototype
```

Impeccable no tiene desinstalador: borra `~/.claude/skills/impeccable` y `~/.claude/agents/impeccable-*.md`.
UI/UX Pro Max se actualiza repitiendo su comando de instalación y se desinstala borrando sus carpetas de `~/.claude/skills` (las siete que lista el paso 5: `ui-ux-pro-max` más las seis extra).

## Estructura del repo

```
style-agent/
├── README.md
├── CLAUDE.md                       # instrucciones para trabajar en este repo (pruebas, convenciones)
├── install.sh                      # instala los tres paquetes, la skill y el opcional, en global y para uno o varios agentes (--agent)
├── LICENSE                         # MIT
└── skills/
    └── diseno/
        ├── SKILL.md                # el orquestador: fases, rutas, precedencia
        ├── entrevista.md           # preguntas por ronda, reglas de salto, diales
        ├── reference/
        │   ├── reglas-rapidas.md   # reglas anti "look de IA" para modo rápido y degradado
        │   ├── design-md.md        # plantilla de DESIGN.md (formato oficial)
        │   ├── inmersivo.md        # playbook de dirección visual de la ruta X (evidencia de los 7 sitios)
        │   ├── escenografia.md     # recetas de GSAP y Lenis: setup, reveals, firmas, verificación
        │   └── referencias-externas.md  # Mobbin público, UI/UX Pro Max local, Cosmos, Three.js
        └── scripts/
            └── estado.sh           # detecta paquetes, CLI de Impeccable, Python, librerías y el proyecto
```

Para desarrollar la skill en local: `bash install.sh` desde el clon, o `npx -y skills@latest add /ruta/a/style-agent -g -a claude-code -y -s diseno` (ruta relativa o absoluta).

## Créditos y licencias

Esta skill no modifica ni redistribuye los paquetes que orquesta; los instala desde sus repos originales:
[Impeccable](https://github.com/pbakaus/impeccable) (Apache 2.0, Paul Bakaus), [taste-skill](https://github.com/Leonxlnx/taste-skill) (MIT, Leonxlnx), [emilkowalski/skills](https://github.com/emilkowalski/skills) (MIT, Emil Kowalski) y, como paso opcional, [UI/UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) (MIT, NextLevelBuilder). El formato de `DESIGN.md` es de [google-labs-code/design.md](https://github.com/google-labs-code/design.md).

Librerías que la ruta X puede instalar en tu proyecto, siempre desde npm o su CDN y con la versión fijada en el brief: [GSAP](https://gsap.com/) (licencia estándar de GreenSock, todos los plugins gratis desde 3.13), [Lenis](https://github.com/darkroomengineering/lenis) (MIT) y [Three.js](https://threejs.org/) (MIT, three.js authors) solo si el brief pide 3D.

[Mobbin](https://mobbin.com/) se usa como referencia visual con crédito al sitio original: la skill no re-publica ni redistribuye sus capturas, y sus imágenes no acaban en el entregable. Igual con [Cosmos](https://www.cosmos.so/), que además solo se consulta si tú pegas la URL. Los siete sitios citados como referencia (biologica, drinkpouch, yucca, sylverrappresentanze, eatnaked, skanvi, oddritualgolf) son propiedad de sus marcas: se estudian sus patrones, no se copian sus assets.

style-agent se publica bajo licencia MIT.
