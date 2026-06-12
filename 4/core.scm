(define-library (lib gl 4.0 core)
(import
   (scheme core)
   (lib gl 3 context core)
   (lib gl 3 context 4.0)

   (lib gl)
   (OpenGL 4.0))

(export
   (exports (lib gl))
   (exports (OpenGL 4.0)))

(begin ))
