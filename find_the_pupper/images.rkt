#lang racket/gui

(provide base-map-image
         update-map)

(require images/compile-time
         2htdp/image
         (only-in pict
                  pict->bitmap)
         "config.rkt"
         (prefix-in m: "models.rkt")
         (for-syntax data/collection
                     2htdp/image
                     (only-in pict
                              pict->bitmap)
                     (prefix-in m: "models.rkt")
                     "config.rkt"))

(begin-for-syntax
  (define (build-cell-image color)
    (square cell-pixel-dim "solid" color))

  (define (build-character-image color)
    (pict->bitmap (circle (/ cell-pixel-dim 4)
                          "solid"
                          color)))


  (define terrain-pic-mappings
    (hash
     bldg (build-cell-image "magenta")
     park (build-cell-image "green")
     road (build-cell-image "darkgrey")))

  (define (get-terrain-mapping cell)
    (hash-ref terrain-pic-mappings
              (location-terrain cell)))

  (define (build-row-image row)
    (apply beside
           (map get-terrain-mapping
                (m:get-row m:init-map row))))

  (define base-map-image
    (apply above
           (map build-row-image
                (range 1 (+ 1 map-height)))))

  (define base-map-bitmap (pict->bitmap base-map-image))
  (define pupper-bitmap (build-character-image "tan"))
  (define human-bitmap (build-character-image "purple"))
  )

(define base-map-image (compiled-bitmap base-map-bitmap))
(define pupper-image (compiled-bitmap pupper-bitmap))
(define human-image (compiled-bitmap human-bitmap))

(define (get-dim-pixel-offset dimension)
  (lambda (row/colmn)
    (* cell-pixel-dim
       (remainder row/colmn dimension))
    ))

(define get-row-offset (get-dim-pixel-offset map-height))
(define get-column-offset (get-dim-pixel-offset map-width))

(struct coords
  (row column)
  #:transparent)

(define (update-map-image map-image character-image row/column)
  (let ([x-offset (get-column-offset (coords-column row/column))]
        [y-offset (get-row-offset (coords-row row/column))])
    (displayln x-offset)
    (displayln y-offset)
    (pict->bitmap
     (underlay/xy map-image
                 x-offset
                 y-offset
                 character-image))))


(define (index->coords index)
  (coords (m:index-row index)
          (m:index-column index)))


(define (update-map turn)
  (let* ([pupper-coords (index->coords (gamestate-pupper-location turn))]
         [human-coords (index->coords (gamestate-human-location turn))])
    (update-map-image (update-map-image base-map-image
                                        pupper-image
                                        pupper-coords)
                      human-image
                      human-coords)))
