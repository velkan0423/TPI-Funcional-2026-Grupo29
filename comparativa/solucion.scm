;;; ============================================
;;; 1. SELECTORES SEMANTICOS (ENTORNO SCHEME)
;;; ============================================

;; ========================================================
;; FUNCION: obtener-tiempo-rojo / obtener-tiempo-amarillo / obtener-tiempo-verde
;; NATURALEZA: Pura (Siempre extrae el mismo valor para la misma estructura asociativa).
;; ESTRATEGIA: Busqueda por Clave (Usa las funciones primitivas 'assoc' y 'cdr').
;; IMPACTO: No destructiva (Lee la lista sin alterar los pares originales).
;; ========================================================
(define (obtener-tiempo-rojo configuracion)
  (cdr (assoc 'rojo configuracion)))

(define (obtener-tiempo-amarillo configuracion)
  (cdr (assoc 'amarillo configuracion)))

(define (obtener-tiempo-verde configuracion)
  (cdr (assoc 'verde configuracion)))

;; ========================================================
;; FUNCION: duracion-ciclo
;; NATURALEZA: Pura (La suma de los mismos tres tiempos mas la extension da el mismo resultado).
;; ESTRATEGIA: Composicion Matematica (Suma los resultados de otras funciones puras y una constante).
;; IMPACTO: No destructiva.
;; ========================================================
(define (duracion-ciclo configuracion)
  (+ (obtener-tiempo-rojo configuracion)
     (obtener-tiempo-amarillo configuracion)
     (obtener-tiempo-verde configuracion)
     3)) ; Extension fisica de 3 segundos solicitada por el equipo.

;;; ============================================
;;; 2. LOGICA TEMPORAL
;;; ============================================

;; ========================================================
;; FUNCION: timer-seguro
;; NATURALEZA: Pura (Retorna siempre la misma fase vial para el mismo segundo del ciclo).
;; ESTRATEGIA: Evaluacion de Rangos Acumulativos (Determina el tramo mediante condicionales lineales).
;; IMPACTO: No destructiva (Calculos matematicos basados en marcas de tiempo universales).
;; ========================================================
(define (timer-seguro time-exac configuracion)
  (let* ((t-rojo (obtener-tiempo-rojo configuracion))
         (t-verde (obtener-tiempo-verde configuracion))
         (inicio-epoch (cdr (assoc 'inicio-epoch configuracion)))
         ;; En Scheme la funcion para el residuo de la division es 'modulo'
         (segundo-actual (modulo (- time-exac inicio-epoch) (duracion-ciclo configuracion))))
    (cond
      ;; 1. Tramo Rojo
      ((< segundo-actual t-rojo) 'en-rojo)
      
      ;; 2. Tramo Verde
      ((< segundo-actual (+ t-rojo t-verde)) 'en-verde)
      
      ;; 3. Tramo Amarillo Intermitente (Seguridad)
      ((< segundo-actual (+ t-rojo t-verde 3)) 'amarillo-intermitente)
      
      ;; 4. Tramo Amarillo Fijo (Caso por defecto)
      (else 'en-yellow))))

;; ========================================================
;; FUNCION: transicion
;; NATURALEZA: Pura (Retorna el mismo mensaje siempre que reciba los mismos colores).
;; ESTRATEGIA: Condicional / Seleccion Multiple (Usa 'cond' y el predicado de igualdad de simbolos 'eq?').
;; IMPACTO: No destructiva (Genera estructuras de listas totalmente nuevas).
;; ========================================================
(define (transicion color-actual cambiar-a)
  (cond
    ;; REGLA DE PERMANENCIA
    ((eq? color-actual cambiar-a)
     (list color-actual "mantener-estado-actual"))

    ;; Transiciones validas tradicionales
    ((and (eq? color-actual 'en-rojo) (eq? cambiar-a 'en-verde))
     (list cambiar-a "cambiar-a-verde"))

    ((and (eq? color-actual 'en-verde) (eq? cambiar-a 'amarillo-intermitente))
     (list cambiar-a "cambiar-a-amarillo-intermitente"))

    ((and (eq? color-actual 'amarillo-intermitente) (eq? cambiar-a 'en-amarillo))
     (list cambiar-a "cambiar-a-amarillo"))

    ((and (eq? color-actual 'en-amarillo) (eq? cambiar-a 'en-rojo))
     (list cambiar-a "cambiar-a-rojo"))

    ;; Caso de resguardo por defecto (En Scheme se usa obligatoriamente 'else')
    (else
     (list color-actual "accion-por-defecto"))))
