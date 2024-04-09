(asdf:defsystem "hectors-maze"
  :description "Hector's Maze"
  :author "ZeroPlayerRodent"
  :defsystem-depends-on (:deploy)
  :depends-on (#:sketch
               #:harmony)
  :build-operation "deploy-op"
  :build-pathname "hectors-maze.mem"
  :components ((:file "hectors-maze"))
  :entry-point "mazegame:main"
  :serial t
) 
