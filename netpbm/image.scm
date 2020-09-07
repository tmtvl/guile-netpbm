(define-module (netpbm image)
  #:use-module (srfi srfi-9)
  #:export (make-image
	    image?
	    image-magic-number
	    set-image-magic-number!
	    image-width
	    set-image-width!
	    image-height
	    set-image-height!
	    image-maxval
	    set-image-maxval!
	    image-raster
	    set-image-raster!))

(define-record-type <image>
  (make-image magic-number width height maxval raster)
  image?
  (magic-number image-magic-number set-image-magic-number!)
  (width image-width set-image-width!)
  (height image-height set-image-height!)
  (maxval image-maxval set-image-maxval!)
  (raster image-raster set-image-raster!))
