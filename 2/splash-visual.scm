(define-library (lib gl 2 splash-visual)
(import
   (scheme base)
   (lib gl))

(export
   gl:splash-visual
)

(begin
   (define (gl:splash-visual width height colors)
      ; load minimal function set
      (define glEnable      (GL_LIBRARY GLvoid "glEnable" GLenum))
         (define GL_TEXTURE_2D #x0DE1)
      (define glDisable     (GL_LIBRARY GLvoid "glDisable" GLenum))
      ;; (setq glGenTextures (GL_LIBRARY GLvoid "glGenTextures" GLsizei GLuint&))
      ;; (setq glDeleteTextures (GL_LIBRARY GLvoid "glDeleteTextures" GLsizei GLuint*))
      (define glBindTexture (GL_LIBRARY GLvoid "glBindTexture" GLenum GLuint))
      (define glTexParameteri (GL_LIBRARY GLvoid "glTexParameteri" GLenum GLenum GLint))
         (define GL_TEXTURE_MAG_FILTER #x2800)
         (define GL_TEXTURE_MIN_FILTER #x2801)
         (define GL_LINEAR #x2601)  (define GL_NEAREST #x2600)
      (define glTexImage2D  (GL_LIBRARY GLvoid "glTexImage2D" GLenum GLint GLint GLsizei GLsizei GLint GLenum GLenum fft-any))
         (define GL_RGB #x1907)
         (define GL_UNSIGNED_BYTE #x1401)
      (define glBegin       (GL_LIBRARY GLvoid "glBegin" GLenum))
         (define GL_QUADS #x0007)
      (define glEnd         (GL_LIBRARY GLvoid "glEnd"))
      (define glVertex2f    (GL_LIBRARY GLvoid "glVertex2f" GLfloat GLfloat))
      (define glTexCoord2f  (GL_LIBRARY GLvoid "glTexCoord2f" GLfloat GLfloat))

      ; upload texture
      ;; (glGenTextures 1 id)
      (glBindTexture GL_TEXTURE_2D 0) ;; (car id))
      (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MAG_FILTER GL_NEAREST)
      (glTexParameteri GL_TEXTURE_2D GL_TEXTURE_MIN_FILTER GL_NEAREST)
      (glTexImage2D GL_TEXTURE_2D 0 GL_RGB
         width height
         0 GL_RGB GL_UNSIGNED_BYTE colors)

      ; draw textured quad
      (glEnable GL_TEXTURE_2D)
      ;; (glColor3f 1 1 1)
      (glBegin GL_QUADS)
         (glTexCoord2f 0 0)
         (glVertex2f -1  1)
         (glTexCoord2f 0 1)
         (glVertex2f -1 -1)
         (glTexCoord2f 1 1)
         (glVertex2f  1 -1)
         (glTexCoord2f 1 0)
         (glVertex2f  1  1)
      (glEnd)

      ; show it
      (gl:redisplay)

      ; done.
      ;; (glDeleteTextures 1 id)
      (glDisable GL_TEXTURE_2D)
   )

))
