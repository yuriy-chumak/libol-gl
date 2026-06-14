(define-library (lib gl 3 shading)
(import
   (scheme base)
   (OpenGL 3.1))

(export
   gl:compile-shader
   gl:link-shaders
   gl:create-program
   gl:vertex-preprocessor
   gl:geometry-preprocessor
   gl:fragment-preprocessor
)

; -=( * ol functions )=-------------------------------------
; todo: move "#version" from the source to the top
; note:
;  no GL_VERTEX_PROGRAM_TWO_SIDE
(begin
   (define (preprocessor source)
      (if (pair? source) source (list source)))
   (define vertex-preprocessor preprocessor)
   (define geometry-preprocessor preprocessor)
   (define fragment-preprocessor preprocessor)
)

(begin
   ; * internal
   (define (compile shader sources)
      (glShaderSource shader (length sources) sources #false)
      (glCompileShader shader)
      (let ((isCompiled (box 0)))
         (glGetShaderiv shader GL_COMPILE_STATUS isCompiled)

         (if (eq? (unbox isCompiled) 0)
            (let*((maxLength (box 0))
                  (_ (glGetShaderiv shader GL_INFO_LOG_LENGTH maxLength))
                  (maxLengthValue (unbox maxLength))
                  (errorLog (make-bytevector maxLengthValue 0))
                  (_ (glGetShaderInfoLog shader maxLengthValue maxLength errorLog)))
               (raise (utf8->string errorLog))))))

   ; * internal
   (define (link program . shaders)
      (for-each (lambda (shader)
            (glAttachShader program shader))
         shaders)
      ;; todo: check this!
      ;; (for-each (lambda (shader)
      ;;       (glDeleteShader shader))
      ;;    shaders)

      (glLinkProgram program)
      (let ((isLinked (box 0)))
         (glGetProgramiv program GL_LINK_STATUS isLinked)
         (if (eq? (unbox isLinked) 0)
            ;; the maxLength includes the NULL character
            (let*((maxLength (box 0))
                  (_ (glGetProgramiv program GL_INFO_LOG_LENGTH maxLength))
                  (maxLengthValue (unbox maxLength))
                  (errorLog (make-bytevector maxLengthValue 0))
                  (_ (glGetProgramInfoLog program maxLengthValue maxLength errorLog)))

               ;; we don't need the program anymore.
               (glDeleteProgram program)
               ;; don't leak shaders either.
               (for-each (lambda (shader)
                     (glDeleteShader shader))
                  shaders)
               ;; throw error
               (raise (utf8->string errorLog)))))

      (for-each (lambda (shader)
            ;; always detach shaders after a successful link.
            (glDetachShader program shader))
         shaders))

   (define (gl:create-program vstext fstext)
      (let ((po (glCreateProgram))
            (vs (glCreateShader GL_VERTEX_SHADER))
            (fs (glCreateShader GL_FRAGMENT_SHADER)))
         (if (eq? po 0)
            (raise "Can't create shader program."))

         (compile vs (vertex-preprocessor vstext))
         (compile fs (fragment-preprocessor fstext))

         (link po vs fs)
         po))

   ; publicly available names
   (define gl:compile-shader compile)
   (define gl:link-shaders link)
   (define gl:vertex-preprocessor vertex-preprocessor)
   (define gl:geometry-preprocessor geometry-preprocessor)
   (define gl:fragment-preprocessor fragment-preprocessor)

))
