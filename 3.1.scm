; core or compat depends on driver
; most drivers creates compat
(define-library (lib gl 3.1)
(import
   (scheme core)
   (lib gl)
   (lib gl 3 context 3.1)
   (OpenGL 3.1))

(export
   (exports (lib gl))
   (exports (OpenGL 3.1)))

(begin ))
