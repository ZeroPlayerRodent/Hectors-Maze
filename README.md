# Hector's Maze
Is a classic-style arcade maze game with a medieval fantasy theme

![screenshot-1](https://github.com/ZeroPlayerRodent/Hectors-Maze/blob/main/screenshots/screenshot-1.png)

## How to build from source

First make sure you have these libraries installed:
* [Sketch](https://github.com/vydd/sketch)
* [Harmony](https://github.com/Shirakumo/harmony)
* [Deploy](https://github.com/Shinmera/deploy)

Then load and run `build-game.lisp` in [SBCL](https://www.sbcl.org/) or another compatible Lisp.

This should create a new directory called `bin` with the game executable and shared libraries inside.

Copy or move the `img`, `sfx` and `res` directories to the new `bin` directory.

Now the game is built! Open the finished executable to play the game.
