;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname randomizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; Head, body, arms, legs

;; Head is
(define-struct head (image chance))
;; image is Image ; head image
;; chance is Natural ; rarity, where higher numbers are more common

;; ListOfHead is (listof Head)

(define head1 (make-head (circle 20 "solid" "blue") 5))
(define head2 (make-head (rectangle 20 10 "solid" "green") 6))

