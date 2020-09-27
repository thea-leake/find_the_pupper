#lang racket/gui

(require data/collection
         racket/match
         pict
         racket/draw
         "config.rkt"
         (prefix-in m: "models.rkt")
         (prefix-in i: "images.rkt"))


(define game-window
  (new frame%
       [label "Find the Pupper"]
       [height canvas-height]
       [width canvas-width]))

(define game-pane
  (new pane%
       [parent game-window]))

(define game-canvas
  (new canvas%
       [parent game-pane]
       [paint-callback (lambda (self dc)
                         (send dc
                               draw-bitmap
                               i:map-image
                               0 0))]))

(send game-window show #t)
