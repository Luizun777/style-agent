---
name: diseno
description: Diseña o rediseña pantallas, landings, logins, dashboards, portfolios y componentes para que no parezcan hechas por IA; desde cero, sobre código existente o con referencias ("como esta web", capturas). Orquesta también el registro inmersivo, páginas de marca al nivel de Awwwards con GSAP y Lenis, apoyadas en Mobbin público y UI/UX Pro Max como referencias. Úsala cuando el usuario pida diseñar, rediseñar, mejorar el look, una página cinematográfica o diga que algo "se ve genérico". Orquesta impeccable, design-taste-frontend, redesign-existing-projects, animate, review-animations y prototype; úsala en lugar de invocarlos por separado. No para backend ni tareas sin UI.
argument-hint: "[crea|rediseña|variantes|revisa|ajusta|sistema] <pantalla o página> [archivos] [como <URL o imagen>]"
allowed-tools:
  - Read
  - Glob
  - Grep
  - Edit
  - Write
  - AskUserQuestion
  - Skill
  - WebFetch
  - Bash(bash ${CLAUDE_SKILL_DIR}/scripts/estado.sh*)
  - Bash(npx impeccable *)
  - Bash(node ~/.claude/skills/impeccable/scripts/*)
  - Bash(~/.claude/skills/impeccable/scripts/impeccable *)
  - Bash(grep *)
  - Bash(LC_ALL=C grep *)
  - Bash(ls *)
  - Bash(git status*)
  - Bash(git diff*)
  - Bash(npm run build*)
  - Bash(npx tsc --noEmit*)
  - Bash(npx vite build*)
  - Bash(npm install *)
  - Bash(npm i *)
  - Bash(pnpm add *)
  - Bash(curl -sL *)
  - Bash(curl -sL * -o *)
  - Bash(python3 *)
  - Bash(python3 -m http.server *)
  - Bash(kill *)
  - KillShell
  - mcp__Claude_Browser__navigate
  - mcp__Claude_Browser__computer
  - mcp__Claude_Browser__read_page
  - mcp__Claude_Browser__resize_window
  - mcp__Claude_Browser__read_console_messages
  - mcp__claude-in-chrome__navigate
  - mcp__claude-in-chrome__computer
  - mcp__claude-in-chrome__read_page
  - mcp__claude-in-chrome__resize_window
  - mcp__claude-in-chrome__read_console_messages
---

# /diseno · diseño sin "look de IA"

Argumentos recibidos: `$ARGUMENTS`

## Reglas de sesión

- Responde en español. Muestra la salida real de cada comando; nunca digas "ya verifiqué" sin evidencia.
- Cero em-dash y cero en-dash (guion largo `U+2014` y guion medio `U+2013`) en cualquier texto visible de la UI (títulos, botones, párrafos, captions, alt). Usa punto, coma o dos puntos.
- Carga de paquetes ("carga X" es el rol "cargar otra skill" de la Fase 0b): `design-taste-frontend` se carga UNA sola vez por sesión. `impeccable` se carga una vez por subcomando (`document`, `init`, `critique`, o la construcción de la ruta D); nunca repitas el mismo subcomando. Sus referencias (`polish.md`, `craft-floor.md`, `typeset.md`, `layout.md`) siempre se leen, nunca se cargan. `prototype` y `review-animations` no se cargan nunca: se lee su `SKILL.md` y se aplica.
- Sin herramienta de carga de skills, cada subcomando de Impeccable **es** su referencia: `document` → `<IMPECCABLE>/reference/document.md`, `init` → `<IMPECCABLE>/reference/init.md`, `critique` → `<IMPECCABLE>/reference/critique.md`, y la construcción de la ruta D lo que dice esa ruta. Antes del primero, corre UNA sola vez `node <IMPECCABLE>/scripts/context.mjs` desde la carpeta del proyecto: es el Setup que Impeccable pide "once per session" y que en Claude Code dispara la propia carga, pero fuera de ahí no dispara nadie. Declara en la entrega que fue por lectura y no por carga.
- Nunca cargues `design-taste-frontend` en modo rápido ni en pantallas de app (modos Operate y Read), y nunca en la ruta X (ahí solo se leen dos trozos suyos). Nunca leas `reference/new-work.md` de Impeccable en rutas taste (C y E); en la ruta X sí se lee su §6.
- Una superficie por sesión. Si el usuario pide una segunda, sugiere compactar el contexto antes de empezarla (`/compact` en Claude Code; en otro agente, su equivalente, y si no lo tiene no lo menciones).
- Si no hay quien responda (sesión no interactiva, o la pregunta con opciones falla o no bloquea el turno): no inventes respuestas del usuario; toma la lectura más probable, márcala como SUPUESTO en el brief, sigue la ruta más conservadora (B antes que E, sin variantes) y lista los supuestos en la entrega. En **registro inmersivo sin interlocutor** la ruta X se queda (no degrada a C ni se aborta), pero en su versión conservadora declarada: `Firma: scrub tipográfico` (la única que no necesita material real en una página única; ver `inmersivo.md` "Hero tesis"), `Instrumentos: ninguno`, `Cargaré:` limitado a `gsap@3.15.0` y `lenis@1.3.26`, y las tres líneas marcadas SUPUESTO en el brief y repetidas en la entrega. La Firma es la decisión más cara de la ruta: no se inventa otra sin confirmación.
- No inventes testimonios, clientes, cifras ni precios. Placeholders etiquetados sí.
- Trabaja dentro del stack existente. No migres frameworks ni instales librerías de animación salvo que ya estén en `package.json`. **Excepción única**: con Registro inmersivo y el brief confirmado en la Fase 3, puedes añadir `gsap` y `lenis` con versión exacta (hoy `gsap@3.15.0` y `lenis@1.3.26`; todos los plugins de GSAP son gratis desde 3.13), `three@0.186.0` solo si la Firma exige 3D en tiempo real, y `@barba/core@2.10.3` solo si la Firma es transiciones de página (antes valora la View Transitions API o las transiciones nativas de Astro, que son gratis: `escenografia.md` sección "Firmas", subsección "Transiciones de página"). Se anuncian en la línea `Cargaré:` antes de preguntar; sin confirmación no se instala nada. Nunca añadas Motion, Framer Motion, Swiper ni Locomotive.
- `python3` está permitido para tres cosas y nada más: el `search.py` de UI/UX Pro Max (Fase 2b), el extractor de Mobbin de `<DISENO>/reference/referencias-externas.md` y `python3 -m http.server <puerto>` para servir el entregable y poder capturarlo (Fase 5). No escribas scripts propios ni toques archivos del usuario con Python. El permiso del frontmatter es `Bash(python3 *)`, más amplio que esos tres usos, porque el extractor de Mobbin se invoca como `python3 - <archivo> <<PY` (heredoc) y no encaja en un patrón acotado tipo `Bash(python3 * search.py *)`. La restricción a esos tres usos es esta regla, no el permiso: cualquier otra invocación de `python3` está fuera de la skill.
- Fuentes: se descargan con `curl -sL <url> -o <archivo>` siguiendo la "Receta de descarga" de `<DISENO>/reference/inmersivo.md` sección "Tipografía y pool de fuentes" (una petición por familia; la API de Fontshare descarta familias si se agrupan y sus URLs son relativas al protocolo). Si ese permiso no está disponible en la sesión, las fuentes se entregan como **pendientes** y el punto 5 del Checklist X no se marca; dilo con esas palabras.
- Registro inmersivo: `<DISENO>/reference/inmersivo.md` sustituye las líneas de `<DISENO>/reference/reglas-rapidas.md` marcadas "(en registro inmersivo: ver inmersivo.md)" (hero, etiquetas y numeración, glass, marquee, fuentes, un solo acento, display y pesos, tema de página y presupuesto de movimiento). El resto de ese archivo sigue vigente; accesibilidad, contraste y "nada inventado" no se relajan en ningún registro.
- Con referencias: inspírate en estructura, ritmo y tono; nunca clones logos, copy, fotos ni fuentes con licencia ajena.
- Marcadores de ruta: `<DISENO>` es la carpeta de esta skill y `<IMPECCABLE>`, `<TASTE>`, `<REDESIGN>`, `<ANIMATE>`, `<REVIEW_ANIM>` y `<PROTOTYPE>` las de los paquetes; todos salen de las líneas `KEY=VALOR` de estado.sh (Fase 0). En Claude Code `<DISENO>` equivale a `${CLAUDE_SKILL_DIR}`; antes de la Fase 0 vale la carpeta desde la que el agente cargó este archivo (varios agentes la inyectan como base directory de la skill). Si tu agente no te dice esa carpeta (Codex y Cursor inyectan el contenido de este archivo sin ruta), localízala por consola antes de la Fase 0: `ls -d ~/.agents/skills/diseno ~/.claude/skills/diseno ./.agents/skills/diseno ./.claude/skills/diseno 2>/dev/null | head -1`. Son las mismas raíces que recorre `estado.sh`; si no aparece ninguna, pide al usuario la ruta y no sigas. La carpeta del proyecto es el directorio de trabajo actual. Al leer usa siempre rutas absolutas.
- Esta skill funciona en cualquier agente que lea skills de disco (Claude Code, Codex, Gemini CLI, Cursor, opencode y los demás): la Fase 0b traduce cada herramienta y el resto del archivo no depende de Claude. La instalación multiagente está en el `README.md` del repo. Si al agente le falta una capacidad, se declara en la entrega en vez de fingirla.
- Impeccable por consola: el comando principal es **siempre** `npx impeccable detect …`, sea cual sea el valor de `IMPECCABLE_CLI`. Esa clave describe solo el **fallback** disponible si `npx` falla, no la ruta que se va a usar: con `IMPECCABLE_CLI=node` e `IMPECCABLE_VERSION=4.1.3`, `npx impeccable detect --json` corre igualmente con parser HTML completo (verificado: resuelve colores computados y fondos). Fallbacks: con `launcher`, `~/.claude/skills/impeccable/scripts/impeccable detect --json <archivos>`; con `node`, `node ~/.claude/skills/impeccable/scripts/detect.mjs --json <archivos>`. Escribe `~` literal (así coincide con los permisos); si estado.sh devolvió otra carpeta, usa esa.

## Fase 0 · Estado

Corre `bash <DISENO>/scripts/estado.sh` desde la carpeta del proyecto (sin argumento resuelve el directorio de trabajo actual). Guarda cada `KEY=VALOR`: `<DISENO>` es esta skill; `<IMPECCABLE>`, `<TASTE>`, `<REDESIGN>`, `<ANIMATE>`, `<REVIEW_ANIM>` y `<PROTOTYPE>` son los paquetes; `UI_CODE` dice si el proyecto ya tiene código de UI (empieza por `si` o `no`); `PRODUCT.md` y `DESIGN.md` dicen si existen. Guarda también: `IMPECCABLE_CLI` (`launcher`, `node` o `MISSING`) e `IMPECCABLE_VERSION`, que describen el **fallback** del detector, no el comando principal; `NODE` (versión de Node o `MISSING`); `UIPRO` (ruta al `search.py` de UI/UX Pro Max, o `no`) y `PYTHON3`, que habilitan el piso uupm de la Fase 2b; `AGENTE`, que dice desde qué raíz se resolvió esta skill (`claude-global`, `agents-global`, `claude-proyecto`, `agents-proyecto` u `otro`) y es solo informativo: no decide capacidades, para eso está la Fase 0b; `SKILLS_DIR`, la carpeta donde viven los paquetes; y `LIBS`, las librerías de movimiento ya presentes en `package.json` (o `ninguna`), que es la línea base de `Cargaré:`. `UIPRO=no` o `PYTHON3=no` no bloquean nada ni son motivo de modo degradado: solo desactivan ese piso, y se dice en una línea.

- Si sale con 1: imprime tal cual las líneas `instalar:` y sigue en **modo degradado**: para cada paquete que falte usa `<DISENO>/reference/reglas-rapidas.md`.
- Si imprime líneas `AVISO=`, repítelas al usuario antes de seguir.
- Si no recibiste argumentos, es decir, si la línea "Argumentos recibidos" quedó vacía **o llegó con el literal `$ARGUMENTS` sin sustituir** (pasa en Codex, Gemini CLI y opencode, que no sustituyen esa variable dentro de un `SKILL.md`): trátalo como sin argumentos, muestra el estado y este menú, y para. No ejecutes nada y nunca tomes esa cadena por la petición del usuario. El menú se escribe con la forma de invocación de tu agente (`/diseno …` en Claude Code, `$diseno …` en Codex, la que use el tuyo).
  - `/diseno crea <pantalla o landing>`
  - `/diseno rediseña <pantalla o archivo>`
  - `/diseno crea|rediseña <…> como <URL o imagen>` (con referencias)
  - `/diseno sistema` (documentar o definir el sistema del proyecto: tipografía, paleta, forma, modo)
  - `/diseno variantes <componente>`
  - `/diseno revisa <archivo>` (solo diagnóstico; no toca tu código)
  - `/diseno ajusta <cambio puntual>` (modo rápido, sin preguntas)

## Fase 0b · Capacidades del agente

`Read <DISENO>/reference/capacidades.md`, sección "Tabla de roles": ahí está la traducción de cada rol (leer archivo, leer archivo mostrando imágenes, recibir imágenes pegadas, escribir, editar, listar, buscar, consola, proceso en segundo plano, traer una URL, preguntar con opciones, cargar otra skill, lanzar un subagente, generar imágenes, navegador) a la herramienta preferida en Claude Code y a su degradación, más las reglas de detección y de capacidad crítica ausente. Ese archivo manda sobre cualquier nombre de herramienta que aparezca en el resto de este `SKILL.md`.

## Fase 1 · Contexto sin preguntar

1. Intención a partir de los argumentos: `crea` | `rediseña` | `variantes` | `revisa` | `ajusta` | `sistema`. Sin verbo: archivo existente → `rediseña`; no existe nada → `crea`.
   Modificador **G** (referencias): hay URLs, rutas de imagen, imágenes pegadas en el chat, o palabras como "como", "referencia", "inspirado en", "parecido a".
2. Superficie: **marketing** (landing, portafolio, pricing, página pública) o **app** (login, formulario, panel, dashboard, ajustes, docs).
3. Lee fragmentos, no archivos enteros: `PRODUCT.md` y `DESIGN.md` si existen; `package.json` (framework, tailwind v3 o v4, motion/framer-motion/gsap, lucide/phosphor); tokens (`tailwind.config.*`, `:root`, `globals.css`); `git status --short`.
4. Localiza los archivos objetivo con Glob por nombre (`login|signin|landing|hero|<término del usuario>`) y lee solo lo relevante.
5. Escribe la **Lectura previa** en 5 viñetas: superficie y modo probable · stack y tokens · estado visual actual en una frase (de ahí salen los diales "existentes" de un rediseño) · lo ya decidido (PRODUCT.md, DESIGN.md, referencias o el usuario) · lo que falta saber.
6. **Registro**: `estándar` o `inmersivo`. Es inmersivo si se cumple UNA de estas señales: modo Experience; Vibra "Inmersiva y cinematográfica"; `MOTION_INTENSITY >= 8` con la Vibra distinta de "Atrevida y creativa" (esa vibra lleva MOTION a 8 o más por definición y su sitio es la ruta C: es variación alta y desorden buscado, no composición disciplinada; `entrevista.md` pregunta Vibra); el argumento trae las palabras inmersivo, inmersiva, cinemático, cinematográfico, awwwards o editorial premium; o la Lectura de referencia técnica (ruta G) detectó `gsap`, `lenis`, scrub, vídeo en el hero o `canvas`. Nunca es inmersivo en app UI (modos Operate y Read): ahí se queda en estándar aunque el argumento lo pida, y lo dices en una línea. Tampoco es inmersivo si la Vibra elegida es "Confiable y formal" (sector regulado o accesibilidad crítica): sobrescribe cualquier otra señal y vuelve a estándar (`entrevista.md`, Reglas de salto y tabla de diales). Varias señales salen de la entrevista, así que el registro se cierra al final de la Fase 2 y se imprime en el brief.
   Enrutado: en **marketing** con registro inmersivo, `crea` → ruta **X** y `rediseña` + "Cambiar el look" → ruta **X** (sustituye a C y a E). `rediseña` + "Conservar y pulir" sigue en **B**, con `inmersivo.md` como referencia de pulido si el sitio ya es inmersivo.

Atajos por intención:
- **Modo rápido** (`ajusta`, o un cambio de una propiedad o un componente sin verbo de diseñar): ruta **R**, sin entrevista.
- **`revisa`**: solo diagnóstico, pasos B.1 y B.2, luego la lista de hallazgos y para. No toca el código del usuario; critique deja su informe en `.impeccable/critique/` (dilo). Al invocar critique añade: `Cierra con la línea literal "Questions skipped: modo revisa"`.
- **`sistema`**: solo la Fase 2b (ruta **S**) y para.

## Fase 2 · Entrevista

Lee `<DISENO>/entrevista.md` y aplícala: reglas de salto, Ronda 1 (2 o 3 preguntas), Ronda 2 solo si queda un hueco material. Pregunta con opciones (Fase 0b). Prompt preciso → salta las Rondas 1 y 2, pero la **Fase 2b se ejecuta siempre** antes de la Fase 3. En `rediseña` sin Alcance explícito, asume "Conservar y pulir" y márcalo como SUPUESTO en el brief. Con referencias (G), haz primero la Lectura de referencia y úsala como respuesta a "Vibra" y "Referencias".

- **Stack en proyecto vacío** (`PACKAGE_JSON=no` y `UI_CODE=no`): la Ronda 1 incluye siempre la pregunta `Stack` de entrevista.md. Su respuesta va a `stack=` de `init`, a `Stack fijo:` de taste y a la línea Cargaré del brief. Sin respuesta, fija "HTML, CSS y JS estáticos" como SUPUESTO; nunca dejes el stack vacío (taste crearía Next + Tailwind v4 + Motion por defecto).
- **Registro inmersivo**: la Ronda 1 incluye además `Firma` y `Assets` de entrevista.md. La Firma es UNA sola; los Instrumentos no se preguntan, se derivan de `inmersivo.md` sección "Instrumentos" y se declaran en el brief. En la pregunta `Stack`, la opción inmersiva ("Sitio editorial con animación: HTML, CSS y JS + GSAP + Lenis") es la que ofreces como "Recomienda tú". Si el proyecto ya tiene stack, no preguntes: GSAP y Lenis se añaden a ese stack sin migrarlo.

## Fase 2b · Sistema del proyecto (estandarizar para futuras pantallas)

El sistema vive en `DESIGN.md` (formato oficial DESIGN.md: frontmatter con tokens + secciones) y los hechos de producto en `PRODUCT.md`. Se establece una vez por proyecto; después cada pantalla lo hereda y no se vuelve a preguntar.

- **Existe `DESIGN.md` con tokens** (`colors` y `typography` en el frontmatter): léelo y resume en 4 líneas (fuente, paleta, radios y espaciado, modo e iconos). Es el **Sistema fijo** de todas las rutas. Solo se reemplaza si el usuario eligió "Cambiar el look", al final y con confirmación. Si el archivo no tiene tokens o su frontmatter trae `status: seed`: trátalo como "propuesto", no fijo, confírmalo en el brief y, al terminar de construir, reescríbelo con los tokens reales y quita el marcador (Fase 6).
- **No existe, `UI_CODE=si` y Alcance no es "Cambiar el look"**: carga `impeccable` con `document. Datos ya conocidos: North Star=<propuesto desde la Vibra>; adjetivos=<de la Vibra y la Lectura previa>; nombres descriptivos de color=<…>; filosofía de elevación=<…>. Una sola ronda de 3 preguntas como máximo; lo demás dedúcelo del código.` (por eso en B sin `DESIGN.md` la Ronda 1 incluye Vibra). Escribe `DESIGN.md` y trátalo como Sistema fijo.
- **No existe, `UI_CODE=si` y Alcance es "Cambiar el look"**: no documentes el look que se va a tirar. Usa el Scan de `<REDESIGN>/SKILL.md` como evidencia y anti-referencia. Si las referencias no fijan tokens, haz la **Ronda Sistema** con sus opciones de rediseño ("mantener la fuente actual", "mantener la paleta", "propón tú"); "propón tú" se marca como SUPUESTO. Eso es el "sistema nuevo acordado" de D y E; el `DESIGN.md` nuevo se escribe al final con los tokens reales.
- **Existe `DESIGN.md` y Alcance es "Cambiar el look"**: misma Ronda Sistema adaptada; el archivo actual es solo evidencia y se reemplaza al final con confirmación.
- **No existe y `UI_CODE=no`** (proyecto desde cero): haz la **Ronda Sistema** de `entrevista.md` (una sola llamada). Anota las respuestas como "Sistema propuesto" en el brief. Se escribe `DESIGN.md` al terminar de construir, con los tokens que quedaron en el código, usando `<DISENO>/reference/design-md.md`.
- **Registro inmersivo sin `DESIGN.md`**: el Sistema propuesto se construye con `<DISENO>/reference/inmersivo.md`, secciones "Tipografía y pool de fuentes", "Color" y "Ritmo y layout" (de ahí salen la curva de la casa y las dos duraciones; los valores canónicos están en `<DISENO>/reference/escenografia.md` sección "Setup GSAP + Lenis"), más las respuestas de la Ronda Sistema; incluye ya la curva de la casa y las dos duraciones. Si `UIPRO` no es `no` y `PYTHON3=si`, haz UNA sola llamada como piso: `python3 <UIPRO> "<producto> <sector> <vibra>" --design-system -p "<Proyecto>" --variance <a> --motion <b> --density <c>` (nunca con `--persist`, que colisiona con `DESIGN.md`). Es piso, no autoridad: cítala en el brief como "piso uupm" y toma de ella **solo el esqueleto de capítulos y los datos de licencia de fuentes**. Se ignoran su estilo, su paleta, su pareja tipográfica y su checklist de entrega: los tres últimos contradicen esta skill (llamada real medida: estilo "Brutalism" con keywords "plain text, default fonts", paleta negro más oro, pareja Cormorant + Montserrat con Montserrat en la lista negra, un `@import` de Google Fonts que `inmersivo.md` prohíbe, y una "PRE-DELIVERY CHECKLIST" que manda Heroicons o Lucide contra la regla de iconos de la tabla de precedencia). La fuente y el color salen del playbook. Nunca fija tokens por sí sola.
- **Ruta S (`sistema`)**: con `UI_CODE=si` y sin `DESIGN.md`, `impeccable document`. Con `UI_CODE=no`, Ronda Sistema (más la pregunta `Stack`) y escribe ya `DESIGN.md` con la plantilla, con `status: seed` en el frontmatter y "tokens acordados, aún sin código" en Overview. Con `DESIGN.md` existente, una pregunta con opciones (header `Sistema`): Refrescar desde el código · Mezclar con el código · Reemplazar (Ronda Sistema) · Dejar como está. Para las dos primeras carga `impeccable` con `document. El usuario ya eligió: refresh|merge; no vuelvas a preguntar; muestra el diff al final.` Luego para.

## Fase 3 · Brief y confirmación única

Imprime:

```
Lectura de diseño: <tipo de página> para <audiencia>, lenguaje <vibra>, apoyado en <sistema o estética>.
Modo: Persuade | Operate | Read | Experience
Registro: estándar | inmersivo
Diales: DESIGN_VARIANCE=a · MOTION_INTENSITY=b · VISUAL_DENSITY=c   (una razón por dial)
Ruta: R | B | C | D | E | F | X (+ G si hay referencias)
Referencias: <Lectura de referencia en una línea, o "ninguna">
Sistema: <fijo desde DESIGN.md | propuesto: fuente, paleta, radios, modo | lo extrajo impeccable document | propuesto con piso uupm>
Cambios de sistema propuestos: <p. ej. "reemplazar Inter por Satoshi", o "ninguno">
Firma: <una sola: vídeo macro en hero | producto 3D o secuencia atada al scroll | scrub tipográfico | scroll horizontal por paneles | transiciones de página | ninguna>
Instrumentos: <preloader, cursor, marquee x N, sonido, índice; cada uno con su condición o "ninguno">
No se toca: …
Cargaré: <paquetes y librerías con versión>
```

Las líneas `Firma:` e `Instrumentos:` solo aparecen con Registro inmersivo; en registro estándar se omiten. El techo es una firma y dos instrumentos por página; el cómputo exacto (qué fila cuenta, por qué los dos marquees cuentan como uno y cuándo "transiciones de página" gasta la Firma en vez de un instrumento) está en `inmersivo.md` sección "Instrumentos". Si el usuario pide más, di qué se cae y por qué. `Cargaré:` lleva siempre versión exacta de cada librería nueva (`gsap@3.15.0`, `lenis@1.3.26`, `three@0.186.0`, y `@barba/core@2.10.3` solo si la Firma es transiciones de página) y de dónde sale (npm, o import map de esm.sh o jsdelivr con esa misma versión fijada).

Si Registro es inmersivo y no hay assets reales (foto de estudio, vídeo o secuencia), dilo en el brief con esta letra: sin material real la receta degrada a texto sobre fondo plano y no alcanza el nivel. Lista qué placeholders vas a usar, con medidas, formato y la toma descrita en una frase, y que hay que sustituirlos. En esa rama la línea `Firma:` solo puede decir **scrub tipográfico** o **transiciones de página** (las otras cuatro dependen de material que aún no existe); el glass degrada a sólido y el parallax no se crea, y las tres cosas se dicen en el brief. Detalle en `inmersivo.md` sección "Hero tesis".

Si la ruta es D **y tienes herramienta de carga de skills** (Fase 0b), añade: "Si la pantalla necesita un mundo visual nuevo, Impeccable puede abrir una página de decisión en tu navegador; es normal, elige ahí y vuelve". Sin esa herramienta no prometas la página de decisión: no se va a abrir (y en un shell con sandbox tampoco podría abrir puerto); di en su lugar que el mundo visual lo decides tú con el brief. Haz UNA pregunta con opciones (header `Confirmar`): Sí, adelante · Más sobrio (diales -2) · Más atrevido (diales +2) · cambios vía Other. Esta confirmación es también la autorización para instalar lo que diga `Cargaré:`.

El Registro ya está cerrado y no se reabre con esa respuesta. Si "Más atrevido" deja `MOTION_INTENSITY` en 8 o más en una superficie de marketing de registro estándar, mantén la ruta confirmada, dilo en una línea y ofrece repetir el pedido con la palabra inmersivo. Si "Más sobrio" deja `MOTION_INTENSITY` por debajo de 8 en un brief inmersivo, el registro tampoco cambia: baja las duraciones y el número de instrumentos dentro de la ruta X.

Si el usuario veta las librerías en el Other de Confirmar ("sin librerías"), `Cargaré:` pasa a `ninguna`, se conserva la ruta X y la escenografía se construye con CSS scroll-driven animations (`animation-timeline: view()` y `scroll()`), `IntersectionObserver` y `scroll-behavior: smooth`; no hay Lenis, no hay pin y no hay scrub. En la Fase 5 se omiten las filas de la tabla de `escenografia.md` que citan GSAP o Lenis (las cuatro primeras y la de listeners de scroll se mantiene) y se dice por escrito cuáles se omitieron y por qué.

Después de la confirmación, solo en rutas C, D, E o X con `PRODUCT.md=no`: carga `impeccable` con
`init. Hechos ya confirmados con el usuario: usuarios=<…>; propósito=<…>; diferenciador=<…>; stack=<…>; brand commitments=<fuente, paleta, forma y modo de la Ronda Sistema, si los hubo>. Escribe PRODUCT.md y pregunta solo lo material que falte.`
Cuando termine, continúa aquí sin repetir preguntas.

## Fase 4 · Ejecución por ruta

| Ruta | Cuándo |
|---|---|
| **R** Modo rápido | ajuste puntual |
| **B** Rediseño conservando | `rediseña` + "Conservar y pulir" (app o marketing) |
| **C** Nueva landing o portafolio | `crea` + marketing, registro estándar |
| **D** Pantalla de app: nueva o cambio de look | `crea` + app (Operate o Read), o `rediseña` + "Cambiar el look" en una pantalla de app |
| **E** Cambiar el look de marketing existente | `rediseña` + "Cambiar el look" + marketing, registro estándar |
| **X** Experiencia inmersiva | marketing + registro inmersivo: `crea`, o `rediseña` + "Cambiar el look" (sustituye a C y a E) |
| **F** Variantes | `variantes`, o el usuario pidió 3 direcciones (se suma a B, C, D o X) |
| **G** Con referencias | URLs, capturas o imágenes en el pedido (se suma a B, C, D, E o X) |
| **S** Sistema | `sistema`: solo Fase 2b y parar |

**R.** Lee `<DISENO>/reference/reglas-rapidas.md` → edita → Fase 5 sobre ese archivo.

**B.**
1. Carga `impeccable` con `critique <archivos>. Cierra con la línea literal "Questions skipped: /diseno continúa con polish".` Si critique ya corrió en la entrevista ("No sé, propón"), reutiliza su snapshot y no lo repitas.
2. `Read <REDESIGN>/SKILL.md`. Aplica su Diagnose a los mismos archivos. Une ambas listas en una sola ordenada por su Fix Priority: fuente → color → hover y active → layout → componentes → estados → escala tipográfica.
3. `Read <IMPECCABLE>/reference/polish.md` (más `typeset.md` o `layout.md` solo si esos hallazgos dominan) y `Read <IMPECCABLE>/reference/craft-floor.md` justo antes de editar.
4. Edita dentro del stack existente. Conserva identidad, flujo, rutas, nombres de campos, copy y textos legales. Fuente y paleta de marca solo cambian si lo propusiste en el brief (línea "Cambios de sistema propuestos: …") y el usuario confirmó; si no, se quedan y el hallazgo del detector se justifica en una línea. Con referencias (G), úsalas solo para estructura, ritmo, densidad y movimiento; los tokens de `DESIGN.md` o del código mandan.
5. Si añades movimiento, `Read <ANIMATE>/SKILL.md` antes de escribirlo.

**C.**
1. `init` si no había `PRODUCT.md` (Fase 3).
2. Carga `design-taste-frontend` con este argumento, rellenando los huecos:
   `Lectura de diseño: <…>. DESIGN_VARIANCE=<a>, MOTION_INTENSITY=<b>, VISUAL_DENSITY=<c>. Stack fijo: <detectado> (no migrar; no instalar Motion ni GSAP salvo que ya estén en package.json). Sistema fijo: <fuente, paleta, radios, espaciado, modo e iconos de DESIGN.md o de la Ronda Sistema; no inventes otros tokens>. Modo: <Persuade|Experience>. Autoridad visual: <Lectura de referencia o "ninguna">. Dirección elegida: <variante ganadora de F o "ninguna">. No se toca: <…>. Cero em-dashes en toda la página.`
3. `Read <IMPECCABLE>/reference/craft-floor.md` antes de escribir UI. No leas `new-work.md`.
4. Movimiento: si MOTION ≥ 5 y hay coreografía de scroll, `Read <ANIMATE>/SKILL.md`; si no, transiciones CSS según las reglas de Emil en `reglas-rapidas.md`.

**D.**
Si es cambio de look, primero `Read <REDESIGN>/SKILL.md` y haz su Scan y Diagnose (tokens actuales como evidencia y anti-referencia). Luego carga `impeccable` con la petición en lenguaje natural que incluya el brief confirmado, la superficie, los archivos vecinos y todo lo que el usuario fijó. Ejemplos:
- Nueva: `crea la pantalla de ajustes de notificaciones junto a src/pages/Settings.tsx; modo Operate; sistema fijado por el usuario (pinned): <fuente, paleta, forma, modo de DESIGN.md o de la Ronda Sistema>; conservar tokens y componentes existentes; MOTION_INTENSITY ≤ 3; autoridad visual: <Lectura de referencia o ninguna>; no se toca: nombres de campos.`
- Cambio de look: `rediseña src/pages/Login.tsx: reemplaza el mundo visual, no lo pulas; preservar contenido, rutas, nombres de campos, logo y textos legales; DESIGN.md actual solo como evidencia; modo Operate; MOTION_INTENSITY ≤ 3; sistema nuevo acordado: <…>.`
Impeccable corre su propio flujo de construcción y revisión final (puede lanzar su subagente `impeccable-finish-reviewer` y, si el mundo visual es nuevo, su página de decisión). Lo que el usuario fijó va como pinned: Impeccable lo respeta. No cargues taste.
Sin herramienta de carga de skills, el `SKILL.md` de Impeccable es solo un enrutador y leerlo no construye nada: corre UNA vez `node <IMPECCABLE>/scripts/context.mjs` desde la carpeta del proyecto, `Read <IMPECCABLE>/reference/new-work.md` y `Read <IMPECCABLE>/reference/craft-floor.md`, y construye tú con el brief confirmado. La página de decisión y el finish-reviewer no aplican; el mundo visual lo fija el brief y se dice en la entrega que la ruta D corrió por lectura.

**E.**
1. `Read <REDESIGN>/SKILL.md`. Scan y Diagnose: tokens, arquitectura de información, bloques a preservar y a retirar.
2. Carga `design-taste-frontend` con:
   `Redesign - Overhaul. <Lectura de diseño y diales>. Autoridad visual: <Lectura de referencia o "ninguna">. Sistema nuevo: <fuente, paleta, radios, modo acordados; o "propón uno coherente y regístralo">. Dirección elegida: <variante de F o "ninguna">. Preservar: contenido, arquitectura de información, rutas y slugs, nombres de campos, logo y textos legales. Stack fijo: <detectado>. Cero em-dashes.`
3. craft-floor y movimiento como en C.

**X.** (marketing con Registro inmersivo; nunca en app UI. Autoridad: brief > `inmersivo.md` y `escenografia.md` > Impeccable > taste > Emil en componentes)
1. `init` si no había `PRODUCT.md`, igual que en C (Fase 3).
2. Con URLs de referencia, haz primero la ruta **G** incluida su línea técnica. Sin URLs ni capturas, ofrece referencias externas en UNA pregunta con opciones (header `Refs`): "¿Busco 2 o 3 referencias públicas de secciones en Mobbin?" Sí · No, decide tú. Solo con un sí, `Read <DISENO>/reference/referencias-externas.md` sección "Mobbin" y sigue esa sección. Cosmos solo si el usuario pegó una URL (sección "Cosmos"); no lo automatices nunca.
3. `Read <DISENO>/reference/inmersivo.md` y `Read <DISENO>/reference/escenografia.md`, completos. Son la autoridad de dirección visual y de escenografía en esta ruta.
4. Impeccable se lee, no se carga: `<IMPECCABLE>/reference/new-work.md` §6, `<IMPECCABLE>/reference/animate.md` y `<IMPECCABLE>/reference/craft-floor.md` con las excepciones que lista `inmersivo.md`; añade `<IMPECCABLE>/reference/overdrive.md` solo si la Firma trae canvas o WebGL. El `init` de Impeccable (`PRODUCT.md`) aplica igual que en C.
5. taste NO se carga en esta ruta: sus vetos de cursor, marquee, eyebrow, serif y display gigante chocan de frente con el playbook. Solo `Read` de dos trozos de `<TASTE>/SKILL.md`: §5.A (sticky-stack, l. 365 a 425) cuando la Firma es "producto 3D o secuencia atada al scroll" (esa firma se pina) o §5.B (horizontal-pan, l. 427 a 473) cuando la Firma es "scroll horizontal por paneles"; y su **§14 FINAL PRE-FLIGHT CHECK** (`Read` con offset 910 y limit 71: l. 910 a 980, 62 casillas, no "14 puntos") para el repaso final, saltando las casillas que `inmersivo.md` levante en su lista de excepciones.
6. Construye en este orden y termina cada paso antes del siguiente: (1) tokens (suelo neutro con nombre, ink, cero o un acento, curva de la casa, dos duraciones, escala fluida, dos roles de radio, rampa de alfa del ink, fuentes servidas en woff2 con la "Receta de descarga" de `inmersivo.md`); (2) hero tesis; (3) ritmo de bandas; (4) la Firma, una sola; (5) la gramática de reveal, la misma en toda la página; (6) los Instrumentos aprobados en el brief; (7) footer con wordmark.
7. UI de componentes (botones, menú, acordeón, carrusel, formularios, estados): `Read <ANIMATE>/SKILL.md` y `<ANIMATE>/RECIPES.md`. Ahí manda Emil.
8. Cola: `review-animations` solo sobre los componentes de UI, nunca sobre la escenografía de scroll (pondría en Block cualquier reveal de 1 s). La escenografía se revisa con la tabla de `escenografia.md` sección "Verificación" y el "Checklist X" de `inmersivo.md`.

**F.**
Tras la confirmación: `Read <PROTOTYPE>/SKILL.md` y `Read <PROTOTYPE>/PICKER.md`. Construye 3 direcciones con ejes distintos (layout, densidad, personalidad, movimiento o modelo de interacción) detrás del selector, aisladas del código de producción: en una ruta aislada si hay dev server; si no, en `prototypes/<slug>/index.html` estático (ábrelo con la herramienta de navegador o pide al usuario que lo abra). Para, y dile al usuario que responda `keep <variante>` (o `riff <variante>` para iterar). Tras `keep`, promueve la ganadora y continúa con B, C, D o X pasando "Dirección elegida: <variante>".

**G.** (antes de la Fase 3; máximo 3 referencias)
1. Lee cada referencia. Imágenes y capturas: el rol de leer archivo, que aquí además tiene que mostrar imágenes (`Read` en Claude Code); el usuario puede arrastrar el archivo a la terminal para insertar la ruta, o pegar la imagen en el chat si su agente lo acepta. Si tu agente no abre imágenes, dilo, marca esa referencia como no observable en tipografía y color y no la describas; nunca hagas `cat` sobre un `.png`. URLs: con la herramienta de navegador si existe (captura desktop y móvil). Sin navegador, traer la URL (`WebFetch` en Claude Code, o `curl -sL`) solo da estructura, jerarquía de contenido y copy: escribe "no observable" **solo en tipografía y color**; nunca los deduzcas del texto. Movimiento y fuentes propias no se declaran "no observable": los cubre la línea técnica del paso 2, que sí los mide (de drinkpouch salieron gsap, scrolltrigger, splittext, lenis, `<video>`, `sticky/fixed` y 4 `@font-face`).
2. Escribe la **Lectura de referencia**, por referencia, en 5 líneas: estructura y familia de layout · tipografía (carácter, no la fuente exacta si es de marca) · color (temperatura, número de acentos) · densidad y espaciado · movimiento. Y una sexta línea, **qué no se copia**: logo, marca, copy, fotos, fuente con licencia, componentes calcados.
   Añade una **línea técnica** (la séptima), solo para URLs de marketing. UA de navegador completo: los WAF devuelven 403 a un `-A "Mozilla/5.0"` corto (medido en yucca.co.za: 403 con el UA corto, 200 con el de Chrome). Sin `sort` ni `uniq`, que no están en `allowed-tools`:

   ```bash
   curl -sL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" <url> | grep -ioE 'gsap|scrolltrigger|splittext|lenis|three\.module|barba|@font-face|<video|<canvas|position: ?(fixed|sticky)'
   ```

   El UA va en línea, sin variable previa: el comando tiene que empezar por `curl` para que coincida con `Bash(curl -sL *)`. Anota librerías, fuentes propias, vídeo, canvas y elementos fijos o pegados. Si la salida es larga, repite con `grep -icE '<un término>'` sobre el mismo `curl` para contar solo lo que dudes; un conteo de 0 con `grep -c` **sale con código 1**: es un resultado válido, no un comando fallido. Esa línea alimenta el paso 6 de la Fase 1 (`Registro`) y la línea `Cargaré:` del brief. Tres desenlaces y nada más: 403, reintenta una vez con ese mismo UA y, si sigue, escribe "stack no observable"; `curl` que falla o app vacía, "stack no observable" y no lo deduzcas del texto; **200 con librerías visibles pero sin `<h1|h2|h3>` ni `@font-face`** (el caso de yucca, que carga lenis y barba y renderiza por JS), escribe "estructura no observable, stack sí observable" y no deduzcas el resto.
3. Una sola tanda de preguntas con opciones, en una única llamada cuando la herramienta lo permita (en Claude Code `AskUserQuestion` admite las dos a la vez); nunca en dos turnos seguidos. Hasta dos preguntas y cada una solo si aplica: `Faltan datos` (hay líneas "no observable"; se salta si `DESIGN.md` ya tiene tokens y el Alcance no es "Cambiar el look"): Pego la ruta de una captura · Sigue solo con la estructura · Te describo colores y fuente. `Contradicción` (dos referencias chocan): Manda la 1 · Manda la 2 · Manda la 3 · Mezcla, estructura de una y color de otra. Nunca más de 4 opciones por pregunta.
4. Convierte la lectura en diales y en el "apoyado en <sistema o estética>" del brief. Pásala a C, D, E o X como `Autoridad visual`. Precedencia: si existe `DESIGN.md` con tokens, sus tokens mandan y la referencia aporta estructura, ritmo, densidad y movimiento; solo con "Cambiar el look" la referencia puede redefinir tokens.

**Cola común** (todas las rutas menos R, cuando se tocó movimiento): `Read <REVIEW_ANIM>/SKILL.md`, aplícalo a los archivos cambiados, muestra su tabla de hallazgos y el veredicto Block o Approve, y corrige los Block. En la ruta X se aplica solo a los componentes de UI, como dice su paso 8.

## Fase 5 · Verificación acotada

Una ronda de corrección, no un bucle. Usa el mismo detector antes de editar (línea base) y después; reporta ambos conteos. Muestra la salida real:

```bash
npx impeccable detect --json <archivos tocados>                    # detector completo; cuenta los objetos del JSON
LC_ALL=C grep -nE "$(printf '\xe2\x80\x94|\xe2\x80\x93')" <archivos tocados>   # em-dash y en-dash: vacío
grep -nE 'transition:\s*all|scale\(0\)|[^-]ease-in\b' <css o tsx>   # greps rápidos de Emil
grep -c 'prefers-reduced-motion' <css o tsx>                       # ≥ 1 si añadiste movimiento
```

El grep de guiones va con `printf` porque `$'...'` es sintaxis de bash y de zsh: en una consola `sh` (dash, la de varios agentes en contenedor) no se expande, el patrón nunca casa y sale vacío en falso. Medido sobre un archivo con un `U+2014`: con la forma vieja, dash devuelve 0 y rc=1 mientras bash devuelve 1 y rc=0; con `printf`, los tres (dash, bash y zsh) devuelven 1 y rc=0. Si tu consola es bash o zsh y la sustitución `$( )` te dispara una petición de permiso, ahí, y solo ahí, vale la forma equivalente `grep -nE $'\xe2\x80\x94|\xe2\x80\x93' <archivos tocados>`. Antes de dar por bueno un resultado vacío en una consola que no conoces, comprueba el comando contra un archivo de prueba que sí lleve uno de los dos caracteres.

Si `npx impeccable` falla (sin red o permiso denegado), usa el fallback de `IMPECCABLE_CLI` (Reglas de sesión). `DEGRADED` se imprime **solo si de verdad acabaste usando `detect.mjs`** (mismas reglas, sin parser HTML, conteo subregistrado): con `npx impeccable` funcionando no lo imprimas aunque `IMPECCABLE_CLI` diga `node`.

**Segunda pasada si se escribe `DESIGN.md`.** Las reglas de conformidad con el sistema (`design-system-font-size`, `design-system-color`) solo se puntúan cuando `DESIGN.md` existe. Si en esta sesión lo escribes o lo reescribes (Fase 6, "Sistema guardado"), **repite la pasada del detector después de escribirlo** y reporta ese conteo como el definitivo. Medido en la prueba de humo: al aparecer `DESIGN.md` el conteo pasó de 29 a 38, con 8 `design-system-font-size` reales (clamps fuera de la rampa declarada) y 1 `design-system-color`. Después, el build que exista (`npm run build`, `npx tsc --noEmit` o `npx vite build`).

Éxito: detector en 0 fuera de la tabla "Hallazgos esperados del detector en ruta X" de `<DISENO>/reference/inmersivo.md` (en registro estándar, 0 a secas); cada hallazgo de esa tabla se justifica en una línea y **cualquier id fuera de ella se corrige, no se justifica**. Además: grep de guiones vacío, `review-animations` en Approve, build verde, y las casillas aplicables del **§14 FINAL PRE-FLIGHT CHECK** de `<TASTE>/SKILL.md` (l. 910 a 980, 62 casillas): el hero cabe en el viewport, un solo acento, un solo sistema de radios (en registro inmersivo, dos roles: punto 7 del Checklist X), contraste de CTA y formularios, estados hover/focus/error/vacío presentes, `min-h-[100dvh]` y nunca `h-screen`. En Registro inmersivo, ese pre-flight se filtra según el bloque siguiente.

Con navegador (Fase 0b), una sola ronda de capturas desktop y móvil sobre lo construido; sin navegador, dilo en la entrega y no describas lo que no has visto. Esto vale en todos los registros.

**Verificación inmersiva** (solo Registro inmersivo, además de lo anterior):

- La tabla de comprobaciones vive en `<DISENO>/reference/escenografia.md` sección "Verificación": córrela entera y pega su salida real. Cierra con el "Checklist X" de `<DISENO>/reference/inmersivo.md`.
- Aquí la captura desktop y móvil es **obligatoria si una navegación de prueba a la página devuelve captura**, no opcional. Que la herramienta esté listada no basta: medido dos veces en Claude Code, `mcp__Claude_Browser__navigate` existe y responde "navigation denied or failed", y la captura solo salió con la familia `mcp__claude-in-chrome__*`. Prueba en el orden de la Fase 0b (`mcp__claude-in-chrome__*` primero, que es la que funciona; `mcp__Claude_Browser__*` después); en otro agente, con el navegador que exponga. Si **toda** navegación se deniega o no hay navegador, la escenografía se entrega marcada como **no verificada**: dilo en la Fase 6 con esa palabra, no la declares correcta y lista los puntos del Checklist X que quedan sin marcar por eso (15 entero, y la parte renderizada de 1, 6, 11, 12 y 16). Si devolvió captura, una sola ronda de capturas desktop y móvil.
- Para capturar una página con import map hay que servirla: por `file://` los módulos ES no cargan. Levanta `python3 -m http.server <puerto>` en la carpeta del entregable **en segundo plano** (nunca en primer plano: bloquearía el turno), navega a `http://localhost:<puerto>`, captura y **mata el servidor al terminar**. En Claude Code, `run_in_background` y `KillShell` sobre ese shell id. Por consola, el comando completo y portable es `python3 -m http.server <puerto> >/dev/null 2>&1 & echo $!`: guarda ese número como pid y ciérralo con `kill <pid>`. Si la consola de tu agente mata el grupo de procesos al acabar la llamada (pasa en varios), levanta el servidor y captura en la MISMA llamada, o sirve el entregable sin import map; si tampoco, la escenografía se entrega no verificada. Verificado en la prueba de humo: index 200, js 200, consola sin un solo error de página (import map, GSAP y Lenis cargan bien).
- Degradación móvil: bajo 768 px no debe quedar pin ni scrub salvo que la Firma lo exija, el preloader no corre en móvil, y la página se lee entera con el movimiento apagado (`prefers-reduced-motion`) y con Lenis desactivado.
- Del §14 de taste se aplican solo las casillas que `inmersivo.md` no levante en su lista "Excepciones concretas que autoriza este playbook". No dupliques aquí esa lista: léela allí y salta exactamente esas casillas, ni una más.

## Fase 6 · Entrega

- Qué cambió y por qué, en 6 líneas o menos. Diales finales. Si hubo referencias, qué se tomó de cada una y qué no.
- Assets que el usuario debe reemplazar (imágenes, logos, textos marcados como placeholder).
- Registro inmersivo, cinco líneas más: la **Firma** construida y en qué sección vive · los **Instrumentos** que quedaron, cada uno con su condición · si la escenografía quedó **no verificada** porque toda navegación se denegó o no había herramienta (y qué puntos del Checklist X quedaron sin marcar por eso) · las **fuentes** con licencia y desde dónde se sirven (Fontshare u OFL, Google descargada y servida en local, trial de Pangram con el aviso de que no cubre producción, o la de marca) · los **assets** provisionales con medidas y toma descrita que hay que sustituir por material real.
- Detector antes y después, y `git diff --stat`.
- **Sistema guardado**: si no existía `DESIGN.md` (ruta C, E o X desde cero), escríbelo ahora con `<DISENO>/reference/design-md.md` a partir de los tokens reales del código. Escribirlo activa reglas del detector que antes no puntuaban: vuelve a la Fase 5, repite la pasada y reporta ese conteo como el definitivo. Si tenía `status: seed`, reescríbelo con los tokens reales, quita el marcador y muestra el diff. Si la ruta E, D o X cambió el look, reemplázalo (muestra el anterior y pide confirmación en una línea). En Registro inmersivo registra además la curva de la casa, las dos duraciones, el nivel `label` y la receta de glass, para que la próxima pantalla no los reinvente. Ruta B: si cambiaste fuente o paleta con aprobación, refresca el frontmatter (`typography`, `colors`) y muéstralo. Ruta D nueva: Impeccable lo escribe por su cuenta; verifica que exista. Di en una línea qué quedó fijado para las próximas pantallas.
- Ruta B o `revisa` con `PRODUCT.md=no`: ofrece en una línea guardar lo confirmado (usuarios, propósito, diferenciador) con `impeccable init` para no volver a preguntarlo.
- Sugiere `/impeccable live` solo si hay un dev server corriendo; `/diseno variantes <componente>` si quiere comparar direcciones; y `/compact` con foco antes de otra superficie. Esos tres nombres son de Claude Code: en otro agente escribe la invocación que use (`$diseno`, el comando puntero que documenta el `README.md`), sugiere su forma de compactar contexto solo si la tiene y, si Impeccable no es invocable por barra ahí, no menciones `/impeccable live`.

## Precedencia cuando los paquetes se contradicen

| Tema | Gana | Nota |
|---|---|---|
| Cualquier regla vs. brief del usuario | El brief | Si el usuario pide morado, serif o Inter, se hace bien, con intención |
| Proceso, verificación y memoria (`PRODUCT.md`) | Impeccable | Setup, critique, polish, detector, craft-floor |
| Layout, tipografía y color en marketing | taste (4.x y §14 FINAL PRE-FLIGHT CHECK, l. 910 a 980) | Registro estándar. craft-floor sigue aplicando |
| Layout, tipografía y color en marketing inmersivo | `reference/inmersivo.md` | Ruta X. taste no se invoca; de él solo los skeletons §5.A y §5.B y el §14 filtrado por la lista de excepciones de `inmersivo.md` |
| Layout, tipografía y color en app UI | Impeccable (modo Operate) | taste se excluye a sí mismo de dashboards y UI de producto |
| `DESIGN.md` existente vs. referencia nueva | `DESIGN.md` en tokens (fuente, paleta, radios, modo, iconos) | La referencia aporta estructura, ritmo, densidad y movimiento; solo "Cambiar el look" deja que redefina tokens |
| Referencias vs. reglas de los paquetes | La referencia, si el usuario la pidió | Salvo lo que no se copia (marca, copy, fotos, fuentes con licencia) y salvo accesibilidad |
| Fuentes | Unión de las listas negras; en registro inmersivo, el pool de `reference/inmersivo.md` | El detector de Impeccable marca Inter, Roboto, Open Sans, Lato, Montserrat, Arial, Helvetica, Fraunces, Instrument Sans y Serif, Geist, Mona Sans, Plus Jakarta Sans, Space Grotesk y Recoleta; Impeccable new-work desaconseja además Outfit, DM Sans, IBM Plex, Syne, Playfair y Lora. No las uses por defecto. Pasan: Satoshi, Cabinet Grotesk, General Sans, Manrope, o una serif del pool de taste (no Recoleta) con justificación. En registro inmersivo manda el pool de `inmersivo.md` (Fontshare, Google incluida Instrument Serif como acento, trials de Pangram avisando de que la licencia trial no cubre producción); lo que uses de ese pool y esté en la lista negra se justifica en una línea, y el resto de la lista negra sigue vetado. Siempre servida en woff2 desde el proyecto, nunca `<link>` a Google Fonts. La fuente de marca existente siempre gana: si es una de la lista, deja el hallazgo del detector justificado en una línea |
| Todo lo que se mueve, en dos capas | Emil en componentes de UI; `reference/escenografia.md` en el scroll | Emil (`animate`, `review-animations`): ease-out al entrar, ease-in-out al mover, < 300 ms en UI, solo transform y opacity, nunca `scale(0)`, `:active` en 0.97, `prefers-reduced-motion`; manda sobre el "usa Motion" de taste y el "spring en todo" de redesign. La escenografía de scroll del registro inmersivo (reveals de escena, máscaras, pin, scrub, parallax, marquee) se rige por `escenografia.md`, con sus duraciones y su curva única, y no pasa por `review-animations` |
| Librería de animación | Stack existente > Emil > taste | CSS o WAAPI por defecto; Motion o GSAP solo si ya están en `package.json`. En registro inmersivo con el brief confirmado: `gsap` y `lenis` con versión exacta, y `three` solo si la Firma exige 3D en tiempo real; nunca Motion, Framer Motion ni Swiper |
| Stack por defecto de taste (Next, RSC, Tailwind v4) | El stack detectado | Por eso el argumento lleva "Stack fijo"; nunca migrar |
| Dark mode obligatorio (taste 6.C) | Solo en marketing de consumo de registro estándar | Nunca forzarlo en app UI ni contra el brief. En registro inmersivo el tema es único y planificado (suelo claro o suelo oscuro, con bandas alternas dentro de ese tema): no añadas toggle ni `prefers-color-scheme` salvo que el usuario lo pida |
| Glass y `backdrop-filter` | `reference/inmersivo.md` sobre reglas-rapidas y craft-floor | Funcional, solo encima de foto o vídeo, una sola receta tokenizada por proyecto y con `@supports`. Sobre fondo plano y como tarjeta decorativa sigue prohibido |
| Etiquetas pequeñas y numeración de capítulos | `reference/inmersivo.md` sección "Sistema de labels" | Permitidas como rail, ficha técnica o índice con sus condiciones. Sigue prohibido el eyebrow genérico con acento de color sobre cada `h2`. Los hallazgos del detector se justifican en bloque, en una línea |
| Marquee | `reference/inmersivo.md`: cupo de 2 con roles distintos | Manda sobre el "marquee max one per page" de taste. Dos marquees con el mismo rol es relleno, y sigue vetado uno por sección |
| Cursor y preloader | `reference/inmersivo.md`, condicionados | Cursor solo si el usuario lo pide, contextual, bajo `(hover: hover) and (pointer: fine)` y sin ocultar el nativo. Preloader solo si hay assets reales que esperar, tope 1.5 s, nunca en móvil |
| Mobbin y UI/UX Pro Max | Piso, nunca autoridad | Aportan vocabulario y referencias reales; `DESIGN.md`, el brief e `inmersivo.md` mandan. Sin descarga masiva, con crédito al sitio de origen, y sus imágenes jamás en el entregable |
| Cosmos | Solo por URL que pegue el usuario | Sus ToS prohíben automatizar: no hagas `curl` ni búsquedas. Las imágenes son de terceros y solo sirven de inspiración |
| Three.js y WebGL | Solo si la Firma lo exige | 0 de los 7 sitios de referencia usa WebGL: el nivel se consigue con foto, vídeo o canvas 2D. Si entra, va diferido tras el LCP y con poster de reserva |
| Testimonios, clientes, cifras, precios | Impeccable y taste 9.D coinciden | Nada inventado; placeholders etiquetados |
| Iconos | Proyecto existente > taste | Phosphor, Tabler o Radix; lucide solo si ya está |
| Qué se preserva en un rediseño | taste 11.C y 11.F + "refinement preserves" | Slugs, navegación, nombres de campos, logo y textos legales nunca cambian sin aprobación |
