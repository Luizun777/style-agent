# Playbook de registro inmersivo (ruta X)

Autoridad en registro inmersivo, de mayor a menor: **brief confirmado (Fase 3) > este playbook > Impeccable** (proceso, detector y `craft-floor.md`, con las excepciones de abajo) **> el §14 FINAL PRE-FLIGHT CHECK de taste** (`<TASTE>/SKILL.md`, l. 910 a 980, 62 casillas, sin las que se levantan abajo) **> Emil** (`animate`, `review-animations`), que sigue mandando en componentes.
Este archivo sustituye, solo en registro inmersivo y solo en marketing, las líneas de `reference/reglas-rapidas.md` marcadas "(en registro inmersivo: ver inmersivo.md)". Se citan por su texto, no por número de línea, porque el número se desplaza al editar: la viñeta "El hero cabe en el viewport", la viñeta "Eyebrow o kicker en mayúsculas", la viñeta "Marquee de logos o claims", la viñeta "Texto con gradiente; glass o blur como decoración", la viñeta "Inter para todo" (pool de fuentes), la viñeta "Un solo acento", la viñeta "Fuente con carácter" (display y pesos), la viñeta "Tema de página bloqueado" y la viñeta "Un solo momento de movimiento autoral". Todo lo demás de `reglas-rapidas.md` sigue vigente: cero em-dashes, accesibilidad AA, estados completos, nada inventado.
Dos viñetas más de ese archivo se leen aquí con una precisión, aunque no lleven marca allí: la viñeta "Emojis o glifos unicode como iconos" sigue vigente salvo el glifo de flecha (`→` o `↗`) del CTA, y solo como parte del texto del botón, nunca como icono suelto ni en otro sitio (sigue vigente la casilla "Icons from an allowed library only" del §14 de taste: ningún SVG a mano); y la viñeta "Un solo sistema de radios" se cumple aquí con **dos roles declarados**, superficies y controles, tal como los define "Ritmo y layout".
El código de la escenografía de scroll vive en `reference/escenografia.md`; las fuentes externas, en `reference/referencias-externas.md`. Nunca uses registro inmersivo en app UI (modos Operate y Read).

## Excepciones concretas que autoriza este playbook

Esta es la **lista canónica**. La Fase 5 de `SKILL.md` no la duplica: la lee de aquí y salta exactamente estas casillas, ni una más.

De Impeccable `craft-floor.md` y `animate.md`:

- `craft-floor.md` "display máximo 6rem" → aquí hasta `clamp(3rem, 8vw, 14rem)` con peso 200 a 400.
- `craft-floor.md` "tracking mínimo -0.04em" → aquí tracking positivo de +0.05 a +0.2em en mayúsculas, y hasta -0.05em en display fluido.
- `craft-floor.md` ban de kicker o eyebrow → aquí "Sistema de labels" con sus tres condiciones. El kicker sobre cada h2 sigue prohibido.
- `craft-floor.md` ban de glass → sigue prohibido el glass decorativo; permitido el funcional sobre media con las condiciones de "Glass".
- `craft-floor.md` "un solo momento focal" → aquí una firma, una gramática de reveal repetida (la repetición ES el sistema) y como máximo 2 instrumentos.
- `animate.md` l. 69 "Do not add a dependency for an effect the existing stack can express cleanly" → levantado solo para GSAP y Lenis (y `@barba/core` si la Firma es transiciones de página), y solo con el brief confirmado.

Del §14 de taste se levantan estas casillas, por su nombre literal:

- "Hero fits the viewport" → lo sustituye "Hero tesis".
- "Hero top padding: max `pt-24`" y "Hero stack discipline: max 4 text elements" → el hero es una portada de 100dvh; el tope pasa a 2 elementos secundarios sobre el titular y el CTA.
- "Page Theme Lock" → las bandas alternas a sangre son el ritmo (6/7). Lo que sigue bloqueado es el toggle de modo, no la alternancia.
- "Marquee max-one-per-page" → cupo de 2 con roles distintos, ver "Marquee".
- "No section-numbering eyebrows" → permitido como "Sistema de labels" con sus tres condiciones.
- "Serif discipline" (serif desaconsejada, y Instrument Serif vetada por nombre) → la pareja serif + sans es la opción principal (4/7) y el pool admite Instrument Serif como voz secundaria.
- "Premium-consumer palette check" → el suelo hueso o crema es 5/7 y es la opción por defecto aquí, aunque el brief sea premium-consumer. Lo que se sigue evitando es la familia beige + latón + oxblood + espresso completa como paleta.
- "Real images used (gen-tool first, then Picsum-seed, then explicit placeholder slots)" → se levanta solo la rama Picsum: nada de stock genérico (7/7 usan foto o render propio). Se conserva "imágenes reales" y, sin material del usuario, placeholders etiquetados con medidas y toma descrita.
- "No pills/labels overlaid on images" → los badges y tarjetas glass del hero son 6/7. Solo sobre media real y con la receta única de "Glass".
- "No locale / city-name / time / weather strips" y "No version footers" → permitidos como ficha técnica en nivel `label` (SKU, `©2026`, dirección, horario), no como decoración suelta.
- "Dark mode tokens defined and tested in both modes" → el tema es único y planificado (0/7 ofrecen toggle); no hay segundo modo que probar.

Fuera del §14, de la sección 9 de taste (no son casillas del pre-flight, son prohibiciones del cuerpo):

- taste l. 604 "NO custom mouse cursors" → pasa a condicionado, ver "Instrumentos".
- taste l. 608 "NO oversized H1s" → el display gigante es 5/7, ver "Tipografía y pool de fuentes".

Todas las demás casillas del §14 se aplican tal cual, Core Web Vitals, estados vacío y error, iconos y cleanup de `useEffect` incluidos.

### Hallazgos esperados del detector en ruta X

Las excepciones de arriba levantan casillas de taste y líneas de `craft-floor`, pero el detector de Impeccable no las conoce: una página que cumple este playbook arrastra estos ids **por construcción**. Son los únicos justificables. Conteos medidos en la prueba de humo (una página de 8 bandas, 29 hallazgos), como referencia de orden de magnitud, no como cupo.

| Id del detector | Por qué sale, citado en este playbook | Línea de justificación en la entrega |
|---|---|---|
| `all-caps-body` (10) | "Sistema de labels": mayúsculas con tracking como forma única del nivel `label` | "Labels en mayúsculas: nivel `label` declarado en `DESIGN.md`, 7/7 de los sitios de referencia" |
| `tiny-text` (9) | "Sistema de labels" condición 2: suelo de 0.6875rem (11 px), el de drinkpouch | "11 px es el suelo deliberado del nivel `label`; por debajo es error, no excepción" |
| `cramped-padding` (5) | "Ritmo y layout": el inset horizontal vive en el envoltorio del contenedor, no en la `<section>` | "El padding de banda es `--band-pad` en el envoltorio; la sección va a sangre a propósito" |
| `numbered-section-labels` (3) | "Sistema de labels": numeración capitular que navega de verdad | "Numeración navegable con anclas reales, 2/7; no es el eyebrow decorativo" |
| `cream-palette` (1) | "Color": suelo hueso o crema, 5/7, y la casilla "Premium-consumer palette check" levantada arriba | "Suelo crema nombrado en `DESIGN.md`; lo evitado es la familia beige más latón más oxblood completa" |
| `marquee` (1) | "Marquee": cupo de 2 pistas con roles distintos. Comparten clase, así que el detector da un solo hallazgo | "2 pistas, roles claim y logos, no consecutivas; verificado a mano" |

Cualquier id **fuera** de esta tabla se corrige, no se justifica. En particular `design-system-font-size` y `design-system-color` son errores reales (un `clamp()` o un color que no está en la rampa declarada de `DESIGN.md`) y aparecen solo cuando `DESIGN.md` ya existe: de ahí la segunda pasada del detector que pide la Fase 5 de `SKILL.md`.

## Qué hacen los 7

Personalidad en 6 palabras:

- **biologica** (biologica.com): clínico editorial, mayúsculas tracked, fotografía dramática.
- **drinkpouch** (drinkpouch.com): científico de lujo, numerado, scrub tipográfico.
- **yucca** (yucca.co.za): industrial minimal, peso 200, aire enorme.
- **sylver** (sylverrappresentanze.it): hospitality clásica, Didone ultrafina, collage horizontal.
- **eatnaked** (eatnaked.co): tech de producto, oscuro, canvas isométrico.
- **skanvi** (skanvi.com): retail escandinavo cálido, quieto, bento fotográfico.
- **oddritual** (oddritualgolf.com): streetwear editorial, monocromo, silencio con corchetes.

`si` = presente, `.` = ausente. Datos del análisis de HTML y del recorrido visual de los 7 sitios.

| Patrón | bio | pouch | yucca | sylver | naked | skanvi | odd | Conteo |
|---|---|---|---|---|---|---|---|---|
| Hero a viewport completo con media real | si | si | si | si | si | si | si | 7/7 |
| Vídeo en el hero | . | si | . | . | si | si | . | 3/7 |
| Titular anclado a un lado, no centrado | si | si | si | si | . | si | si | 6/7 |
| Suelo neutro claro y cálido | si | si | si | si | . | si | . | 5/7 |
| Nunca `#fff` ni `#000` puros | si | si | si | si | si | si | si | 7/7 |
| Un acento saturado (los demás, ninguno) | . | si | . | . | si | . | si | 3/7 |
| Pareja serif + sans con roles fijos | si | si | . | si | . | . | si | 4/7 |
| Display gigante (8rem o más, o watermark) | . | si | si | si | si | si | . | 5/7 |
| Display moderado en mayúsculas, jerarquía por caja | si | . | . | si | . | . | si | 3/7 |
| Labels pequeños en mono o mayúsculas | si | si | si | si | si | si | si | 7/7 |
| Numeración de capítulos | . | si | . | . | . | . | si | 2/7 |
| Hairlines de 1 px en vez de sombras | si | si | si | si | si | si | si | 7/7 |
| Bandas alternas o bloques de color a sangre | si | si | si | si | . | si | si | 6/7 |
| Marquee | si | si | si | si | . | si | . | 5/7 |
| Glass solo sobre foto o vídeo | si | si | si | si | si | si | . | 6/7 |
| Wordmark o watermark gigante | si | si | si | si | si | . | si | 6/7 |
| Header transparente que se rellena o se esconde | si | si | si | si | si | . | si | 6/7 |
| GSAP + ScrollTrigger | si | si | si | si | si | . | si | 6/7 |
| Lenis | . | si | si | . | si | . | si | 4/7 |
| SplitText activo en la home | si | si | si | . | . | . | . | 3/7 |
| Reveals por máscara, no por fade | si | si | si | si | si | . | si | 6/7 |
| Pin, scrub o solapamiento de secciones | si | si | si | si | si | . | si | 6/7 |
| Parallax de imagen por atributo | si | si | si | . | si | . | si | 5/7 |
| Preloader | . | . | si | . | si | . | si | 3/7 |
| Cursor custom | . | si | . | . | si | . | si | 3/7 |
| Transiciones de página (Barba) | . | . | si | . | . | . | si | 2/7 |
| Scroll horizontal por paneles | . | . | . | si | . | . | . | 1/7 |
| Secuencia de imágenes en canvas | . | . | . | . | si | . | . | 1/7 |
| Three.js, WebGL o shaders | . | . | . | . | . | . | . | 0/7 |
| Escala tipográfica fluida | si | si | si | . | si | si | . | 5/7 |
| Botón píldora con glifo de flecha | si | si | si | . | si | si | . | 5/7 |
| Swap vertical del texto del botón al hover | . | . | si | . | si | . | si | 3/7 |
| Una sola curva de la casa en todo el sitio | si | si | si | si | si | si | si | 7/7 |
| Fotografía o render de estudio, cero stock | si | si | si | si | si | si | si | 7/7 |

Lecturas obligadas de la tabla: skanvi no anima nada y sigue leyéndose premium (la contención es una opción válida, no un fallo); Three.js es 0/7 (el nivel lo dan la foto, el vídeo y el canvas 2D); Tailwind y Motion son 0/7; el framework no decide el resultado (el más animado es HTML con módulos ES y el único React es el menos animado).

## Hero tesis

Sustituye la viñeta "El hero cabe en el viewport" de `reglas-rapidas.md` (titular de 2 líneas máximo, subtexto de 20 palabras, 4 elementos de texto máximo), las casillas "Hero fits the viewport", "Hero top padding" y "Hero stack discipline" del §14 de taste, y el criterio de éxito equivalente de la Fase 5. En registro inmersivo el hero no cabe: es una portada.

- `min-height: 100dvh` (y `100svh` en móvil para que la barra del navegador no lo corte) con un visual real a sangre: foto de estudio, vídeo o render prerrenderizado. Nunca un gradiente, un mesh, un blob ni stock genérico. 7/7 abren con media real.
- Titular anclado a la izquierda o abajo a la izquierda, hasta 3 líneas, en escala fluida. 6 de 7 lo anclan; solo eatnaked centra. El titular es opcional si el wordmark ocupa su rol (drinkpouch no tiene titular en desktop).
- Como máximo 2 elementos secundarios: una fila de prueba (badges, tarjetas glass, chips de sabor) y un label del sistema. Nada más.
- Un CTA en píldora con glifo (`→` o `↗`), texto corto en mayúsculas con tracking. Un solo label por intención, repetido en toda la página.
- Header transparente sobre el hero que se rellena de color al bajar y se esconde al seguir bajando, reapareciendo al subir (6/7). Umbral de 40 a 80 px.
- Entrada de la imagen: un solo zoom-out suave, una sola vez (biologica `scale` 1.5 a 1 en 0.8 s; yucca 1.2 a 1 en 3 s). Bajo `prefers-reduced-motion` se queda en 1.
- Vídeo con carga honesta: `poster` en webp con `fetchpriority="high"` (el poster es el LCP, no el vídeo), `muted loop playsinline preload="none"`, fuente mp4 añadida en `requestIdleCallback`, y se salta entero si `navigator.connection.saveData` o `prefers-reduced-motion: reduce`. Si el contraste no da, tíñelo con `mix-blend-mode: multiply` sobre un color de marca (drinkpouch multiplica sobre `#97A5B9`), nunca con una capa negra al 60 %.
- Vídeo sin audio salvo que exista banda real; si la hay, arranca muted y añade el toggle de "Instrumentos".
- Sin media real no hay ruta X. Si el usuario no aporta foto ni vídeo, construye con placeholders etiquetados con medidas y toma descrita (ver "Móvil" y la entrega de Fase 6) y dilo: el resultado no alcanzará el nivel hasta que se sustituyan. Esa rama tiene tres reglas propias:
  1. La ficha del placeholder (medidas, formato, toma) va **fuera de la columna del titular**: esquina inferior o superior del plate, o un `<figcaption>` bajo el hueco. Nunca solapando texto. En la prueba de humo se colocó dentro del plate a `top: 42%` y quedó impresa encima del `h1`, ilegibles los dos, como primera impresión de la página. Y **cuenta como uno de los 2 elementos secundarios** del hero.
  2. Sin assets reales, las únicas Firmas declarables son el **scrub tipográfico** y las **transiciones de página**. Vídeo macro en hero, producto 3D o secuencia atada al scroll y, en la práctica, el scroll horizontal por paneles dependen de material que no existe todavía: se posponen, se dice en el brief y se anotan en la entrega como pendientes (lo repite `escenografia.md` sección "Firmas").
  3. Mientras la media sea un placeholder, el glass degrada a relleno sólido del token y el parallax no se crea (ver "Glass" y `escenografia.md` sección "Parallax"). Se anota como pendiente de reactivar al llegar el material.

## Tipografía y pool de fuentes

- Contraste extremo de escala (7/7): display grande o tracked frente a labels de 10 a 14 px; el rango medio queda casi vacío. Tres registros válidos, elige uno:
  1. Display fluido `clamp(3rem, 8vw, 14rem)`, peso 200 a 400, `line-height` 0.9 a 1, tracking -0.02 a -0.05em (yucca 14.2rem peso 200; eatnaked `min(10rem, 10vh)`; skanvi `clamp(3.2rem, 6.2vw, 6.4rem)` con -0.052em).
  2. Display moderado de 2.5 a 4.5rem en MAYÚSCULAS con tracking positivo de +0.05 a +0.2em, jerarquía por caja y espacio (biologica: todos los títulos a 35 px con +3 px; sylver 75 px serif 300 con +2 px).
  3. Wordmark SVG o watermark tipográfico al 12 a 24 % de alfa como pieza display (sylver "SYLVER" a 280 px; oddritual SVG a 4 columnas).
- Máximo 3 familias con roles fijos y declarados en `DESIGN.md`: display, cuerpo, labels (mono o serif secundaria). La pareja serif + sans es la opción principal (4/7): serif en el display **o** en los párrafos lead, nunca en ambos.
- Pesos 200 a 400 son jerarquía legítima; la jerarquía secundaria se hace con opacidad 0.3 a 0.6 del mismo ink, no con un gris nuevo.
- Escala fluida en `:root` (5/7): `html { font-size: clamp(5px, 0.58vw, 19px) }` o el patrón de yucca (`0.5787vw`, 1rem = 10px a 1728px). Bloquea también por altura con `min(Xrem, Xvh)` para que el titular no desborde en apaisado.
- Self-host woff2 siempre, con `font-display: swap` y subconjunto latino. Nunca un `<link>` a Google Fonts: 0 de 7 usan Google como primaria. Tras cargar, `ScrollTrigger.refresh()` en `document.fonts.ready` (receta en `escenografia.md`).
- Fallo a no repetir: declarar una `font-family` que no se sirve (skanvi declara "Proxima Soft" sin `@font-face` y renderiza en `system-ui`). Verifícalo con un grep de cada familia declarada contra los `@font-face` del proyecto. Y no cargues familias que no uses: 4 de 7 arrastran peso muerto.

**Receta de descarga** (Fontshare y Google). Cuatro pasos, con permiso para ejecutar `curl` en la consola (en Claude Code lo concede `Bash(curl -sL * -o *)` de `allowed-tools`; en los demás agentes, el permiso de consola que use ese agente, ver Fase 0b de `SKILL.md`); sin ese permiso las fuentes se entregan como **pendientes** y el punto 5 del Checklist X no se marca (dilo así en la entrega, no lo pases por alto):

1. Una petición **por familia**, nunca combinadas: la API de Fontshare descarta familias en silencio si se agrupan (medido: `?f[]=satoshi@400,500,700&f[]=zodiak@300,400` devuelve solo Satoshi). `curl -sL "https://api.fontshare.com/v2/css?f[]=satoshi@400,500,700" -o fonts/_satoshi.css`, y otra igual para cada familia del pool.
2. Saca las URLs de los archivos del CSS descargado. Son **relativas al protocolo**, así que un grep de `https://` no encuentra nada: `grep -oE '//cdn\.fontshare\.com[^)"]+\.woff2' fonts/_satoshi.css`.
3. Descarga cada woff2 con el protocolo delante, uno por peso: `curl -sL "https://cdn.fontshare.com/…/Satoshi-Regular.woff2" -o fonts/satoshi-400.woff2`. Con Google es lo mismo sobre `https://fonts.googleapis.com/css2?family=Instrument+Serif&display=swap`, siempre con el UA de Chrome del paso 2 de la ruta G (sin UA moderno devuelve `ttf` en vez de `woff2`), y el resultado se sirve en local: el `<link>` a Google Fonts sigue prohibido.
4. Escribe los `@font-face` a mano con `font-display: swap` y cierra con el grep de verificación: cada `font-family` declarada en el CSS tiene su `@font-face` y su archivo en el repo.

Pool libre (usa solo esto salvo que el usuario aporte licencia):

| Familia | Origen | Licencia | Para qué voz |
|---|---|---|---|
| Satoshi | Fontshare | ITF Free, uso comercial | Grotesk variable neutra con carácter: display y cuerpo a la vez (eatnaked la usa en todo) |
| General Sans | Fontshare | ITF Free | Sans de trabajo: cuerpo, UI y labels |
| Cabinet Grotesk | Fontshare | ITF Free | Display con personalidad, titulares cortos |
| Clash Display | Fontshare | ITF Free | Display rotunda y condensada, mayúsculas grandes |
| Zodiak | Fontshare | ITF Free | Serif de contraste alto: display editorial |
| Sentient | Fontshare | ITF Free | Serif humanista: párrafos lead |
| Gambetta | Fontshare | ITF Free | Serif de pluma con itálicas: display editorial |
| Author | Fontshare | ITF Free | Serif de lectura: cuerpo largo |
| Instrument Serif | Google | libre (OFL) | Voz secundaria: numerales, pies, itálica de acento, un titular condensado (rol de oddritual) |
| Newsreader | Google | libre (OFL) | Serif de lectura con tallas ópticas |
| Cormorant Garamond | Google | libre (OFL) | Serif fina de display; ilegible en cuerpo |
| EB Garamond | Google | libre (OFL) | Serif clásica de cuerpo |
| Schibsted Grotesk | Google | libre (OFL) | Grotesk de labels y UI |
| JetBrains Mono | Google | libre (OFL) | Labels, ficha técnica, numeración |
| Geist Mono | Google | libre (OFL) | Mono geométrica; el detector marca la familia Geist, justifica el hallazgo o usa JetBrains Mono |
| PP Neue Montreal | Pangram Pangram | **trial** | Grotesk suiza contemporánea (la de oddritual) |
| PP Editorial New | Pangram Pangram | **trial** | Serif editorial de alto contraste |

- Los trials de Pangram sirven para maquetas y presentación. **No cubren producción.** Si los usas, dilo en la entrega y anótalo en `DESIGN.md`; ofrece la alternativa libre equivalente (Cabinet Grotesk por PP Neue Montreal, Zodiak por PP Editorial New).
- Fuente de marca: gana siempre. Pide los woff2, colócalos en el repo y declara `@font-face { font-family: 'X'; src: url('/fonts/x.woff2') format('woff2'); font-weight: 200 900; font-display: swap; }`. Si es variable, un solo archivo y rango de pesos. Nunca sirvas un archivo que el usuario no licenció, y nunca escribas el nombre de una comercial (Matter, Bradford, Magnetik, Haboro, The Future) sin tener el archivo.
- Lista negra vigente (el detector las marca): Inter, Roboto, Open Sans, Lato, Montserrat, Arial, Helvetica, Fraunces, Instrument Sans, Instrument Serif, Geist, Mona Sans, Plus Jakarta Sans, Space Grotesk, Recoleta. Dos de ellas están además en el pool de arriba y se admiten como voz secundaria: **Instrument Serif** (la casilla "Serif discipline" del §14 la veta por nombre) y **Geist Mono**. Si usas una de esas dos, o si la fuente de marca es una de la lista, se queda y el hallazgo del detector se justifica en una línea con la referencia a `DESIGN.md`.

## Color

- Un suelo neutro de una sola familia, con nombre propio en los tokens, nunca `#fff` ni `#000` puros (7/7): hueso `#edefea` (biologica), chalk `#EDEBE4` (drinkpouch), porcelana `#FFFDF5` (yucca), crema `#F3EFE6` (sylver), cream `#fff5e9` (skanvi), tinta `#0b0b0b` (eatnaked), `#020202` (oddritual). Nombra los tokens por material o botánica (`--c-oat`, `--c-almond`, `--c-porcelain`), no por número.
- Un acento como máximo, y solo si hace falta: 3 de 7 tienen acento saturado (drinkpouch `#000BFA`, eatnaked `#f4783e`, oddritual `#050fff`); los otros 4 no tienen ninguno y el color saturado lo ponen el producto y la fotografía. Esa es la opción por defecto en la ruta X.
- Las variantes de gris se hacen con alfa del mismo ink, no con grises nuevos (skanvi deriva 25 variantes de `#292929`; oddritual tiene `--swatch--dark-faded-1` a `-8`). Declara la rampa completa en `:root` con el alfa en el nombre (`--ink`, `--ink-72`, `--ink-55`, `--ink-12`) y no uses ninguna fuera de esa lista: cada `var(--…)` que aparezca en el JS de la escenografía tiene que estar declarado ahí (el scrub tipográfico parte de `--ink-55`). Un token inventado no rompe nada visible, hereda el color del elemento y deja la firma muda; lo caza la fila "Variables declaradas" de `escenografia.md`.
- Bandas oscuras planificadas como ritmo (6/7), no como segundo tema: mismo ink invertido, mismo acento, misma tipografía. Escribe la lista de bandas antes del HTML (biologica alterna `#1b1a21` y `#edefea` en sus 10 secciones; yucca va oat, porcelana, negro, verde bosque). **Todo el chrome fijo invierte con la banda que tiene debajo**, no solo el header: índice lateral, barra de progreso y botones flotantes incluidos (sylver usa un doble header recortado por `clip-path`; la alternativa barata es `mix-blend-mode: difference`). Un chrome que no invierte queda ilegible en las bandas oscuras y el contraste AA del punto 16 del Checklist X se marca pasado sin serlo.
- Tema único bloqueado, sin toggle: 0 de 7 ofrecen uno. "Tema único" se refiere al **toggle de modo claro y oscuro**, no a las bandas: las bandas alternas a sangre son el ritmo de la página y son 6/7. Elige claro cálido u oscuro en el brief, anótalo en `DESIGN.md` Overview y pasa "sin dark mode" si se invoca taste. Esto sustituye la fila de "dark mode obligatorio en marketing de consumo" y la casilla "Page Theme Lock" del §14 de taste.
- Contraste AA sigue siendo obligatorio, también encima de foto y de vídeo. Se resuelve con glass, con un degradado de legibilidad anclado al texto o cambiando la toma; nunca bajando el tamaño ni poniendo texto gris sobre foto.

## Ritmo y layout

- El hero a `100dvh` y al menos 2 bandas más cerca de 80vh, con un solo mensaje cada una (5/7 trabajan en ese rango). El resto se dimensiona **por contenido** con `padding-block: var(--band-pad)` (base 8rem), nunca con relleno para llegar a una altura: una ficha técnica de 5 filas o un protocolo de 3 pasos son bandas legítimas y no llenan 80vh sin inventar aire. `min-height` solo donde el mensaje lo justifica.
- Alternancia planificada claro y oscuro a sangre, declarada como lista antes de escribir. Nunca dos secciones seguidas con la misma familia de layout (viñeta "Layout con variación" de `reglas-rapidas.md`, vigente).
- Hairlines de 1 px en lugar de sombras (7/7; sombras difusas en tarjetas: 0/7). Usa `border: 1px solid color-mix(in srgb, currentColor 50%, transparent)`; si la animas, `scaleX` de 0 a 1 (yucca), no `width`.
- **Dos roles de radio declarados y nada más**: superficies (bandas, tarjetas, plates de media, inputs; todas con el mismo valor, recto o contenido de 10 a 16 px) y controles (botones y chips; todos con el mismo valor, recto, contenido o pill). Declara los dos en `DESIGN.md` como `--r-surface` y `--r-control`; cero radios fuera de esos dos. La combinación frecuente es superficies rectas más controles en píldora, coherente con el botón píldora de 5/7 y con la opción "Pill en botones, suaves en tarjetas e inputs" de `entrevista.md`. Lo que sigue prohibido es un tercer valor, o que cada tarjeta tenga el suyo.
- Grid de 12 columnas con asimetría real: el contenido no empieza siempre en la columna 1 (drinkpouch pone el hero en las columnas 3 y 4 y su pie en 5 y 6). Contenedor ancho (1320 a 1360 px, o `--container-width` en rem fluidos), márgenes de 24 a 32 px en móvil, gutters `calc((100vw - 90rem) / 2)`. Si el brief aprueba el instrumento de índice lateral, **el contenedor se estrecha para reservarle su columna**: el índice vive dentro del gutter, con un `min-width` de página por debajo del cual se oculta. Nunca se superpone. Medido en la prueba de humo: contenedor de 84rem (1447 px) con el índice en `right: var(--gutter)` sobre un viewport de 1485 px pisa el manifiesto, la cuarta tarjeta de la tira de producto y el texto del segundo marquee.
- Elementos que sangran por el borde: tira de producto con la cuarta tarjeta asomando a la derecha (oddritual), foto que cabalga entre dos paneles (sylver), carrusel a sangre cuyo primer item alinea con la columna de texto.
- Collage con solapes y tamaños distintos para la sección de historia o de servicios (sylver, biologica). Recortes PNG con alfa que entran ligeramente rotados y se enderezan (yucca `rotate: -10deg`).
- Un solo token de curva y dos duraciones para todo el sitio: `--ease-house` (7/7 tienen una sola: biologica `cubic-bezier(.5,0,0,1)`, yucca `(0.22,1,0.36,1)`, oddritual `(0.32,0.72,0,1)`), `--dur-ui: .24s`, `--dur-reveal: 1.2s`, `--stagger: .06s`. **Valores canónicos en `escenografia.md` sección "Setup GSAP + Lenis"**: son los que consume el código y los que se escriben en `DESIGN.md`. La banda observada en los 7 sitios es UI de 0.3 s y reveal de 1 s; se fija en 0.24 s para no chocar con el techo de Emil (menos de 300 ms en UI, que este playbook no levanta) y en 1.2 s porque es la duración del reveal real. La escena admite de 1.0 a 1.6 s como rango, no como token.
- Densidad: los dos extremos funcionan (denso en biologica y eatnaked; casi vacío en yucca, sylver y oddritual). Elige uno en el brief y mantenlo en toda la página.

### Arquitectura de bandas

De aquí sale la lista que pide el paso 6(3) de la ruta X: escribe la secuencia antes del HTML y cítala por estos nombres. No es un orden obligatorio, es el repertorio observado; elige de 6 a 9 bandas, ninguna familia de layout dos veces seguidas, y con `UIPRO` o Mobbin como piso opcional del orden, nunca como única fuente.

| Banda | Qué lleva | Conteo | Contraparte real |
|---|---|---|---|
| Portada | media real a 100dvh, titular anclado, un CTA, una fila de prueba | 7/7 | todas; ver "Hero tesis" |
| Manifiesto | tríada corta o párrafo lead, mucho aire, a veces con scrub tipográfico | 6/7 | drinkpouch (scrub de `chars`), biologica, yucca |
| Producto o catálogo | tira, carrusel a sangre o bento fotográfico con nombre y precio. **Nunca N tarjetas idénticas en fila**: al menos un item cambia de tamaño, de recorte o de línea de base (bento, escalonado, o el primero alineado a la columna de texto y el último sangrando). Cuatro cajas iguales con el mismo `aspect-ratio` y el mismo orden interno es la viñeta "Tres tarjetas iguales como estructura de página" de `reglas-rapidas.md`, que este playbook no levanta, y la cuarta tarjeta asomando tiene que ser una decisión de composición, no un accidente del viewport | 6/7 | skanvi (carrusel de recortes y franja salvia con 4 productos), oddritual (cuarta tarjeta asomando) |
| Escena de proceso | 2 a 4 pasos en el mismo encuadre, pinados o solapados | 6/7 | drinkpouch ("The science", pin con rail `001` a `002`), eatnaked (canvas) |
| Prueba o credencial | certificación, dato verificable, logos de partners, retratos | 5/7 | sylver (12 logos), biologica (retratos en marquee vertical), drinkpouch (OB/GYN, MS RDN) |
| Historia o collage | solapes, tamaños distintos, recortes ligeramente rotados | 4/7 | sylver, biologica, yucca (`rotate: -10deg`) |
| Formulario o newsletter | una tarjeta con foto, un campo, un botón; nunca popup al cargar | 4/7 | skanvi (tarjeta con foto a la izquierda) |
| Banda CTA | un solo mensaje a sangre, el mismo label de intención de toda la página | 5/7 | yucca, eatnaked, drinkpouch |
| Footer con wordmark | wordmark a sangre, 3 columnas con hairlines, ficha técnica en nivel `label` | 6/7 | ver "Wordmark y footer" |

Secuencias reales completas, para calibrar: biologica alterna `#1b1a21` y `#edefea` en sus 10 secciones; yucca va oat, porcelana, negro, verde bosque; skanvi es portada, carrusel de recortes, bento de 2 columnas, franja salvia con 4 productos, 3 columnas USP con hairlines, tarjeta newsletter, footer de 4 columnas.

## Sistema de labels

Permitido en registro inmersivo solo si cumple las tres condiciones. Los labels aparecen en 7 de 7 sitios; la numeración de capítulos, en 2 de 7.

1. Es el rol declarado de la tercera fuente (mono o serif secundaria) y está registrado en `DESIGN.md` como nivel `label`.
2. Tiene una sola forma en toda la página: 0.6875 a 0.875rem, mayúsculas o mono, tracking de 0.1 a 0.14em, ink al 50 a 60 %, sin color de acento, sin caja (drinkpouch `.text-sci-details` a 0.6875rem con `line-height` 1.8). Ese 0.6875rem son 11 px y es el **suelo deliberado**: el detector lo reporta como `tiny-text` y por eso está en la tabla de hallazgos esperados. Por debajo cae en `undersized-ui-text`, que es error y se corrige; nada del chrome, índice incluido, baja de 0.6875rem.
3. Aparece como sistema, no como adorno: en 1 de cada 3 secciones, o como índice navegable real, rail lateral, ficha técnica o pie de foto.

- Legítimos: numeración capitular que navega (`01 / OUR FORMULAS` hasta `09` en drinkpouch), índice fijo con progreso (eatnaked), ornamento tipográfico de sistema (`( FEATURED PRODUCTS )`, `〔 VIEW ALL PRODUCTS 〕` en oddritual), ficha técnica (SKU `(OR_CAD_N)`, `ORGC©2026`), overline de sección puntual (yucca), watermark (sylver).
- Sigue prohibido: el kicker o eyebrow en mayúsculas encima de cada h2, el label con color de acento y la secuencia `01 / 02 / 03` decorativa que no lleva a ninguna parte.
- El detector marcará estos labels. Justifícalos en bloque, en una línea, citando el nivel `label` de `DESIGN.md`.

## Marquee

Receta única por proyecto, en CSS puro (4 de 7 lo hacen así):

```css
.marquee { overflow: hidden; mask-image: linear-gradient(90deg, transparent, var(--ink) 6rem, var(--ink) calc(100% - 6rem), transparent); }
.marquee__track { display: flex; gap: 4rem; width: max-content; animation: marquee 26s linear infinite; will-change: transform; }
@keyframes marquee { to { transform: translateX(-50%); } }
@media (prefers-reduced-motion: reduce) { .marquee__track { animation: none; } }
```

- La pista lleva el grupo duplicado y la copia va con `aria-hidden="true"`; con `translateX(-50%)` el bucle es continuo. Duraciones de 22 a 34 s, `linear` siempre (movimiento constante).
- La máscara solo usa el canal alfa, así que cualquier color opaco sirve: usa el token de ink, **nunca `#000`**, que contradice la regla de color de este playbook (ni `#fff` ni `#000` puros, 7/7) y sale como `design-system-color` en el detector. Si en vez de máscara usas degradados pintados, esos sí llevan el color del fondo de la banda (sylver enmascara con su verde). `will-change` solo en la pista, nunca en los hijos.
- Bajo `prefers-reduced-motion` se queda quieto y sin duplicar (skanvi lo hace así). Pausa en hover, opcional.
- Cupo de 2 por página con roles distintos: uno de palabras clave o claim, otro de logos. Nunca dos seguidos ni dos con el mismo contenido. Ejemplos: skanvi (marcas en grises y métodos de pago), yucca (dos filas en direcciones opuestas), drinkpouch (ticker de anuncio y marquee de ingredientes dentro de cada tarjeta), sylver (12 logos de partners), biologica (dos filas verticales contrapuestas de retratos, alternativa legítima a un grid de fotos).
- Variante que reacciona a la velocidad del scroll solo con GSAP (`horizontalLoop` con `timeScale` derivado de `ScrollTrigger.getVelocity()`, clamp a ±40, vuelve a 1 al parar): es de yucca y su código está en `escenografia.md`. En CSS no se hace.
- Accesibilidad: si el texto de la pista importa, ponlo también en un elemento real; si es decorativo, la lista entera puede ir con `aria-hidden`.

## Glass

- Solo encima de una imagen o de un vídeo real. Nunca sobre color plano: eso es el glass decorativo que `craft-floor` prohíbe y que el detector marca. 6 de 7 lo usan y siempre sobre media.
- **Mientras la media sea un placeholder, el glass degrada a relleno sólido del token** y se anota como pendiente de reactivar cuando llegue el material. Un hueco de media es un rectángulo de color plano: las pastillas glass encima son exactamente el glass decorativo prohibido, no una excepción del registro. En la prueba de humo las tres pastillas del hero quedaron sobre color plano y el punto 11 del Checklist X se marcó pasado porque comprobaba `@supports` y el corte a 768 px, no si había media debajo.
- Una sola receta tokenizada por proyecto, reutilizada en badges, tarjetas y header: `backdrop-filter: blur(8px a 30px)`, relleno blanco o negro al 10 a 25 %, borde de 1 px al 20 a 50 %, un radio. Ejemplos: biologica `blur(8px)` en los badges del hero, drinkpouch `blur(30px)` en header, badges y ticker, yucca `blur(3rem)` con blanco al 25 % en las tarjetas del hero, sylver `blur(45px) saturate(220%)` en el footer fijo, eatnaked `rgba(255,255,255,.11)` con `blur(28px)` y borde `#363535`.
- Un componente glass por página. Ese componente puede repetirse (las tres tarjetas del hero); lo que no se hace es inventar un segundo tratamiento. eatnaked aplica la misma receta a toda su UI oscura y funciona porque es una, no seis.
- Fallback obligatorio y sólido en móvil:

```css
.glass { background: rgba(255,255,255,.18); backdrop-filter: blur(24px); border: 1px solid rgba(255,255,255,.35); }
@supports not (backdrop-filter: blur(1px)) { .glass { background: var(--c-porcelain); } }
@media (max-width: 767px) { .glass { backdrop-filter: none; background: var(--c-porcelain); } }
```

- Registra `glass: { blur, fill, border, radius }` en `DESIGN.md` (sección Elevation & Depth) para que no se reinvente por sección.
- Mide el contraste del texto sobre el glass con el fotograma más claro del vídeo, no con el poster.

## Wordmark y footer

- Wordmark a sangre como pieza display, a ancho completo del contenedor (6/7). Variantes: texto con tracking ajustado a `width: 100%` (biologica, eatnaked, yucca), SVG desplegado a 4 o 12 columnas (oddritual), watermark al 12 a 24 % de alfa (sylver "SYLVER" a 280 px con +50 px de tracking), wordmark vertical con `soft-light` y scrub (drinkpouch).
- Mecanismo, porque "a ancho completo" no se consigue solo: **SVG con `viewBox` y `width: 100%`** es lo más fiable y no depende del número de caracteres; con texto, `font-size` en `vw` **calibrado junto con `letter-spacing`** para la longitud concreta del wordmark y comprobado en captura. Un `clamp()` a ojo se queda corto: en la prueba de humo `clamp(3.4rem, 17.4vw, 22rem)` ocupó el 55 % del ancho, grande pero no a sangre. El punto 12 del Checklist X se mide: 100 % del ancho del contenedor con tolerancia del 2 %.
- Footer de 100svh en 3 de 7 (yucca, oddritual, sylver con footer fijo). Un solo reveal en el footer, no tres (yucca sube el bloque con `yPercent` de -50 a 0 con scrub).
- Tres columnas separadas por hairlines, con los títulos de columna en el nivel `label`. Navegación real, contacto y legales; nunca un segundo CTA gigante que compita con el hero.
- Disclaimer y microcopy técnico en nivel `label`: `©2026`, dirección, horario, SKU, "visitas con cita". Aporta textura y credibilidad; un párrafo de marketing no.

## Instrumentos

Cupo total: **1 firma + 2 instrumentos como techo por página**. Todos gateados a desktop salvo el marquee, que es CSS puro y se conserva en móvil (o pausado).

Cómputo, para que no haya aritmética ambigua:

- El cupo de 2 cuenta **filas de esta tabla**, no efectos.
- Los dos marquees del cupo de "Marquee" cuentan como **1 instrumento**, no como dos.
- "Transiciones de página" cuenta como Firma cuando la línea `Firma:` del brief dice "transiciones de página", y como instrumento solo cuando la Firma es otra. Nunca las dos cosas a la vez.
- Si el usuario pide más, di qué se cae y por qué: eso es lo que pide la Fase 3 de `SKILL.md`.

Umbral de desktop: el del proyecto es el de `escenografia.md`, **768 px** (`(prefers-reduced-motion: no-preference) and (min-width: 768px)`), y 1025 px solo para el scroll horizontal. Dato descriptivo de los sitios, no instrucción: 5 de los 7 encierran sus firmas en `gsap.matchMedia('(min-width:992px) and (pointer:fine)')` (biologica y drinkpouch en 992 px), lo que deja sin firma ni fallback la franja de 768 a 991 px. No copies ese umbral.

| Instrumento | Condición para existir | Coste | Ejemplo real |
|---|---|---|---|
| Preloader | Solo si hay assets que esperar (vídeo hero, secuencia de imágenes, 3D). Progreso real, nunca falso. Máximo 1.5 s con timeout forzado que lo mata y muestra la página. Nunca en móvil. Una vez por sesión con `sessionStorage` | Retrasa el LCP; es el instrumento que más daño hace | 3/7: eatnaked (porcentaje real de 241 frames), yucca (`sessionStorage.hasVisited`, solo primera visita), oddritual (`clip-path`, 2 s). Fallo observado: eatnaked en móvil se queda de 15 a 25 s |
| Cursor custom | Solo si el usuario lo pide. Solo bajo `@media (hover: hover) and (pointer: fine)`. Contextual (`Drag`, `Next`, `Add`, `close`) y dentro del componente que lo necesita. No oculta el cursor nativo salvo en zonas de arrastre | taste lo prohíbe entero ("NO custom mouse cursors"); hostil a accesibilidad y a rendimiento | 3/7: eatnaked (solo dentro del track de testimonios), oddritual (2 elementos), drinkpouch |
| Toggle de sonido | Solo si el vídeo tiene banda real. Arranca muted, botón visible con estado y `aria-pressed`. Nunca autoplay con audio | Un botón más en el chrome del hero | 1/7: drinkpouch. biologica lo usa en los vídeos de testimonio |
| Índice de secciones y barra de progreso | Solo si la página tiene 6 o más capítulos con nombre. Anclas reales con `aria-current`; se oculta en móvil. **El contenedor le reserva su columna** (vive en el gutter, con un `min-width` de página por debajo del cual se oculta): no se superpone al contenido a 1280, 1440 ni 1920 px. Y **declara su inversión por banda**: un ScrollTrigger que conmuta una clase con el color de la banda de debajo, o `mix-blend-mode: difference`. Sin las dos cosas no se construye | Chrome fijo que compite con el contenido | 2/7: eatnaked (índice fijo con progreso), drinkpouch (barra vertical en el borde derecho). Fallo medido en la prueba de humo: índice en `--ink-72` sobre `band--deep` (#24403a) da 1.37:1, y sobre el footer abyss (#101f1e) es invisible |
| Marquee | Cupo de 2 con roles distintos (claim y logos), receta única, ver sección "Marquee". Los 2 cuentan como 1 instrumento | Bajo: es CSS puro y se conserva en móvil | 5/7: skanvi (marcas en grises y métodos de pago), yucca (dos filas opuestas), drinkpouch (ticker e ingredientes) |
| Transiciones de página | Solo en sitios multipágina, con el overlay del mismo color del suelo y `ScrollTrigger.refresh()` al entrar. **Solo cuenta como instrumento si la Firma es otra**; si la Firma es "transiciones de página", gasta la Firma y no un instrumento | Una librería más (`@barba/core@2.10.3`) y riesgo de estado sucio | 2/7: yucca (Barba con overlay porcelana de 0.4 s), oddritual (Barba con `clip-path`) |
| Popup de newsletter | **Prohibido al cargar.** Si el usuario lo pide: tras el 50 % de scroll o al salir, una vez por sesión, cerrable con `Escape` | Mata la primera impresión y la captura de Fase 5 | oddritual lo lanza al cargar y tapa el hero, también en móvil. Es el antipatrón, no el modelo |

## Botones y micro-interacciones

Emil manda en esta sección: carga `animate` antes de escribirla (lee `<ANIMATE>/SKILL.md`; la regla de carga está en la Fase 0b de `SKILL.md`) y pásala por `review-animations`. La escenografía de scroll no pasa por esa barra; los componentes sí.

- Forma: píldora (5/7) o sin caja con una línea que crece desde el borde de ataque (sylver, una línea de 35 px que llega al 100 %). El botón usa el radio del **rol control** (`--r-control`), el mismo en todos los botones y chips; las tarjetas usan el de superficie. Son los dos roles de "Ritmo y layout", no dos sistemas.
- Texto pequeño en mayúsculas con tracking, y un glifo `→` o `↗` pegado al texto, como parte del texto del botón: es la única excepción a la viñeta de glifos unicode como iconos, y no habilita ningún otro. Ningún CTA parte en dos líneas.
- Swap vertical del texto duplicado al hover (3/7): `.btn-text` y `.btn-text-hover` desplazándose en `translateY` (yucca, 0.5 s), `::before { content: attr(data-text) }` (oddritual), o duplicado por `text-shadow: 0 -4rem` (eatnaked).
- Fill que sube desde `translateY(104%)` detrás del texto (yucca), o la flecha que sale y vuelve por el otro lado (drinkpouch, keyframe de 0.75 s).
- Enlaces: subrayado que crece con `transform: scaleX()` y `transform-origin`, nunca `text-decoration` animado.
- `:active` a `scale(0.97)`, focus visible con anillo de 2 px y offset, duraciones de 100 a 160 ms con `--ease-house`, hover solo bajo `(hover: hover) and (pointer: fine)`.
- Acordeones, drawers, menús y carruseles: recetas de Emil tal cual. El mega menú con `clip-path inset(0 0 100% 0)` a `inset(0)` más líneas que suben escalonadas (yucca) es compatible con esas reglas si respeta las duraciones de UI.

## Móvil

Dos coreografías, no un responsive degradado: 5 de 7 sitios cambian nodos y comportamiento por contexto, no solo tamaños.

- Se apaga por debajo de 768 px o con `(pointer: coarse)`: pin, scrub largo, scroll horizontal, Lenis, cursor custom, preloader, secuencia de canvas (se queda el poster) y el parallax fuerte.
- Se conserva: reveals por máscara simples (una duración, un stagger), marquees (o pausados), glass convertido en sólido, hover sin efecto.
- Layout: tarjetas glass del hero a barras apiladas (yucca elimina del DOM los nodos `.desktop-only`), scroll horizontal a columna (sylver oculta el track con `display: none`), grid de producto a carrusel a sangre o a una columna.
- Titular con `min(Xrem, Xvh)` para que no desborde en apaisado; márgenes de 24 a 32 px; un CTA fijo abajo solo si la página vende.
- El copy puede cambiar en móvil y es buena práctica declararlo: biologica cambia el copy del hero, drinkpouch añade un titular que en desktop no existe. Decláralo en el brief, no lo improvises.
- Todo esto se implementa con dos contextos de `gsap.matchMedia` más uno de `prefers-reduced-motion` (código en `escenografia.md`).
- Verificación de Fase 5: si hay herramienta de navegador, captura móvil con la página visible y el preloader terminado antes de 3 s; si no la hay, la degradación móvil queda no verificada y se dice así.

## Copy

- Manifiesto en fragmentos cortos (7/7): tríadas cerradas con punto ("Accogliere. Ospitare. Sorprendere.", "One pack. Every formula.", "IV Intent. Daily Format."). Frases de 3 a 7 palabras.
- Sentence case o mayúsculas sostenidas, elegido como sistema y mantenido en toda la página. La marca puede ser verbo (EATnaked).
- Un solo CTA repetido con el mismo texto en toda la página ("Find Your Formula").
- Prueba real solo si el usuario la aporta: credencial, certificación o dato verificable (OB/GYN, MS RDN, ISO). Nunca testimonios, clientes, cifras ni precios inventados. Placeholders etiquetados sí, con la medida y la toma que los sustituirá.
- Microcopy técnico como textura: SKU, `©2026`, medidas, ciudad, "su appuntamento".
- Prohibido: "Elevate", "Seamless", "Unleash", "Next-Gen", "Game-changer", exclamaciones en mensajes de éxito, lorem ipsum, "Acme Corp", cifras redondas tipo 99.99 %.
- Cero em-dash y en-dash en cualquier texto visible, alt y metadatos. Punto, coma o dos puntos. Ninguno de los 7 sitios los usa en titulares.
- No mezcles idiomas por estética: los labels van en inglés solo si la marca habla inglés.

## Qué no se copia

- El logo, el wordmark y la marca gráfica de la referencia.
- El nombre, los claims y el copy literal. Toma el registro, escribe frases nuevas.
- Las fotos, los vídeos y los recortes: son de terceros. Las imágenes de Mobbin y de Cosmos jamás entran en el entregable (ver `referencias-externas.md`).
- Las fuentes con licencia ajena: ni sirvas un woff2 que el usuario no licenció ni declares una comercial que no está en el repo.
- Los componentes calcados: no reproduzcas la misma sección con el mismo orden y las mismas proporciones. Toma el patrón (hero tesis, bandas, tira que sangra) y cambia la composición, el ritmo y el contenido.
- El CSS y el JS de la referencia. Se lee para entender el stack, no se pega.
- En la entrega, nombra las referencias usadas y di qué se tomó de cada una y qué no.

## Checklist X

La Fase 5 recorre esta lista y sustituye el pre-flight de hero de taste.

1. Hero a `100dvh` con media real, titular anclado a un lado, hasta 2 elementos secundarios, un CTA con glifo y header transparente que se rellena al bajar. Con placeholders: ninguna ficha de placeholder se superpone al titular (va fuera de su columna) y cuenta como uno de los 2 elementos secundarios.
2. Cero gradiente decorativo, cero mesh, cero stock genérico. Cada `<video>` con `poster`, `muted`, `loop`, `playsinline` y carga diferida.
3. Un suelo neutro con nombre, sin `#fff` ni `#000` puros, con 0 o 1 acento y grises derivados por alfa del mismo ink.
4. Tema único bloqueado, sin toggle; las bandas oscuras están en la lista de ritmo escrita antes del HTML.
5. Máximo 3 familias con roles declarados en `DESIGN.md`, todas self-hosted con `@font-face` servido (grep de cada `font-family` declarada) y sin familias sin usar.
6. Contraste extremo de escala verificable: existe display y existe label, el rango medio está casi vacío.
7. Dos roles de radio y nada más (`--r-surface` y `--r-control`, declarados en `DESIGN.md`), un solo grosor de hairline, 0 sombras difusas en tarjetas.
8. Hero a `100dvh` y al menos 2 bandas cerca de 80vh, cada una con un mensaje; el resto dimensionado por contenido con `--band-pad`, sin relleno para llegar a una altura; ninguna familia de layout repetida dos veces seguidas; al menos un elemento que sangra por el borde.
9. Labels como sistema (1 de cada 3 secciones, índice, rail o ficha), ningún kicker sobre cada h2, ningún label con color de acento.
10. Marquees: 2 como máximo, con roles distintos, no consecutivos, con máscara en los bordes y quietos bajo `prefers-reduced-motion`.
11. **Glass solo sobre media real**; con placeholders, sólido. Si hay glass: una sola receta, con `@supports not (backdrop-filter)` y sólido por debajo de 768 px.
12. Wordmark o watermark a sangre en el footer: ocupa el 100 % del ancho del contenedor con tolerancia del 2 %, medido en captura. Más 3 columnas con hairlines, disclaimer en nivel `label` y un solo reveal.
13. Una firma y como máximo 2 instrumentos, cada uno con su condición cumplida; ningún instrumento fijo se superpone al contenido a 1280, 1440 y 1920 px; ningún popup al cargar; preloader con timeout y ausente en móvil.
14. Botones: un sistema, glifo, swap o fill, `:active` 0.97, focus visible, hover gateado a `(hover: hover) and (pointer: fine)`.
15. Móvil: pin, scrub, Lenis, cursor y preloader apagados por debajo de 768 px o con `(pointer: coarse)`; tarjetas apiladas; y, si la sesión tiene herramienta de navegador, captura con la página visible antes de 3 s. Sin navegador, este punto queda **no verificado** y se dice así en la entrega.
16. Contraste AA en texto, CTA y formularios, también sobre foto, sobre vídeo y **sobre cada banda oscura, incluido el chrome fijo** (header, índice, barra de progreso): mide cada pieza fija contra la banda más oscura que la va a tener debajo. `prefers-reduced-motion` conserva opacidad y color y quita desplazamiento.
17. Copy: manifiesto corto, un solo CTA, nada inventado, grep de guion largo y guion corto vacío.
18. Entrega: cada placeholder con medidas y toma descrita, cada fuente con su licencia (y aviso explícito si hay un trial de Pangram), y los hallazgos del detector justificados en bloque **contra la tabla "Hallazgos esperados del detector en ruta X"**; cualquier id fuera de esa tabla se corrige, no se justifica.
