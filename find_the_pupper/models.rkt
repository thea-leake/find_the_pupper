#lang racket

(require data/collection)


(struct map-terrain
  (terrain-type
   player-can-occupy? )
  #:transparent
  )

(struct location ;; probably won't use this
  (terrain
   characters)
  #:transparent)

(struct character
  (creature-type
   is-player?
   is-lost-pupper?)
  #:transparent)

(define road (map-terrain "road"
                          #t))

(define bldg (map-terrain "building"
                              #f))

(define park (map-terrain "park"
                          #t))

(define player (character "human"
                          #t
                          #f))

(define pupper (character "pupper"
                          #f
                          #t))
(define map-width 16)
(define map-height 8)

(define block-size 3)
(define road-spacing (+ 1 block-size))

(define map-cell-count (* map-width map-height))

(define terrain-map
  '(
    road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg
    road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg
    road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg road bldg bldg bldg
    road road road road road road road road road road road road road road road road
    road bldg park bldg road bldg bldg bldg road bldg park bldg road bldg park bldg
    road bldg park bldg road bldg bldg bldg road bldg park park road park park bldg
    road park park park road bldg bldg bldg road bldg park bldg road bldg park bldg
    road road road road road road road road road road road road road road road road
    road bldg bldg bldg road bldg bldg bldg road park park park road bldg bldg bldg
    road bldg bldg bldg road bldg bldg bldg road park park park road bldg bldg bldg
    road bldg bldg bldg road bldg bldg bldg road bldg park bldg road bldg bldg bldg
    road road road road road road road road road road road road road road road road
         ))

(define (gen-init-location terrain)
  (location terrain '[]))

(define init-map (apply vector-immutable
                        (map gen-init-location terrain-map)))

