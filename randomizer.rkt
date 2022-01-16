;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname randomizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; _____________________________________________________________________________
;; DATA DEFINITIONS:

;; Class is String, one of:
;; "head", "torso", "arms", "legs"
;; Represents the body portion the part represents.
;; Works with custom classes.


;; Part is
(define-struct part (class image chance))
;; class is Class ; the body portion
;; image is Image ; the image of the portion
;; chance is Natural ; weighted rarity, where higher numbers are more common

;;______________________________________________________________________________
;; USER CONFIGURATION:

;; Part list. Add your own image parts here. Order does not matter
(define part-list
  (list 
   (make-part "head" (circle 20 "solid" "blue") 5)
   (make-part "torso" (rectangle 10 30 "solid" "black") 1)
   (make-part "torso" (rectangle 20 30 "solid" "green") 2)
   (make-part "arms" (rectangle 30 10 "solid" "white") 3)
   (make-part "arms" (rectangle 40 10 "solid" "white") 1)
   (make-part "legs" (rectangle 10 60 "solid" "red") 5)
   (make-part "legs" (rectangle 20 70 "solid" "white") 2)
   (make-part "head" (rectangle 20 10 "solid" "green") 6)
   ))

;; The order that the body parts should be overlayed. This value also determines
;; which classes in the part-list is used. The first defined class will render
;; on the top layer, and the last class will be put on the bottom, and vv.
(define part-order (list "head" "torso" "arms" "legs"))

;; Width and height of the image canvas.
(define WIDTH 400)
(define HEIGHT 400)

;; Background color of the image.
(define BACKGROUND-COLOR "white")

;; _____________________________________________________________________________
;; FUNCTIONS:

;; separate
;; Signature: (listof Part) -> (listof (listof Part))
;; Creates an list of the list of each body part

(define (separate lop)
  (local
    [(define (fn-for-part-list los)
       (cond [(empty? los) empty]
             [else (local [(define (p? n)
                             (string=? (first los) (part-class n)))]
                     (cons (filter p? lop)
                           (fn-for-part-list (rest los))))]))]
    (fn-for-part-list part-order)))


;; render-image
;; Signature: (listof Part) -> Image

(define (render-image lop)
  (cond [(empty? lop) (rectangle WIDTH
                                 HEIGHT
                                 "solid"
                                 BACKGROUND-COLOR)]
        [else (overlay (part-image (first lop))
                       (render-image (rest lop)))]))

; (render-image (first (separate part-list)))
  
