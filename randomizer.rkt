;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname randomizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; _____________________________________________________________________________
;; DATA DEFINITIONS:

;; Head, body, arms, legs



;; Head is
(define-struct head (image chance))
;; image is Image ; head image
;; chance is Natural ; rarity %, where higher numbers are more common

(define head1 (make-head (circle 20 "solid" "blue") 5))
(define head2 (make-head (rectangle 20 10 "solid" "green") 6))

;; Body is
(define-struct body (image chance))
;; image is Image ; body image
;; chance is Natural; rarity %, where higher numbers are more common
(define (make-head (circle 15 "solid" "blue") 10))

;; Arms is
(define-struct arms (image chance))
;; image is Image ; arms image
;; chance is Natural; rarity %, where higher numbers are more common
(define (make-head (circle 15 "solid" "blue") 10))

;; Legs is
(define-struct legs (image chance))
;; image is Image ; legs image
;; chance is Natural; rarity %, where higher numbers are more common
(define (make-head (circle 15 "solid" "blue") 10))

