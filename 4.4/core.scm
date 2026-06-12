(define-library (lib gl 4.4 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.4)

   (lib gl)
   (OpenGL 4.4))

(export
   (exports (lib gl))
   (exports (OpenGL 4.4)))

(begin ))
