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
;; eraser is Boolean ; whether eraser is enabled

;; _____________________________________________________________________________
;; USER VARIABLES:

(define WIDTH 1200)
(define HEIGHT 1200)

(define IMAGE-PATH "images/image.png")

;; Define a custom color by using (make-color r g b a)
;; No duplicates please
(define COLORS (list "red"
                     "light red"
                     "goldenrod"
                     "yellow"
                     "green"
                     "cyan"
                     "light turquoise"
                     "turquoise"
                     "blue"
                     "pink"
                     "purple"
                     "white"
                     "gray"
                     "black"
                     ))

;; Hotkeys
(define HOTKEY-SAVE "s")
;; Resets state to default-image, instead of clearing
;; Racket is stupid and won't let you mask a transparent image
;; this has removed my ability to implement an eraser.
;; Use reset and save often if you want to make changes
(define HOTKEY-RESET "escape")
(define HOTKEY-TOGGLE_MODE " ")
(define HOTKEY-CYCLE_COLOR_RIGHT "right")
(define HOTKEY-CYCLE_COLOR_LEFT "left")
(define HOTKEY-INCREASE_BRUSH_SIZE "up")
(define HOTKEY-DECREASE_BRUSH_SIZE "down")


;; Change default-image to (bitmap/file "image.png") to open existing project
; (define default-image (bitmap/file "image.png"))
(define default-image (rectangle WIDTH HEIGHT "solid" "transparent"))
(define default-brush_width 2)
;; Must be either square or circle
(define default-mode square)
;; Must be defined in COLORS
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
  (overlay/align "left" "top"
                 (overlay (text (number->string (canvas-brush_width c))
                                10 "black")
                          ((canvas-mode c) (+ (canvas-brush_width c) 10)
                                           "solid"
                                           (canvas-color c)))
                 (canvas-image c)))

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
  (cond [(key=? ke HOTKEY-SAVE)
         (if (save-image (canvas-image c) IMAGE-PATH)
             c
             (error "Save failed."))]
        [(key=? ke HOTKEY-TOGGLE_MODE)
         (make-canvas (canvas-image c)
                      (canvas-brush_width c)
                      (if (f-equal? (canvas-mode c) square)
                          circle
                          square)
                      (canvas-color c))]
        [(key=? ke HOTKEY-RESET)
         (make-canvas default-image
                      (canvas-brush_width c)
                      (canvas-mode c)
                      (canvas-color c))]
        [(key=? ke HOTKEY-CYCLE_COLOR_RIGHT)
         (make-canvas (canvas-image c)
                      (canvas-brush_width c)
                      (canvas-mode c)
                      (cycle-right (canvas-color c)))]
        [(key=? ke HOTKEY-CYCLE_COLOR_LEFT)
         (make-canvas (canvas-image c)
                      (canvas-brush_width c)
                      (canvas-mode c)
                      (cycle-left (canvas-color c)))]
        [(key=? ke HOTKEY-INCREASE_BRUSH_SIZE)
         (make-canvas (canvas-image c)
                      (add1 (canvas-brush_width c))
                      (canvas-mode c)
                      (canvas-color c))]
        [(key=? ke HOTKEY-DECREASE_BRUSH_SIZE)
         (make-canvas (canvas-image c)
                      (if (< (canvas-brush_width c) 2)
                          1
                          (sub1 (canvas-brush_width c)))
                      (canvas-mode c)
                      (canvas-color c))]
        [else c]))

;; cycle-right
;; Signature: String -> String
;; selects next color in colors list, circle back if last color

(define (cycle-right c)
  (local [(define (fn-for-loc loc c)
            (cond [(empty? loc) (error "Your color list is empty!")]
                  [else (if (string=? (first loc) c)
                            (if (empty? (rest loc))
                                (first COLORS)
                                (first (rest loc)))
                            (fn-for-loc (rest loc) c))]))]
    (fn-for-loc COLORS c)))

;; cycle-left
;; Signature: String -> String
;; selects last color in colors list, circle forward if first color

(define (cycle-left c)
  (local [(define (fn-for-loc loc c last-color)
            (cond [(empty? loc) (error "Your color list is empty!")]
                  [else (if (string=? (first loc) c)
                            (if (string=? last-color "")
                                (select-last-color COLORS)
                                last-color)
                            (fn-for-loc (rest loc) c (first loc)))]))]
    (fn-for-loc COLORS c "")))

;; select-last-color
;; Signature: (listof Color) -> String
;; finds last color of the list

(define (select-last-color loc)
  (cond [(empty? loc) (error "Your color list is empty!")]
        [else (if (empty? (rest loc))
                  (first loc)
                  (select-last-color (rest loc)))]))

;; f-equal?
;; Signature: x y -> Boolean, x and y both functions
;; Compares two image functions to see if equal

(define (f-equal? x y)
  (equal? (x 1 "solid" "white")
          (y 1 "solid" "white")))


(main default-canvas)