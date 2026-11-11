(define-library (lib gl 4.2 core)
(import
   (scheme core)
   (lib gl context core)
   (lib gl context 4.2)

   (lib gl)
   (lib gl 3. shading)
   (OpenGL 4.2))

(export
   (exports (lib gl))
   (exports (lib gl 3. shading))
   (exports (OpenGL 4.2)))

(begin ))
