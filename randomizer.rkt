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

;; Signature: (listof (listof Part)) -> (listof Image)
;; Takes a list of all of the parts of the image and randomly selects
;; one of each part to be added to a (listof Image)

(define (randomizer lop1)
  (local [(define (randomizer lolop rsf)
            ;; rsf is (listof Image) ; listof chosen images so far
            (cond [(empty? lolop) (render-image rsf)]
                  [else
                   (randomizer (rest lolop)
                               (cons
                                (randomizer-lop (first lolop) empty)
                                rsf))]))

          ;; Signature: (listof Part) (listof Image) -> (listof Image)
          ;; Goes from multiple listof Part to listof Image
          (define (randomizer-lop lop rsf2)
            ;; rsf2 is (listof Image)
            (cond [(empty? lop)
                   (chose-random rsf2)]
                  [else
                   (randomizer-lop (rest lop)
                                   (randomizer-p (part-chance (first lop))
                                                 (part-image (first lop))
                                                 rsf2))]))
          ;; Signature: Natural Image (listof Image) -> (listof Image)
          (define (randomizer-p chance img rsf3)
            (local [(define (f1 n) img)]
              (append rsf3 (build-list chance f1))))

          ;; Signature: (listof Image) -> Image
          ;; Takes in a listof Image and produces a single random chance image
          (define (chose-random loi)
            (list-ref loi (random (length loi))))]
    (randomizer (separate lop1) empty)))

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
        [else (overlay (first lop)
                       (render-image (rest lop)))]))

; (render-image (first (separate part-list)))
  
