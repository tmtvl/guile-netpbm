(define-module (netpbm pgm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netpbm image)
  #:use-module (rnrs bytevectors)
  #:export (make-pgm-image pgm-image? write-pgm-image
			   rat->pgm-color))

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

(define (pgm-image? image)
  (string= (image-magic-number image) *pgm-magic-number*))

(define (rat->pgm-color image rat)
  (let ((cv (round (* (if (inexact? rat)
			  (inexact->exact rat)
			  rat)
		      (image-maxval image)))))
    (if (> (image-maxval image) 255)
	(let ((bv (make-bytevector 2)))
	  (bytevector-u16-native-set! bv 0 cv)
	  bv)
	(let ((bv (make-bytevector 1)))
	  (bytevector-u8-set! bv 0 cv)
	  bv))))

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
