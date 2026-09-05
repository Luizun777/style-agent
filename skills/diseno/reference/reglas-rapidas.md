# Reglas rápidas anti "look de IA"

Uso: modo rápido (ruta R) y modo degradado cuando falte un paquete. Una regla por línea. Si el brief pide lo contrario, el brief gana.
Fuentes: taste-skill (0.D, 4.x, 9.G, 14), redesign-existing-projects (Fix Priority), Impeccable (craft-floor, detector) y Emil Kowalski (review-animations).

## No hagas por defecto (los "tells" de diseño IA)
- Gradiente morado a azul, glow morado, mesh oscuro tras un hero centrado.
- Tres tarjetas iguales (icono + título + texto) como estructura de página; tarjetas dentro de tarjetas.
- Inter para todo; tampoco Roboto, Open Sans, Lato, Montserrat, Geist, Mona Sans, Space Grotesk, Plus Jakarta, Fraunces, Instrument Sans o Serif, Recoleta (el detector las marca); serif "porque se ve creativo".
- Eyebrow o kicker en mayúsculas sobre cada título; numeración de secciones (01 / 02 / 03).
- Texto con gradiente; glass o blur como decoración; `border-left` de color mayor a 1 px en tarjetas y alertas.
- Sombras negras puras; sombra offset dura (`4px 4px 0`) fuera de un mundo neobrutalista.
- Puntos pulsantes, dots decorativos, chips de estado por todos lados.
- Emojis o glifos unicode como iconos; lucide por defecto; cohete = "lanzar", escudo = "seguridad".
- Copy: "Elevate", "Seamless", "Unleash", "Next-Gen", "Game-changer", "Oops!", exclamaciones en mensajes de éxito, lorem ipsum, "Acme Corp", "John Doe", cifras redondas (99.99 %).
- Em-dash (—) y en-dash (–) en cualquier texto visible. Cero. Usa punto, coma o dos puntos.
- `h-screen` o `height: 100vh` (usa `min-h-[100dvh]`); `transition: all`; `scale(0)`; `ease-in` en UI; `window.addEventListener('scroll')`.

## Haz siempre
- Declara en una línea la lectura: "<tipo> para <audiencia>, lenguaje <vibra>, apoyado en <sistema>".
- Un solo acento (saturación menor a 80 %) sobre neutros de una sola familia (cálidos o fríos, no ambos). El mismo acento en toda la página.
- Un solo sistema de radios (todo recto, todo suave o todo pill) y un solo grosor de icono.
- Fuente con carácter: Satoshi, Cabinet Grotesk, General Sans, Manrope, o la de marca. Display con tracking negativo y line-height ajustado; cuerpo de 65 a 75 caracteres; pesos 500 y 600 para la jerarquía.
- Jerarquía por peso y tamaño, no por color ni gradiente. Más espacio arriba de un título que abajo.
- El hero cabe en el viewport: titular de 2 líneas máximo, subtexto de 20 palabras máximo, CTA visible sin scroll, padding superior máximo 6 rem, 4 elementos de texto máximo.
- Layout con variación: split 50/50, asimetría, zig-zag; nunca dos secciones seguidas con la misma familia de layout. Grid, no matemáticas de flex.
- Estados completos: hover, focus visible, `:active` (scale 0.97 o translateY 1px), disabled, loading (skeleton, no spinner), vacío, error inline.
- Contraste AA: texto 4.5:1, texto grande 3:1, CTA y formularios incluidos. Ningún CTA parte en 2 líneas. Un solo label por intención de CTA.
- Contenido real o placeholder etiquetado; nunca testimonios, clientes, cifras ni precios inventados.
- Semántica: `nav`, `main`, `section`, `article`; alt en imágenes; skip-link; z-index con escala.
- Tema de página bloqueado: una sola sección oscura suelta en una página clara es un error.

## Movimiento (Emil Kowalski)
- ¿Debe animarse? Acciones de más de 100 veces al día o por teclado: no. Ocasionales: sí. Raras: puede haber deleite.
- Cada animación responde "¿por qué?": continuidad espacial, estado, feedback, explicación o evitar un salto.
- Entra con ease-out (curva custom, no la de CSS), se mueve con ease-in-out, hover con ease. `ease-in` en UI está prohibido.
- Menos de 300 ms en UI: botones 100 a 160, dropdowns 150 a 250, modales 200 a 500.
- Solo `transform` y `opacity`. Popovers escalan desde su trigger (`transform-origin`); nunca desde `scale(0)`, sí desde 0.95 más opacity.
- Transiciones (interrumpibles) antes que keyframes. Springs solo para gestos y drag.
- Presiones y holds lentos, respuestas del sistema rápidas (asimetría).
- `prefers-reduced-motion`: conserva opacidad y color, quita desplazamiento. Hover solo bajo `@media (hover: hover) and (pointer: fine)`.
- Un solo momento de movimiento autoral por página, no la misma entrada en cada sección. Ante la duda, borra la animación.

## Orden de arreglo en un rediseño (mayor impacto, menor riesgo)
1. Fuente. 2. Paleta (un acento, neutros coherentes). 3. Hover y active. 4. Layout y espaciado (grid, max-width, padding consistente). 5. Componentes cliché por alternativas. 6. Estados loading, vacío y error. 7. Escala tipográfica final.
- Trabaja con el stack existente; no migres; revisa `package.json` antes de importar; cambios pequeños y revisables.

## Antes de entregar
- Detector de Impeccable en 0 o cada hallazgo justificado; grep de `—|–` vacío; build verde; capturas desktop y móvil si hay navegador.
