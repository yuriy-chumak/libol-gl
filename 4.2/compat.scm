(define-library (lib gl 4.2 compat)
(import
   (scheme core)
   (lib gl context compat)
   (lib gl context 4.2)

   (lib gl)
   (lib gl 3. shading)
   (OpenGL 3.0)
   (OpenGL 4.2))

(export
   (exports (lib gl))
   (exports (lib gl 3. shading))
   (exports (OpenGL 3.0))
   (exports (OpenGL 4.2)))

(begin ))
