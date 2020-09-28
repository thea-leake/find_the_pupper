#lang racket

(provide current-turn-channel
         start-controller)

(require data/collection
         "config.rkt"
         (prefix-in m: "models.rkt"))

(define current-turn-channel (make-channel))

(define init-turn
  (gamestate m:init-map
             0
             (- map-cell-count 1)
             pupper))


(define (start)
  (channel-put current-turn-channel init-turn)
  )


(define (start-controller)
  (thread start))
