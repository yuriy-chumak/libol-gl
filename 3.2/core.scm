(define-library (lib gl 3.2 core)
(import
   (scheme core)
   (lib gl context core)
   (lib gl context 3.2)

   (lib gl)
   (lib gl 3.2 shading)
   (OpenGL 3.2))

(export
   (exports (lib gl))
   (exports (lib gl 3.2 shading))
   (exports (OpenGL 3.2)))

(begin ))
