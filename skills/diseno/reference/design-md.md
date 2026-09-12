# Plantilla de DESIGN.md (formato oficial DESIGN.md, compatible con Impeccable y Google Stitch)

Escríbelo en la raíz del proyecto cuando el sistema ya está en el código (tokens reales). Excepción: en `/diseno sistema` sobre un proyecto vacío se escribe con los tokens acordados en la Ronda Sistema, con `status: seed` en el frontmatter (justo debajo de `description`) y "tokens acordados, aún sin código" en Overview; tras la primera pantalla se reescribe con los tokens reales y se quita `status: seed`.
Frontmatter YAML = tokens normativos (lo que leen las herramientas). Cuerpo = cómo aplicarlos.
En registro inmersivo la rampa declarada en `typography` debe cubrir **cada `clamp()` que exista en el CSS**: los cuatro niveles base (display, body, label, mono) no llegan, por eso están las claves opcionales `wordmark`, `lead` y `subhead`. Si un nivel real no cabe en ninguna de esas claves, añádelo con nombre descriptivo (`root`, `card-title`, `marquee-item`) y cítalo en la sección Typography del cuerpo. Todo `clamp()` sin clave sale como `design-system-font-size` en el detector, y ese id no está en la lista de hallazgos esperados de `inmersivo.md`: es error, no excepción.
Si ya existe un `DESIGN.md`, nunca lo sobrescribas en silencio: muéstralo y pregunta (refrescar, reemplazar o mezclar).
Omite secciones que no apliquen; las que queden van en este orden. Cero em-dashes.

```markdown
---
name: <nombre del proyecto>
description: <tagline de una línea>
colors:
  # una entrada por color real; clave = nombre descriptivo (no "blue-800")
  ink: "#141414"
  paper: "#f6f5f2"
  accent: "#1d4ed8"
  accent-deep: "#1e3a8a"
  muted: "#6b7280"
typography:
  display:
    fontFamily: "Satoshi, system-ui, sans-serif"
    fontSize: "clamp(2.25rem, 5vw, 3.75rem)"
    fontWeight: 600
    lineHeight: 1.05
    letterSpacing: "-0.02em"
  body:
    fontFamily: "Satoshi, system-ui, sans-serif"
    fontSize: "1rem"
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: "Satoshi, system-ui, sans-serif"
    fontSize: "0.8125rem"
    fontWeight: 500
  mono:
    # opcional: solo si el proyecto usa un tercer nivel de etiquetas, numeración de secciones o chrome.
    # En registro inmersivo aquí va la tercera familia (mono o serif secundaria) y `label` conserva
    # los valores de tamaño y tracking del nivel de etiquetas.
    fontFamily: "JetBrains Mono, ui-monospace, monospace"
    fontSize: "0.6875rem"
    fontWeight: 400
    letterSpacing: "0.12em"
  wordmark:
    # opcional, solo en registro inmersivo: la pieza display del footer o el watermark.
    fontSize: "clamp(3.4rem, 17.4vw, 22rem)"
    fontWeight: 300
    letterSpacing: "-0.03em"
  lead:
    # opcional, solo en registro inmersivo: el párrafo de entrada y el manifiesto.
    fontSize: "clamp(1.25rem, 2.2vw, 1.75rem)"
    fontWeight: 300
    lineHeight: 1.35
  subhead:
    # opcional, solo en registro inmersivo: títulos intermedios (paso, tarjeta, item de marquee).
    fontSize: "clamp(1.5rem, 3vw, 2.5rem)"
    fontWeight: 400
    lineHeight: 1.1
rounded:
  sm: "6px"
  md: "10px"
  pill: "9999px"
spacing:
  xs: "4px"
  sm: "8px"
  md: "16px"
  lg: "32px"
  xl: "64px"
motion:
  # una sola curva para todo el proyecto; es lo que da coherencia perceptible
  # valores canónicos del registro inmersivo, copiados de escenografia.md "Setup GSAP + Lenis"
  ease-house: "cubic-bezier(0.22, 1, 0.36, 1)"
  dur-ui: "0.24s"
  dur-reveal: "1.2s"
  stagger: "0.06s"
  reduced-motion: "opacity-only"
glass:
  # solo si el proyecto usa vidrio sobre imagen o vídeo; omite el bloque si no
  blur: "8px"
  fill: "rgba(255, 255, 255, 0.18)"
  border: "1px solid rgba(255, 255, 255, 0.28)"
  radius: "12px"
components:
  button-primary:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.paper}"
    rounded: "{rounded.pill}"
    padding: "12px 20px"
  button-primary-hover:
    backgroundColor: "{colors.accent-deep}"
  input:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
    rounded: "{rounded.sm}"
    padding: "10px 12px"
---

# Design System: <nombre del proyecto>

## Overview

**Creative North Star: "<metáfora en 2 o 3 palabras>"**

<2 párrafos: personalidad, densidad y filosofía. Solo rechazos visuales confirmados.>

**Key Characteristics:**
- <rasgo 1>
- <rasgo 2>
- <rasgo 3>

## Colors

<Carácter de la paleta en una frase. Un solo acento salvo decisión explícita.>

### Primary
- **<Nombre descriptivo>** (#hex): <dónde y por qué se usa>.

### Neutral
- **<Nombre>** (#hex): <texto / fondo / borde>.

### Named Rules
**The One Accent Rule.** El acento aparece en menos del 10 % de cualquier pantalla; su rareza es el punto.

## Typography

**Display Font:** <familia> (fallback <…>)
**Body Font:** <familia> (fallback <…>)

**Character:** <1 o 2 frases sobre la pareja tipográfica.>

### Hierarchy
- **Display** (<peso>, <tamaño>, <line-height>): <uso>.
- **Headline** (<peso>, <tamaño>, <line-height>): <uso>.
- **Body** (<peso>, <tamaño>, <line-height>): máximo 65 a 75 caracteres por línea.
- **Label** (<peso>, <tamaño>, <tracking>): <uso>.

## Layout

<Contenedor máximo, rejilla, breakpoints, ritmo de espaciado, densidad. Solo valores observados.>

## Elevation & Depth

<Sombras, capas tonales o plano. Si es plano, dilo y explica cómo se transmite la profundidad.>

## Motion

**Curva de la casa:** <una sola, p. ej. cubic-bezier(0.22, 1, 0.36, 1)>

- **UI** (<dur-ui>): botones, menus, hover, acordeones. Reglas de Emil: ease-out al entrar, menos de 300 ms, solo transform y opacity.
- **Escenografía** (<dur-reveal>, solo si el proyecto tiene registro inmersivo): <gramática de reveal única: máscara por palabras, clip-path, imagen scale 1.2 a 1>.
- **Reduced motion:** conserva opacidad y color, quita desplazamiento, pin y scrub.

## Shapes

<Sistema de radios (uno solo), bordes, recortes. Regla: botones <…>, tarjetas <…>, inputs <…>.>

## Components

- **Button**: <forma, color, hover, focus, active (scale 0.97), padding>.
- **Input**: <borde, focus ring, error inline, label arriba>.
- **Card**: <cuándo existe una tarjeta y cuándo no>.
- **Iconos**: <familia (una sola) y grosor>.

## Firma

<Solo en registro inmersivo. La firma de movimiento elegida (una sola por página) y los instrumentos activos, con el cupo de 2 de `reference/inmersivo.md` sección "Instrumentos", para que las próximas páginas no inventen otros: p. ej. "vídeo macro en el hero; marquee de palabras clave; sin preloader ni cursor custom". Si el proyecto no es inmersivo, omite esta sección.>

## Do's and Don'ts

- Do: <regla positiva confirmada>.
- Don't: <anti-patrón concreto que este proyecto rechaza (p. ej. gradientes en texto, eyebrows sobre títulos, em-dashes)>.
```

Bloques `motion`, `glass`, `typography.mono` y sección "Firma": escríbelos solo con los valores reales del código. `motion.ease-house` es normativo: una sola curva por proyecto (los sitios de referencia repiten la suya cientos de veces). En registro inmersivo, `dur-reveal` y "Firma" son obligatorios y sus valores son los de `reference/escenografia.md` sección "Setup GSAP + Lenis"; en el resto, omítelos.

Sección "Modo": si el proyecto tiene modo claro y oscuro, registra ambos juegos de colores en `colors` con sufijos (`paper`, `paper-dark`) y explica en Colors cómo se alternan. Si solo hay uno, dilo en Overview.
