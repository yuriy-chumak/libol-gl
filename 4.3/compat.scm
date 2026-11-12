(define-library (lib gl 4.3 compat)
(import
   (scheme core)
   (lib gl context compat)
   (lib gl context 4.3)

   (lib gl)
   (lib gl 3.2 shading)
   (OpenGL 3.0)
   (OpenGL 4.3))

(export
   (exports (lib gl))
   (exports (lib gl 3.2 shading))
   (exports (OpenGL 3.0))
   (exports (OpenGL 4.3)))

(begin ))
