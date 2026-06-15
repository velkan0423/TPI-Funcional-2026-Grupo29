;; Archivo principal del proyecto
Ejercicio-1:
;; ========================================================
;; FUNCIÓN: transicion
;; NATURALEZA: Pura (Dada una cierta condincion, imprime un mensaje)
;; ESTRATEGIA: Estrategia Condicional (El cond gobierna todo el resultado a modo tal que los datos ingresados son evaluados directamente)
;; IMPACTO: No destructiva
;; ========================================================

(defun transicion (color-actual cambia-a)
	(cond
		((and (eq color-actual 'en-rojo) (eq cambia-a 'intermitente-rojo)) ;;Rojo llega a intermitencia.
			(list color-actual "cambiar-a-intermitente-rojo"))
		((and (eq color-actual 'intermente-rojo) (eq cambia-a 'verde))   ;;Rojo en intermitencia llega a verde.
			(list color-actual "cambiar-a-verde"))

		((and (eq color-actual 'en-verde) (eq cambia-a 'intermitente-verde))   ;;Verde llega a intermitencia.
			(list color-actual "cambiar-a-intermitente-verde"))
		((and (eq color-actual 'intermitente-verde) (eq cambia-a 'amarillo))   ;;Verde llega a amarillo.
			(list color-actual "cambiar-a-amarilla"))

		((and (eq color-actual 'en-amarillo) (eq cambia-a 'intermitente-amarillo))   ;;Amarillo llega a intermitencia.
			(list color-actual "cambiar-a-intermitente-amarillo"))
		((and (eq color-actual 'intermitente-amarillo) (eq cambia-a 'rojo))   ;;Amarillo llega a rojo.
			(list color-actual "cambiar-a-rojo"))

		(t (list (color-actual 'transcicion-invalida)));;caso en el que el color ingresado sea distinto al del semaforo
	)
) 

Ejercicio-2:
;; ========================================================
;; FUNCIÓN: time-exac
;; NATURALEZA: Impura (recibe parametros que constantemente cambian)
;; ESTRATEGIA: Orden Superior (Trabaja en conjunto con otras funciones)
;; IMPACTO: No destructiva
;; ========================================================

(defun obtener-timeexac ()
(- (get-universal-time) 2208988800))

(defun timer(time-exac)
	;;let* sirve para lo que se realice dentro del let sea de forma secuencial o bien usamos el "progn".
	(let* (
		(duracion-rojo 90)
		(duracion-intermitente-rojo 3)			;;Asignamos los valores a las variables correspondientes.
		(duracion-verde 120)
		(duracion-intermitente-verde 3)
		(duracion-amarillo 6)
		(duracion-intermitente-amarillo 3)
		(ciclo-total (+ duracion-rojo duracion-intermitente-rojo duracion-verde duracion-intermitente-verde
		duracion-amarillo duracion-intermitente-amarillo))
		(segundo-actual (mod time-exac ciclo-total))	;;Hallamos el segundo actual en el que esta el semaforo para. saber su color correspondiente al momento
	)
		(cond 		;;Buscamos el color actual
            ((< segundo-actual 90) 'rojo)
            ((< segundo-actual 93) 'intermitente-rojo)
            ((< segundo-actual 99) 'amarillo)
            ((< segundo-actual 102) 'intermitente-amarillo)
            ((< segundo-actual 222) 'verde
            (t 'intermitente-verde)
		)
	)
)
Ejercicio-3:
;; ========================================================
;; FUNCIÓN: registro-semaforo
;; NATURALEZA: Impura (Imprime resultados en pantalla)
;; ESTRATEGIA: Secuencial (Ejecucion directa de las instrucciones)
;; IMPACTO: No destructiva
;; ========================================================

(defun registro-semaforo(timer-unix color-anterior color-nuevo)   ;;Decimos el momento exacto en el que el semaforo cambio su color de uno a siguiente y cuales fueron estos". 
	(format t "el tiempo ~A: la luz ha cambiado de ~A a ~A~%" timer-unix color-anterior color-nuevo)
)

Ejercicio-4:
;; ========================================================
;; FUNCIÓN: duracion-ciclo
;; NATURALEZA: Pura (No altera nada)
;; ESTRATEGIA: Orden Superior (LLama a otra funcion durante su ejecucion)
;; IMPACTO: No destructiva
;; ========================================================

(defun duracion-ciclo (rojo amarillo verde)
		(recomendacion-ciclo (+ rojo amarillo verde)) ;;Se suma la cantidad de segundos que dura cada color para caluclar el valor de un ciclo
)

(defun recomendacion-ciclo (total-seg)
	(cond 
		((< total-seg 35) 'el-ciclo-esta-por-debajo-de-lo-recomendado)
		((> total-seg 150) 'el-ciclo-esta-por-encima-de-lo-recomendado)
		(t 'el-ciclo-esta-dentro-de-lo-recomendado)
	)
)
Ejercicio-5:
;; ========================================================
;; FUNCIÓN: ciclo-por-tiempo
;; NATURALEZA: Pura (mantiene los mismos parametros)
;; ESTRATEGIA: Secuencial (ejecuta cada tarea de manera lineal)
;; IMPACTO: No destructiva
;; ========================================================

(defun ciclos-por-tiempo (minutos)
	(values (truncate (* minutos 60) 225)) ;; La funcion Values se encarga de eliminar el sobrante que resta luego del 0 o bien el 0
)

Ejercicio-6:

;; ========================================================
;; FUNCIÓN: porcentaje
;; NATURALEZA: Pura (Mantiene los mismos parametros)
;; ESTRATEGIA: Orden Superior (Trabaja en conjunto con otras funciones)
;; IMPACTO: Destructiva (no altera la informacion original)
;; ========================================================

(defun porcentaje (hora)
    (list ;;aplicamos regla de 3 simples a cada uno de los colores para sacar su porcentaje
        'rojo (float (/ (* (contador-rojo hora) 100) hora))
        'amarillo (float (/ (* (contador-amarillo hora) 100) hora))
        'verde (float (/ (* (contador-verde hora) 100) hora))
    )
)

(defun contador-rojo (hora)
    (cond
        ((<= hora 0) 0)
        ((< hora 93) hora) ;;Los segundos que quedan por debajo de los 93seg se suman automaticamente              
        ((<= hora 225) 93) ;;Los segundos que quedan por debajo de 225 (ciclo rojo + ciclo verde) hacen que automaticamente se sumen 93 al total debido a que eso le corresponde al rojo            
        ((> hora 0) (+ 93 (contador-rojo (- hora 225))))
    )
)

(defun contador-amarillo (hora)
    (cond
        ((<= hora 0) 0)
        ((<= hora 93) 0) ;;Si los segundos estan por debajo a los 93 no se suma nada debido a que le corresponde a otro color              
        ((< hora 102) (- hora 93)) ;;Los segundos que queden por encima de los 93 seran sumando al ciclo del amarillo     
        ((> hora 0) (+ 9 (contador-amarillo (- hora 225))))
    )
)

(defun contador-verde (hora)
    (cond
        ((<= hora 0) 0)
        ((<= hora 102) 0) ;;Los segundos por debajo de los 102 ya no seran contados ya que eso corresponde a otros dos ciclos (rojo + amarillo)
        ((< hora 225) (- hora 102)) ;;Los segundos por encima de los 102 seran sumandos ya que corresponde a el color verde, pero estos deben estar por debajo de 225 (un ciclo completo)    
        ((> hora 0) (+ 123 (contador-verde (- hora 225))))
    )
)
