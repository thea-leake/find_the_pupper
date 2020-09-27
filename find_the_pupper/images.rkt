#lang racket/gui

(provide map-image)

(require images/compile-time
         (for-syntax data/collection
                     2htdp/image
                     (only-in pict
                              pict->bitmap)
                     (prefix-in m: "models.rkt")
                     "config.rkt"))

(begin-for-syntax
  (define (build-cell-image color)
    (square cell-pixel-dim "solid" color))


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

  (define base-map-bitmap (pict->bitmap base-map-image)))

(define map-image (compiled-bitmap base-map-bitmap))
