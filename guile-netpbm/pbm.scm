(define-module (netpbm pbm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-43)
  #:export (make-pbm-image write-pbm-image))

(define *pbm-magic-number* "P4")

(define bit-values '(128 64 32 16 8 4 2 1))

(define (make-pbm-image width height)
  (list *pbm-magic-number*
	(cons width height)
	(make-vector
	 height (make-bitvector width #f))))

(define (pad-bitvector vec)
  (let ((add (- 8
		(remainder (bitvector-length vec)
			   8))))
    (list->bitvector
     (append (bitvector->list vec)
	     (make-list add #f)))))

(define (bitvector->u8 vec)
  (define (split-and-sum lst)
    (if (null? lst)
	'()
	(cons (apply +
		     (map (lambda (bit val)
			    (if bit val 0))
			  (list-head lst 8)
			  bit-values))
	      (split-and-sum (list-tail lst 8)))))
  (split-and-sum (bitvector->list vec)))

(define (write-pbm-image image port)
  (let ((magic-number (car image))
	(width (number->string (caadr image)))
	(height (number->string (cdadr image)))
	(vecs (caddr image)))
    (put-string port magic-number)
    (put-char port #\newline)
    (put-string port width)
    (put-char port #\space)
    (put-string port height)
    (put-char port #\newline)
    (vector-for-each
     (lambda (i vec)
       (for-each (lambda (x)
		   (put-u8 port x))
		 (bitvector->u8 (pad-bitvector vec))))
     vecs)
    (put-char port #\newline))
  'done)
