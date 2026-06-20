;;;; *************************************************** 
;;;; Fichero: core.lisp 
;;;; Fecha-de-creacion: Junio 2026
;;;; Modulo: Trabajo Practico Integrador - Paradigmas
;;;; Comentarios: Nucleo funcional para simulacion vial con metadatos de paradigma.
;;;; Autores: Grupo 29
;;;; ***************************************************

;;; ============================================
;;; 1. CAPA ADAPTADORA (INTEROPERABILIDAD JSON)
;;; ============================================
;;; ((:ROJO . 40) (:AMARILLO . 5) (:VERDE . 45))

;; ========================================================
;; FUNCION: adaptar-entrada-json
;; NATURALEZA: Pura (Retorna la misma lista para las mismas entradas asociativas).
;; ESTRATEGIA: Mapeo y Extraccion de Pares (Busca claves especificas en la estructura asociativa).
;; IMPACTO: No destructiva (Genera una lista posicional totalmente nueva).
;; ========================================================
(defun adaptar-entrada-json (datos-json) 
  (let ((tiempo-r (cdr (assoc :ROJO datos-json)))
        (tiempo-a (cdr (assoc :AMARILLO datos-json)))
        (tiempo-v (cdr (assoc :VERDE datos-json)))) 
    (list tiempo-r tiempo-a tiempo-v)))

;; (40 5 45)

;;; ============================================
;;; 2. SELECTORES SEMANTICOS Y METRICAS VIALES
;;; ============================================

;; ========================================================
;; FUNCION: obtener-tiempo-... (rojo/amarillo/verde)
;; NATURALEZA: Pura (Siempre extrae el mismo elemento de la lista dada).
;; ESTRATEGIA: Extraccion Secuencial (Usa funciones primitivas como 'first', 'second' y 'third').
;; IMPACTO: No destructiva (Lee la lista sin modificarla).
;; ========================================================
;; (FIRST (40 5 45))  ==> 40

(defun obtener-tiempo-rojo (configuracion)
  (first configuracion))

(defun obtener-tiempo-amarillo (configuracion)
  (second configuracion))

(defun obtener-tiempo-verde (configuracion)
  (third configuracion))

;;---------------------------------------------------------------------------
;;; Todo lo anterior puede ser encapsulado en las funciones principales

;; ========================================================
;; FUNCION: duracion-ciclo
;; NATURALEZA: Pura (La suma de los mismos tres tiempos mas la extension da el mismo resultado).
;; ESTRATEGIA: Composicion Matematica (Suma los resultados de otras funciones puras y un entero constante).
;; IMPACTO: No destructiva (Solo realiza calculos aritmeticos sin alterar el entorno).
;; ========================================================

;; (FIRST (40 5 45))  ==> 40
;; (second (40 5 45)) ==> 5
;; (third (40 5 45))  ==> 45 
;; encima agrega 3 segundos

(defun duracion-ciclo (configuracion)
  (+ (obtener-tiempo-rojo configuracion)
     (obtener-tiempo-amarillo configuracion)
     (obtener-tiempo-verde configuracion) 3)) ; Extension fisica de 3 segundos solicitada por el equipo.

;; ========================================================
;; FUNCION: recomendacion-ciclo
;; NATURALEZA: Pura (Devuelve el mismo diagnostico para la misma configuracion).
;; ESTRATEGIA: Condicional (Toma decisiones logicas basadas en un calculo numerico preevaluado).
;; IMPACTO: No destructiva.
;; ========================================================
(defun recomendacion-ciclo (configuracion)
  (let ((total (duracion-ciclo configuracion)))
    (cond
      ((< total 35) 'ciclo-muy-corto-ajustar-a-alta-densidad)
      ((> total 150) 'ciclo-muy-largo-riesgo-de-congestion)
      (t 'ciclo-optimo-flujo-vehicular-eficiente))))

;; ========================================================
;; FUNCION: calcular-porcentajes-eficiencia
;; NATURALEZA: Pura (El calculo matematico no depende del entorno externo).
;; ESTRATEGIA: Secuencial / Matematica (Extrae, divide y multiplica de forma directa).
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
;;; 3. LOGICA TEMPORAL (CORE MATEMATICO)
;;; ============================================

;; ========================================================
;; FUNCION: transicion
;; NATURALEZA: Pura (Retorna el mismo mensaje siempre que reciba los mismos colores).
;; ESTRATEGIA: Condicional / Seleccion Multiple (El 'cond' evalua todas las rutas de transicion validas).
;; IMPACTO: No destructiva (Crea y retorna una lista nueva sin alterar las variables originales).
;; ========================================================
(defun transicion (color-actual cambiar-a)
  (cond
    ;; REGLA DE PERMANENCIA: Si el temporizador calcula el mismo color en el que ya esta,
    ;; se mantiene el estado de forma explicita y segura sin romper el ciclo.
    ((eq color-actual cambiar-a)
     (list color-actual "mantener-estado-actual"))

    ;; Transiciones de cambio de fase tradicionales (Orden corregido)
    ((and (eq color-actual 'rojo) (eq cambiar-a 'verde))
     (list cambiar-a "cambiar-a-verde"))

    ((and (eq color-actual 'verde) (eq cambiar-a 'amarillo-intermitente))
     (list cambiar-a "cambiar-a-amarillo-intermitente"))

    ((and (eq color-actual 'amarillo-intermitente) (eq cambiar-a 'amarillo))
     (list cambiar-a "cambiar-a-amarillo"))
     
    ((and (eq color-actual 'verde) (eq cambiar-a 'amarillo))
     (list cambiar-a "cambiar-a-amarillo"))

    ((and (eq color-actual 'amarillo) (eq cambiar-a 'rojo))
     (list cambiar-a "cambiar-a-rojo"))

    ;; Caso de resguardo definitivo
    (t
     (list color-actual "accion-por-defecto"))))

;; ========================================================
;; FUNCION: timer (REQUERIDA POR EL TEST DE LA CATEDRA)
;; NATURALEZA: Pura (Retorna siempre la misma fase vial para el mismo segundo del ciclo).
;; ESTRATEGIA: Evaluacion de Rangos Acumulativos (Usa los umbrales de tiempo para delimitar tramos).
;; IMPACTO: No destructiva.
;; ========================================================
(defun timer (time-exac configuracion)
  (let* ((t-rojo (obtener-tiempo-rojo configuracion))
         (t-verde (obtener-tiempo-verde configuracion))
         (t-amarillo (obtener-tiempo-amarillo configuracion))
         (ciclo-total (duracion-ciclo configuracion))
         (segundo-actual (mod time-exac ciclo-total)))
    (cond 
      ;; Orden Corregido: 1ro Rojo -> 2do Verde -> 3ro Amarillo
      ((< segundo-actual t-rojo) 'rojo) 
      ((< segundo-actual (+ t-rojo t-verde)) 'verde) 
      (t 'amarillo))))

;; ========================================================
;; FUNCION: timer-seguro
;; NATURALEZA: Pura (Retorna siempre la misma fase vial para el mismo segundo del ciclo).
;; ESTRATEGIA: Evaluacion de Rangos Acumulativos (Usa los umbrales de tiempo para delimitar tramos).
;; IMPACTO: No destructiva (Determina el estado simbolico a partir de calculos matematicos puros).
;; ========================================================
(defun timer-seguro (time-exac configuracion)
  (let* ((t-rojo (obtener-tiempo-rojo configuracion))
         (t-verde (obtener-tiempo-verde configuracion))
         ;; (inicio-epoch (cdr (assoc :INICIO-EPOCH configuracion))) <- Se comenta para no romper los test con listas
         (ciclo-total (duracion-ciclo configuracion))
         
         ;; IMPLEMENTACION: Aplicamos el modulo de la duracion total del ciclo.
         (segundo-actual (mod time-exac ciclo-total)))
    
    (cond
      ;; 1. Tramo Rojo
      ((< segundo-actual t-rojo) 'rojo) 
      
      ;; 2. Tramo Verde
      ((< segundo-actual (+ t-rojo t-verde)) 'verde) 
 
      ;; 3. Tramo Amarillo Intermitente (Seguridad)
      ((< segundo-actual (+ t-rojo t-verde 3)) 'amarillo-intermitente) 
      
      ;; 4. Tramo Amarillo Fijo: Caso por defecto para el resto del ciclo
      (t 'amarillo))))

;;; ========================================================
;;; 4. CAPA DE SALIDA (EFECTOS SECUNDARIOS Y PERSISTENCIA)
;;; ========================================================

;; ========================================================
;; FUNCION: formatear-fecha-auditoria
;; NATURALEZA: Pura (Para un mismo timestamp universal, devuelve siempre la misma cadena).
;; ESTRATEGIA: Descomposicion Temporal y Formateo Lineal (Usa 'decode-universal-time').
;; IMPACTO: No destructiva (Retorna un string nuevo sin alterar datos).
;; ========================================================
(defun formatear-fecha-auditoria (timestamp-universal)
  ;; decode-universal-time devuelve: (second minute hour date month year day-of-week daylight-saving-time-p timezone)
  ;; Usamos multiple-value-bind para capturar de forma inmutable los primeros 6 valores que necesitamos.
  (multiple-value-bind (seg min hora dia mes ano)
      (decode-universal-time timestamp-universal)
    ;; Formateamos con ~4,'0D para el ano (4 digitos) y ~2,'0D para garantizar 2 digitos rellenados con cero si es necesario.
    (format nil "~4,'0D-~2,'0D-~2,'0D ~2,'0D:~2,'0D:~2,'0D"
            ano mes dia hora min seg)))

;; ========================================================
;; FUNCION: informe
;; NATURALEZA: Impura (Su ejecucion afecta activamente al sistema de archivos del sistema operativo).
;; ESTRATEGIA: Secuencial con Conversion de Formato (Aplica formato legible antes de la persistencia).
;; IMPACTO: Destructiva (Modifica el estado fisico del almacenamiento mediante modo :append).
;; ========================================================
(defun informe (datos ruta-archivo)
  (with-open-file (stream ruta-archivo
                          :direction :output
                          :if-exists :append
                          :if-does-not-exist :create)
    ;; datos contiene: (segundo-real estado-validado)
    ;; Convertimos el segundo-real de simulacion (que es un Unix Timestamp) de vuelta a Universal Time de Common Lisp.
    ;; Como en tu 'main.lisp' restaste 2208988800 para pasarlo a Unix, aqui le sumamos esa misma constante para decodificarlo correctamente.
    (let ((fecha-legible (formatear-fecha-auditoria (+ (first datos) 2208988800))))
      (format stream "~%[AUDITORIA] Fecha: ~A | Estado: ~A"
              fecha-legible
              (second datos)))))

;; ========================================================
;; FUNCION: procesar-estado-seguro
;; NATURALEZA: Impura (Hereda la naturaleza de Entrada/Salida de 'informe').
;; ESTRATEGIA: Composicion Funcional y Vinculacion Vial.
;; IMPACTO: Destructiva (Genera persistencia fisica mediante append en disco).
;; ========================================================
(defun procesar-estado-seguro (time-exac estado-anterior configuracion ruta-archivo)
  (let* ((estado-calculado (timer-seguro time-exac configuracion))
         (resultado-vial (transicion estado-anterior estado-calculado)) 
         (estado-validado (first resultado-vial)))
    
    ;; Persistimos enviando el timestamp bruto; la conversion se encapsula adentro de 'informe'
    (informe (list time-exac estado-validado) ruta-archivo)
    
    estado-validado)) 
