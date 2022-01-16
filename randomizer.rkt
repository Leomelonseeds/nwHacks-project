;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname randomizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; _____________________________________________________________________________
;; DATA DEFINITIONS:

;; Class is String, one of:
;; "head", "torso", "arms" "legs"
;; Represents the body portion the part represents.


;; Part is
(define-struct part (class image chance))
;; class is Class ; the body portion
;; image is Image ; the image of the portion
;; chance is Natural ; weighted rarity, where higher numbers are more common

;; Part list. Add your own image parts here
(define part-list
  (list 
   (make-part "head" (circle 20 "solid" "blue") 5)
   (make-part "head" (rectangle 20 10 "solid" "green") 6)
   (make-part "torso" (rectangle 10 30 "solid" "black") 1)
   (make-part "torso" (rectangle 20 30 "solid" "green") 2)
   (make-part "arms" (rectangle 30 10 "solid" "white") 3)
   (make-part "arms" (rectangle 40 10 "solid" "white") 1)
   (make-part "legs" (rectangle 10 60 "solid" "red") 5)
   (make-part "legs" (rectangle 20 70 "solid" "white") 2)
   ))

;; _____________________________________________________________________________
;; FUNCTIONS:

;; Separate function
;; Signature: (listof Part) -> (listof (listof Part))
;; Creates an array of the list of each body part


 