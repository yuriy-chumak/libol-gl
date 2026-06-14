; just a regular opengl version
(define-library (lib gl 3.0)
(import
   (scheme core)
   (lib gl)
   (lib gl 3 context 3.0)
   (lib gl shading)
   (OpenGL 3.0))

(export
   (exports (lib gl))
   (exports (lib gl shading))
   (exports (OpenGL 3.0)))

(begin ))
