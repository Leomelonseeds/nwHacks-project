;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname randomizer) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #t)))
(require 2htdp/image)
(require 2htdp/universe)

;; _____________________________________________________________________________
;; DATA DEFINITIONS:

;; Class is String, one of:
;; "head", "torso", "arms", "legs"
;; Represents the body portion that the part represents.
;; Works with custom classes.


;; Part:
(define-struct part (class image chance))
;; class is String ; the body portion
;; image is Image ; the image of the portion
;; chance is Natural ; weighted rarity, where higher numbers are more common

;; RandomizerImage is image
;; Represents the currently generated image

;;______________________________________________________________________________
;; USER CONFIGURATION:

;; Part list. Add your own image parts here. Order does not matter.
;; *ENSURE THAT CHANCE is an integer > 0
(define part-list
  (list 
   (make-part "arms"
              (bitmap/url "https://art.pixilart.com/1b6e194722e1716.png") 1)
   (make-part "arms"
              (bitmap/url "https://art.pixilart.com/230253694f0a431.png") 1)
   (make-part "arms"
              (bitmap/url "https://art.pixilart.com/2a847c530cf0d22.png") 1)
   (make-part "arms"
              (bitmap/url "https://art.pixilart.com/8f34d7ff8b3151e.png") 1)
   
   (make-part "torso"
              (bitmap/url "https://art.pixilart.com/5374f2ff0f8f319.png") 1)
   (make-part "torso"
              (bitmap/url "https://art.pixilart.com/0903dfc0f4b7f4f.png") 1)
   (make-part "torso"
              (bitmap/url "https://art.pixilart.com/bc91e02dc27cc8e.png") 1)
   (make-part "torso"
              (bitmap/url "https://art.pixilart.com/123417353a02516.png") 1)
   
   (make-part "legs"
              (bitmap/url "https://art.pixilart.com/0d56bb8c5e6e559.png") 1)
   (make-part "legs"
              (bitmap/url "https://art.pixilart.com/1cbd16a015ccec5.png") 1)
   (make-part "legs"
              (bitmap/url "https://art.pixilart.com/cc8cb75525059b5.png") 1)
   (make-part "legs"
              (bitmap/url "https://art.pixilart.com/6c51812878436d2.png") 1)
   
   (make-part "head"
              (bitmap/url "https://art.pixilart.com/1a4a62ccf72a5d0.png") 1)
   (make-part "head"
              (bitmap/url "https://art.pixilart.com/2f9778f573bd86f.png") 1)
   (make-part "head"
              (bitmap/url "https://art.pixilart.com/582edbf44e31f17.png") 1)
   (make-part "head"
              (bitmap/url "https://art.pixilart.com/af0e266b0035339.png") 1)
   
   (make-part "accessory"
              (bitmap/url "https://art.pixilart.com/6b28aca5d9ed84a.png") 1)
   (make-part "accessory"
              (bitmap/url "https://art.pixilart.com/89e5514d3720269.png") 1)
   (make-part "accessory"
              (bitmap/url "https://art.pixilart.com/f6a88b9d8371d38.png") 1)
   (make-part "accessory"
              (bitmap/url "https://art.pixilart.com/dfb3a1b76fc33ba.png") 1)
   (make-part "accessory"
              empty-image 4)
   ))

;; The order that the body parts should be overlayed. This value also determines
;; which classes in the part-list is used. The first defined class will render
;; on the top layer, and the last class will be put on the bottom, and vv.
(define part-order (list "head" "torso" "arms" "legs" "accessory"))

;; Width and height of the image canvas.
(define WIDTH 1200)
(define HEIGHT 1200)

;; Potential background colors of the image. Each background has an equal chance
;; of being used in the image.
(define BACKGROUND-COLOR-LIST
  (list "white"
        "green"
        "blue"
        "yellow"
        "purple"))

;; Hotkeys
(define HOTKEY-NEW-IMAGE " ")
(define HOTKEY-SAVE "s")

;; Where and name to save liked files
(define IMAGE-PATH "images/ilikethis.png")

;; _____________________________________________________________________________
;; FUNCTIONS:

;; main
;; Signature: RandomizerImage -> RandomizerImage

(define (main ri)
  (big-bang ri
    (to-draw render-world)
    (on-key handle-key)))


;; render-world
;; Signature: RandomizerImage -> Image
;; Takes current image and renders it into the world program

(define (render-world ri)
  ri)

;; handle-key
;; Signature: RandomizerImage KeyEvent -> RandomizerImage
;; Manages creation of new images and saving liked images

(define (handle-key ri ke)
  (cond [(key=? ke HOTKEY-NEW-IMAGE) (randomizer part-list)]
        [(key=? ke HOTKEY-SAVE)
         (if (save-image ri IMAGE-PATH)
             ri
             (error "Save failed."))]
        [else ri]))

;; Signature: (listof (listof Part)) -> Image
;; Takes a list of all of the parts of the image and randomly selects
;; one of each part to be added to a (listof Image), then returns rendered img

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
            (cond [(or (< chance 1) (not (integer? chance)))
                   (error "PLEASE ENSURE EACH CHANCE VALUE FOLLOWS THE RULES")]
                  [else
                   (local [(define (f1 n) img)]
                     (append rsf3 (build-list chance f1)))]))

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
                                 (background-randomizer BACKGROUND-COLOR-LIST))]
        [else (overlay (first lop)
                       (render-image (rest lop)))]))

;; background-randomizer
;; Signature: (listof String) -> String

(define (background-randomizer los)
  (list-ref los (random (length los))))

(main (randomizer part-list))
  
