(define-library (lib gl 3 context)
(import
   (scheme base)
   (owl math) (otus async)
   (lib gl)
   (lib gl config)
   (otus ffi))

(export
   gl:set-context-version ; recreate OpenGL with version
)

; -=( 3.0+ )=-------------------------
; Higher OpenGL versions support
(cond-expand
   ((or Android Emscripten) ; TODO: dev only, please rename to Android
      (begin
         (define (gl:set-context-version major minor)
            #false)
   ))
   (Linux
      ;; (import (OpenGL GLX ARB create_context))
      (import (owl io))
      (begin
         (define (gl:set-context-version major minor) ; TODO: change this!
            (config 'set 'context-version (cons major minor)) ; reflect context version change in config

            (let*((context (await (mail 'opengl ['get 'context]))) ;#(display screen window cx)
                  (dpy screen window cx fbc0 context))
               (print "fbc0: " fbc0)

               ;; GLX_ARB_create_context
               (define glXCreateContextAttribsARB (gl:GetProcAddress type-vptr "glXCreateContextAttribsARB" fft-void* fft-void* fft-void* fft-int fft-int*))

               (define contextAttribs (append
                  (list
                     #x2091  major ; GLX_CONTEXT_MAJOR_VERSION
                     #x2092  minor ; GLX_CONTEXT_MINOR_VERSION
                  )
                  ; поддерживать ли fixed-function функции
                  (if (config 'core-profile #f)
                     (list #x9126 1) ; GLX_CONTEXT_PROFILE_MASK_ARB GLX_CONTEXT_CORE_PROFILE_BIT_ARB
                     (list #x9126 2) ; GLX_CONTEXT_PROFILE_MASK_ARB GLX_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB
                  )
                  ; NVidia cards
                  (if (config 'exact-context #f)
                     (list #x2094 2) ; GLX_CONTEXT_FLAGS_ARB GLX_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB
                     (list )
                  )
                  ; end of options
                  (list 0)
               ))

               ; create new context
               (define new-cx (glXCreateContextAttribsARB dpy fbc0 #f 1 contextAttribs))

               ; TODO: fail if error
               (define new_context [dpy screen window new-cx fbc0])

               ;; ; disable and destroy old context
               ;; (native:disable-context context) ; todo: destroy
               ; set new context
               (mail 'opengl ['set 'context new_context])
               ; enable new context
               (native:enable-context new_context)
               #true))))
   (Windows
      ;(import (OpenGL WGL ARB create_context))
      (begin
         (define (gl:set-context-version major minor)
            #false)))
)

(begin ))
