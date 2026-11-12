(define-library (lib gl 4.4 core)
(import
   (scheme core)
   (lib gl context core)
   (lib gl context 4.4)

   (lib gl)
   (lib gl 3.2 shading)
   (OpenGL 4.4))

(export
   (exports (lib gl))
   (exports (lib gl 3.2 shading))
   (exports (OpenGL 4.4)))

(begin ))
