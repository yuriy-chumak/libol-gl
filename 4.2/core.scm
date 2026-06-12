(define-library (lib gl 4.2 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.2)

   (lib gl)
   (OpenGL 4.2))

(export
   (exports (lib gl))
   (exports (OpenGL 4.2)))

(begin ))
