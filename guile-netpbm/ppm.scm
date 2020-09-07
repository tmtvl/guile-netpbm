(define-module (netpbm ppm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netbpm image)
  #:use-module (rnrs bytevectors)
  #:export (make-ppm-image write-ppm-image))

(define *ppm-magic-number* "P6")

(define (make-ppm-image width height maximum-color-value)
  (let ((bv-size (if (> maximum-color-value 255) 6 3)))
    (make-image *ppm-magic-number*
		width
		height
		maximum-color-value
		(make-array
		 (make-bytevector bv-size 0)
		 height width))))

(define (write-ppm-image image port)
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
