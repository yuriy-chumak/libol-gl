(define-library (lib gl 3.1 shading)
(import
   (scheme base)
   (OpenGL 3.1))

(export
   gl:compile-shader
   gl:link-shaders
   gl:create-program
   gl:vertex-preprocessor
   gl:fragment-preprocessor
)

(include "lib/gl/2/shading.lisp")
(begin ))
