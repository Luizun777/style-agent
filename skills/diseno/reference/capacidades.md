# Capacidades del agente

Traducción de cada rol que usa `SKILL.md` a la herramienta que expone tu agente. `SKILL.md` nombra siempre el rol ("carga X", "pregunta con opciones", "el rol de leer archivo"), nunca el nombre de herramienta de un agente concreto. Esta tabla es la única autoridad sobre cómo se cumple cada rol y qué se hace cuando falta.

## Tabla de roles

| Rol | Preferida en Claude Code | Si no existe |
|---|---|---|
| leer archivo | `Read` | la herramienta de lectura del agente; sin ella, `cat` o `sed -n '1,80p'` por consola |
| leer archivo mostrando imágenes | `Read` sobre el `.png`, `.jpg` o `.webp` | la herramienta multimodal del agente; si no abre imágenes, dilo, marca esa referencia como no observable en tipografía y color y no la describas (nunca describas una captura que no has visto) |
| recibir imágenes pegadas en el chat | nativo | si el agente no las acepta, pide al usuario la ruta del archivo y usa el rol anterior |
| escribir archivo | `Write` | la de escritura; sin ella, heredoc por consola |
| editar archivo | `Edit` | la de edición o de parche del agente (`apply_patch`, `edit`) |
| listar o buscar por nombre | `Glob` | `ls`, `find` por consola |
| buscar por contenido | `Grep` | `rg` o `grep` por consola |
| ejecutar un comando de consola | `Bash` | la herramienta de shell del agente (`bash`, `unified_exec`) |
| proceso en segundo plano y matarlo | `run_in_background` más `KillShell` sobre ese shell id | `<comando> >/dev/null 2>&1 & echo $!` y `kill <pid>` con ese número; si la consola del agente mata el grupo de procesos al acabar la llamada, levanta y usa el proceso en la MISMA llamada |
| traer una URL | `WebFetch` | búsqueda web del agente, o `curl -sL` por consola |
| preguntar al usuario con opciones | `AskUserQuestion` (admite varias preguntas en UNA llamada) | escribe la pregunta con sus opciones numeradas (tope 4, igual que aquí) y espera la respuesta antes de seguir; si son dos preguntas, van juntas en el mismo turno, nunca en dos |
| cargar otra skill | `Skill` (en este archivo y en `SKILL.md` se escribe "carga X") | lee su `SKILL.md` con la fila "leer archivo", aplica lo esencial y declara en la entrega que fue por lectura y no por carga; para Impeccable, el mapa de subcomando a referencia está en las Reglas de sesión de `SKILL.md` |
| lanzar un subagente | `Task` | el equivalente del agente (Codex y opencode lo exponen; Impeccable nombra `impeccable_finish_reviewer` en Codex y `/impeccable-finish-reviewer` en Cursor); sin ninguno, se corre en el mismo hilo y se declara en la entrega como corrida degradada, que es lo que pide `critique.md` de Impeccable |
| generar imágenes | ninguna de serie: la aporta Impeccable en su página de decisión y en sus comps (ruta D) | sin carga de Impeccable no hay página de decisión ni comps: se trabaja con placeholders etiquetados, con medidas y toma descrita, y se dice en la entrega |
| navegador | `mcp__claude-in-chrome__*`, si no `mcp__Claude_Browser__*` | el navegador del agente, sea cual sea su nombre; sin ninguno, no hay capturas: dilo en la entrega y, en registro inmersivo, la escenografía se entrega "no verificada" (Fase 5) |

## Reglas

- Detección: mira qué herramientas expone el agente al arrancar y usa esos nombres; no supongas que existen los de la columna 2 ni los des por perdidos sin mirar.
- Consola que no es bash: la línea de guiones de la Fase 5 usa `printf` justamente para eso, pero antes de dar por bueno un resultado vacío compruébala contra un archivo de prueba que sí tenga uno de los dos caracteres. Un grep que no casa nunca también sale vacío.
- Falta una capacidad crítica: sin consola no se pueden correr `estado.sh` ni el detector de Impeccable; pide al usuario que pegue la salida de `bash <DISENO>/scripts/estado.sh`, o sigue en modo degradado (Fase 0) diciéndolo y marcando el conteo del detector como "no disponible". Nunca lo inventes.
- Si al agente le falta una capacidad, se declara en la entrega en vez de fingirla.
