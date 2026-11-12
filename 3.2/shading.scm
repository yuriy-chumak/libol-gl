(define-library (lib gl 3.2 shading)
(import
   (scheme base)
   (OpenGL 3.2))

(export
   gl:compile-shader
   gl:link-shaders
   gl:create-program
   gl:vertex-preprocessor
   gl:fragment-preprocessor
)

(include "lib/gl/3.2/shading.lisp")
(begin ))
