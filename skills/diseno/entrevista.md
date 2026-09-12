# Entrevista de /diseno

Objetivo: reunir en 1 o 2 rondas lo que cambia el resultado, y nada más. Pregunta con el rol
"preguntar al usuario con opciones" de la Fase 0b de `SKILL.md` (en Claude Code, `AskUserQuestion`):
máximo 4 preguntas por llamada, 2 a 4 opciones cada una, header de 12 caracteres o menos, y siempre
una salida de texto libre. En Claude Code la opción "Other" ya viene incluida, no la agregues a mano;
si el agente no tiene esa herramienta, escribe las preguntas en el mensaje con las opciones numeradas
(el mismo tope de 4), di que también vale responder con texto libre, y espera la respuesta antes de seguir.

## Reglas de salto

- **Prompt preciso** (nombra superficie + archivo o ruta + objetivo + "conservar"/"cambiar el look" o una vibra):
  salta las Rondas 1 y 2, pasa por la Fase 2b (sistema del proyecto) y ve a la confirmación del brief (Fase 3).
  En `rediseña` sin decir conservar o cambiar, se asume "Conservar y pulir" y se marca como SUPUESTO.
- **Prompt escueto** ("rediseña el login", "hazme una landing"): Ronda 1 obligatoria, con respuesta real.
- **Con referencias** (URLs, capturas o imágenes en el prompt): la pregunta "Referencias" ya está contestada;
  la vibra y los diales salen de la Lectura de referencia (ruta G). Pregunta solo si las referencias se contradicen.
- **Ronda 2** solo si una respuesta dejó un hueco material (p. ej. "Cambiar el look" sin vibra ni referencias,
  o "No sé, propón").
- **Modo rápido** (ajuste puntual de una propiedad o un componente): sin entrevista.
- **Registro inmersivo** (se decide en la Fase 1, paso 6): la Ronda 1 añade `Firma` y `Assets`, y en `Stack` la opción inmersiva es la que ofreces como "Recomienda tú". Si el usuario elige la vibra "Confiable y formal", el registro vuelve a estándar aunque el argumento pidiera algo cinematográfico.
- Nunca preguntes valores CSS, hex, fuentes ni píxeles. Nunca repitas lo que ya dicen `PRODUCT.md`,
  `DESIGN.md` o los argumentos. Afirma la lectura más probable e invita a corregir.
- Tope habitual: Ronda 1 + Ronda 2 (solo si hace falta) + Confirmar. La primera vez en un proyecto se suman la Ronda Sistema (o las preguntas de `impeccable document` al extraer el sistema del código) y la ronda de `impeccable init` para crear `PRODUCT.md`. Con referencias incompletas o contradictorias, una pregunta más (`Referencia`). Después de eso, ninguna pantalla vuelve a preguntar lo ya guardado.
- Adapta las opciones a lo que ya sabes: nombra el producto, el flujo y los archivos reales. Las opciones
  de abajo son el respaldo cuando no sabes nada.

## Ronda 1 · propósito, personas y alcance (elige 2 o 3)

En registro inmersivo la Ronda 1 se llena en este orden de prioridad, hasta 4 preguntas en una sola llamada: `Assets` (sin material real nada más importa), `Firma`, `Stack` (solo si el proyecto está vacío) y `Vibra` (solo si no está ya decidida por el argumento o por las referencias). `Superficie`, `Personas` y `Lo único` se deducen o pasan a la Ronda 2.

**Superficie** · "¿Qué debe conseguir la persona que llega a esta pantalla?"
- Decidir y actuar (landing, marketing, precios) → modo **Persuade**
- Completar una tarea (login, formulario, panel, ajustes) → modo **Operate**
- Entender algo (docs, artículo, ayuda) → modo **Read**
- Ver la obra (portafolio, galería) → modo **Experience**

**Personas** · "¿Quién llega y en qué situación?"
- Cliente nuevo que no nos conoce
- Usuario que ya lo usa a diario
- Comprador técnico o empresa
- Reclutador o cliente potencial

**Alcance** (solo rediseño) · "¿Conservamos la identidad actual o cambiamos el look?"
- Conservar y pulir: misma marca; arreglar jerarquía, espaciado y estados → ruta **B**
- Cambiar el look: nueva dirección visual; se mantienen contenido, rutas y funciones → ruta **E** (marketing) o **D** (app)
- No sé, propón: primero `impeccable critique`, luego una pregunta más

**Stack** (obligatoria si `PACKAGE_JSON=no` y `UI_CODE=no`) · "¿Con qué lo construimos?"
- HTML, CSS y JS estáticos, sin build
- Sitio editorial con animación: HTML, CSS y JS + GSAP + Lenis (Vite o import map, sin framework)
- Un framework concreto (dilo vía Other: Next, Astro, Vite + React, Vue, Svelte…)
- Recomienda tú y dime cuál

En registro inmersivo, "Recomienda tú" resuelve a la opción editorial con GSAP y Lenis: es lo que hacen 6 de los 7 sitios de referencia (CSS propio y JS vanilla; el único React, skanvi, es el menos animado). En registro estándar resuelve a "HTML, CSS y JS estáticos".

**Vibra** (pantalla nueva sin referencias; también en rediseño cuando Alcance = "Cambiar el look" o cuando no hay `DESIGN.md`, para dar adjetivos a `impeccable document`) · "¿Qué sensación debe transmitir?"
- Sobria y clara (Linear, Notion) → diales 5-6 / 3-4 / 2-3
- Premium y elegante (Apple, lujo) → 7-8 / 5-7 / 3-4
- Inmersiva y cinematográfica (marcas de consumo premium, Awwwards) → 8-9 / 8-9 / 2-3 y registro **inmersivo**
- Atrevida y creativa (agencia, Awwwards) → 9-10 / 8-10 / 3-4
- Confiable y formal (banca, salud, sector público) → 3-4 / 2-3 / 4-5

Son 5 casos y en una llamada solo caben 4 opciones: elige las 4 que apliquen. Descarta "Confiable y formal" salvo sector regulado o accesibilidad crítica, y descarta "Inmersiva y cinematográfica" si la superficie es app o si no hay producto ni marca que se pueda fotografiar. "Inmersiva y cinematográfica" es composición disciplinada con movimiento alto; "Atrevida y creativa" es variación alta y desorden buscado: no son la misma cosa.

**Firma** (solo registro inmersivo; una sola por página) · "¿Cuál es el momento que va a recordar quien visite la página?"
- Vídeo macro en el hero: el producto en movimiento ocupa la primera pantalla
- El producto atado al scroll: render 3D o secuencia de imágenes que gira al bajar
- Tipografía cinemática: scrub tipográfico, o scroll horizontal por paneles si la página es una secuencia de capítulos
- Elige tú una sola y dime cuál

Son 6 firmas posibles y solo caben 4 opciones, así que van agrupadas. Los seis valores declarables de la línea `Firma:` son exactamente estos y no hay más: vídeo macro en hero, producto 3D o secuencia atada al scroll, scrub tipográfico, scroll horizontal por paneles, transiciones de página, ninguna. El pin o la escena sticky no son una firma declarable: son el recurso con el que se construyen la segunda y la cuarta (`escenografia.md` sección "Firmas"). Si el sitio tiene más de una página y el usuario ya pidió continuidad al navegar, sustituye la tercera opción por "Transiciones de página: la salida de una se encadena con la entrada de la siguiente". Nunca ofrezcas dos firmas ni aceptes dos: la respuesta va a la línea `Firma:` del brief y todo lo demás se declara "ninguna". La firma 3D solo se ofrece si el usuario tiene el modelo o los renders; si no, se convierte en secuencia de imágenes.

**Assets** (solo registro inmersivo) · "¿Qué material real tenemos para el hero y las bandas?"
- Tengo fotos o vídeo (dime la ruta o la carpeta vía Other)
- Placeholders con medidas y la toma descrita, los sustituyo yo después
- Genera plates provisionales (solo si esta sesión tiene una herramienta de generación de imagen en `allowed-tools`)

La tercera opción solo se ofrece si la sesión tiene de verdad una herramienta de imagen en `allowed-tools`. Si no la tiene, no la muestres; y si el usuario la pide vía Other, dilo en una línea y cae en la opción de placeholders etiquetados con medidas y toma descrita. Sin material real la receta degrada a texto sobre fondo plano y no alcanza el nivel: dilo con esa letra en el brief. Los 7 sitios de referencia usan foto de estudio, vídeo o render propio en 7/7, así que este dato cambia el resultado más que cualquier dial.

**Lo único** · "¿Qué es verdad aquí que una plantilla genérica o un competidor no podría decir?"
- Sin diferenciador claro
- Ya está en el README o PRODUCT.md
- (texto libre vía Other)

## Ronda 2 · dirección y límites (solo huecos materiales, 1 a 3)

**Referencias** (salta si ya las dio) · "¿Referencias que te gusten (URLs, productos, capturas)?"
- No, decide tú
- Las que ya usa el proyecto
- (URLs, nombres de productos o la ruta de una captura vía Other; el usuario puede arrastrar el archivo a la terminal para insertar la ruta, o pegar la imagen en el chat)

**Intocable** (multiSelect) · "¿Qué NO debemos tocar?"
- Textos y copy
- Rutas, URLs y nombres de campos
- Colores y logo de marca
- Nada, libertad total

**Movimiento** (salta en Operate: mínima por defecto) · "¿Cuánta animación?"
- Mínima, solo feedback → MOTION 2-3
- Moderada, entradas y hover → MOTION 5-6
- Cinemática, scroll y parallax → MOTION 8-9

Esta última respuesta pone `MOTION_INTENSITY` en 8 o 9 y con eso activa el registro inmersivo en marketing (Fase 1, paso 6), salvo que la Vibra sea "Atrevida y creativa": esa combinación se queda en la ruta C, porque su variación alta no es composición disciplinada. Si activa el registro, pregunta `Firma` y `Assets` antes del brief, aunque la Ronda 1 ya haya pasado.

**Variantes** · "¿Quieres ver 3 direcciones distintas antes de construir?"
- No, una buena y directa
- Sí, 3 variantes con selector → ruta **F** (avisa que tarda más)

## Ronda Sistema · estandarizar el proyecto

Cuándo: no existe `DESIGN.md` y no hay código de UI (proyecto desde cero), o el usuario eligió "Cambiar el look" y las
referencias no fijan tokens. Una sola llamada, hasta 4 preguntas. Las respuestas se guardan en `DESIGN.md` (y como Brand
Commitments en `PRODUCT.md`) para que las siguientes pantallas las hereden sin volver a preguntar. Si existe código de UI,
no hay `DESIGN.md` y se conserva el look, no preguntes esto: extrae el sistema con `impeccable document` y confírmalo.
En "Cambiar el look" añade a cada pregunta la opción "Mantener la actual" y, si el usuario responde "propón tú", márcalo
como SUPUESTO en el brief. En ruta S sin vibra conocida, "elige tú" significa: suaves (8 a 12 px) y modo claro.

**Tipografía** · "¿Tienen una fuente de marca?"
- Sí, te digo cuál (vía Other: nombre o archivo)
- No: elige una sans con carácter (Satoshi, Cabinet Grotesk, General Sans)
- No: algo editorial, serif en titulares y sans en cuerpo
- No: neutra y segura para una app de trabajo

En registro inmersivo, la pareja serif y sans con roles es la opción por defecto (4 de los 7 sitios de referencia la usan) y la fuente se elige del pool con licencia de `reference/inmersivo.md` sección "Tipografía y pool de fuentes", siempre servida en woff2 desde el proyecto. Si el usuario tiene licencia de una comercial, dilo aquí vía Other y gana.

**Paleta** · "¿Colores de marca?"
- Sí, te paso los hex o el logo (vía Other)
- No: neutros fríos (zinc, slate) + un acento que elijas según la vibra
- No: neutros cálidos (stone) + un acento que elijas
- No: monocromo con un solo color vivo

**Forma** · "¿Qué forma tienen los componentes?"
- Rectos (radio 0)
- Suaves (8 a 12 px en todo)
- Pill en botones, suaves en tarjetas e inputs
- Elige tú según la vibra

La respuesta se guarda como **dos roles de radio**: controles (botones y chips) y superficies (tarjetas, inputs, plates). Las dos primeras opciones dan el mismo valor a los dos roles; la tercera los separa. Nunca un tercer valor. En registro inmersivo esos roles se escriben `--r-control` y `--r-surface` (`reference/inmersivo.md` sección "Ritmo y layout").

**Modo** · "¿Modo claro, oscuro o ambos?"
- Claro
- Oscuro
- Ambos, con detección automática
- Elige tú según el uso (app de trabajo = claro; consumo nocturno = oscuro)

En registro inmersivo no ofrezcas "Ambos": el tema es único (suelo claro cálido en 5 de los 7 sitios, oscuro en 2) y las bandas alternas viven dentro de ese tema.

Iconos: no se pregunta; usa los del proyecto o Phosphor por defecto, un solo grosor. Regístralo en `DESIGN.md`.

## Confirmación (Fase 3, una sola pregunta)

Header `Confirmar` · "¿Avanzamos con este brief?"
- Sí, adelante
- Más sobrio (baja los diales 2 puntos)
- Más atrevido (sube los diales 2 puntos)
- (cambios concretos vía Other)

## Derivación de diales (DESIGN_VARIANCE / MOTION_INTENSITY / VISUAL_DENSITY)

| Señal | VARIANCE | MOTION | DENSITY |
|---|---|---|---|
| Sobria y clara | 5-6 | 3-4 | 2-3 |
| Premium y elegante | 7-8 | 5-7 | 3-4 |
| Inmersiva y cinematográfica (registro inmersivo) | 8-9 | 8-9 | 2-3 |
| Atrevida y creativa | 9-10 | 8-10 | 3-4 |
| Confiable y formal / regulado / accesibilidad crítica | 3-4 | 2-3 | 4-5 (y sobrescribe cualquier estética, incluido el registro inmersivo: vuelve a estándar) |
| Rediseño conservando | igual al existente (estímalo desde la Lectura previa: una frase → diales) | existente +1 | igual |
| Rediseño cambiando el look | +2 | +2 | igual |
| Con referencias | según la Lectura de referencia | según la referencia | según la referencia |
| Pantalla Operate (app) | se ignora | ≤ 3 salvo petición | según datos |

La respuesta de "Movimiento" manda sobre la fila de vibra para MOTION.
