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
;;; ((:ROJO . 40) (:AMARILLO . 5) (:VERDE . 45))
;; ========================================================
;; FUNCIÓN: adaptar-entrada-json
;; NATURALEZA: Pura (Retorna la misma lista para las mismas entradas asociativas).
;; ESTRATEGIA: Mapeo y Extracción de Pares (Busca claves específicas en la estructura asociativa).
;; IMPACTO: No destructiva (Genera una lista posicional totalmente nueva).
;; ========================================================
;;(defun adaptar-entrada-json (datos-json) 
;;  (let ((tiempo-r (cdr (assoc :ROJO datos-json)))
;;        (tiempo-a (cdr (assoc :AMARILLO datos-json)))
;;        (tiempo-v (cdr (assoc :VERDE datos-json)))) 
;;    (list tiempo-r tiempo-a tiempo-v)))

;; (40 5 45)
;;; ============================================
;;; 2. SELECTORES SEMÁNTICOS Y MÉTRICAS VIALES
;;; ============================================

;; ========================================================
;; FUNCIÓN: obtener-tiempo-... (rojo/amarillo/verde)
;; NATURALEZA: Pura (Siempre extrae el mismo elemento de la lista dada).
;; ESTRATEGIA: Extracción Secuencial (Usa funciones primitivas como 'first', 'second' y 'third').
;; IMPACTO: No destructiva (Lee la lista sin modificarla).
;; ========================================================
;; (FIRST (40 5 45))  ==> 40

;; (defun obtener-tiempo-rojo (configuracion)
;;  (first configuracion))

;; (defun obtener-tiempo-amarillo (configuracion)
;;  (second configuracion))

;; (defun obtener-tiempo-verde (configuracion)
;;  (third configuracion))


;;---------------------------------------------------------------------------

;;; Toda lo anterior puede ser encapsulados en la funcion de las dos funciones

;;; ========================================================
;;; 1. SELECTORES SEMÁNTICOS (ENCAPSULAN EL ACCESO AL JSON)
;;; ========================================================

;; ========================================================
;; FUNCIÓN: obtener-tiempo-rojo / obtener-tiempo-amarillo / obtener-tiempo-verde
;; NATURALEZA: Pura (Siempre extrae el mismo valor para la misma estructura asociativa).
;; ESTRATEGIA: Búsqueda por Clave Asociativa (Usa funciones primitivas 'assoc' y 'cdr' para indexar el mapa).
;; IMPACTO: No destructiva (Lee la estructura asociativa sin alterar los pares originales).
;; ========================================================

(defun obtener-tiempo-rojo (configuracion)
  (cdr (assoc :ROJO configuracion)))

(defun obtener-tiempo-amarillo (configuracion)
  (cdr (assoc :AMARILLO configuracion)))

(defun obtener-tiempo-verde (configuracion)
  (cdr (assoc :VERDE configuracion)))



;;; ============================================
;;; 1. SELECTORES SEMÁNTICOS (ENCAPSULAN EL ACCESO AL JSON)
;;; ============================================

(defun obtener-tiempo-rojo (configuracion)
  (cdr (assoc :ROJO configuracion)))

(defun obtener-tiempo-amarillo (configuracion)
  (cdr (assoc :AMARILLO configuracion)))

(defun obtener-tiempo-verde (configuracion)
  (cdr (assoc :VERDE configuracion)))


;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (La suma de los mismos tres tiempos más la extensión da el mismo resultado).
;; ESTRATEGIA: Composición Matemática (Suma los resultados de otras funciones puras y un entero constante).
;; IMPACTO: No destructiva (Solo realiza cálculos aritméticos sin alterar el entorno).
;; ========================================================

;; (FIRST (40 5 45))  ==> 40
;; (second (40 5 45)) ==> 5
;; (third (40 5 45))  ==> 45 
;; encima agrega 3 segundos

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
    ;; REGLA DE PERMANENCIA: Si el temporizador calcula el mismo color en el que ya está,
    ;; se mantiene el estado de forma explícita y segura sin romper el ciclo.
    ((eq color-actual cambiar-a)
     (list color-actual "mantener-estado-actual"))

    ;; Transiciones de cambio de fase tradicionales
    ((and (eq color-actual 'en-rojo) (eq cambiar-a 'en-verde))
     (list cambiar-a "cambiar-a-verde"))

    ((and (eq color-actual 'en-verde) (eq cambiar-a 'amarillo-intermitente))
     (list cambiar-a "cambiar-a-amarillo-intermitente"))

    ((and (eq color-actual 'amarillo-intermitente) (eq cambiar-a 'en-amarillo))
     (list cambiar-a "cambiar-a-amarillo"))

    ((and (eq color-actual 'en-amarillo) (eq cambiar-a 'en-rojo))
     (list cambiar-a "cambiar-a-rojo"))

    ;; Caso de resguardo definitivo
    (t
     (list color-actual "accion-por-defecto"))))

;; ========================================================
;; FUNCIÓN: timer-seguro
;; NATURALEZA: Pura (Retorna siempre la misma fase vial para el mismo segundo del ciclo).
;; ESTRATEGIA: Evaluación de Rangos Acumulativos (Usa los umbrales de tiempo para delimitar tramos).
;; IMPACTO: No destructiva (Determina el estado simbólico a partir de cálculos matemáticos puros).
;; ========================================================
(defun timer-seguro (time-exac configuracion)
  (let* ((t-rojo (obtener-tiempo-rojo configuracion))
         (t-verde (obtener-tiempo-verde configuracion))
         ;; Buscamos el hito temporal directamente desde la estructura asociativa del JSON
         (inicio-epoch (cdr (assoc :INICIO-EPOCH configuracion)))
         
         ;; IMPLEMENTACIÓN:
         ;; Restamos el hito operacional al tiempo absoluto actual de la CPU (time-exac - inicio-epoch)
         ;; e inmediatamente aplicamos el módulo de la duración total del ciclo.
         (segundo-actual (mod (- time-exac inicio-epoch) (duracion-ciclo configuracion))))
    
    (cond
      ;; 1. Tramo Rojo: de 0 a 39
      ((< segundo-actual t-rojo) 'en-rojo) 
      
      ;; 2. Tramo Verde: de 40 a 84
      ((< segundo-actual (+ t-rojo t-verde)) 'en-verde) 
 
      ;; 3. Tramo Amarillo Intermitente (Seguridad): de 85 a 87
      ((< segundo-actual (+ t-rojo t-verde 3)) 'amarillo-intermitente) 
      
      ;; 4. Tramo Amarillo Fijo: Caso por defecto para el resto del ciclo (de 88 a 92)
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
;; NATURALEZA: Impura (Hereda la naturaleza de Entrada/Salida de 'informe').
;; ESTRATEGIA: Composición Funcional y Vinculación Vial.
;; IMPACTO: Destructiva (Genera persistencia física mediante append en disco).
;; ========================================================
(defun procesar-estado-seguro (time-exac estado-anterior configuracion ruta-archivo)
  (let* ((estado-calculado (timer-seguro time-exac configuracion))
         ;; Aquí invocamos formalmente a transicion usando el estado previo y el nuevo
         (resultado-vial (transicion estado-anterior estado-calculado))
         (estado-validado (first resultado-vial)))
    
    ;; Persistimos el estado validado por las reglas de la función transicion
    (informe (list time-exac estado-validado) ruta-archivo)
    
    ;; Retornamos el estado para que la simulación continúe en el siguiente ciclo
    estado-validado))
