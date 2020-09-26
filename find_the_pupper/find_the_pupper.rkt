#lang racket

(require data/collection)


(define map-width 16)
(define map-height 8)

(define block-size 3)
(define road-spacing (+ 1 block-size))

(define map-cell-count (* map-width map-height))

;;rbbbrbbbrbbbrbbb
;;rbbbrbbbrbbbrbbb
;;rbbbrbbbrbbbrbbb
;;rrrrrrrrrrrrrrrr
;;rbbbrpbbrbbbrbbb
;;rbbbrppprbbbrbbb
;;rbbbrpbbrbbbrbbb
;;rrrrrrrrrrrrrrrr



(struct map-terrain
  (terrain-type
   player-can-occupy? )
  #:transparent
  )

(struct location ;; probably won't use this
  (index
   terrain
   characters)
  #:transparent)

(struct character
  (index
   creature-type
   is-player?
   is-lost-pupper?)
  #:transparent)

(define road (map-terrain "road"
                          #t))

(define building (map-terrain "building"
                              #f))

(define park (map-terrain "park"
                          #t))

(define player (character 0
                          "human"
                          #t
                          #f))

(define pupper (character (- map-cell-count 1)
                          "pupper"
                          #f
                          #t))

