(define-library (lib gl 4.3 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.3)

   (lib gl)
   (OpenGL 4.3))

(export
   (exports (lib gl))
   (exports (OpenGL 4.3)))

(begin ))
