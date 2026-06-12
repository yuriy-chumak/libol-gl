(define-library (lib gl 3.3 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 3.3)

   (lib gl)
   (OpenGL 3.3))

(export
   (exports (lib gl))
   (exports (OpenGL 3.3)))

(begin ))
