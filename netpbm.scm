(define-module (netpbm)
  #:use-module (netpbm image)
  #:use-module (netpbm pbm)
  #:use-module (netpbm pgm)
  #:use-module (netpbm ppm)
  #:use-module (srfi srfi-1)
  #:export (draw-point
	    draw-line
	    draw-rectangle
	    write-image))

(define (draw-point image x y color)
  (array-set! (image-raster image) color y x))

(define (draw-line image start-x start-y end-x end-y color)
  (cond ((and (= start-x end-x)
	      (= start-y end-y))
	 (draw-point image start-x start-y color))
	((= start-x end-x)
	 (let ((offset (min start-y end-y))
	       (dist (abs (- end-y start-y))))
	   (array-fill! (make-shared-array (image-raster image)
					   (lambda (i)
					     (list (+ i offset)
						   start-x))
					   (list 0 dist))
			color)))
	((= start-y end-y)
	 (let ((offset (min start-x end-x))
	       (dist (abs (- end-x start-x))))
	   (array-fill! (make-shared-array (image-raster image)
					   (lambda (i)
					     (list start-y
						   (+ i offset)))
					   (list 0 dist))
			color)))
	(else
         (let* ((x-dist (- end-x start-x))
		(y-dist (- end-y start-y))
		(points (lset-union
			 equal?
			 (map
			  (lambda (x)
			    (list (+ start-x x)
				  (+ start-y
				     (round (/ (* x y-dist)
					       x-dist)))))
			  (iota (1+ (abs x-dist))
				(min 0 x-dist)))
			 (map
			  (lambda (y)
			    (list (+ start-x
				     (round (/ (* y x-dist)
					       y-dist)))
				  (+ start-y y)))
			  (iota (1+ (abs y-dist))
				(min 0 y-dist))))))
	   (for-each
	    (lambda (p)
	      (draw-point image (car p) (cadr p) color))
	    points)))))

(define (draw-rectangle image start-x start-y end-x end-y color)
  (cond ((and (= start-x end-x)
	      (= start-y end-y))
	 (draw-point image start-x start-y color))
	((or (= start-x end-x)
	     (= start-y end-y))
	 (draw-line image start-x start-y end-x end-y color))
	(else
	 (let ((x-offset (min start-x end-x))
	       (y-offset (min start-y end-y))
	       (x-dist (abs (- end-x start-x)))
	       (y-dist (abs (- end-y start-y))))
	   (array-fill! (make-shared-array (image-raster image)
					   (lambda (y x)
					     (list (+ y-offset y)
						   (+ x-offset x)))
					   (list 0 y-dist)
					   (list 0 x-dist))
			color)))))

(define (write-image image filename)
  (call-with-output-file filename
    (lambda (port)
      (cond ((pbm-image? image)
	     (write-pbm-image image port))
	    ((pgm-image? image)
	     (write-pgm-image image port))
	    ((ppm-image? image)
	     (write-ppm-image image port))
	    (else (error "Unknown image type" image))))
    #:binary #t))
