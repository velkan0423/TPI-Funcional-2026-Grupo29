# 🚦 TPI-Funcional-2026-Grupo29

Trabajo práctico integrador de Paradigmas Funcionales 2026.

Sistema de Semáforos Inteligentes desarrollado en **Common Lisp** bajo el paradigma funcional puro para la materia **Paradigmas y Lenguajes — UNNE 2026**.

> Trabajo práctico integrador orientado al modelado funcional de sistemas temporizados, análisis de flujo de estados y comparación entre paradigmas funcionales.

---

# 📌 Descripción del proyecto

El presente trabajo práctico implementa el núcleo lógico de un sistema de control semafórico urbano aplicando conceptos fundamentales de programación funcional.

Durante el desarrollo se trabajó con:

* Funciones puras
* Inmutabilidad
* Recursividad de cola
* Funciones de orden superior
* Composición funcional
* Transformación no destructiva de datos

Además, se realiza un análisis comparativo entre **Common Lisp** y **Scheme**, estudiando diferencias sintácticas y conceptuales entre ambos lenguajes.

---

# 🗂️ Estructura del repositorio

```plaintext
TPI-Funcional-2026-Grupo[X]/
├── lisp/
│   ├── core.lisp
│   └── config.json
├── comparativa/
│   └── solucion.scm
├── docs/
│   ├── INFORME.pdf
│   └── HONOR.md
└── README.md
```

| Carpeta        | Contenido                                                      |
| -------------- | -------------------------------------------------------------- |
| `lisp/`        | Implementación principal del sistema semafórico en Common Lisp |
| `comparativa/` | Reimplementación parcial de funciones en Scheme                |
| `docs/`        | Informe técnico, análisis conceptual y código de honor         |
| `README.md`    | Presentación general del proyecto                              |

---

# ⚙️ Funcionalidades implementadas

## 🚥 Control de estados del semáforo

El sistema implementa transiciones entre estados semafóricos:

* rojo
* amarillo
* verde

Incluyendo:

* Validación de cambios permitidos
* Estados intermitentes de seguridad
* Modelado funcional de transiciones
* Representación inmutable del estado del sistema

---

## ⏱️ Temporización automática

Sistema automático basado en tiempo Unix (Epoch).

| Estado   | Duración     |
| -------- | ------------ |
| Rojo     | 90  segundos |
| Amarillo | 6   segundos |
| Verde    | 120 segundos |

El temporizador calcula automáticamente el color correspondiente para un instante temporal determinado.

---

## 📝 Sistema de auditoría

Registro funcional de cambios de estado para reconstrucción histórica de eventos.

Ejemplo de salida:

```lisp
Tiempo 1717420000: la luz ha cambiado de rojo a verde
```

Incluye persistencia en archivo de texto plano en el disco.

---

## 📊 Análisis de ciclos semafóricos

El sistema permite:

* Calcular duración total de ciclos
* Analizar eficiencia temporal
* Generar recomendaciones de optimización
* Calcular ciclos por intervalo de tiempo
* Obtener distribución porcentual de estados

---

# 🧠 Paradigma funcional aplicado

El proyecto fue desarrollado respetando las restricciones funcionales solicitadas por la cátedra:

* ❌ Sin variables globales mutables
* ❌ Sin `setf`, `setq`, `loop`
* ❌ Sin iteración imperativa
* ✅ Uso de recursividad
* ✅ Funciones puras
* ✅ Funciones de orden superior
* ✅ Transformación inmutable de datos

---

# 🔍 Tecnologías y herramientas utilizadas

| Herramienta          | Uso                       |
| -------------------- | ------------------------- |
| Common Lisp          | Implementación principal  |
| Scheme               | Comparativa funcional     |
| Quicklisp            | Gestión de librerías      |
| cl-json / local-time | Configuración y auditoría |
| CLISP / SBCL         | Ejecución del proyecto    |
| Neovim               | Edición de código         |
| Sublime Text         | Edición de código         |
| Git + GitHub         | Control de versiones      |

---

# 🚀 Ejecución del proyecto

## Requisitos

Instalar previamente:

* CLISP o SBCL
* Quicklisp
* Git

## Ejecutar con CLISP

```bash
clisp lisp/core.lisp
```

---

## Ejecutar con SBCL

```bash
sbcl --script lisp/core.lisp
```

---

# 📚 Temas trabajados

* Programación funcional pura
* Recursividad de cola
* Manejo de listas
* Modelado de estados
* Evaluación funcional
* Sistemas temporizados
* Persistencia funcional
* Comparación de paradigmas funcionales

---

# 🎥 Video de defensa

📺 Enlace al video:
(Aquí colocar enlace de YouTube)

---

# 👥 Integrantes

| Integrante          | GitHub       |
| ------------------- | -----------  |
| Zarate Lucas Martin | @velkan0423  |
| Portillo Joel       | @joelito1234 |
| Meza Lautaro        | @lautymeza427|
| Nombre Apellido     | @usuario     |
---

# 📖 Bibliografía

* Practicas de Common Lisp
* Documentación oficial de Common Lisp
* Material de cátedra — Paradigmas y Lenguajes UNNE 2026
* Documentación oficial de Scheme

---

# 🤝 Contribuciones

El historial de commits refleja el desarrollo incremental del proyecto siguiendo las reglas de trazabilidad solicitadas por la cátedra.

Cada integrante realizó aportes individuales mediante GitHub.

---

# 📌 Observaciones

Este proyecto fue realizado con fines exclusivamente académicos para la materia Paradigmas y Lenguajes — UNNE 2026.

---

# ❤️ Desarrollado por Grupo [X]
