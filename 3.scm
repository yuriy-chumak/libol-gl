(define-library (lib gl 3.0)
(import
   (scheme core)
   (lib gl)
   (lib gl 2. shading)
   (OpenGL 3.0))

(export
   (exports (lib gl))
   (exports (OpenGL 3.0))
   (exports (lib gl 2. shading)))
(begin ))
