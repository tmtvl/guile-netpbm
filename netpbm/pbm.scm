(define-module (netpbm pbm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netpbm image)
  #:export (make-pbm-image pbm-image? write-pbm-image))

(define *pbm-magic-number* "P4")

(define (make-pbm-image width height)
  (make-image *pbm-magic-number*
	      width
	      height
	      #f
	      (make-array #f height width)))

(define (pbm-image? image)
  (string= (image-magic-number image) *pbm-magic-number*))

(define (pbm-raster-to-u8-array raster)
  (let* ((dims (array-dimensions raster))
	 (byte-array (make-array 0 (car dims) (cadr dims)))
	 (result-array (make-array 0 (car dims)
				   (1+ (quotient (cadr dims) 8)))))
    (array-index-map! byte-array
		      (lambda (y x)
			(if (array-ref raster y x)
			    (let ((a (array-ref result-array
						y (quotient x 8)))
				  (e (expt 2 (- 7 (remainder x 8)))))
			      (array-set! result-array
					  (+ a e)
					  y
					  (quotient x 8)))
			    0)))
    result-array))

(define (write-pbm-image image port)
  (put-string port (image-magic-number image))
  (newline port)
  (format port "~a ~a"
	  (image-width image)
	  (image-height image))
  (newline port)
  (array-for-each
   (lambda (u8)
     (put-u8 port u8))
   (pbm-raster-to-u8-array
    (image-raster image)))
  (newline port))
