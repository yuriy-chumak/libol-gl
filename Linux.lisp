(define setup:autorender-mode #true)

; AMD and Intel cards (mesa drivers):
; 3.2 - for Core Profile
; 3.2COMPAT - for Compatibility Profile
; 3.0FC - for Forward Compatible
(when (config 'exact-context #f)
   (define context-version (config 'context-version '(3 . 2)))
   (syscall 1014 ; set-environment-variable!
      "MESA_GL_VERSION_OVERRIDE\0"
      (string-append
         (number->string (car context-version))
         "."
         (number->string (cdr context-version))
         (if (config 'core-profile #t) "" "COMPAT")
         "\0")))
; NVidia cards will use GLX_CONTEXT_FLAGS_ARB GLX_CONTEXT_FORWARD_COMPATIBLE_BIT_ARB

(setq X11 (load-dynamic-library "libX11.so.6"))
(setq void* fft-void*)

; context manipulations
(setq XOpenDisplay   (X11 fft-void* "XOpenDisplay" type-string))
(setq XDefaultScreen (X11 fft-int "XDefaultScreen" fft-void*))
(setq XRootWindow    (X11 fft-void* "XRootWindow" fft-void* fft-int))
(setq XCreateWindow  (X11 fft-void* "XCreateWindow"
   fft-void* ; display
   fft-void* ; parent Window
   fft-int fft-int fft-unsigned-int fft-unsigned-int ; x y width height
   fft-unsigned-int ; border width
   fft-int ; depth
   fft-unsigned-int ; class
   fft-void* ; visual
   fft-unsigned-long ; valuemask
   (fft* (list
            fft-unsigned-long ; Pixmap
            fft-unsigned-long
            fft-unsigned-long ; Pixmap
            fft-unsigned-long
            fft-int
            fft-int
            fft-int
            fft-unsigned-long
            fft-unsigned-long
            fft-int ; Bool
            fft-long ; event_mask
            fft-long
            fft-int ; Bool
            fft-void* ; Colormap (important!)
            fft-unsigned-long ; Cursor
      ))
   ))
(setq XCreatePixmap  (X11 type-vptr "XCreatePixmap" type-vptr type-vptr fft-unsigned-int fft-unsigned-int fft-unsigned-int))


(setq XSelectInput   (X11 fft-void "XSelectInput" fft-void* fft-void* fft-long))
(setq XMapWindow     (X11 fft-void "XMapWindow" fft-void* fft-void*))
(setq XStoreName     (X11 fft-void "XStoreName" fft-void* fft-void* type-string))
(setq XKeycodeToKeysym  (X11 fft-unsigned-long "XKeycodeToKeysym" fft-void* fft-unsigned-char fft-int))
(setq XFree          (X11 fft-void "XFree" fft-void*))

(setq GLX GL_LIBRARY)
(setq glXChooseVisual   (GLX fft-void* "glXChooseVisual" fft-void* fft-int fft-int*))
(setq glXCreateContext  (GLX fft-void* "glXCreateContext" fft-void* fft-void* fft-void* fft-int))
(setq glXMakeCurrent    (GLX fft-int "glXMakeCurrent" fft-void* fft-void* fft-void*))
(setq glXSwapBuffers    (GLX fft-void "glXSwapBuffers" fft-void* fft-void*))

(setq XSynchronize (X11 type-vptr "XSynchronize" fft-void* fft-int)) ; TEMP
(setq XCreateColormap (X11 type-vptr "XCreateColormap" fft-void* fft-void* fft-void* fft-int))

(setq None 0)
(setq True 1)

; functions
(define (native:create-context title)
   (let*((dpy (XOpenDisplay #f))
         ( // (XSynchronize dpy 1)) ; TEMP (debug purposes)
         (screen (XDefaultScreen dpy))
         (context-version (config 'context-version #f))

         ;; (create-basic-vi (lambda ()


         (fbc0 (begin
                  (define glXGetProcAddress (GLX type-vptr "glXGetProcAddress" type-string))
                  ;; GLX 1.3 required (handle case GLX < 1.3)
                  (define glXChooseFBConfig (GLX fft-void* "glXChooseFBConfig" fft-void* fft-int fft-int* fft-int&)) ; GLX 1.3
                  ; TODO: if no glXChooseFBConfig create legacy context before, then try again

                  (define visual_attribs (list
                     #x8012  True ; GLX_X_RENDERABLE
                     #x8010  True ; GLX_DRAWABLE_TYPE GLX_WINDOW_BIT
                     #x22  #x8002 ; GLX_X_VISUAL_TYPE GLX_TRUE_COLOR
                     #x8011  True ; GLX_RENDER_TYPE GLX_RGBA_BIT
                        8 (config 'red 8)    ; GLX_RED_SIZE
                        9 (config 'green 8)  ; GLX_GREEN_SIZE
                     10 (config 'blue 8)   ; GLX_BLUE_SIZE
                     11 (config 'alpha 8)  ; GLX_ALPHA_SIZE
                     12 (config 'depth 24) ; GLX_DEPTH_SIZE
                        5      True ; GLX_DOUBLEBUFFER
                     None))

                  (define fbcount (box 0))
                  (define fbc* (glXChooseFBConfig dpy screen visual_attribs fbcount))
                  (define fbc0 (bytevector->void* (vptr->bytevector fbc* (sizeof type-vptr)) 0)) ; fbc0 = fbc*[0]
                  (XFree fbc*)
                  fbc0))
         (vi depth
               (if fbc0
               then
                  ;; GLX 1.3 required
                  (define glXGetVisualFromFBConfig (GLX fft-void* "glXGetVisualFromFBConfig" fft-void* fft-void*))
                  (define glXGetFBConfigAttrib (GLX fft-int "glXGetFBConfigAttrib" fft-void* fft-void* fft-int fft-int&))

                  (define vinfo (glXGetVisualFromFBConfig dpy fbc0))
                  (define vi (bytevector->void* (vptr->bytevector vinfo (sizeof type-vptr)) 0)) ; vi = vinfo->visual
                  (define depth
                     (fold (lambda (bits param)
                              (define value (box 0))
                              (glXGetFBConfigAttrib dpy fbc0 param value)
                              (+ bits (unbox value)))
                        0
                        (list 8 9 10))) ; RED GREEP BLUE
                  (XFree vinfo)
                  (values vi depth)
               else
                  (define vi (glXChooseVisual dpy screen (list
                        4 ; GLX_RGBA
                        8 (config 'red 8)   ; GLX_RED_SIZE
                        9 (config 'green 8) ; GLX_GREEN_SIZE
                        10 (config 'blue 8)  ; GLX_BLUE_SIZE
                        11 (config 'alpha 8) ; GLX_ALPHA_SIZE
                        12 (config 'depth 24); GLX_DEPTH_SIZE
                        5 ; GLX_DOUBLEBUFFER
                        None)))
                  (define depth (+ (config 'red 8) (config 'green 8) (config 'blue 8))) ; TODO: переделать

                  (values vi depth) ))
         (window
               (begin
                  (define cmap (XCreateColormap dpy
                     (XRootWindow dpy screen)
                     vi 0))

                  (define window (XCreateWindow dpy
                     (XRootWindow dpy screen)
                     0 0 (config 'width WIDTH) (config 'height HEIGHT) 1
                     depth
                     1 ; = InputOutput
                     vi
                     #x2000 ; CWColormap
                     (list 0 0 0 0 0 0 0 0 0 0 0 0 0 cmap 0)))
                  (XSelectInput dpy window #b100000000000000111) ; StructureNotifyMask | KeyPressMask | KeyReleaseMask | ButtonPressMask
                  
                  ; show splash text if OpenGL 3.1+ or 4.0+
                  (when (or
                           (config 'context-version #f)
                           (config 'background #f)
                           (config 'splash-text #f))
                     ; X11 functions
                     (define XCreateGC (X11 fft-void* "XCreateGC" fft-void* fft-void* fft-unsigned-long fft-void*))
                     (define XSetForeground (X11 fft-void* "XSetForeground" fft-void* fft-void* fft-unsigned-long))
                     (define XFreeGC (X11 fft-void "XFreeGC" fft-void* fft-void*))
                     (define XFillRectangle (X11 fft-void "XFillRectangle" fft-void* fft-void* fft-void* fft-int fft-int fft-unsigned-int fft-unsigned-int))
                     (define XFlush (X11 fft-void "XFlush" fft-void*))
                     (define XSetWindowBackgroundPixmap (X11 fft-int "XSetWindowBackgroundPixmap" fft-void* fft-void* fft-void*))
                     (define XClearWindow (X11 fft-int "XClearWindow" fft-void* fft-void*))

                     ; well, let's clear
                     (define pixmap (XCreatePixmap dpy window (config 'width WIDTH) (config 'height HEIGHT) depth))
                     (define gc (XCreateGC dpy pixmap 0 #f))

                     (XSetForeground dpy gc 0)
                     (XFillRectangle dpy pixmap gc 0 0 (config 'width WIDTH) (config 'height HEIGHT))
                     (XSetWindowBackgroundPixmap dpy window pixmap)

                     ; show the text in lower right corner
                     (define XFT (load-dynamic-library "libXft.so"))
                     (define XftFontOpenName (XFT fft-void* "XftFontOpenName" fft-void* fft-int type-string))
                     (define XftDrawCreate (XFT fft-void* "XftDrawCreate" fft-void* fft-void* fft-void* fft-void*))
                     (define XftColorAllocName (XFT fft-bool "XftColorAllocName" fft-void* fft-void* fft-void* type-string type-bytevector))
                     (define XftDrawStringUtf8 (XFT fft-void "XftDrawStringUtf8" fft-void* fft-void* fft-void* fft-int fft-int type-bytevector fft-int))
                     (define XftTextExtentsUtf8 (XFT fft-void "XftTextExtentsUtf8" fft-void* fft-void* type-bytevector fft-int type-bytevector))
                     
                     (define (splash-text /text /font /color)

                        (define text (string->utf8 /text))
                        (define font (XftFontOpenName dpy screen (or /font "DejaVu Sans")))
                        (define draw (XftDrawCreate dpy pixmap vi cmap))
                        (define color (make-bytevector 16))
                        (XftColorAllocName dpy vi cmap (or /color "gray") color) ; todo: get color from config

                        (define extents (make-bytevector 24))
                        (XftTextExtentsUtf8 dpy font text (size text) extents)

                        (XFillRectangle dpy pixmap gc 0 0 (config 'width WIDTH) (config 'height HEIGHT))
                        (XftDrawStringUtf8 draw color font
                           (- (config 'width WIDTH) (bytevector->uint16 extents 0) 40) ; todo: use config
                           (- (config 'height HEIGHT) (bytevector->uint16 extents 2) 20) ; todo: use config
                           text (size text))
                           
                        ; redraw window
                        (XSetWindowBackgroundPixmap dpy window pixmap)
                        (XClearWindow dpy window)
                        (XFlush dpy))
                     
                     (splash-text (config 'splash-text "Loading OpenGL libraries...") #f #f)
                     (mail 'opengl ['set 'splash-text splash-text])

                     ; setup splash screen remover
                     (mail 'opengl ['set 'splashcreen-remover (lambda ()
                           (XSetWindowBackgroundPixmap dpy window #f)
                           (XFreeGC dpy gc)
                        )])
                     ;; XftDrawDestroy(draw);
                     ;; XftFontClose(dpy, font);
                     )

                  ; finally, show window
                  (XStoreName dpy window title)
                  (XMapWindow dpy window)

                  window))

         (context
               (begin
                  (if fbc0
                  then
                     ;; GLX_ARB_create_context
                     (define glXCreateContextAttribsARB (gl:GetProcAddress type-vptr "glXCreateContextAttribsARB" fft-void* fft-void* fft-void* fft-int fft-int*))

                     (define contextAttribs (append
                        (if context-version
                           (list
                              #x2091  (car context-version) ; GLX_CONTEXT_MAJOR_VERSION
                              #x2092  (cdr context-version) ; GLX_CONTEXT_MINOR_VERSION
                           )
                           (list )
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
                        (list None)
                     ))

                     (glXCreateContextAttribsARB dpy fbc0 #f 1 contextAttribs)
                  else
                     (glXCreateContext dpy vi #false 1)) )))

      (glXMakeCurrent dpy window context)
      (print-to stderr "OpenGL version: " (glGetString GL_VERSION))
      (print-to stderr "OpenGL vendor: " (glGetString GL_VENDOR))
      (print-to stderr "OpenGL renderer: " (glGetString GL_RENDERER))

      ; TODO: collect extensions map (for the quick access)
      [dpy screen window context fbc0]
))

(define (native:enable-context context)
   (vector-apply context (lambda (dpy screen window cx)
      (glXMakeCurrent dpy window cx))))

(define (native:disable-context context)
   (vector-apply context (lambda (dpy screen window cx)
      (glXMakeCurrent dpy #false #f))))

(define (native:swap-buffers context)
   (vector-apply context (lambda (dpy screen window cx)
      (glXSwapBuffers dpy window))))

; -=( process events )=--------------------------------
(setq XPending      (X11 fft-int "XPending" type-vptr))
(setq XNextEvent    (X11 fft-void "XNextEvent" type-vptr type-bytevector))

(import (prefix (lib x11 config) x11))
(import (lib gamepad))

(define (native:process-events context handler)
   (vector-apply context (lambda (dpy screen window cx)
      ; x11 events
      (define XEvent (make-bytevector (x11config '|sizeof XEvent|)))
      (let loop ()
         (when (> (XPending dpy) 0)
            (XNextEvent dpy XEvent)
            ; https://tronche.com/gui/x/xlib/events/types.html
            (case (bytevector->int32 XEvent 0)
               ; keyboard events:
               (2 ; KeyPress
                  (handler ['keyboard (XKeycodeToKeysym dpy
                        (bytevector->int32 XEvent (x11config '|XKeyEvent.keycode|)) 0) #t]))
               (3 ; KeyRelease
                  (handler ['keyboard (XKeycodeToKeysym dpy
                        (bytevector->int32 XEvent (x11config '|XKeyEvent.keycode|)) 0) #f]))
               ; mouse
               (4 ; ButtonPress
                  (let ((x (bytevector->int32 XEvent (x11config '|XButtonEvent.x|)))
                        (y (bytevector->int32 XEvent (x11config '|XButtonEvent.y|)))
                        (button (bytevector->int32 XEvent (x11config '|XButtonEvent.button|))))
                     (handler ['mouse button x y])))
               (5 #f) ; ButtonRelease
               ; others
               (17 #f); DestroyNotify
               (19 #f) ; MapNotify
               (21 #f) ; ReparentNotify
               (22 ; ConfigureNotify
                  (let ((w (bytevector->int32 XEvent (x11config '|XConfigureEvent.width|)))
                        (h (bytevector->int32 XEvent (x11config '|XConfigureEvent.height|))))
                     (mail 'opengl ['resize w h])))
               (else #f))
            (loop)))

      ; gamepad events
      (let loop ()
         (define ev (read-event))
         (if ev (vector-apply ev (lambda (value evtype abnumber)
            (handler ['gamepad evtype abnumber value])
            (loop)))))
   )))

; ---
(setq XInternAtom (X11 type-vptr "XInternAtom" type-vptr type-string fft-int))
(setq XChangeProperty (X11 fft-void "XChangeProperty" type-vptr type-vptr type-vptr type-vptr fft-int fft-int type-string fft-int))

(define (os:SetWindowTitle context title)
   (vector-apply context (lambda (dpy screen window cx)
      (case (type title)
         (type-string
            (XStoreName dpy window title))
         (type-string-wide
            (XChangeProperty dpy window ; BUG: is not working
               (XInternAtom dpy "_NET_WM_NAME" 0)
               (XInternAtom dpy "UTF8_STRING" 0)
               8 0 ;PropModeReplace
               title 0))))))

; ---
(setq XResizeWindow (X11 fft-int "XResizeWindow" type-vptr type-vptr fft-int fft-int))

(define (os:SetWindowSize context width height)
   (let ((display (ref context 1))
         (window  (ref context 3)))
      (XResizeWindow display window width height)))

; ---
(setq XCreatePixmap (X11 type-vptr "XCreatePixmap" type-vptr type-vptr fft-unsigned-int fft-unsigned-int fft-unsigned-int))
(setq XCreatePixmapCursor (X11 type-vptr "XCreatePixmapCursor" type-vptr type-vptr type-vptr type-vptr type-vptr fft-unsigned-int fft-unsigned-int))
(setq XDefineCursor (X11 fft-void "XDefineCursor" type-vptr type-vptr type-vptr))
(setq XFreeCursor (X11 type-vptr "XFreeCursor" type-vptr type-vptr))
(setq XFreePixmap (X11 type-vptr "XFreePixmap" type-vptr type-vptr))

(define (os:HideCursor context)
   (vector-apply context (lambda (dpy screen window cx)
      (let*((bm_no_data (make-bytevector 8))
            (pixmap (XCreatePixmap dpy window 1 1 1))
            (color (make-bytevector 16))
            (cursor (XCreatePixmapCursor dpy pixmap pixmap color color 0 0)))
         (XDefineCursor dpy window cursor)
         (XFreeCursor dpy cursor)
         (XFreePixmap dpy pixmap)))))

; ---
(setq XGetInputFocus (X11 fft-void "XGetInputFocus" type-vptr (fft* type-vptr) (fft& fft-int)))
(setq XQueryPointer (X11 fft-int "XQueryPointer" type-vptr type-vptr (fft* type-vptr) (fft* type-vptr) (fft& fft-int) (fft& fft-int) (fft& fft-int) (fft& fft-int) (fft& fft-unsigned-int)))

(define (os:GetMousePos context)
   (vector-apply context (lambda (dpy screen window cx)
   (let ((vptr (make-vptr))
         (revert_to_return (box 0)))
      (XGetInputFocus dpy vptr revert_to_return)
      (if (equal? vptr window) ; we'r focused?
         (let ((root (make-vptr))
               (child (make-vptr))
               (root_x (box 0)) (root_y (box 0))
               (x (box 0)) (y (box 0)) (mask (box 0)))
            (if (eq? (XQueryPointer dpy window root child root_x root_y x y mask) 1)
               (cons (unbox x) (unbox y)))))))))
