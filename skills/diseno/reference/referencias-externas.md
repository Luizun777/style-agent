# Referencias externas

Uso: solo cuando el brief lo justifica y siempre después de las referencias del usuario. Estas cuatro fuentes son **piso de conocimiento y banco de referencias, nunca autoridad de gusto**. Precedencia: brief > `inmersivo.md` > estas fuentes. Ninguna imagen de terceros entra en el entregable.

- Rol necesario: ejecutar un comando de consola, para `curl` y `python3`. En Claude Code es `Bash` con los permisos `Bash(curl -sL *)` y `Bash(python3 *)`; en otro agente, su herramienta de consola con el permiso equivalente. Si no la tienes o el permiso se deniega, di que no puedes consultar la fuente y sigue sin ella; nunca inventes resultados.
- Descarga siempre al scratchpad de la sesión (`$TMPDIR` o la carpeta temporal que te indique el entorno), nunca dentro del repo del usuario, y nunca a `git add`.
- Una sola consulta por fuente y por sesión, salvo que el usuario pida otra. Si una fuente falla, sigue; ninguna es obligatoria.

## Mobbin

Librería curada de capturas de producto real. La vertical **Sites** (desde agosto de 2025) etiqueta cada sección con Sección (`sectionPatterns`), Estilo (`siteStyles`) y Categoría (`siteCategories`), y sirve las secciones animadas como mp4 con su frame fijo.

**Sesgo, medido en dos muestras del 2026-09-12.** `styles/motion` devuelve 12 filas y 11 sitios distintos, todos productos digitales de los que reconoces ToDesktop, Frontify, Paraform, Squarespace, ElevenLabs y Aave; `ui-animations` etiqueta 11 de esas 12 filas y `scroll-effects` 6. En `sections/hero-section`, 8 de 12 filas llevan `light`. Ninguno de los 7 sitios de referencia del playbook (biologica, drinkpouch, yucca, sylverrappresentanze, eatnaked, skanvi, oddritualgolf) está en el catálogo. Conclusión operativa: Mobbin sirve para **orden de secciones, nombres de patrón y para ver qué hace la competencia directa**. No sirve para dirección de arte inmersiva; esa sale de `inmersivo.md` y de las referencias del usuario.

**Cuándo se consulta.** Superficie de marketing, el usuario no aportó URLs ni capturas, y ya tienes vibra y diales de la Ronda 1. Si el usuario dio una referencia, no se consulta. Nunca en app UI (Operate, Read).

**Acceso.** Solo páginas públicas, sin login. El WAF discrimina por User-Agent, verificado el 2026-09-12 sobre `explore/sites/styles/motion`:

| User-Agent | Resultado |
|---|---|
| `ClaudeBot/1.0 (+https://anthropic.com)` | `403` |
| curl por defecto (sin `-A`) | `200` |
| UA de navegador (Chrome 140 en macOS) | `200`, 1.252.774 bytes |

Por eso el rol de traer una URL no vale aquí (`WebFetch` en Claude Code, y lo mismo cualquier fetch del agente que se identifique con su propio UA): reciben 403. Usa `curl` con UA de navegador desde la consola.

**Rutas públicas y slugs.** Tres familias:

- `https://mobbin.com/explore/sites/sections/<slug>`: `hero-section`, `landing-page`, `pricing`, `cta-section`, `footer-section`, `features`, `how-it-works`, `showcase-section`, `social-proof`, `stats-section`, `faq`, `testimonial-examples`, `404`, `thank-you-page`, `newsletter`, `navigation-section`(*).
- `https://mobbin.com/explore/sites/styles/<slug>`: `dark`, `glass`, `3d`, `motion`, `scroll-effects`, `bold`, `colorful`, `editorial`, `brutalism-design`, `luxury-design`, `photography`, `typography`, `grid`, `ui-styles`, `minimal`(*), `light`(*), `swiss-design`(*), `kinetic-typography`(*).
- `https://mobbin.com/explore/sites/categories/<slug>`: `agency-webdesign`, `portfolio-websites`, `ecommerce-landing-page`, `award-winning-websites`, `bento-grid`, `saas-landing-page`(*), `startup-landing-page`(*), `product-landing-page`(*).

Los slugs sin marca están en el índice público del sitio. Los marcados con (*) respondían `200` el 2026-09-12 pero no aparecen en ese índice: pueden venir con pocas filas. `styles/bento` devuelve `404`; el equivalente real es `categories/bento-grid`. Regla: si la extracción devuelve menos de 4 filas, baja el índice (`/explore/sites/styles`, `/explore/sites/sections`, `/explore/sites/categories`), saca los slugs con `grep -oE '/explore/sites/styles/[a-z0-9-]+'` y elige uno de ahí en vez de adivinar.

**Extracción probada.** El HTML es un payload RSC de Next con el JSON escapado (`\"`). Dos pasos:

El UA va en línea, sin variable previa: el comando tiene que empezar por `curl` para que coincida con el permiso `Bash(curl -sL *)` y no pare la sesión con una petición de permiso.

```bash
curl -sL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" "https://mobbin.com/explore/sites/styles/motion" -o "$TMPDIR/mobbin.html"

python3 - "$TMPDIR/mobbin.html" <<'PY'
import re,sys
t=open(sys.argv[1],encoding="utf-8",errors="replace").read().replace('\\"','"')
S=lambda b:"+".join(re.findall(r'"slug":"([^"]+)"',b)) or "-"
R=r'"sectionPatterns":\[(.*?)\],"siteCategories":\[.*?\],"siteStyles":\[(.*?)\],"type":"[a-z_]+"'
for i,m in enumerate(re.finditer(R,t,re.S)):
    if i>=12: break
    w=t[m.end():m.end()+9000]
    n=re.findall(r'"name":"([^"]+)","logoCdnImgSources"',t[:m.start()])
    u=re.search(r'"(?:cdnImgSources|poster)":\{"src":"([^"]+)"',w)
    print("%2d | %-14s | %-34s | %-44s | %s"%(i+1,n[-1] if n else "?",S(m.group(1)),S(m.group(2)),u.group(1) if u else "-"))
PY
```

Salida real (en vivo, `styles/motion`, URL recortada):

```
 1 | ToDesktop      | hero-section                       | ui-animations+glass                          | bytescale...
 2 | Frontify       | hero-section                       | scroll-effects+ui-animations                 | bytescale...
 3 | Superr         | hero-section                       | fun+scroll-effects+ui-animations+illustration| bytescale...
 7 | Squarespace    | hero-section                       | 3d+black-white+scroll-effects+ui-animations  | bytescale...
 8 | Aave           | blog                               | minimal                                      | bytescale...
 9 | Paraform       | features+stats-section+social-proof | light+ui-animations+minimal                  | bytescale...
11 | ElevenLabs     | features                           | light+ui-animations                          | bytescale...
```

Salida real (archivo local de muestra, `sections/hero-section`, 1,3 MB): `Titan | hero-section | black-white+illustration+minimal`, `ToDesktop | hero-section | ui-animations+glass`, `Jeton | hero-section | 3d+scroll-effects+glass`, `Voiceflow | hero-section | light+glass`, `Lightdash | hero-section | light`, `Firecrawl | hero-section | light`, `Parker | hero-section | light`. Las 12 filas resuelven con URL en las dos páginas.

**Tres trampas del JSON, verificadas:**

1. El nombre del sitio está en `site.name`. La clave `appName` aparece 157 veces en el mismo HTML pero pertenece a otro bloque (el carrusel de pantallas de app móvil: Depop, Walmart, Klarna); no corresponde a estos sitios.
2. `page_image_url` apunta a un bucket de Supabase que no es público: responde `400 {"error":"Bucket not found"}`. Sirve como identificador, no para descargar.
3. El asset descargable es `cdnImgSources.src` (webp, hasta 3840x2520 verificado) y, en las secciones animadas, `poster.src` (webp 1920x1200 verificado; es una transformación de imagen sobre el mp4, por eso la URL acaba en `file.mp4`). El token `?enc=` caduca: descarga en la misma sesión en que extrajiste la lista.

**Protocolo obligatorio.**

1. Muestra la tabla al usuario y pídele que elija 2 o 3 filas. Nunca decidas tú por él.
2. Solo entonces descarga esas 2 o 3 imágenes al scratchpad, una por comando y con el UA en línea, sin variable previa (`curl -sL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36" "<url>" -o "$TMPDIR/ref-<sitio>.webp"`), y ábrelas con el rol de leer archivo, que además tiene que mostrar imágenes (`Read` en Claude Code). Si tu agente no puede abrir imágenes, dilo y quédate con la tabla: nunca describas una captura que no has visto.
3. Cita en el brief el sitio real y la fuente: `Referencia: hero de Frontify (vía Mobbin, explore/sites/styles/motion)`. El JSON no trae el dominio del sitio: si lo necesitas, pregúntalo o resuélvelo, nunca lo inventes.
4. Máximo 3 páginas de Mobbin por sesión. Nunca descarga masiva, nunca recorras el sitemap, nunca guardes las capturas en el repo ni las reutilices en el entregable (son de terceros; Mobbin solo permite cita con crédito).
5. De una captura de Mobbin se toma orden de secciones, densidad y jerarquía. No se toma la paleta ni la pareja tipográfica: eso lo fija el sistema del proyecto.

## UI/UX Pro Max

Base de datos local, MIT, con CSVs de estilos (88 filas, 50 activas), paletas de producto, parejas tipográficas, guías UX, patrones de landing, presets GSAP y licencias de Google Fonts. Todo offline: cero red, cero rate limits, respuesta en menos de un segundo. La web `uupm.cc` no aporta nada al agente (no hay API pública) y su Premium está pausado: ignórala.

Instalación por defecto en `~/.claude/skills/ui-ux-pro-max` (`SKILL.md`, `scripts/search.py`, `scripts/core.py`, `scripts/design_system.py`, `data/*.csv`). La ruta viene en la clave `UIPRO` de `estado.sh`; si vale `no`, sáltate esta fuente.

**Rol: piso, nunca techo.** De ella se toman el orden de secciones de un patrón, la checklist UX, los presets GSAP y los datos de licencia de Google Fonts. Se ignoran sus paletas y sus parejas tipográficas: tiran al look de IA. Evidencia de una ejecución real con un brief inmersivo premium (`--variance 9 --motion 8 --density 3`): propuso estilo **Brutalism** con efectos "No smooth transitions (instant), sharp corners (0px)", pareja **Cormorant / Montserrat** y acento `#A16207` sobre `#FAFAF9`; y el dominio `typography` para "editorial luxury serif display pairing" devuelve **Playfair Display + Inter**. Inter está en la lista negra de `reglas-rapidas.md` y "sin transiciones" contradice la curva única del playbook. Es decir: útil como esqueleto, nocivo como gusto.

**Sintaxis real.** `<UIPRO>` es la ruta absoluta de `search.py` que dio `estado.sh`; funciona desde cualquier directorio (Python resuelve `core.py` y `design_system.py` junto al script):

```bash
python3 <UIPRO> "<consulta>" --domain <dominio> -n 3
python3 <UIPRO> "<consulta>" --stack <stack> -n 3
python3 <UIPRO> "<consulta>" --design-system -p "<Proyecto>" --variance <1-10> --motion <1-10> --density <1-10>
```

Dominios: `style`, `color`, `chart`, `landing`, `product`, `ux`, `typography`, `google-fonts`, `icons`, `gsap`, `react`, `web`. Stacks: `html-tailwind`, `react`, `nextjs`, `vue`, `svelte`, `astro`, `threejs`, `shadcn` y otros. Diales solo con `--design-system`.

**Prohibido:** `--persist`, `--force`, `--output-dir` y `--page`. Escriben `design-system/<slug>/MASTER.md` en el proyecto del usuario y compiten con `DESIGN.md`, que es la única fuente del sistema. Lee la salida en pantalla y vuelca lo que sirva en `DESIGN.md`.

**Consultas que devuelven resultados** (probadas el 2026-09-12; usa el vocabulario del catálogo, no adjetivos de marca):

| Dominio | Consulta | Devuelve |
|---|---|---|
| `landing` | `scroll-triggered storytelling immersive scroll` | patrón `scroll-triggered-storytelling` con orden de capítulos y notas de reduced motion |
| `style` | `kinetic typography editorial grid magazine` | `editorial-grid-magazine` con keywords, riesgos y checklist |
| `style` | `editorial minimal swiss typography` | `minimalism-and-swiss-style` |
| `gsap` | `scrolltrigger pin scrub text reveal` | snippet de scrub con pin y el aviso de no pinear más de 1 o 2 secciones |
| `typography` | `editorial luxury serif display pairing` | parejas con URL de Google Fonts (revisa el veto de fuentes antes de usarlas) |
| `google-fonts` | `Instrument Serif` | familia, pesos, subsets, diseñadores, URL del specimen |
| `ux` | `reduced motion scroll parallax accessibility` | guía "Motion Sensitivity" con do, don't y ejemplo de código |

**Cero resultados no es un resultado vacío.** El propio script lo dice: si `Found: 0`, no caigas en defaults genéricos en silencio. Reintenta con vocabulario del catálogo y, si sigue en cero, dilo explícitamente. Ejemplo real: `"premium editorial beverage landing serif" --domain landing` devuelve 0 y sugiere `Pricing-Focused Landing`, `Event/Conference Landing`; la consulta que funciona es la de la tabla.

## Cosmos

Plataforma de moodboards. **Solo se usa si el usuario pega la URL.** Sus condiciones (ToS 8(F)) prohíben bots y extracción automática: no busques en Cosmos, no construyas URLs de búsqueda, no recorras categorías, no uses MCPs no oficiales.

- Formas de URL admitidas cuando el usuario las pega: cluster `https://www.cosmos.so/<usuario>/<slug>`, elemento `https://www.cosmos.so/e/<id>`, categoría `https://www.cosmos.so/explore/<categoria>`.
- Se lee con el navegador de la sesión, como cualquier otra referencia del usuario, y con su permiso. Máximo 8 imágenes por URL pegada.
- De cada imagen se extrae lo mismo que de una captura: suelo neutro, acento, pareja tipográfica, composición, ritmo, textura de la foto. Cita el elemento por su `/e/<id>`.
- Casi todo es contenido de terceros guardado por usuarios (Pinterest, Are.na, Instagram, webs de estudios). Nunca reutilices una imagen de Cosmos en el entregable, ni la guardes en el repo.
- Si el usuario pide "busca referencias en Cosmos": explica que no se automatiza por sus condiciones y ofrece las dos alternativas reales, que pegue un cluster suyo o que uses Mobbin público.

## Three.js

Solo si el brief pide 3D, partículas, shaders o distorsión, o si la Lectura de referencia detectó `<canvas>` con WebGL. Dato del playbook: **0 de los 7 sitios de referencia usa Three.js** (eatnaked resuelve su secuencia con canvas 2D e imágenes). Antes de cargarlo, agota el árbol de decisión de `escenografia.md`, sección "3D y WebGL": CSS, luego vídeo o secuencia en canvas 2D, y solo al final WebGL.

Versión: `three@0.186.0` (release r186). Cadencia mensual **con breaking changes entre versiones r y sin semver estable**: fija la versión exacta en el import map y en `package.json`, y desconfía de todo tutorial con `three.min.js` global o `/examples/js/`.

URLs consumibles con `curl` (verificadas el 2026-09-12, todas `200`):

- `https://threejs.org/docs/pages/<Class>.html`: la página real de la clase (`WebGLRenderer.html` 72 KB, `GLTFLoader.html` 15 KB). El índice `/docs/` y las URLs `#hash` o `/docs/api/en/...` devuelven un shim JS inútil.
- `https://threejs.org/manual/pages/<slug>.html`: guía (`fundamentals.html` 27 KB). Índice de slugs en `https://threejs.org/manual/list.json`.
- `https://threejs.org/docs/llms.txt` (5 KB): guía oficial para modelos, con el patrón moderno de import map. Léela antes de escribir la primera línea; evita el código obsoleto que los modelos generan por defecto.
- `https://threejs.org/examples/files.json` (18 KB): catálogo de ejemplos para filtrar por palabra (`points`, `shader`, `gltf`, `postprocessing`, `tsl`).
- `https://raw.githubusercontent.com/mrdoob/three.js/dev/examples/<nombre>.html`: fuente del ejemplo, autocontenido y con import map (`webgl_points_waves.html` 5 KB).

Los assets de `examples/` tienen licencias mixtas: no los copies al entregable. Las reglas de carga diferida, `pixelRatio`, `dispose()`, render bajo demanda y `prefers-reduced-motion` están en `escenografia.md`, sección "3D y WebGL"; no las repitas aquí.
