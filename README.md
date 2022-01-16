# RAIR - The Racket Automatic Image Randomizer
By Torrin, Griffin and Leo

This program facilitates the creation of NFT-like images. Users can paint and save body parts and accessories using the painter.rkt application, and then use the randomizer.rkt to generate a randomly-pieced image of those body parts with an associated rarity and random background, which can then also be saved. The painter also allows users to open existing images and touch them up.

Many options are configurable, including width and height of the canvas, image file name and location, hotkeys, and more. Hotkeys are available to generate a new image and save an image in randomizer, and choose color, brush width, save, and reset in painter. To use, simply open the file in DrRacket and click run. A (painter \<path\>) function is available to quickly open up an existing image.

Given the limitations of racket, this project was certainly a challenge, and we had a lot of fun with it. Unfortunately, functions like an eraser are just not possible given our knowledge of the language, but this can be worked around by saving the file often, allowing one to reset to the state in which the file was opened.
