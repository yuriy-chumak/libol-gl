(define-library (lib gl 4.1 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.1)

   (lib gl)
   (OpenGL 4.1))

(export
   (exports (lib gl))
   (exports (OpenGL 4.1)))

(begin ))
