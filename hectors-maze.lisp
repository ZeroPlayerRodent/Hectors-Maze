(defpackage :mazegame
  (:use :cl :sketch :org.shirakumo.fraf.harmony)
  (:export :main)
)

(in-package :mazegame)

(defclass enemy ()
  (
    (x :initarg :x :initform 0 :accessor x)
    (y :initarg :y :initform 0 :accessor y)
    (wait :initarg :wait :initform 100 :accessor wait)
    (top :initarg :top :initform 20 :accessor top)
  )
)

(defvar start-screen 1)

(defvar init-width 30)
(defvar init-height 30)

(defun reset ()

(setq spells 3)

(setq died 0)
(setq score 0)

(setq width init-width)
(setq height init-height)

(setq enemies (list
(make-instance 'enemy :x 1 :y 1 :wait 100)
))

(setq foo (list (make-list width :initial-element 1)))
(setf foo (append foo (list (make-list width :initial-element 0)) ))

(setf (elt (elt foo 1) 0) 1)
(setf (elt (elt foo 1) (- width 1)) 1)

(setq bar '(1))

(dotimes (y (- height 2))
  (dotimes (x (- width 2))
    (if (= (random 4 (make-random-state t)) 0)
      (setf bar (append bar (list 1)))
      (progn
        (setf bar (append bar (list 0)))
        (when (and (= (random 25 (make-random-state t)) 0) (= (elt (elt foo y) x) 0))
          (setf enemies (append enemies (list (make-instance 'enemy :x x :y y :wait 100))))
        )
      )
    )
  )
  (setf bar (append bar (list 1)))
  (setf foo (append foo (list bar)))
  (setf bar (list 1))
)

(setf foo (append foo (list (make-list width :initial-element 0)) ))
(setf foo (append foo (list (make-list width :initial-element 1)) ))

(setf (elt (elt foo height) 0) 1)
(setf (elt (elt foo height) (- width 1)) 1)

(let ((x (+ (random (- (length (elt foo 0)) 2) (make-random-state t)) 1))(y (- (length foo) 2)))
  (loop
    (setf (elt (elt foo y) x) 0)
    (when (and (> x 2)(< x (- width 2)))
    (if (= (random 2 (make-random-state t)) 0)
      (if (= (random 2 (make-random-state t)) 0)
        (progn (setf x (+ x 1)) (setf (elt (elt foo y) x) 0))
        (progn (setf x (- x 1)) (setf (elt (elt foo y) x) 0))
      )
    )
    )
    (setf y (- y 1))
    (when (= y 1)(return))
  )
)

(setq player-x (truncate (/(length (elt foo 0)) 2)))
(setq player-y (- (length foo) 2))
(setq offset-x player-x)
(setq offset-y player-y)

(setq ghost-x (truncate (/ width 2)))
(setq ghost-y (truncate (/ height 2)))
(setq ghost-wait 50)
(setq ghost-top 50)
(setq ghost-inc 100)
(setq ghost-inc-top 100)

)

(reset)

(defmacro the-enemy ()
  '(elt enemies i)
)


(defsketch mazegame
  (
   (title "Hector's Maze")
   (width 640)
   (height 640)
   (stone (load-resource "img/tile.png"))
   (ground (load-resource "img/cobble.png"))
   (helmet (load-resource "img/helmet.png"))
   (skull (load-resource "img/skull.png"))
   (ghost (load-resource "img/ghost.png"))
   (logo (load-resource "img/logo.png"))
   (bg (load-resource "img/BG.png"))
  )
  
  (defun over ()
     (with-pen (make-pen :fill bg :stroke nil)
       (rect 0 0 640 640)
     )
     (rect 200 150 287 200)
     (text "YOU LOSE!!!" 250 150)
     (text (write-to-string score) 250 200)
     (text
"Press 1 for small maze
Press 2 for medium maze
Press 3 for large maze" 250 250)
   )
   
  (defun title-screen ()
     (with-pen (make-pen :fill bg :stroke nil)
       (rect 0 0 640 640)
     )
     (with-pen (make-pen :fill logo :stroke nil)
       (rect 150 100 300 65)
     )
     (rect 150 300 287 125)
     (text
"Press 1 for small maze
Press 2 for medium maze
Press 3 for large maze" 175 333)
   )
  
  (background (rgb 0 0 0))
  
  (setf offset-y (-(* player-y 32)(* 32 10)))
  (setf offset-x (-(* player-x 32)(* 32 10)))
  
  (let ((i 0))
    (loop
      (let ((a 0))
        (loop
          (when (= (elt (elt foo i) a) 1)
            (when (and (and (>= (- (* a 32) offset-x) 0)(<= (- (* a 32) offset-x) 608))
                       (and (>= (- (* i 32) offset-y) 0)(<= (- (* i 32) offset-y) 608)))
              (with-pen (make-pen :fill stone :stroke nil)
                (rect (- (* a 32) offset-x) (- (* i 32) offset-y) 32 32)
              )
            )
          )
          (when (= (elt (elt foo i)a) 0)
            (when (and (and (>= (- (* a 32) offset-x) 0)(<= (- (* a 32) offset-x) 608))
                       (and (>= (- (* i 32) offset-y) 0)(<= (- (* i 32) offset-y) 608)))
              (with-pen (make-pen :fill ground :stroke nil)
                (rect (- (* a 32) offset-x) (- (* i 32) offset-y) 32 32)
              )
            )
          )
          (setf a (+ a 1))
          (when (>= a (length (elt foo i)))(return))
        )
      )
      (setf i (+ i 1))
      (when (>= i (length foo))(return))
    )
  )
  (with-pen (make-pen :fill helmet :stroke nil)
    (rect (- (* player-x 32) offset-x) (- (* player-y 32) offset-y) 32 32)
  )
  
  (let ((i 0))
  (loop
  (setf (wait (the-enemy)) (- (wait (the-enemy)) 1))
  (when (= (wait (the-enemy)) 0)
    (let ((dir (random 4 (make-random-state t))))
      (when (= dir 0)(setf (y (the-enemy)) (- (y (the-enemy)) 1))
      (when (= (elt (elt foo (y (the-enemy))) (x (the-enemy))) 1) (setf (y (the-enemy)) (+ (y (the-enemy)) 1))))
      
      (when (= dir 1)(setf (x (the-enemy)) (- (x (the-enemy)) 1))
      (when (= (elt (elt foo (y (the-enemy))) (x (the-enemy))) 1) (setf (x (the-enemy)) (+ (x (the-enemy)) 1))))
      
      (when (= dir 2)(setf (y (the-enemy)) (+ (y (the-enemy)) 1))
      (when (= (elt (elt foo (y (the-enemy))) (x (the-enemy))) 1) (setf (y (the-enemy)) (- (y (the-enemy)) 1))))
      
      (when (= dir 3)(setf (x (the-enemy)) (+ (x (the-enemy)) 1))
      (when (= (elt (elt foo (y (the-enemy))) (x (the-enemy))) 1) (setf (x (the-enemy)) (- (x (the-enemy)) 1))))
    )
    (setf (wait (the-enemy)) (+(random (top (the-enemy)) (make-random-state t))20))
  )
  (when (and (= (x (the-enemy)) player-x)(= (y (the-enemy)) player-y))(setf died 1))
  (when (and (and (>= (- (* (x (the-enemy)) 32) offset-x) 0)(<= (- (* (x (the-enemy)) 32) offset-x) 640))
             (and (>= (- (* (y (the-enemy)) 32) offset-y) 0)(<= (- (* (y (the-enemy)) 32) offset-y) 640)))
    (with-pen (make-pen :fill skull :stroke nil)
      (rect (- (* (x (the-enemy)) 32) offset-x) (- (* (y (the-enemy)) 32) offset-y) 32 32)
    )
  )
  (setf i (+ i 1))
  (when (>= i (length enemies))(return))
  )
  
  (setf ghost-wait (- ghost-wait 1))
  (setf ghost-inc (- ghost-inc 1))
  (when (= ghost-inc 0)
    (setf ghost-top (- ghost-top 1))
    (setf ghost-inc ghost-inc-top)
    (when (<= ghost-top 10)(setf ghost-top 10))
  )
  (when (= ghost-wait 0)
    (when (= died 0)(setf score (+ score 1)))
    (when (> ghost-x player-x) (setf ghost-x (- ghost-x 1)))
    (when (< ghost-x player-x) (setf ghost-x (+ ghost-x 1)))
    (when (> ghost-y player-y) (setf ghost-y (- ghost-y 1)))
    (when (< ghost-y player-y) (setf ghost-y (+ ghost-y 1)))
    (setf ghost-wait ghost-top)
    (when (and (and (>= (- (* ghost-x 32) offset-x) 0)(<= (- (* ghost-x 32) offset-x) 608))
          (and (>= (- (* ghost-y 32) offset-y) 0)(<= (- (* ghost-y 32) offset-y) 608)))
      (teleport)
    )
  )
  (when (and (= ghost-x player-x)(= ghost-y player-y))(setf died 1))

  (when (and (and (>= (- (* ghost-x 32) offset-x) 0)(<= (- (* ghost-x 32) offset-x) 608))
             (and (>= (- (* ghost-y 32) offset-y) 0)(<= (- (* ghost-y 32) offset-y) 608)))
    (with-pen (make-pen :fill ghost :stroke nil)
      (rect (- (* ghost-x 32) offset-x) (- (* ghost-y 32) offset-y) 32 32)
    )
  )
  
  )
  
  (rect 0 0 100 50)
  (text "Score: " 0 0)
  (text (write-to-string score) 55 0)
  (text "Spells: " 0 25)
  (text (write-to-string spells) 55 25)
  
  (when (= died 1) (over))
  (when (= start-screen 1)(title-screen))
)

(defmethod on-key ((sketch mazegame) key state)
  (when (and(eq key :W)(eq state :DOWN))(setf player-y (- player-y 1))
  (if (= (elt (elt foo player-y) player-x) 1) (progn (setf player-y (+ player-y 1))(grunt)) (footstep)))
  
  (when (and(eq key :A)(eq state :DOWN))(setf player-x (- player-x 1))
  (if (= (elt (elt foo player-y) player-x) 1) (progn (setf player-x (+ player-x 1))(grunt)) (footstep)))
    
  (when (and(eq key :S)(eq state :DOWN))(setf player-y (+ player-y 1))
  (if (= (elt (elt foo player-y) player-x) 1) (progn (setf player-y (- player-y 1))(grunt)) (footstep)))
    
  (when (and(eq key :D)(eq state :DOWN))(setf player-x (+ player-x 1))
  (if (= (elt (elt foo player-y) player-x) 1) (progn (setf player-x (- player-x 1))(grunt)) (footstep)))
  
  (when (and(eq key :1)(eq state :DOWN))(when (or (= start-screen 1) (= died 1))(setf init-width 15)(setf init-height 15)(reset)(setf start-screen 0)))
  (when (and(eq key :2)(eq state :DOWN))(when (or (= start-screen 1) (= died 1))(setf init-width 30)(setf init-height 30)(reset)(setf start-screen 0)))
  (when (and(eq key :3)(eq state :DOWN))(when (or (= start-screen 1) (= died 1))(setf init-width 60)(setf init-height 60)(reset)(setf start-screen 0)))
  
  (when (and(eq key :K)(eq state :DOWN))(stun-hector))
)

(defun stun-hector ()
  (when (> spells 0)
    (when (and (= died 0)(= start-screen 0))
      (org.shirakumo.fraf.harmony:play #p"sfx/hectordies.mp3" :mixer :music)
    )
    (setf ghost-wait 500)
    (setf spells (- spells 1))
  )
)

(defun footstep ()
  (when (and (= died 0)(= start-screen 0))
    (org.shirakumo.fraf.harmony:play #p"sfx/footstep.mp3" :mixer :music)
  )
)

(defun grunt ()
  (when (and (= died 0)(= start-screen 0))
    (org.shirakumo.fraf.harmony:play #p"sfx/grunt.mp3" :mixer :music)
  )
)

(defun teleport ()
  (when (and (= died 0)(= start-screen 0))
    (org.shirakumo.fraf.harmony:play #p"sfx/teleport.mp3" :mixer :music)
  )
)

(defun main()
(org.shirakumo.fraf.harmony:maybe-start-simple-server)
(let ((sketch::*build* t))
  (sdl2:make-this-thread-main
   (lambda ()
     (make-instance 'mazegame))))
)
