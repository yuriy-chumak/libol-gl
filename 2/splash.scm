(define-library (lib gl 2 splash)
(import
   (scheme core)
   (lib gl config))

(export )

(begin
   (import (owl io))
   (print "hello")
   (config 'set 'background #t)
))
