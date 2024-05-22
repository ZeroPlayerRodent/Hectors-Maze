(asdf:load-system :sketch)
(asdf:load-system :harmony)
(load "hectors-maze.lisp")
(sb-ext:save-lisp-and-die "hectors-maze" :toplevel #'mazegame:main :executable t :compression t)
