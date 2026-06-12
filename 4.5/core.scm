(define-library (lib gl 4.5 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.5)

   (lib gl)
   (OpenGL 4.5))

(export
   (exports (lib gl))
   (exports (OpenGL 4.5)))

(begin ))
