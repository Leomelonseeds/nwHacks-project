;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname painter) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; A program allowing users to paint their own body parts

;; _____________________________________________________________________________
;; DATA DEFINITIONS:

;; We need brush width, mode (circle/rectangle), color
;; Canvas is
(define-struct canvas (image brush_width mode color))
;; image is Image ; current state of canvas
;; brush_width is Natural ; width of brush mode
;; mode is one of square or circle ; images on screen
;; color is any avaliable color enum or (make-color r g b a)

;; _____________________________________________________________________________
;; USER VARIABLES:

(define WIDTH 400)
(define HEIGHT 400)

;; Change default-image to (bitmap/file "image.png") to open existing project
(define default-image (bitmap/file "image.png"))
; (define default-image (rectangle WIDTH HEIGHT "solid" "transparent"))
(define default-brush_width 2)
(define default-mode square)
(define default-color "green")

(define default-canvas (make-canvas default-image
                                    default-brush_width
                                    default-mode
                                    default-color))

;; _____________________________________________________________________________
;; FUNCTIONS:

;; main function, uses big bang
;; Signature: canvas -> canvas

(define (main c)
  (big-bang c
    (to-draw render-canvas)
    (on-mouse handle-mouse)
    (on-key handle-key)))


;; render-canvas
;; Signature: Canvas -> Image

(define (render-canvas c)
  (canvas-image c))

;; handle-mouse
;; Signature: Canvas Integer Integer MouseEvent -> Canvas

(define (handle-mouse c x y me)
  (cond [(or (mouse=? me "button-down") (mouse=? me "drag"))
         (make-canvas (place-image ((canvas-mode c)
                                    (canvas-brush_width c)
                                    "solid"
                                    (canvas-color c))
                                   x y
                                   (canvas-image c))
                      (canvas-brush_width c)
                      (canvas-mode c)
                      (canvas-color c))]
        [else c]))

;; handle-key
;; Signature: Canvas KeyEvent -> Canvas

(define (handle-key c ke)
  (cond [(key=? ke "s")
         (if (save-image (canvas-image c) "image.png")
             c
             (error "Save failed."))]
        [else c]))


(main default-canvas)