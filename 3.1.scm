(define-library (lib gl 3.1)
(import
   (scheme core)
   (lib gl context 3.1)
   (lib gl)
   (lib gl 3.1 shading)
   (OpenGL 3.1))

(export
   (exports (lib gl))
   (exports (OpenGL 3.1))
   (exports (lib gl 3.1 shading)))
(begin ))
