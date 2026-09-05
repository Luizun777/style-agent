# style-agent · `/diseno`

Diseña y rediseña pantallas, componentes y landing pages con Claude Code sin que parezcan "hechas por IA".
Una skill que te entrevista, fija el sistema visual del proyecto (tipografía, paleta, forma, modo) para que todas las pantallas lo hereden, y orquesta tres paquetes públicos de diseño en el orden correcto.

*English: a Claude Code skill that interviews you, standardizes your project's design system, and orchestrates Impeccable, taste-skill and Emil Kowalski's skills so your UI does not look AI-generated. Prompts and docs are in Spanish.*

## Qué hace

- **Te pregunta poco y bien.** Dos o tres preguntas con opciones antes de tocar código; si das contexto en la misma línea, se las salta.
- **Estandariza el proyecto la primera vez.** Tipografía, paleta, radios, modo claro u oscuro e iconos quedan en `DESIGN.md` (formato oficial DESIGN.md) y los hechos de producto en `PRODUCT.md`. Las siguientes pantallas los heredan sin volver a preguntar.
- **Tres formas de trabajar:** desde cero, rediseño de lo que ya existe, o con referencias (URLs, capturas, imágenes).
- **Verifica con evidencia.** Corre el detector de anti-patrones de "diseño IA" de Impeccable antes y después, revisa el movimiento y muestra el `git diff`.
- **No rompe nada.** Conserva rutas, nombres de campos, textos legales y logo salvo que lo apruebes. No migra frameworks ni instala librerías por su cuenta.

Los tres paquetes que orquesta:

| Paquete | Para qué sirve | Qué hace dentro de /diseno |
|---|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) | Proceso y control de calidad | Contexto del producto (`PRODUCT.md`, `DESIGN.md`), crítica, pulido y el detector de anti-patrones |
| [taste-skill](https://github.com/Leonxlnx/taste-skill) | Dirección visual de landings y portafolios | "Lectura de diseño", tres diales (variación, movimiento, densidad), reglas anti-plantilla y auditoría de rediseño |
| [emilkowalski/skills](https://github.com/emilkowalski/skills) | Animación y variantes | Movimiento que se siente bien (`animate`, `review-animations`) y tres variantes con selector (`prototype`) |

## Instalación (una vez, vale para todos tus proyectos)

Requisitos: [Claude Code](https://claude.com/claude-code) y Node 22.20 o superior con npm (`node -v`, `npx -v`).

**Opción A, un comando** (clona el repo e instala todo desde el clon):

```bash
git clone https://github.com/Luizun777/style-agent.git && bash style-agent/install.sh
```

**Opción B, paso a paso** (desde tu carpeta de usuario, `cd ~`):

```bash
npx -y impeccable install --providers=claude --scope=global --no-hooks
npx -y skills@latest add Leonxlnx/taste-skill -g -a claude-code -y -s design-taste-frontend redesign-existing-projects
npx -y skills@latest add emilkowalski/skills -g -a claude-code -y -s animate review-animations prototype
npx -y skills@latest add Luizun777/style-agent -g -a claude-code -y -s diseno
```

**Comprobar:**

```bash
bash ~/.claude/skills/diseno/scripts/estado.sh
```

Las siete primeras líneas (`DISENO`, `IMPECCABLE`, `TASTE`, `REDESIGN`, `ANIMATE`, `REVIEW_ANIM`, `PROTOTYPE`) deben mostrar una ruta y ninguna `MISSING`. Las demás (`NODE`, `PRODUCT.md`, `DESIGN.md`, `PACKAGE_JSON`, `UI_CODE`) describen la carpeta desde la que lo ejecutas y pueden decir `no`. Reinicia Claude Code, escribe `/` y comprueba que aparece `diseno`.

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
| 1. Propósito | Siempre que el prompt sea escueto | Qué debe lograr quien llega (decidir, completar una tarea, entender, ver la obra), quién es, conservar o cambiar el look, qué sensación, qué es único |
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
| F | Variantes | `prototype` de Emil (tres direcciones) y luego B, C o D |
| G | Con referencias | Lectura de referencia y luego B, C, D o E |
| S | Sistema | `impeccable document` o ronda de sistema, escribe `DESIGN.md` |

Cuando los paquetes se contradicen manda, en este orden: tu brief, el proceso y el detector de Impeccable, las reglas de taste en marketing (Impeccable en UI de app), y las reglas de Emil en todo lo que se mueve. Detalle completo en [`skills/diseno/SKILL.md`](skills/diseno/SKILL.md).

## Consejos para buenos resultados

- Una pantalla por sesión. Entre dos, `/compact`.
- Nombra archivos y rutas. "El login" funciona; `src/pages/Login.tsx` funciona mejor.
- Si el proyecto ya tiene marca, pásale el logo y los colores la primera vez; quedan en `DESIGN.md`.
- Si propone migrar a Next o instalar una librería de animación, dile "stack fijo". La skill ya lo pide, pero tu brief manda.
- Con referencias, di qué te gusta de cada una ("la estructura de Linear, el color de Stripe"). Ahorra una pregunta.

## Problemas frecuentes

| Síntoma | Qué hacer |
|---|---|
| No aparece `/diseno` al escribir `/` | Reinicia Claude Code. Comprueba que existe `~/.claude/skills/diseno/SKILL.md`. |
| `npx: command not found` o Node menor a 22.20 | Instala Node 22.20 o superior desde nodejs.org (incluye npm y npx) y repite la instalación. |
| Pide permiso en cada comando | Agrega el bloque de permisos de la sección de instalación (con tu usuario en la ruta absoluta). |
| "skill impeccable not found" o aparece `impeccable:impeccable` | Lo instalaste como plugin. Desinstálalo desde `/plugin` y reinstala con el comando de Impeccable de la Opción B. `estado.sh` lo avisa. |
| Aparecen hooks de Impeccable en `~/.claude/settings.local.json` | Corriste `npx impeccable install` o `update` sin `--no-hooks`. Borra el bloque `hooks` de ese archivo si no lo quieres en todos tus proyectos. `estado.sh` lo avisa. |
| Se abre una página en el navegador al crear una pantalla de app | Es la página de decisión de Impeccable: elige una dirección ahí y vuelve a Claude. |
| El detector dice "DEGRADED" | Claude usó el script local de respaldo (mismas reglas, sin parser HTML, cuenta de menos). Pídele que repita con `npx impeccable detect <archivo>`; ese es el completo. |
| La respuesta se corta o el contexto está muy largo | `/compact` y repite el comando. Una pantalla por sesión. |
| Una skill dice `MISSING` aunque la carpeta existe | Reinstala añadiendo `--copy` al final del comando `npx skills add …`. |
| Claude propone migrar a Next o instalar una librería de animación | Dile "stack fijo". La skill ya lo pide, pero el brief manda. |

## Actualizar y desinstalar

```bash
cd ~ && npx -y impeccable update --no-hooks && npx -y skills@latest update -g -y && bash ~/.claude/skills/diseno/scripts/estado.sh
```

Desinstalar:

```bash
npx -y skills@latest remove -g -y -s diseno design-taste-frontend redesign-existing-projects animate review-animations prototype
```

Impeccable no tiene desinstalador: borra `~/.claude/skills/impeccable` y `~/.claude/agents/impeccable-*.md`.

## Estructura del repo

```
style-agent/
├── README.md
├── install.sh                      # instala los tres paquetes y la skill, en global
├── LICENSE                         # MIT
└── skills/
    └── diseno/
        ├── SKILL.md                # el orquestador: fases, rutas, precedencia
        ├── entrevista.md           # preguntas por ronda, reglas de salto, diales
        ├── reference/
        │   ├── reglas-rapidas.md   # reglas anti "look de IA" para modo rápido y degradado
        │   └── design-md.md        # plantilla de DESIGN.md (formato oficial)
        └── scripts/
            └── estado.sh           # detecta paquetes, DESIGN.md, PRODUCT.md y código de UI
```

Para desarrollar la skill en local: `bash install.sh` desde el clon, o `npx -y skills@latest add /ruta/a/style-agent -g -a claude-code -y -s diseno` (ruta relativa o absoluta).

## Créditos y licencias

Esta skill no modifica ni redistribuye los paquetes que orquesta; los instala desde sus repos originales:
[Impeccable](https://github.com/pbakaus/impeccable) (Apache 2.0, Paul Bakaus), [taste-skill](https://github.com/Leonxlnx/taste-skill) (MIT, Leonxlnx) y [emilkowalski/skills](https://github.com/emilkowalski/skills) (MIT, Emil Kowalski). El formato de `DESIGN.md` es de [google-labs-code/design.md](https://github.com/google-labs-code/design.md).

style-agent se publica bajo licencia MIT.
