(define-module (netpbm ppm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:export (make-ppm-image write-ppm-image))

(define *ppm-magic-number* "P6")

(define (make-ppm-image width height maximum-color-value)
  (let ((bv-size (if (> maximum-color-value 255) 6 3)))
    (list *ppm-magic-number*
	  (cons width height)
	  maximum-color-value
	  (make-array
	   (make-bytevector bv-size 0)
	   height width))))

(define (write-ppm-image image port)
  (let ((magic-number (car image))
	(width (number->string (caadr image)))
	(height (number->string (cdadr image)))
	(max-color-value (number->string (caddr image)))
	(arr (cadddr image)))
    (put-string port magic-number)
    (put-char port #\newline)
    (put-string port width)
    (put-char port #\space)
    (put-string port height)
    (put-char port #\newline)
    (put-string port max-color-value)
    (put-char port #\newline)
    (array-for-each
     (lambda (bv)
       (put-bytevector port bv))
     arr)
    (put-char port #\newline))
  'done)
