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
