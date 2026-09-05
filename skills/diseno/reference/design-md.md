# Plantilla de DESIGN.md (formato oficial DESIGN.md, compatible con Impeccable y Google Stitch)

Escríbelo en la raíz del proyecto cuando el sistema ya está en el código (tokens reales). Excepción: en `/diseno sistema` sobre un proyecto vacío se escribe con los tokens acordados en la Ronda Sistema, con `status: seed` en el frontmatter (justo debajo de `description`) y "tokens acordados, aún sin código" en Overview; tras la primera pantalla se reescribe con los tokens reales y se quita `status: seed`.
Frontmatter YAML = tokens normativos (lo que leen las herramientas). Cuerpo = cómo aplicarlos.
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

## Shapes

<Sistema de radios (uno solo), bordes, recortes. Regla: botones <…>, tarjetas <…>, inputs <…>.>

## Components

- **Button**: <forma, color, hover, focus, active (scale 0.97), padding>.
- **Input**: <borde, focus ring, error inline, label arriba>.
- **Card**: <cuándo existe una tarjeta y cuándo no>.
- **Iconos**: <familia (una sola) y grosor>.

## Do's and Don'ts

- Do: <regla positiva confirmada>.
- Don't: <anti-patrón concreto que este proyecto rechaza (p. ej. gradientes en texto, eyebrows sobre títulos, em-dashes)>.
```

Sección "Modo": si el proyecto tiene modo claro y oscuro, registra ambos juegos de colores en `colors` con sufijos (`paper`, `paper-dark`) y explica en Colors cómo se alternan. Si solo hay uno, dilo en Overview.
