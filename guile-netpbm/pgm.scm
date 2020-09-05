(define-module (netpbm pgm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:export (make-pgm-image write-pgm-image))

(define *pgm-magic-number* "P5")

(define (make-pgm-image width height maximum-gray-value)
  (let ((bv-size (if (> maximum-gray-value 255) 2 1)))
    (list *pgm-magic-number*
	  (cons width height)
	  maximum-gray-value
	  (make-array
	   (make-bytevector bv-size 0)
	   height width))))

(define (write-pgm-image image port)
  (let ((magic-number (car image))
	(width (number->string (caadr image)))
	(height (number->string (cdadr image)))
	(max-gray-value (number->string (caddr image)))
	(arr (cadddr image)))
    (put-string port magic-number)
    (put-char port #\newline)
    (put-string port width)
    (put-char port #\space)
    (put-string port height)
    (put-char port #\newline)
    (put-string port max-gray-value)
    (put-char port #\newline)
    (array-for-each
     (lambda (bv)
       (put-bytevector port bv))
     arr)
    (put-char port #\newline))
  'done)
