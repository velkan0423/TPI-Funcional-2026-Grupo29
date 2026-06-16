;;;Para este Programa usaremos quicklisp "https://www.quicklisp.org/beta/"
;;;descargamos.
;;;Para Instalar seguimos los siguientes comandos en en nuestro Clisp.
;;;       (load "quicklisp.lisp")
;;;       (quicklisp-quickstart:install)
;;;       (ql:add-to-init-file)

;;;Una ves instalado quicklisp, esto nos permitira cl-JSON para instalarlo
;;;Ponemos el siguiente comando en nuestro Clisp
;;;       (ql:quickload "cl-json") 
;;; y luego 
;;;         (use-package :cl-json)


;;;
;;;; *************************************************** 
;;;; Fichero: backend-semaforo.lisp 
;;;; Fecha-de-creación: Junio 2026
;;;; Modulo: Trabajo Práctico Integrador - Paradigmas
;;;; Comentarios: Núcleo funcional para simulación vial con metadatos de paradigma.
;;;; Autores: Grupo 29
;;;; ***************************************************

;;; ============================================
;;; 1. CAPA ADAPTADORA (INTEROPERABILIDAD JSON)
;;; ============================================

;; ========================================================
;; FUNCIÓN: adaptar-entrada-json
;; NATURALEZA: Pura (Retorna la misma lista para las mismas entradas asociativas).
;; ESTRATEGIA: Mapeo y Extracción de Pares (Busca claves específicas en la estructura asociativa).
;; IMPACTO: No destructiva (Genera una lista posicional totalmente nueva).
;; ========================================================
(defun adaptar-entrada-json (datos-json) 
  (let ((tiempo-r (cdr (assoc :ROJO datos-json)))
        (tiempo-a (cdr (assoc :AMARILLO datos-json)))
        (tiempo-v (cdr (assoc :VERDE datos-json)))) 
    (list tiempo-r tiempo-a tiempo-v)))


;;; ============================================
;;; 2. SELECTORES SEMÁNTICOS Y MÉTRICAS VIALES
;;; ============================================

;; ========================================================
;; FUNCIÓN: obtener-tiempo-... (rojo/amarillo/verde)
;; NATURALEZA: Pura (Siempre extrae el mismo elemento de la lista dada).
;; ESTRATEGIA: Extracción Secuencial (Usa funciones primitivas como 'first', 'second' y 'third').
;; IMPACTO: No destructiva (Lee la lista sin modificarla).
;; ========================================================

(defun obtener-tiempo-rojo (configuracion)
  (first configuracion))

(defun obtener-tiempo-amarillo (configuracion)
  (second configuracion))

(defun obtener-tiempo-verde (configuracion)
  (third configuracion))

;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (La suma de los mismos tres tiempos más la extensión da el mismo resultado).
;; ESTRATEGIA: Composición Matemática (Suma los resultados de otras funciones puras y un entero constante).
;; IMPACTO: No destructiva (Solo realiza cálculos aritméticos sin alterar el entorno).
;; ========================================================
(defun duracion-ciclo (configuracion)
  (+ (obtener-tiempo-rojo configuracion)
     (obtener-tiempo-amarillo configuracion)
     (obtener-tiempo-verde configuracion) 3)) ; Extensión física de 3 segundos solicitada por el equipo.

;; ========================================================
;; FUNCIÓN: recomendacion-ciclo
;; NATURALEZA: Pura (Devuelve el mismo diagnóstico para la misma configuración).
;; ESTRATEGIA: Condicional (Toma decisiones lógicas basadas en un cálculo numérico preevaluado).
;; IMPACTO: No destructiva.
;; ========================================================
(defun recomendacion-ciclo (configuracion)
  (let ((total (duracion-ciclo configuracion)))
    (cond
      ((< total 35) 'ciclo-muy-corto-ajustar-a-alta-densidad)
      ((> total 150) 'ciclo-muy-largo-riesgo-de-congestion)
      (t 'ciclo-optimo-flujo-vehicular-eficiente))))




;; ========================================================
;; FUNCIÓN: calcular-porcentajes-eficiencia
;; NATURALEZA: Pura (El cálculo matemático no depende del entorno externo).
;; ESTRATEGIA: Secuencial / Matemática (Extrae, divide y multiplica de forma directa).
;; IMPACTO: No destructiva (Genera y devuelve una nueva lista con los resultados).
;; ========================================================
(defun calcular-porcentajes-eficiencia (configuracion)
  (let* ((r (obtener-tiempo-rojo configuracion))
         (a (obtener-tiempo-amarillo configuracion))
         (v (obtener-tiempo-verde configuracion))
         (total (duracion-ciclo configuracion)))
    (list
     'rojo (float (* (/ r total) 100))
     'amarillo (float (* (/ a total) 100))
     'verde (float (* (/ v total) 100)))))


;;; ============================================
;;; 3. LÓGICA TEMPORAL (CORE MATEMÁTICO)
;;; ============================================

;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (Retorna el mismo mensaje siempre que reciba los mismos colores).
;; ESTRATEGIA: Condicional / Selección Múltiple (El 'cond' evalúa todas las rutas de transición válidas).
;; IMPACTO: No destructiva (Crea y retorna una lista nueva sin alterar las variables originales).
;; ========================================================
(defun transicion (color-actual cambiar-a)
  (cond
    ((and (eq color-actual 'en-rojo) (eq cambiar-a 'verde))
     (list color-actual "cambiar-a-verde"))

    ((and (eq color-actual 'en-verde) (eq cambiar-a 'amarillo))
     (list color-actual "cambiar-a-amarillo"))

    ((and (eq color-actual 'en-amarillo) (eq cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo"))

    ((and (eq color-actual 'en-verde) (eq cambiar-a 'amarillo-intermitente))
     (list color-actual "cambiar-a-amarillo-intermitente"))

    ((and (eq color-actual 'amarillo-intermitente) (eq cambiar-a 'rojo))
     (list color-actual "cambiar-a-rojo"))

    (t
     (list color-actual "accion-por-defecto"))))

;; ========================================================
;; FUNCIÓN: timer-seguro
;; NATURALEZA: Pura (Para un mismo segundo exacto y configuración, devuelve el mismo estado).
;; ESTRATEGIA: Matemática y Condicional (Calcula el módulo respecto al ciclo total y evalúa tramos con ventanas de seguridad).
;; IMPACTO: No destructiva (No altera el reloj universal, solo evalúa proyecciones de tiempo numéricas).
;; ========================================================
(defun timer-seguro (time-exac configuracion)
  (let* ((t-rojo (obtener-tiempo-rojo configuracion))
         (t-amarillo (obtener-tiempo-amarillo configuracion))
         (t-verde (obtener-tiempo-verde configuracion))
         (ciclo-total (duracion-ciclo configuracion))
         (segundo-actual (mod time-exac ciclo-total)))
    (cond 
      ;; 1. Tramo Rojo
      ((< segundo-actual t-rojo) 'en-rojo) 
      ;; 2. Tramo Verde 
      ((< segundo-actual (+ t-rojo t-verde)) 'en-verde) 
      ;; 3. Tramo de Seguridad (Consume 3 segundos justo antes de la transición) 
      ((< segundo-actual (+ t-rojo t-verde 3)) 'amarillo-intermitente) 
      ;; 4. Tramo Amarillo Fijo (El resto del tiempo del ciclo)
      (t 'en-amarillo))))


;;; ============================================
;;; 4. CAPA DE SALIDA (EFECTOS SECUNDARIOS Y PERSISTENCIA)
;;; ============================================

;; ========================================================
;; FUNCIÓN: informe
;; NATURALEZA: Impura (Su ejecución depende de y afecta activamente al sistema operativo).
;; ESTRATEGIA: Secuencial / Lineal (Abre el descriptor, inyecta la cadena formateada y cierra el flujo).
;; IMPACTO: Destructiva (Modifica el estado físico del almacenamiento secundario mediante el modo :append).
;; ========================================================
(defun informe (datos ruta-archivo)
  (with-open-file (stream ruta-archivo
                          :direction :output
                          :if-exists :append
                          :if-does-not-exist :create)
    (format stream "~%Timestamp: ~A | Estado: ~A"
            (first datos)
            (second datos))))

;; ========================================================
;; FUNCIÓN: procesar-estado-seguro
;; NATURALEZA: Impura (Al invocar a la función 'informe', hereda sus efectos secundarios).
;; ESTRATEGIA: Composición Secuencial (Orquesta la evaluación temporal y la posterior persistencia forense).
;; IMPACTO: Destructiva (Genera un efecto secundario directo en el disco, manteniendo la salida limpia para la interfaz visual).
;; ========================================================
(defun procesar-estado-seguro (time-exac configuracion ruta-archivo)
  (let ((estado-actual (timer-seguro time-exac configuracion)))
    (informe (list time-exac estado-actual) ruta-archivo)
    estado-actual))


;;; ============================================
;;; REQUERIMIENTO 7: ASEGURAMIENTO DE LA CALIDAD (TESTING)
;;; ============================================
;;; A continuación se presentan los casos de prueba solicitados por el equipo
;;; de control de calidad, cubriendo caminos normales, alternativos y de error.

;; ---------------------------------------------------------
;; PRUEBAS PARA: transicion
;; ---------------------------------------------------------

;; 1. Camino Normal (Happy Path): Transición esperada y válida.
;; Esperado: (EN-ROJO "cambiar-a-verde")
(transicion 'en-rojo 'verde)

;; 2. Camino Alternativo: Transición hacia un estado de seguridad intermitente.
;; Esperado: (EN-VERDE "cambiar-a-amarillo-intermitente")
(transicion 'en-verde 'amarillo-intermitente)

;; 3. Camino de Error (Lógico): Intento de transición con colores inexistentes.
;; Esperado: El sistema no colapsa, captura el error y devuelve: (AZUL "accion-por-defecto")
(transicion 'azul 'magenta)

;; 4. Camino de Error (Sintáctico): Falta de argumentos.
;; Esperado: ERROR fatal del compilador (invalid number of arguments).
;; (transicion 'en-rojo) ; Descomentar para forzar el quiebre.


;; ---------------------------------------------------------
;; PRUEBAS PARA: adaptar-entrada-json
;; ---------------------------------------------------------

;; 1. Camino Normal: Diccionario Alist perfectamente estructurado.
;; Esperado: (45 5 40)
(adaptar-entrada-json '((rojo . 45) (amarillo . 5) (verde . 40)))

;; 2. Camino Alternativo: El JSON llega con las llaves en distinto orden.
;; Esperado: La función extrae por llave, no por posición. Retorna: (45 5 40)
(adaptar-entrada-json '((verde . 40) (rojo . 45) (amarillo . 5)))

;; 3. Camino de Error (Lógico): El JSON llega corrupto o faltan llaves vitales.
;; Esperado: (45 NIL 40) - El sistema detecta la ausencia sin romper la ejecución.
(adaptar-entrada-json '((rojo . 45) (azul . 99) (verde . 40)))


;; ---------------------------------------------------------
;; PRUEBAS PARA: recomendacion-ciclo (y duracion-ciclo)
;; ---------------------------------------------------------
;; Nota: Recordar que la función suma 3 segundos extra físicamente.

;; 1. Camino Normal: Una configuración estándar (45 + 5 + 40 + 3 = 93 seg).
;; Esperado: CICLO-OPTIMO-FLUJO-VEHICULAR-EFICIENTE
(recomendacion-ciclo '(45 5 40))

;; 2. Camino Alternativo 1 (Límite Inferior): Tiempos irreales muy cortos (10+2+10+3 = 25 seg).
;; Esperado: CICLO-MUY-CORTO-AJUSTAR-A-ALTA-DENSIDAD
(recomendacion-ciclo '(10 2 10))

;; 3. Camino Alternativo 2 (Límite Superior): Tiempos propensos a embotellamiento (80+10+80+3 = 173 seg).
;; Esperado: CICLO-MUY-LARGO-RIESGO-DE-CONGESTION
(recomendacion-ciclo '(80 10 80))

;; 4. Camino de Error: Inyección de datos de tipo incorrecto (Strings en vez de Integers).
;; Esperado: ERROR fatal de tipado (The value "45" is not of type NUMBER).
;; (recomendacion-ciclo '("45" "5" "40")) ; Descomentar para forzar el quiebre.


;; ---------------------------------------------------------
;; PRUEBAS PARA: timer-seguro
;; ---------------------------------------------------------
;; Usando la configuración '(45 5 40) cuyo ciclo total es de 93 segundos.

;; 1. Camino Normal: Segundo 10 (Cae holgadamente dentro del primer tramo rojo de 45s).
;; Esperado: EN-ROJO
(timer-seguro 10 '(45 5 40))

;; 2. Camino Alternativo (Edge Case): Exactamente en el segundo 86.
;; (45 rojo + 40 verde = 85. El segundo 86 entra en la ventana de 3s de seguridad).
;; Esperado: AMARILLO-INTERMITENTE
(timer-seguro 86 '(45 5 40))

;; 3. Camino Alternativo (Loop Temporal): Segundo 100.
;; (Supera el ciclo de 93s, el módulo lo reinicia al segundo 7 del nuevo ciclo).
;; Esperado: EN-ROJO
(timer-seguro 100 '(45 5 40))

;; 4. Camino de Error: Enviar un timestamp vacío o tipo de dato no numérico.
;; Esperado: ERROR fatal (The value NIL is not of type REAL).
;; (timer-seguro nil '(45 5 40)) ; Descomentar para forzar el quiebre.
