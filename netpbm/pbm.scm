(define-module (netpbm pbm)
  #:use-module (ice-9 binary-ports)
  #:use-module (ice-9 textual-ports)
  #:use-module (netpbm image)
  #:export (make-pbm-image write-pbm-image))

(define *pbm-magic-number* "P4")

(define (make-pbm-image width height)
  (make-image *pbm-magic-number*
	      width
	      height
	      #f
	      (make-array #f height width)))

(define (bools-to-u8s bools nums)
  (do ((i 0 (1+ i))
       (l (car (array-dimensions bools)))
       (n 1 (expt 2 (- 7
		       (remainder i 8)))))
      ((>= i l))
    (if (array-ref bools i)
	(let* ((j (floor (/ i 8)))
	       (val (+ (array-ref nums j)
		       n)))
	  (array-set! nums val j)))))

(define (pbm-raster-to-u8-array raster)
  (let* ((dims (array-dimensions raster))
	 (width (ceiling (/ (cadr dims) 8)))
	 (u8a (make-typed-array 'u8 0 (car dims) width)))
    (array-slice-for-each
     1 bools-to-u8s
     raster u8a)
    u8a))

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
