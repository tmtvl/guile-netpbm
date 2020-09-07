(define-module (netpbm pgm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netbpm image)
  #:use-module (rnrs bytevectors)
  #:export (make-pgm-image write-pgm-image))

(define *pgm-magic-number* "P5")

(define (make-pgm-image width height maximum-gray-value)
  (let ((bv-size (if (> maximum-gray-value 255) 2 1)))
    (make-image *pgm-magic-number*
		width
		height
		maximum-gray-value
		(make-array
		 (make-bytevector bv-size 0)
		 height width))))

(define (write-pgm-image image port)
  (put-string port (image-magic-number image))
  (newline port)
  (format port "~a ~a"
	  (image-width image)
	  (image-height image))
  (newline port)
  (put-string port (number->string
		    (image-maxval image)))
  (newline port)
  (array-for-each
   (lambda (bv)
     (put-bytevector port bv))
   (image-raster image))
  (newline port))
