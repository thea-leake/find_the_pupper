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
  (println (channel-try-get current-turn-channel))
  (println "updating channel")
  (channel-put current-turn-channel init-turn)
  (println "updated channel")
  )


(define (start-controller)
  (thread start))
