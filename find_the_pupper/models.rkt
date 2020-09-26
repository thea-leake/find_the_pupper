#lang racket

(provide init-map
         get-row
         (struct-out map-terrain)
         (struct-out location)
         (struct-out character))

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
(define map-height 12)

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


(define (get-row current-map row)
  (subsequence current-map
               (* (- row 1) map-width)
               (* row map-width)))

(define (get-column current-map row)
  (apply vector-immutable
         (map (lambda (x) (nth current-map (+ row x)))
              (range map-height))))

(define (in-range? index)
  (and (< index map-cell-count)
       (>= index 0)))

(define (index-row index)
  (quotient index map-width))

(define (index-column index)
  (remainder index map-width))

(define (same-axis? fn index1 index2)
  (= (fn index1)
     (fn index2)))

(define (same-row? index1 index2)
  (same-axis? index-row index1 index2))

(define (same-column? index1 index2)
  (same-axis? index-column index1 index2))

(define (horizontal-move-check from to)
  (and (in-range? to)
       (same-row? from to)))
