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
  (let ((tiempo-r (cdr (assoc 'rojo datos-json)))
        (tiempo-a (cdr (assoc 'amarillo datos-json)))
        (tiempo-v (cdr (assoc 'verde datos-json)))) 
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

