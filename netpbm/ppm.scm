(define-module (netpbm ppm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netpbm image)
  #:use-module (rnrs bytevectors)
  #:export (make-ppm-image ppm-image? write-ppm-image
			   rats->ppm-color))

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

(define (ppm-image? image)
  (string= (image-magic-number image) *ppm-magic-number*))

(define (rats->ppm-color image red green blue)
  (let ((rval (round (* (if (inexact? red)
			  (inexact->exact red)
			  red)
		      (image-maxval image))))
	(gval (round (* (if (inexact? green)
			  (inexact->exact green)
			  green)
		      (image-maxval image))))
	(bval (round (* (if (inexact? blue)
			  (inexact->exact blue)
			  blue)
		      (image-maxval image)))))
    (if (> (image-maxval image) 255)
	(let ((bv (make-bytevector 6)))
	  (bytevector-u16-native-set! bv 0 rval)
	  (bytevector-u16-native-set! bv 2 gval)
	  (bytevector-u16-native-set! bv 4 bval)
	  bv)
	(let ((bv (make-bytevector 3)))
	  (bytevector-u8-set! bv 0 rval)
	  (bytevector-u8-set! bv 1 gval)
	  (bytevector-u8-set! bv 2 bval)
	  bv))))

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
