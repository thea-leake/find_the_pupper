#lang racket

(provide init-map
         get-row
         (struct-out map-terrain)
         (struct-out location)
         (struct-out character))

(require data/collection
         racket/match)


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


(define (gen-init-location terrain)
  (location terrain (set)))


(define init-map (apply vector-immutable
                        (map gen-init-location terrain-map)))


(define (toggle-player player)
  (if (eq? player human)
      pupper
      human))


(define (toggle-player-turn turn)
  (struct-copy gamestate turn
               [current-player
                (toggle-player (gamestate-current-player turn))]))


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


(define (same-axis? fn)
  (lambda (index1 index2)
    (= (fn index1)
       (fn index2))))


(define same-row? (same-axis? index-row))
(define same-column? (same-axis? index-column))


(define (axis-move-check check-fn)
  (lambda (from to)
    (and (in-range? to)
         (check-fn from to))))


(define horizontal-move-check (axis-move-check same-row?))
(define vertical-move-check (axis-move-check same-column?))


(define (location-occupiable? current-map index)
  (map-terrain-enerable?
   (location-terrain
    (nth current-map index))))


;; depending on what's provided out this will probably be redundant
(define (move-1-away? from to)
  (or (= 1
         (abs (- from to)))
      (= map-width
         (abs (- from to)))))


(define (valid-move current-map from to)
  (and (or (horizontal-move-check from to)
           (vertical-move-check from to))
   (move-1-away? from to)
   (location-occupiable? current-map to)))


(define (get-player-location turn)
  (let ([player (gamestate-current-player turn)])
    (match player
      [human  (gamestate-human-location turn)]
      [pupper (gamestate-pupper-location turn)])))


(define (update-player-location turn to)
  (let ([player (gamestate-current-player turn)])
    (match player
      [human  (struct-copy gamestate turn
                           [human-location to])]
      [pupper (struct-copy gamestate turn
                           [pupper-location to])])))


(define (move-updated turn to)
  (turnresponse (toggle-player-turn
                 (update-player-location turn to))
                #t ""))

(define (move-failed turn)
  (turnresponse turn
                #f
                "You can't move there"))

(define (move-player move-fn turn)
  (let* ([from (get-player-location turn)]
         [to (move-fn from)])
    (cond
      ((valid-move (gamestate-current-map turn)
                              from
                              to)
       (move-updated turn to))
      (else (move-failed turn)))))


(define (move fn increment)
  (lambda (turn)
    (move-player (lambda (from)
                   (fn from increment))
                 turn)))


(define move-left (move - 1))
(define move-right (move + 1))
(define move-up (move + map-width))
(define move-down (move + map-width))
