# Escenografía: recetas de movimiento (registro inmersivo)

Uso: solo en la ruta **X** (Registro inmersivo); en registro estándar mandan `reglas-rapidas.md` y Emil. Alcance: la **escenografía** (scroll, pin, scrub, reveals de sección, vídeo hero, canvas, transiciones de página). La UI de componentes (botones, menús, drawers, toasts, carruseles) se rige por `animate` y `review-animations` de Emil, con sus umbrales de menos de 300 ms. Son dos capas de movimiento con presupuestos distintos: no mezcles los umbrales.
Evidencia: GSAP + ScrollTrigger en 6/7 sitios, Lenis en 4/7, SplitText cargado en 5/7 y activo en 3/7, barba en 2/7, pin o scrub en 6/7, parallax por atributo en 5/7, marquee en 5/7, secuencia en canvas en 1/7 (eatnaked), scroll horizontal en 1/7 (sylver), Three.js y WebGL en 0/7. Versiones fijadas hoy: `gsap@3.15.0`, `lenis@1.3.26`, `@barba/core@2.10.3`, `three@0.186.0`.

## Setup GSAP + Lenis

Dos formas. Elige una en el brief (línea `Cargaré:`) y no mezcles.

**(a) Sin build: import map con versiones fijadas.** Lo que hacen 6/7 (CSS propio y JS en módulos ES, sin framework).

Una entrada por plugin, **con extensión `.js`**: los import maps no la añaden solos, así que el prefijo `"gsap/"` a secas resuelve a 404 en jsdelivr (verificado: `gsap@3.15.0/index.js` y `gsap@3.15.0/ScrollTrigger.js` dan 200; `gsap@3.15.0/ScrollTrigger` sin extensión da 404).

```html
<script type="importmap">
{ "imports": {
  "gsap": "https://cdn.jsdelivr.net/npm/gsap@3.15.0/index.js",
  "gsap/ScrollTrigger": "https://cdn.jsdelivr.net/npm/gsap@3.15.0/ScrollTrigger.js",
  "gsap/SplitText": "https://cdn.jsdelivr.net/npm/gsap@3.15.0/SplitText.js",
  "gsap/CustomEase": "https://cdn.jsdelivr.net/npm/gsap@3.15.0/CustomEase.js",
  "lenis": "https://cdn.jsdelivr.net/npm/lenis@1.3.26/dist/lenis.mjs"
} }
</script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/lenis@1.3.26/dist/lenis.css">
<script type="module" src="/js/escena.js"></script>
```

Alternativa equivalente y más corta: en esm.sh el prefijo sí resuelve sin extensión, así que basta `"gsap": "https://esm.sh/gsap@3.15.0"`, `"gsap/": "https://esm.sh/gsap@3.15.0/"` y `"lenis": "https://esm.sh/lenis@1.3.26"` (los tres verificados en 200). Elige un CDN y no mezcles. Si la página se publica como Artifact de Claude, solo `cdnjs.cloudflare.com` y `cdn.jsdelivr.net/npm/` pasan la CSP. Sin soporte de import maps (navegadores muy viejos): builds UMD `dist/gsap.min.js`, `dist/ScrollTrigger.min.js`, `dist/SplitText.min.js` y `dist/lenis.min.js`, que exponen globales `gsap`, `ScrollTrigger`, `SplitText`, `Lenis`. Desde 3.13 todos los plugins (ScrollTrigger, SplitText, CustomEase, Flip, Draggable, Observer) vienen en el paquete público: no busques el bundle de Club.

**(b) npm.** `npm i gsap@3.15.0 lenis@1.3.26` (añade `@barba/core@2.10.3` solo si la firma es transiciones de página).

- **Vite** (recomendado): un módulo `js/escena.js` importado desde el entry. **Astro**: el setup en un `<script>` del layout; con ViewTransitions, reengancha en `astro:page-load` y llama `ScrollTrigger.refresh()` ahí.
- **Next**: GSAP y Lenis solo en componentes **cliente hoja** con `'use client'`. Usa `useGSAP` de `@gsap/react` con `{ scope: ref }`, o `useEffect` con `gsap.context()` y `return () => ctx.revert()`. Lenis va una sola vez, en un provider (`ReactLenis` de `lenis/react`), nunca por sección. Sin cleanup, cada navegación deja ScrollTriggers zombi.

**Snippet canónico** (el mismo en las dos formas; es la sincronía que usan 4/7 sitios con Lenis):

```js
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { SplitText } from 'gsap/SplitText';
import Lenis from 'lenis';
import 'lenis/dist/lenis.css';                        // con import map, el <link> de arriba

gsap.registerPlugin(ScrollTrigger, SplitText);
ScrollTrigger.config({ ignoreMobileResize: true });   // evita refresh al colapsar la barra del móvil

export const mm = gsap.matchMedia();                  // interruptor único de todas las firmas
export let lenis = null;

export function initEscena() {                        // punto de entrada del módulo; lo llama el hook de barba
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (!reduce && !lenis) {
    lenis = new Lenis({ autoRaf: false, duration: 1, wheelMultiplier: 0.6 });
    lenis.on('scroll', ScrollTrigger.update);
    gsap.ticker.add((t) => lenis.raf(t * 1000));      // t llega en segundos, lenis.raf espera ms
    gsap.ticker.lagSmoothing(0);
  }
  document.documentElement.classList.add('js-ready'); // habilita los estados iniciales del reveal
  // aquí dentro van la gramática de reveal y el snippet de la Firma
}
initEscena();
```

Todos los snippets de "Gramática de reveal" y "Firmas" viven **dentro de `initEscena()`** y usan el `mm` y el `lenis` de este bloque. Copiados fuera, lanzan `mm is not defined`.

Reglas del setup, todas obligatorias:

- **Un solo rAF.** Con `autoRaf: false` conduce Lenis desde `gsap.ticker`; con `autoRaf: true` (drinkpouch) no añadas `gsap.ticker.add`. Nunca las dos. Y nunca `ScrollTrigger.normalizeScroll(true)` junto a Lenis: se pelean por el evento de rueda.
- **CSS de Lenis.** La regla es **importar el archivo del paquete**: `import 'lenis/dist/lenis.css'` con npm, o el `<link>` a `https://cdn.jsdelivr.net/npm/lenis@1.3.26/dist/lenis.css` con import map (verificado en 200). Sin esto el scroll va a saltos. Solo si lo necesitas inline, estas son las cinco reglas reales del paquete, copiadas tal cual:
  ```css
  html.lenis, html.lenis body { height: auto; }
  .lenis:not(.lenis-autoToggle).lenis-stopped { overflow: clip; }
  .lenis [data-lenis-prevent], .lenis [data-lenis-prevent-wheel],
  .lenis [data-lenis-prevent-touch], .lenis [data-lenis-prevent-vertical],
  .lenis [data-lenis-prevent-horizontal] { overscroll-behavior: contain; }
  .lenis.lenis-smooth iframe { pointer-events: none; }
  .lenis.lenis-autoToggle { transition-property: overflow; transition-duration: 1ms; transition-behavior: allow-discrete; }
  ```
  No inventes reglas que el paquete no trae (`scroll-behavior: auto !important` no está) y no te dejes la de `iframe`: sin ella el scroll se queda pegado dentro de cualquier iframe embebido, y estas páginas suelen llevar vídeo de Vimeo o un mapa.
  Con Lenis activo, **nunca `scroll-behavior: smooth`** en `html` ni en `body`: el suavizado lo hace Lenis y las dos capas se pelean por la escritura de scroll (medido en la prueba de humo: los anclajes del índice se suavizaban dos veces). Los anclajes van por `lenis.scrollTo(destino)`. Esa regla solo es legítima en el brief sin librerías, donde no hay Lenis.
- **`ScrollTrigger.refresh()` tras las fuentes y tras el hero.** Sin esto, los `start` medidos con la fuente de sistema quedan desplazados:
  ```js
  document.fonts.ready.then(() => ScrollTrigger.refresh());
  const media = [...document.querySelectorAll('.hero img')];
  Promise.all(media.map((i) => (i.complete ? 1 : i.decode().catch(() => 1)))).then(() => ScrollTrigger.refresh());
  ```
- **`gsap.matchMedia` como interruptor único.** Todo lo que pina, hace scrub o mueve canvas vive dentro de un contexto; así se destruye solo al cambiar de tamaño o de preferencia:
  ```js
  // usa el `mm` exportado del snippet canónico; no lo vuelvas a declarar aquí
  mm.add('(prefers-reduced-motion: no-preference) and (min-width: 768px)', () => {
    /* pin, scrub, horizontal, canvas */ return () => { /* solo si creaste listeners propios */ };
  });
  ```
  Bajo `(prefers-reduced-motion: reduce)` no instancies Lenis, no pines y no hagas scrub: solo opacidad y color. 5/7 sitios gatean sus firmas con `matchMedia` o equivalente.
- **Menús y drawers.** `data-lenis-prevent` en cada panel con scroll propio (drinkpouch lo pone en submenús, lista de header y drawers; yucca en `.n-submenu`) y `lenis.stop()` al abrir, `lenis.start()` al cerrar (oddritual, eatnaked en el preloader). Si no, el fondo se desplaza detrás del menú.
- **Un solo ease por sitio.** 7/7 usan una curva propia. Declara el token y no improvises otra:
  Estos cuatro son los **valores canónicos** del registro inmersivo: los mismos que cita `inmersivo.md` sección "Ritmo y layout" y los que se escriben en `DESIGN.md` (`motion.ease-house`, `dur-ui`, `dur-reveal`, `stagger`). No hay un segundo juego en ningún otro archivo.
  ```css
  :root { --ease-house: cubic-bezier(0.22, 1, 0.36, 1); --dur-ui: .24s; --dur-reveal: 1.2s; --stagger: .06s; }
  ```
  ```js
  import { CustomEase } from 'gsap/CustomEase';
  gsap.registerPlugin(CustomEase);
  CustomEase.create('house', '0.22,1,0.36,1');   // eatnaked: CustomEase.create('EA-ease','0.6,0.08,0.02,0.99')
  ```
  Escenografía de 1.0 a 1.6 s (yucca 1.4 s en títulos, 1.2 s en párrafos; eatnaked 1.2 s). UI de componentes por debajo de 300 ms. `ease: 'none'` siempre que haya `scrub`.

## Gramática de reveal

Una sola gramática de entrada para toda la página, repetida. No inventes una por sección.

```css
/* el estado inicial lo pone el JS, nunca el CSS estático: si el módulo falla, el texto sigue visible */
html.js-ready [data-reveal] { visibility: hidden; }
```
```js
mm.add('(prefers-reduced-motion: no-preference)', () => {
  document.querySelectorAll('[data-reveal]').forEach((el) => {
    SplitText.create(el, {
      type: 'lines', mask: 'lines', autoSplit: true,    // mask crea el wrapper con overflow clip
      onSplit: (self) => {
        gsap.set(el, { visibility: 'visible' });
        return gsap.from(self.lines, {
          yPercent: 110, duration: 1.2, ease: 'house', stagger: 0.06,
          scrollTrigger: { trigger: el, start: 'top 85%', once: true },
        });
      },
    });
  });
});
mm.add('(prefers-reduced-motion: reduce)', () => {
  gsap.set('[data-reveal]', { autoAlpha: 1, visibility: 'visible' });  // ni split ni desplazamiento
});
```

- `mask: 'lines'` y `autoSplit: true` son de SplitText 3.13. Sin ellos, el patrón manual de yucca: `.line { overflow: clip } .line > .line-inner { transform: translateY(110%) }`, y resplit en `document.fonts.ready`.
- Por palabras cuando el titular es corto (biologica: `type: 'words'`, `.split-text__inner` con `overflow-y: clip`, `translateY(100%)` a 0, stagger 0.05). Por líneas en párrafos. Por caracteres solo para el scrub tipográfico.
- `once: true` siempre: reanimar al volver a pasar es una interfaz peleándose con su lector. `start: 'top 85%'` (yucca usa `'bottom+=20% bottom'`); nunca `'top top'` en un reveal, eso es para pin.
- **CLS y FOUC**: el `visibility: hidden` lo aplica el JS, nunca el CSS estático. El módulo pone `js-ready` en `<html>` antes de dividir y el CSS cuelga de `html.js-ready [data-reveal]`; se revela en `onSplit` (drinkpouch usa `.hero-banner__line { visibility: hidden }`, pero sin la guarda de clase un fallo del módulo deja la página muda). No uses `opacity: 0` ni `visibility: hidden` sin esa guarda, y nunca en el `html`. El contenido debe leerse sin JS.
- Imágenes: `clip-path: inset(0 0 100% 0)` a `inset(0 0 0 0)`, o `scale(1.2)` a `1` (yucca hero 3 s, biologica 1.5 a 1 en 0.8 s). Elige una de las dos para todo el sitio.
- 6/7 revelan **por máscara, no por fade**. Impeccable, en `reference/animate.md`: "A generic fade-and-rise, hover lift, parallax layer, or scroll reveal is not a thesis". El `fade-up` repetido en cada sección es relleno; skanvi no tiene ningún reveal y sigue leyéndose premium (la contención es una opción válida).

## Firmas

Una por sitio, la que declara el brief en la línea `Firma:`. **Nunca dos.** Todas gateadas a desktop salvo que el brief diga lo contrario.

Solo cinco de las subsecciones de abajo son valores declarables de `Firma:` (vídeo hero, scrub tipográfico, scroll horizontal por paneles, secuencia de imágenes en canvas o 3D como "producto atado al scroll", transiciones de página). **Sin assets reales, las únicas Firmas declarables son el scrub tipográfico y las transiciones de página**: las otras tres necesitan material que en esa rama no existe (ver `inmersivo.md` "Hero tesis", viñeta de placeholders). Las demás se posponen hasta que llegue el material y se dice así en el brief y en la entrega. **Pin y sticky scene** y **Parallax** son recursos de apoyo: los usa la firma que los necesite, no se declaran como firma y no consumen el cupo. Dato descriptivo, no permiso: en los 7 sitios se cuentan 1 o 2 momentos de este tipo por página; aquí el techo es 1.

### Vídeo hero

- **Cuándo**: el producto o el espacio se explican mejor en movimiento. Vídeo hero en 3/7: drinkpouch (HLS más mp4 con `mix-blend-mode: multiply` sobre `#97A5B9`), eatnaked (`Hero-Showreel.mp4` con `fetchpriority="high"`) y skanvi (mp4 diferido tras poster webp, saltado con `saveData`). Vídeo en secciones en 5/7, sylver incluido (fondo autoplay en 2 secciones).
- **Coste**: 1 a 3 MB y riesgo directo de LCP. El **poster** carga la dirección de arte: si el poster no se sostiene solo, el vídeo no arregla nada.
- **Snippet** (carga honesta de skanvi: `preload="none"`, inyectado tras `load` en `requestIdleCallback`, saltado con `saveData`):

```html
<div class="hero" style="background-image: url(/media/hero-poster.webp)">
  <h1 data-reveal>…</h1>
</div>
```
```js
const play = () => {
  if (navigator.connection?.saveData || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  const v = document.createElement('video');
  Object.assign(v, { muted: true, loop: true, playsInline: true, autoplay: true, preload: 'auto', src: '/media/hero.mp4' });
  v.setAttribute('poster', '/media/hero-poster.webp');
  v.addEventListener('canplay', () => v.classList.add('is-ready'), { once: true }); // fade por CSS
  document.querySelector('.hero').prepend(v);
  v.play().catch(() => {});
};
addEventListener('load', () => 'requestIdleCallback' in window
  ? requestIdleCallback(play, { timeout: 1600 }) : setTimeout(play, 500));
```

- `mix-blend-mode: multiply` sobre un plano de color de la paleta unifica un vídeo de stock con el sistema (drinkpouch lo hace sobre `#97A5B9`). Es opcional y cuesta una capa de composición: una sola por página.
- **Móvil y reduced motion**: poster fijo (el `if` de arriba ya lo cubre). En móvil, un recorte vertical más corto o solo el poster; nunca el mp4 de desktop.

### Scrub tipográfico

- **Cuándo**: un manifiesto de 20 a 40 palabras que es la tesis de la página. 1/7 (drinkpouch: `chars`, `stagger: 1`, `scrub: true`, `start: 'top bottom-=50%'`).
- **Snippet**: color de alfa bajo a tinta, carácter a carácter, atado al scroll. El CSS de la palabra no es opcional.

```css
[data-scrub-type] .word { display: inline-block; }   /* la palabra es la unidad de salto de línea */
```
```js
const h = document.querySelector('[data-scrub-type]');
const split = SplitText.create(h, { type: 'words,chars' });   // aria: 'auto' por defecto, no lo desactives
gsap.fromTo(split.chars,
  { color: 'var(--ink-55)' },
  { color: 'var(--ink)', ease: 'none', stagger: 1,
    scrollTrigger: { trigger: h, start: 'top bottom-=50%', end: 'bottom center', scrub: true } });
```

- Nunca solo `chars`: sin el nivel `words` el titular rompe a media palabra. SplitText no envuelve palabras y el navegador corta entre cualquier par de caracteres; medido en la prueba de humo a 1485 px, el manifiesto salía partido en "sodi / o, magnesio" y "proporci / ón que". Con `words,chars` la palabra es la unidad de salto y el carácter la de animación.
- El color de partida es un alfa del ink ya declarado, nunca un token nuevo. `--muted` no existe en este registro (ni en el `:root` de arriba ni en `inmersivo.md` sección "Color", que además prohíbe grises nuevos): un `color` inválido at-computed-value hereda el del propio elemento y la firma queda en una rampa imperceptible, o invisible si el elemento ya llevaba `color: var(--ink)`. Falla en silencio, así que la fila "Variables declaradas" de "Verificación" es obligatoria.
- **Coste**: un nodo por carácter. Tope 200 caracteres; por encima, divide por palabras. `color` no lo compone la GPU: con más nodos hay jank.
- **Móvil y reduced motion**: por palabras en móvil, o el texto ya en color final sin ScrollTrigger. Un manifiesto que solo se lee scrolleando es hostil en pantalla pequeña.

### Pin y sticky scene

- **Cuándo**: una idea con 2 a 4 pasos que necesitan el mismo encuadre. Pin o solapamiento en 6/7 (drinkpouch sección de 100dvh con `pin: true`, `scrub: true`, `anticipatePin: 1` y rail `001` a `002`; eatnaked hero con `pinSpacing: false` para que la siguiente sección se le monte encima).

```js
mm.add('(prefers-reduced-motion: no-preference) and (min-width: 768px)', () => {
  const tl = gsap.timeline({ scrollTrigger: {
    trigger: '.scene', start: 'top top', end: '+=200%',
    pin: true, pinSpacing: true, anticipatePin: 1, scrub: 1, invalidateOnRefresh: true } });
  tl.to('.scene__step-1', { autoAlpha: 0, yPercent: -20, ease: 'none' })
    .to('.scene__rail',   { scaleY: 1, ease: 'none' }, 0)
    .from('.scene__step-2', { autoAlpha: 0, yPercent: 20, ease: 'none' }, 0.4);
});
```

- `start: 'top top'` (no `'top center'`, no `'top 80%'`: el fallo clásico es que la escena arranca a media pantalla). `pinSpacing: false` solo si buscas el solapamiento; entonces la sección siguiente necesita fondo propio y `z-index`.
- **Coste**: el pin-spacer altera el layout. Comprueba que no aparezca una segunda barra de scroll ni un salto al refrescar.
- **Móvil y reduced motion**: sin pin. La misma escena en bandas apiladas, cada paso con su reveal; fuera del `matchMedia` los tres pasos se ven estáticos.

### Scroll horizontal por paneles

- **Cuándo**: una serie que se lee en orden y cabe en 3 a 5 paneles (catálogo, proceso). 1/7 (sylver: 400vh de recorrido para 400vw de pista, con elementos a caballo entre paneles, solo desde 1025 px).
- **Snippet** (skeleton de taste §5.B sin React; sylver usa la misma forma con `xPercent`):

```js
mm.add('(min-width: 1025px) and (prefers-reduced-motion: no-preference)', () => {
  const wrap = document.querySelector('.pan');
  const track = wrap.querySelector('.pan__track');
  const distance = () => track.scrollWidth - window.innerWidth;
  gsap.to(track, { x: () => -distance(), ease: 'none',
    scrollTrigger: { trigger: wrap, start: 'top top', end: () => '+=' + distance(),
      pin: true, scrub: 1, invalidateOnRefresh: true } });
});
```

- Críticos: `start: 'top top'`, se pina el **wrapper** y se mueve la **pista** interior, `end` igual a la distancia horizontal, `invalidateOnRefresh: true` para recalcular al redimensionar.
- **Coste**: secuestra el scroll. Observado en sylver: los eventos de rueda sintéticos no mueven la página, así que tu propia automatización de navegador solo avanzará con `scrollTo`. Deja anclas o botones de panel para teclado; un `:focus` dentro de la pista no debe empujar el layout (`overflow: clip` en el wrapper).
- **Móvil y reduced motion**: `.pan__track { flex-direction: column }` y fuera el pin (sylver oculta la pista y apila). En reduced motion, la misma columna vertical.

### Parallax

- **Cuándo**: dar profundidad a una **foto o vídeo real** a sangre sin pedir atención. 5/7 por atributo declarativo (yucca `data-parallax-speed` 20 en hero y 10 en el resto; biologica `data-image-parallax`; oddritual `[img-scroll]` yPercent 0 a 20). Con la media todavía en placeholder no crees el tween ni el `will-change`: un `inner` vacío sobre color plano no mueve nada perceptible y solo cuesta composición. Se anota como pendiente junto al hueco de media y se activa cuando llegue el material.

```css
.media { overflow: clip; }
.media__inner { height: calc(100% + 2 * var(--speed) * 1%); will-change: transform; }
```
```js
document.querySelectorAll('[data-parallax]').forEach((el) => {
  const speed = Number(el.dataset.parallax) || 10;
  el.style.setProperty('--speed', speed);
  gsap.fromTo(el.querySelector('.media__inner'),
    { yPercent: -speed }, { yPercent: speed, ease: 'none',
      scrollTrigger: { trigger: el, start: 'top bottom', end: 'bottom top', scrub: 0.5 } });
});
```

- **Coste**: bajo, es `transform` puro. El error típico es no sobredimensionar el `inner` y dejar ver el borde.
- **Móvil y reduced motion**: en móvil se conserva con `speed` a la mitad; bajo reduced motion no crees el tween y la imagen queda centrada.

### Secuencia de imágenes en canvas

- **Cuándo**: un producto que debe girar o abrirse y no hay presupuesto de 3D. 1/7 (eatnaked: 201 frames AVIF más 40 WebP, buffer a DPR, versiones landscape y portrait).

```js
const N = 96, canvas = document.querySelector('.seq'), ctx = canvas.getContext('2d', { alpha: false });
const imgs = new Array(N), state = { i: 0 };
const load = async (from, to) => {                        // por lotes, no las 96 de golpe
  for (let i = from; i < Math.min(to, N); i++) {
    const img = new Image(); img.src = `/seq/${String(i + 1).padStart(4, '0')}.avif`;
    await img.decode().catch(() => {}); imgs[i] = img;
  }
};
const draw = () => { const img = imgs[Math.round(state.i)]; if (img) ctx.drawImage(img, 0, 0, canvas.width, canvas.height); };
const fit = () => { const d = Math.min(devicePixelRatio, 2);
  canvas.width = canvas.clientWidth * d; canvas.height = canvas.clientHeight * d; draw(); };

load(0, 12).then(() => {              // los 12 primeros frames antes de dibujar; el resto en segundo plano
  fit(); load(12, N);                 // sin `await` suelto: `initEscena()` no es async (ver Setup GSAP + Lenis)
  mm.add('(prefers-reduced-motion: no-preference) and (min-width: 768px)', () => {
    gsap.to(state, { i: N - 1, ease: 'none', snap: 'i', onUpdate: draw,
      scrollTrigger: { trigger: '.seq-scene', start: 'top top', end: '+=300%', pin: true, scrub: 1.05 } });
    addEventListener('resize', fit);
    return () => removeEventListener('resize', fit);
  });
});
```

- **Coste**: el más alto del repertorio. Presupuesto: 60 a 120 frames, AVIF de 20 a 40 KB, total por debajo de 4 MB. Fallo real observado: el móvil de eatnaked se queda de 15 a 25 s en el preloader esperando 241 frames. Nunca pongas la secuencia detrás de un preloader bloqueante en móvil.
- **Móvil y reduced motion**: un frame estático (el mejor de la serie) como imagen, o una secuencia aparte con menos frames; en reduced motion, el frame central dibujado una vez y sin ScrollTrigger.

### Transiciones de página

- **Cuándo**: sitio multipágina sin framework donde la continuidad es parte del tono. 2/7 (oddritual: barba `sync: true` con clip-path; yucca: barba 2.10.3 `sync: true`, `timeout: 7000`, excluye `/cart` y `/checkout`). Opcional: antes de barba, valora la **View Transitions API** en mismo documento (0/7 la usan, pero es gratis y degrada sola) o las transiciones nativas de Astro.

```js
import barba from '@barba/core';
history.scrollRestoration = 'manual';

barba.init({
  sync: true, timeout: 7000,
  prevent: ({ href }) => /\/(cart|checkout)/.test(href),
  transitions: [{ name: 'wipe',
    leave: ({ current }) => gsap.to(current.container, { autoAlpha: 0.4, yPercent: 5, duration: 0.6, ease: 'house' }),
    enter: ({ next }) => gsap.fromTo(next.container,
      { clipPath: 'inset(100% 0 0 0)' }, { clipPath: 'inset(0% 0 0 0)', duration: 1, ease: 'house' }) }],
});

barba.hooks.beforeLeave(() => ScrollTrigger.getAll().forEach((st) => st.kill()));
barba.hooks.after(() => { lenis?.scrollTo(0, { immediate: true }); initEscena(); ScrollTrigger.refresh(); });
```

- Obligatorio: matar los ScrollTriggers de la página que sale, reinicializar la escena de la que entra, resetear el scroll y refrescar. Sin eso, la segunda navegación deja triggers colgados y los `start` desplazados.
- **Coste**: pasas a ser dueño del routing. Los enlaces deben seguir siendo `<a href>` reales y funcionar sin JS; excluye carrito, checkout y cualquier ruta con estado de servidor.
- **Móvil y reduced motion**: en móvil se conserva (es opacidad y clip-path) con la duración a 0.6 s; bajo reduced motion, `barba.init` sin `transitions` propias o un crossfade de 0.2 s.

### 3D y WebGL

Árbol de decisión, en este orden. Baja un peldaño solo cuando el de arriba no pueda expresar la idea:

1. **CSS 3D y clip-path** (Emil): `rotateX/rotateY` con `transform-style: preserve-3d`, `perspective`, recortes PNG con alfa y `translateZ` para profundidad (3/7 lo hacen así). Coste cero.
2. **Canvas 2D**: secuencia de imágenes (receta anterior) o dibujo propio. Es lo que usa el único sitio con sensación de 3D real.
3. **Three.js / WebGL**: solo si el brief pide partículas, shader, modelo o distorsión. **0 de los 7 sitios lo usan**: el nivel se consigue con foto, vídeo y canvas 2D. Un hero WebGL mal hecho penaliza más en Core Web Vitals de lo que aporta.
4. **WebGPU con TSL**: solo si el brief lo pide por nombre, siempre con fallback a WebGL2.

```html
<script type="importmap">
{ "imports": {
  "three": "https://cdn.jsdelivr.net/npm/three@0.186.0/build/three.module.js",
  "three/addons/": "https://cdn.jsdelivr.net/npm/three@0.186.0/examples/jsm/"
} }
</script>
```

Documentación consumible por URL (la web usa rutas con hash, estas no): `https://threejs.org/docs/llms.txt` (índice corto, cárgalo primero) · `https://threejs.org/docs/pages/<Class>.html` · `https://threejs.org/manual/pages/<slug>.html` · índice de ejemplos en `https://threejs.org/examples/files.json`.

Reglas no negociables: `import()` diferido después del LCP · `renderer.setPixelRatio(Math.min(devicePixelRatio, 2))` · render on demand o pausa con `IntersectionObserver` cuando el canvas sale del viewport · `dispose()` de geometrías, materiales, texturas y renderer al desmontar · fallback a imagen si `canvas.getContext('webgl2')` es nulo o hay `prefers-reduced-motion: reduce` · versión fijada (releases mensuales con cambios rompientes) · los assets de `examples/` tienen licencias mixtas (DamagedHelmet es CC BY-NC): no los embarques en un proyecto de cliente.

## Rendimiento y accesibilidad

- Anima solo `transform` y `opacity`. `color`, `clip-path` y `backdrop-filter` se permiten como material de una firma, en una sola capa acotada. Nunca `width`, `height`, `top`, `left` ni margins.
- `will-change: transform` solo en el elemento que se mueve y mientras se mueve. Retíralo al terminar (`onComplete: () => el.style.willChange = ''`). Tres declaraciones por página es mucho.
- Imágenes con `srcset` y `sizes`, `aspect-ratio` en CSS para reservar el hueco, AVIF o WebP, `loading="lazy"` fuera del hero y `fetchpriority="high"` en la del hero. Fuentes self-hosted en woff2 con `font-display: swap` y `<link rel="preload" as="font" crossorigin>` solo para la display; nada de `<link>` a Google Fonts en este registro.
- CLS por SplitText: el texto a dividir va con `visibility: hidden` puesto por el JS (`html.js-ready [data-reveal]`, nunca en CSS estático) y se revela en `onSplit`; resplit tras `document.fonts.ready`; después, `ScrollTrigger.refresh()`.
- `prefers-reduced-motion: reduce` conserva opacidad, color y cambios de estado; quita desplazamiento, pin, scrub, parallax, Lenis y autoplay de vídeo. Reducido no es apagado: el feedback de una acción sigue siendo visible.
- Hover solo bajo `@media (hover: hover) and (pointer: fine)`. `:focus-visible` con un anillo real en todo lo interactivo, incluido lo que vive dentro de una escena pinada. Skip-link al contenido.
- Cualquier bucle (marquee, canvas, vídeo) se pausa fuera del viewport o con la pestaña oculta. **La página se lee sin JS**: si el módulo falla, el contenido sigue en el DOM y visible. Ningún estado inicial esconde texto de forma permanente.

## Verificación

Bloque de greps para la Fase 5, sobre los archivos tocados. Muestra la salida real.

| Qué se comprueba | Comando | Espera |
|---|---|---|
| Lenis sincronizado con ScrollTrigger | `grep -nE "lenis\.on\(.scroll., ?ScrollTrigger\.update" <js>` | al menos 1 si hay Lenis |
| Un solo rAF y sin suavizado de lag | `grep -nE "gsap\.ticker\.(add|lagSmoothing)|autoRaf" <js>` | `lagSmoothing(0)` presente y `autoRaf` coherente |
| Interruptor de movimiento | `grep -nE "matchMedia|prefers-reduced-motion" <js> <css>` | al menos 1, y envolviendo pin, scrub y Lenis |
| Refresh tras fuentes | `grep -nE "fonts\.ready" <js>` y `grep -n "ScrollTrigger.refresh" <js>` | ambos presentes |
| Vídeo honesto | `grep -nE "<video[^>]*" <html>` | `muted`, `playsinline`, `poster`, `preload` en todos. Si la Firma no es vídeo y la salida es 0, la fila se declara **no aplicable**, nunca pasada |
| `will-change` acotado | `grep -c "will-change" <css>` | 3 o menos, y sobre elementos animados |
| Cupo de marquees | `grep -cE 'class="marquee__track"' <html>` | exactamente el número de pistas declaradas en el brief (1 o 2). El cupo de roles distintos y la no consecutividad **solo** los verifica la lectura humana: ni el grep ni el detector los cuentan (las 2 pistas comparten clase y animación, así que el detector produce un único hallazgo `marquee`). No cuentes `marquee__item` ni `marquee__group`: un patrón `class="[^"]*marquee` devuelve 30 con 2 pistas |
| Variables declaradas | `grep -oE 'var\(--[a-z0-9-]+\)' <js>` y `grep -nE '^[[:space:]]*--[a-z0-9-]+:' <css>` | cero variables usadas por el JS que no estén en el `:root` del CSS. Compara las dos listas a mano: `sort` y `uniq` no están en `allowed-tools` |
| Suavizado duplicado | `grep -n 'scroll-behavior: *smooth' <css>` | vacío si hay Lenis (pelea con su escritura de scroll); presente solo en el brief sin librerías |
| Glass con guarda | `grep -n -B2 "backdrop-filter" <css>` | dentro de un `@supports`, solo sobre media real. Con la media todavía en placeholder la fila espera **vacío**: el glass va sólido |
| Prohibidos de UI | `grep -nE "transition:\s*all|scale\(0\)|[^-]ease-in\b" <css> <js>` | vacío |
| Listener de scroll a mano | `grep -n "addEventListener('scroll'" <js>` | vacío (usa ScrollTrigger, IntersectionObserver o scroll-driven CSS) |
| Guiones largos y cortos | `grep -nE $'\xe2\x80\x94|\xe2\x80\x93' <archivos tocados>` (el mismo de la Fase 5 de `SKILL.md`) | vacío |

Además: una captura desktop y una móvil, y verifica a mano que en móvil no queda pin ni scrub activo salvo que la firma lo pida por escrito.

**División de responsabilidades.** `review-animations` de Emil revisa **componentes** (botones, menús, drawers, toasts, carruseles) con sus umbrales de menos de 300 ms, `ease-out`, `scale(0.97)` en `:active` e interrumpibilidad. Esta tabla revisa la **escenografía** (Lenis, pin, scrub, reveals de 1.0 a 1.6 s, vídeo, canvas, transiciones de página). No pases la escenografía por `review-animations`: bloquearía por duración una decisión que el brief autorizó.
