(define-library (lib gl 2 shading)
(import
   (scheme base)
   (OpenGL 2.0))

(export
   gl:compile-shader
   gl:link-shaders
   gl:create-program
   gl:vertex-preprocessor
   gl:fragment-preprocessor
)

(include "lib/gl/2/shading.lisp")
(begin ))
