(define-library (lib gl 3.2 compat)
(import
   (scheme core)
   (lib gl context compat)
   (lib gl context 3.2)

   (lib gl)
   (lib gl 3. shading)
   (OpenGL ARB compatibility)
   (OpenGL 3.2))

(export
   (exports (lib gl))
   (exports (lib gl 3. shading))
   (exports (OpenGL ARB compatibility))
   (exports (OpenGL 3.2)))

(begin ))
