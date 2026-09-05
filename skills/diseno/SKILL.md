---
name: diseno
description: Diseña o rediseña pantallas, landings, logins, dashboards, portfolios y componentes para que no parezcan hechas por IA; desde cero, sobre código existente o con referencias ("como esta web", capturas). Úsala cuando el usuario pida diseñar, rediseñar, mejorar el look o diga que algo "se ve genérico". Orquesta impeccable, design-taste-frontend, redesign-existing-projects, animate, review-animations y prototype; úsala en lugar de invocarlos por separado. No para backend ni tareas sin UI.
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
  - Bash(grep *)
  - Bash(ls *)
  - Bash(git status*)
  - Bash(git diff*)
  - Bash(npm run build*)
  - Bash(npx tsc --noEmit*)
  - Bash(npx vite build*)
---

# /diseno · diseño sin "look de IA"

Argumentos recibidos: `$ARGUMENTS`

## Reglas de sesión

- Responde en español. Muestra la salida real de cada comando; nunca digas "ya verifiqué" sin evidencia.
- Cero `—` y `–` en cualquier texto visible de la UI (títulos, botones, párrafos, captions, alt). Usa punto, coma o dos puntos.
- Carga de paquetes: `design-taste-frontend` se invoca con `Skill` UNA sola vez por sesión. `impeccable` se invoca con `Skill` una vez por subcomando (`document`, `init`, `critique`, o la construcción de la ruta D); nunca repitas el mismo subcomando. Sus referencias (`polish.md`, `craft-floor.md`, `typeset.md`, `layout.md`) siempre con `Read`. `prototype` y `review-animations` no son invocables con `Skill`: `Read` de su `SKILL.md`.
- Nunca cargues `design-taste-frontend` en modo rápido ni en pantallas de app (modos Operate y Read). Nunca leas `reference/new-work.md` de Impeccable en rutas taste (C y E).
- Una superficie por sesión. Si el usuario pide una segunda, sugiere `/compact` antes de empezarla.
- Si no hay quien responda (sesión no interactiva o `AskUserQuestion` falla): no inventes respuestas del usuario; toma la lectura más probable, márcala como SUPUESTO en el brief, sigue la ruta más conservadora (B antes que E, sin variantes) y lista los supuestos en la entrega.
- No inventes testimonios, clientes, cifras ni precios. Placeholders etiquetados sí.
- Trabaja dentro del stack existente. No migres frameworks ni instales librerías de animación salvo que ya estén en `package.json`.
- Con referencias: inspírate en estructura, ritmo y tono; nunca clones logos, copy, fotos ni fuentes con licencia ajena.
- Rutas: `${CLAUDE_SKILL_DIR}` es la carpeta de esta skill (si no se sustituyó, usa la línea `DISENO=` de estado.sh). Para `Read` usa siempre rutas absolutas. Para ejecutar scripts de Impeccable con Bash escribe `node ~/.claude/skills/impeccable/scripts/<script>` con `~` literal (así coincide con los permisos); si estado.sh devolvió otra carpeta, usa esa.

## Fase 0 · Estado

Corre `bash ${CLAUDE_SKILL_DIR}/scripts/estado.sh ${CLAUDE_PROJECT_DIR}`. Guarda cada `KEY=VALOR`: `<DISENO>` es esta skill; `<IMPECCABLE>`, `<TASTE>`, `<REDESIGN>`, `<ANIMATE>`, `<REVIEW_ANIM>` y `<PROTOTYPE>` son los paquetes; `UI_CODE` dice si el proyecto ya tiene código de UI (empieza por `si` o `no`); `PRODUCT.md` y `DESIGN.md` dicen si existen.

- Si sale con 1: imprime tal cual las líneas `instalar:` y sigue en **modo degradado**: para cada paquete que falte usa `${CLAUDE_SKILL_DIR}/reference/reglas-rapidas.md`.
- Si imprime líneas `AVISO=`, repítelas al usuario antes de seguir.
- Si no recibiste argumentos (la línea "Argumentos recibidos" quedó vacía): muestra el estado y este menú, y para. No ejecutes nada.
  - `/diseno crea <pantalla o landing>`
  - `/diseno rediseña <pantalla o archivo>`
  - `/diseno crea|rediseña <…> como <URL o imagen>` (con referencias)
  - `/diseno sistema` (documentar o definir el sistema del proyecto: tipografía, paleta, forma, modo)
  - `/diseno variantes <componente>`
  - `/diseno revisa <archivo>` (solo diagnóstico; no toca tu código)
  - `/diseno ajusta <cambio puntual>` (modo rápido, sin preguntas)

## Fase 1 · Contexto sin preguntar

1. Intención a partir de los argumentos: `crea` | `rediseña` | `variantes` | `revisa` | `ajusta` | `sistema`. Sin verbo: archivo existente → `rediseña`; no existe nada → `crea`.
   Modificador **G** (referencias): hay URLs, rutas de imagen, imágenes pegadas en el chat, o palabras como "como", "referencia", "inspirado en", "parecido a".
2. Superficie: **marketing** (landing, portafolio, pricing, página pública) o **app** (login, formulario, panel, dashboard, ajustes, docs).
3. Lee fragmentos, no archivos enteros: `PRODUCT.md` y `DESIGN.md` si existen; `package.json` (framework, tailwind v3 o v4, motion/framer-motion/gsap, lucide/phosphor); tokens (`tailwind.config.*`, `:root`, `globals.css`); `git status --short`.
4. Localiza los archivos objetivo con Glob por nombre (`login|signin|landing|hero|<término del usuario>`) y lee solo lo relevante.
5. Escribe la **Lectura previa** en 5 viñetas: superficie y modo probable · stack y tokens · estado visual actual en una frase (de ahí salen los diales "existentes" de un rediseño) · lo ya decidido (PRODUCT.md, DESIGN.md, referencias o el usuario) · lo que falta saber.

Atajos por intención:
- **Modo rápido** (`ajusta`, o un cambio de una propiedad o un componente sin verbo de diseñar): ruta **R**, sin entrevista.
- **`revisa`**: solo diagnóstico, pasos B.1 y B.2, luego la lista de hallazgos y para. No toca el código del usuario; critique deja su informe en `.impeccable/critique/` (dilo). Al invocar critique añade: `Cierra con la línea literal "Questions skipped: modo revisa"`.
- **`sistema`**: solo la Fase 2b (ruta **S**) y para.

## Fase 2 · Entrevista

Lee `${CLAUDE_SKILL_DIR}/entrevista.md` y aplícala: reglas de salto, Ronda 1 (2 o 3 preguntas), Ronda 2 solo si queda un hueco material. Usa `AskUserQuestion`. Prompt preciso → salta las Rondas 1 y 2, pero la **Fase 2b se ejecuta siempre** antes de la Fase 3. En `rediseña` sin Alcance explícito, asume "Conservar y pulir" y márcalo como SUPUESTO en el brief. Con referencias (G), haz primero la Lectura de referencia y úsala como respuesta a "Vibra" y "Referencias".

**Stack en proyecto vacío** (`PACKAGE_JSON=no` y `UI_CODE=no`): la Ronda 1 incluye siempre la pregunta `Stack` de entrevista.md. Su respuesta va a `stack=` de `init`, a `Stack fijo:` de taste y a la línea Cargaré del brief. Sin respuesta, fija "HTML, CSS y JS estáticos" como SUPUESTO; nunca dejes el stack vacío (taste crearía Next + Tailwind v4 + Motion por defecto).

## Fase 2b · Sistema del proyecto (estandarizar para futuras pantallas)

El sistema vive en `DESIGN.md` (formato oficial DESIGN.md: frontmatter con tokens + secciones) y los hechos de producto en `PRODUCT.md`. Se establece una vez por proyecto; después cada pantalla lo hereda y no se vuelve a preguntar.

- **Existe `DESIGN.md` con tokens** (`colors` y `typography` en el frontmatter): léelo y resume en 4 líneas (fuente, paleta, radios y espaciado, modo e iconos). Es el **Sistema fijo** de todas las rutas. Solo se reemplaza si el usuario eligió "Cambiar el look", al final y con confirmación. Si el archivo no tiene tokens o su frontmatter trae `status: seed`: trátalo como "propuesto", no fijo, confírmalo en el brief y, al terminar de construir, reescríbelo con los tokens reales y quita el marcador (Fase 6).
- **No existe, `UI_CODE=si` y Alcance no es "Cambiar el look"**: invoca `Skill` `impeccable` con `document. Datos ya conocidos: North Star=<propuesto desde la Vibra>; adjetivos=<de la Vibra y la Lectura previa>; nombres descriptivos de color=<…>; filosofía de elevación=<…>. Una sola ronda de 3 preguntas como máximo; lo demás dedúcelo del código.` (por eso en B sin `DESIGN.md` la Ronda 1 incluye Vibra). Escribe `DESIGN.md` y trátalo como Sistema fijo.
- **No existe, `UI_CODE=si` y Alcance es "Cambiar el look"**: no documentes el look que se va a tirar. Usa el Scan de `<REDESIGN>/SKILL.md` como evidencia y anti-referencia. Si las referencias no fijan tokens, haz la **Ronda Sistema** con sus opciones de rediseño ("mantener la fuente actual", "mantener la paleta", "propón tú"); "propón tú" se marca como SUPUESTO. Eso es el "sistema nuevo acordado" de D y E; el `DESIGN.md` nuevo se escribe al final con los tokens reales.
- **Existe `DESIGN.md` y Alcance es "Cambiar el look"**: misma Ronda Sistema adaptada; el archivo actual es solo evidencia y se reemplaza al final con confirmación.
- **No existe y `UI_CODE=no`** (proyecto desde cero): haz la **Ronda Sistema** de `entrevista.md` (una sola llamada). Anota las respuestas como "Sistema propuesto" en el brief. Se escribe `DESIGN.md` al terminar de construir, con los tokens que quedaron en el código, usando `${CLAUDE_SKILL_DIR}/reference/design-md.md`.
- **Ruta S (`sistema`)**: con `UI_CODE=si` y sin `DESIGN.md`, `impeccable document`. Con `UI_CODE=no`, Ronda Sistema (más la pregunta `Stack`) y escribe ya `DESIGN.md` con la plantilla, con `status: seed` en el frontmatter y "tokens acordados, aún sin código" en Overview. Con `DESIGN.md` existente, una `AskUserQuestion` (header `Sistema`): Refrescar desde el código · Mezclar con el código · Reemplazar (Ronda Sistema) · Dejar como está. Para las dos primeras invoca `document. El usuario ya eligió: refresh|merge; no vuelvas a preguntar; muestra el diff al final.` Luego para.

## Fase 3 · Brief y confirmación única

Imprime:

```
Lectura de diseño: <tipo de página> para <audiencia>, lenguaje <vibra>, apoyado en <sistema o estética>.
Modo: Persuade | Operate | Read | Experience
Diales: DESIGN_VARIANCE=a · MOTION_INTENSITY=b · VISUAL_DENSITY=c   (una razón por dial)
Ruta: R | B | C | D | E | F (+ G si hay referencias)
Referencias: <Lectura de referencia en una línea, o "ninguna">
Sistema: <fijo desde DESIGN.md | propuesto: fuente, paleta, radios, modo | lo extrajo impeccable document>
Cambios de sistema propuestos: <p. ej. "reemplazar Inter por Satoshi", o "ninguno">
No se toca: …
Cargaré: <paquetes de la ruta>
```

Si la ruta es D, añade: "Si la pantalla necesita un mundo visual nuevo, Impeccable puede abrir una página de decisión en tu navegador; es normal, elige ahí y vuelve".

Haz UNA `AskUserQuestion` (header `Confirmar`): Sí, adelante · Más sobrio (diales -2) · Más atrevido (diales +2) · cambios vía Other.

Después de la confirmación, solo en rutas C, D o E con `PRODUCT.md=no`: invoca `Skill` `impeccable` con
`init. Hechos ya confirmados con el usuario: usuarios=<…>; propósito=<…>; diferenciador=<…>; stack=<…>; brand commitments=<fuente, paleta, forma y modo de la Ronda Sistema, si los hubo>. Escribe PRODUCT.md y pregunta solo lo material que falte.`
Cuando termine, continúa aquí sin repetir preguntas.

## Fase 4 · Ejecución por ruta

| Ruta | Cuándo |
|---|---|
| **R** Modo rápido | ajuste puntual |
| **B** Rediseño conservando | `rediseña` + "Conservar y pulir" (app o marketing) |
| **C** Nueva landing o portafolio | `crea` + marketing (Persuade o Experience) |
| **D** Pantalla de app: nueva o cambio de look | `crea` + app (Operate o Read), o `rediseña` + "Cambiar el look" en una pantalla de app |
| **E** Cambiar el look de marketing existente | `rediseña` + "Cambiar el look" + marketing |
| **F** Variantes | `variantes`, o el usuario pidió 3 direcciones (se suma a B, C o D) |
| **G** Con referencias | URLs, capturas o imágenes en el pedido (se suma a B, C, D o E) |
| **S** Sistema | `sistema`: solo Fase 2b y parar |

**R.** `Read ${CLAUDE_SKILL_DIR}/reference/reglas-rapidas.md` → edita → Fase 5 sobre ese archivo.

**B.**
1. `Skill` `impeccable` con `critique <archivos>. Cierra con la línea literal "Questions skipped: /diseno continúa con polish".` Si critique ya corrió en la entrevista ("No sé, propón"), reutiliza su snapshot y no lo repitas.
2. `Read <REDESIGN>/SKILL.md`. Aplica su Diagnose a los mismos archivos. Une ambas listas en una sola ordenada por su Fix Priority: fuente → color → hover y active → layout → componentes → estados → escala tipográfica.
3. `Read <IMPECCABLE>/reference/polish.md` (más `typeset.md` o `layout.md` solo si esos hallazgos dominan) y `Read <IMPECCABLE>/reference/craft-floor.md` justo antes de editar.
4. Edita dentro del stack existente. Conserva identidad, flujo, rutas, nombres de campos, copy y textos legales. Fuente y paleta de marca solo cambian si lo propusiste en el brief (línea "Cambios de sistema propuestos: …") y el usuario confirmó; si no, se quedan y el hallazgo del detector se justifica en una línea. Con referencias (G), úsalas solo para estructura, ritmo, densidad y movimiento; los tokens de `DESIGN.md` o del código mandan.
5. Si añades movimiento, `Read <ANIMATE>/SKILL.md` antes de escribirlo.

**C.**
1. `init` si no había `PRODUCT.md` (Fase 3).
2. `Skill` `design-taste-frontend` con este argumento, rellenando los huecos:
   `Lectura de diseño: <…>. DESIGN_VARIANCE=<a>, MOTION_INTENSITY=<b>, VISUAL_DENSITY=<c>. Stack fijo: <detectado> (no migrar; no instalar Motion ni GSAP salvo que ya estén en package.json). Sistema fijo: <fuente, paleta, radios, espaciado, modo e iconos de DESIGN.md o de la Ronda Sistema; no inventes otros tokens>. Modo: <Persuade|Experience>. Autoridad visual: <Lectura de referencia o "ninguna">. Dirección elegida: <variante ganadora de F o "ninguna">. No se toca: <…>. Cero em-dashes en toda la página.`
3. `Read <IMPECCABLE>/reference/craft-floor.md` antes de escribir UI. No leas `new-work.md`.
4. Movimiento: si MOTION ≥ 5 y hay coreografía de scroll, `Read <ANIMATE>/SKILL.md`; si no, transiciones CSS según las reglas de Emil en `reglas-rapidas.md`.

**D.**
Si es cambio de look, primero `Read <REDESIGN>/SKILL.md` y haz su Scan y Diagnose (tokens actuales como evidencia y anti-referencia). Luego `Skill` `impeccable` con la petición en lenguaje natural que incluya el brief confirmado, la superficie, los archivos vecinos y todo lo que el usuario fijó. Ejemplos:
- Nueva: `crea la pantalla de ajustes de notificaciones junto a src/pages/Settings.tsx; modo Operate; sistema fijado por el usuario (pinned): <fuente, paleta, forma, modo de DESIGN.md o de la Ronda Sistema>; conservar tokens y componentes existentes; MOTION_INTENSITY ≤ 3; autoridad visual: <Lectura de referencia o ninguna>; no se toca: nombres de campos.`
- Cambio de look: `rediseña src/pages/Login.tsx: reemplaza el mundo visual, no lo pulas; preservar contenido, rutas, nombres de campos, logo y textos legales; DESIGN.md actual solo como evidencia; modo Operate; MOTION_INTENSITY ≤ 3; sistema nuevo acordado: <…>.`
Impeccable corre su propio flujo de construcción y revisión final (puede lanzar su subagente `impeccable-finish-reviewer` y, si el mundo visual es nuevo, su página de decisión). Lo que el usuario fijó va como pinned: Impeccable lo respeta. No cargues taste.

**E.**
1. `Read <REDESIGN>/SKILL.md`. Scan y Diagnose: tokens, arquitectura de información, bloques a preservar y a retirar.
2. `Skill` `design-taste-frontend` con:
   `Redesign - Overhaul. <Lectura de diseño y diales>. Autoridad visual: <Lectura de referencia o "ninguna">. Sistema nuevo: <fuente, paleta, radios, modo acordados; o "propón uno coherente y regístralo">. Dirección elegida: <variante de F o "ninguna">. Preservar: contenido, arquitectura de información, rutas y slugs, nombres de campos, logo y textos legales. Stack fijo: <detectado>. Cero em-dashes.`
3. craft-floor y movimiento como en C.

**F.**
Tras la confirmación: `Read <PROTOTYPE>/SKILL.md` y `Read <PROTOTYPE>/PICKER.md`. Construye 3 direcciones con ejes distintos (layout, densidad, personalidad, movimiento o modelo de interacción) detrás del selector, aisladas del código de producción: en una ruta aislada si hay dev server; si no, en `prototypes/<slug>/index.html` estático (ábrelo con la herramienta de navegador o pide al usuario que lo abra). Para, y dile al usuario que responda `keep <variante>` (o `riff <variante>` para iterar). Tras `keep`, promueve la ganadora y continúa con B, C o D pasando "Dirección elegida: <variante>".

**G.** (antes de la Fase 3; máximo 3 referencias)
1. Lee cada referencia. Imágenes y capturas: `Read` de la ruta (el usuario puede arrastrar el archivo a la terminal para insertar la ruta, o pegar la imagen en el chat, que ya queda en contexto). URLs: con la herramienta de navegador si existe (captura desktop y móvil). Sin navegador, `WebFetch` solo da estructura, jerarquía de contenido y copy: en tipografía, color y movimiento escribe "no observable"; nunca los deduzcas del texto.
2. Escribe la **Lectura de referencia**, por referencia, en 5 líneas: estructura y familia de layout · tipografía (carácter, no la fuente exacta si es de marca) · color (temperatura, número de acentos) · densidad y espaciado · movimiento. Y una sexta línea, **qué no se copia**: logo, marca, copy, fotos, fuente con licencia, componentes calcados.
3. Una sola llamada a `AskUserQuestion` con hasta dos preguntas, cada una solo si aplica: `Faltan datos` (hay líneas "no observable"; se salta si `DESIGN.md` ya tiene tokens y el Alcance no es "Cambiar el look"): Pego la ruta de una captura · Sigue solo con la estructura · Te describo colores y fuente. `Contradicción` (dos referencias chocan): Manda la 1 · Manda la 2 · Manda la 3 · Mezcla, estructura de una y color de otra. Nunca más de 4 opciones por pregunta.
4. Convierte la lectura en diales y en el "apoyado en <sistema o estética>" del brief. Pásala a C, D o E como `Autoridad visual`. Precedencia: si existe `DESIGN.md` con tokens, sus tokens mandan y la referencia aporta estructura, ritmo, densidad y movimiento; solo con "Cambiar el look" la referencia puede redefinir tokens.

**Cola común** (todas las rutas menos R, cuando se tocó movimiento): `Read <REVIEW_ANIM>/SKILL.md`, aplícalo a los archivos cambiados, muestra su tabla de hallazgos y el veredicto Block o Approve, y corrige los Block.

## Fase 5 · Verificación acotada

Una ronda de corrección, no un bucle. Usa el mismo detector antes de editar (línea base) y después; reporta ambos conteos. Muestra la salida real:

```bash
npx impeccable detect --json <archivos tocados>                    # detector completo; cuenta los objetos del JSON
grep -nE '—|–' <archivos tocados>                                  # debe quedar vacío
grep -nE 'transition:\s*all|scale\(0\)|[^-]ease-in\b' <css o tsx>   # greps rápidos de Emil
grep -c 'prefers-reduced-motion' <css o tsx>                       # ≥ 1 si añadiste movimiento
```

Si `npx impeccable` falla (sin red o permiso denegado), usa `node ~/.claude/skills/impeccable/scripts/detect.mjs --json <archivos>`: son las mismas reglas pero sin parser HTML, así que imprime `DEGRADED` y el conteo es un subregistro; dilo al reportar.

Después, el build que exista (`npm run build`, `npx tsc --noEmit` o `npx vite build`).

Éxito: detector en 0 (o cada hallazgo restante justificado en una línea), grep de guiones vacío, `review-animations` en Approve, build verde, y el pre-flight de taste aplicable: el hero cabe en el viewport, un solo acento, un solo sistema de radios, contraste de CTA y formularios, estados hover/focus/error/vacío presentes, `min-h-[100dvh]` y nunca `h-screen`.

Si tienes herramienta de navegador, una sola ronda de capturas desktop y móvil; si no, dilo.

## Fase 6 · Entrega

- Qué cambió y por qué, en 6 líneas o menos. Diales finales. Si hubo referencias, qué se tomó de cada una y qué no.
- Assets que el usuario debe reemplazar (imágenes, logos, textos marcados como placeholder).
- Detector antes y después, y `git diff --stat`.
- **Sistema guardado**: si no existía `DESIGN.md` (ruta C o E desde cero), escríbelo ahora con `${CLAUDE_SKILL_DIR}/reference/design-md.md` a partir de los tokens reales del código. Si tenía `status: seed`, reescríbelo con los tokens reales, quita el marcador y muestra el diff. Si la ruta E o D cambió el look, reemplázalo (muestra el anterior y pide confirmación en una línea). Ruta B: si cambiaste fuente o paleta con aprobación, refresca el frontmatter (`typography`, `colors`) y muéstralo. Ruta D nueva: Impeccable lo escribe por su cuenta; verifica que exista. Di en una línea qué quedó fijado para las próximas pantallas.
- Ruta B o `revisa` con `PRODUCT.md=no`: ofrece en una línea guardar lo confirmado (usuarios, propósito, diferenciador) con `impeccable init` para no volver a preguntarlo.
- Sugiere `/impeccable live` solo si hay un dev server corriendo; `/diseno variantes <componente>` si quiere comparar direcciones; y `/compact` con foco antes de otra superficie.

## Precedencia cuando los paquetes se contradicen

| Tema | Gana | Nota |
|---|---|---|
| Cualquier regla vs. brief del usuario | El brief | Si el usuario pide morado, serif o Inter, se hace bien, con intención |
| Proceso, verificación y memoria (`PRODUCT.md`) | Impeccable | Setup, critique, polish, detector, craft-floor |
| Layout, tipografía y color en marketing | taste (4.x y pre-flight 14) | craft-floor sigue aplicando |
| Layout, tipografía y color en app UI | Impeccable (modo Operate) | taste se excluye a sí mismo de dashboards y UI de producto |
| `DESIGN.md` existente vs. referencia nueva | `DESIGN.md` en tokens (fuente, paleta, radios, modo, iconos) | La referencia aporta estructura, ritmo, densidad y movimiento; solo "Cambiar el look" deja que redefina tokens |
| Referencias vs. reglas de los paquetes | La referencia, si el usuario la pidió | Salvo lo que no se copia (marca, copy, fotos, fuentes con licencia) y salvo accesibilidad |
| Fuentes | Unión de las listas negras | El detector de Impeccable marca Inter, Roboto, Open Sans, Lato, Montserrat, Arial, Helvetica, Fraunces, Instrument Sans y Serif, Geist, Mona Sans, Plus Jakarta Sans, Space Grotesk y Recoleta; Impeccable new-work desaconseja además Outfit, DM Sans, IBM Plex, Syne, Playfair y Lora. No las uses por defecto. Pasan: Satoshi, Cabinet Grotesk, General Sans, Manrope, o una serif del pool de taste (no Recoleta) con justificación. La fuente de marca existente siempre gana: si es una de la lista, deja el hallazgo del detector justificado en una línea |
| Todo lo que se mueve | Emil (`animate`, `review-animations`) | ease-out al entrar, ease-in-out al mover, < 300 ms en UI, solo transform y opacity, nunca `scale(0)`, `:active` en 0.97, `prefers-reduced-motion`. Manda sobre el "usa Motion" de taste y el "spring en todo" de redesign |
| Librería de animación | Stack existente > Emil > taste | CSS o WAAPI por defecto; Motion o GSAP solo si ya están en `package.json` |
| Stack por defecto de taste (Next, RSC, Tailwind v4) | El stack detectado | Por eso el argumento lleva "Stack fijo"; nunca migrar |
| Dark mode obligatorio (taste 6.C) | Solo en marketing de consumo | Nunca forzarlo en app UI ni contra el brief |
| Testimonios, clientes, cifras, precios | Impeccable y taste 9.D coinciden | Nada inventado; placeholders etiquetados |
| Iconos | Proyecto existente > taste | Phosphor, Tabler o Radix; lucide solo si ya está |
| Qué se preserva en un rediseño | taste 11.C y 11.F + "refinement preserves" | Slugs, navegación, nombres de campos, logo y textos legales nunca cambian sin aprobación |
