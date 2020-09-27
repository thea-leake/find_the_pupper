#lang racket

(provide road
         bldg
         park
         human
         pupper
         player-list
         map-width
         map-height
         map-cell-count
         terrain-map
         cell-pixel-dim
         canvas-height
         canvas-width
         (struct-out map-terrain)
         (struct-out location)
         (struct-out character)
         (struct-out gamestate)
         (struct-out turnresponse))

(struct map-terrain
  (terrain-type
   enerable? )
  #:transparent
  )

(struct location
  (terrain
   characters)
  #:transparent)

(struct character
  (creature-type
   is-player?
   is-lost-pupper?)
  #:transparent)

(struct gamestate
  (current-map
   human-location
   pupper-location
   current-player)
  #:transparent)

(struct turnresponse
  (gamestate
   ok?
   message)
  #:transparent)

(define road (map-terrain "road"
                          #t))

(define bldg (map-terrain "building"
                              #f))

(define park (map-terrain "park"
                          #t))

(define human (character "human"
                          #t
                          #f))

(define pupper (character "pupper"
                          #f
                          #t))

(define player-list (list human pupper))
(define map-width 16)
(define map-height 12)

(define map-cell-count (* map-width map-height))

(define cell-pixel-dim 50)

(define canvas-height (* map-height cell-pixel-dim))
(define canvas-width (* map-width cell-pixel-dim))

(define terrain-map
  (list
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