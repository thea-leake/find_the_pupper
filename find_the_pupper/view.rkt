#lang racket/gui

(require data/collection
         racket/match
         pict
         racket/draw
         "config.rkt"
         (prefix-in m: "models.rkt")
         (prefix-in i: "images.rkt")
         (prefix-in c: "controller.rkt"))


(define game-window
  (new frame%
       [label "Find the Pupper"]
       [height canvas-height]
       [width canvas-width]))

(define game-pane
  (new pane%
       [parent game-window]))

(c:start-controller)

(define memoized-image
  (i:update-map (channel-get c:current-turn-channel)))


(define (update-memoized-image image)
  (set! memoized-image image)
  image)


(define (update-image)
  (let ([maybe-new-image (channel-try-get c:current-turn-channel)])
    (if maybe-new-image
        (update-memoized-image)
        memoized-image)))


(define (update-canvas self dc)
  (send dc
        draw-bitmap
        (update-image)
        0 0))


(define game-canvas
  (new canvas%
       [parent game-pane]
       [paint-callback update-canvas]))


(send game-window show #t)
