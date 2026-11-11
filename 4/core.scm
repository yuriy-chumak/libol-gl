(define-library (lib gl 4.0 core)
(import
   (scheme core)
   (lib gl context core)
   (lib gl context 4.0)

   (lib gl)
   (lib gl 3. shading)
   (OpenGL 4.0))

(export
   (exports (lib gl))
   (exports (lib gl 3. shading))
   (exports (OpenGL 4.0)))

(begin ))
