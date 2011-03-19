(in-package #:gravatar)

(defvar +base-uri+ (puri:uri "https://secure.gravatar.com/")
  "Why would we ever _not_ use SSL?")

(defun hash (email)
  (string-downcase (format nil "~{~2,'0x~}"
                           (coerce (md5:md5sum-sequence
                                    (string-downcase (string-trim '(#\space)
                                                                  email)))
                                   'list))))

(defun image-url (email &key size default force-default-p rating)
  "DEFAULT may be either a URL to your own image, or one of :404, :mm,
   :identicon, :monsterid, :wavatar, or :retro. RATING may be one of :g, :pg,
   :r, or :x."
  (let ((parameters ()))
    (when size (push (format nil "s=~d" size) parameters))
    (typecase default
      (keyword (push (format nil "d=~a" (string-downcase default)) parameters))
      (string (push (format nil "d=~a" default) parameters)))
    (when force-default-p (push "f=y" parameters))
    (when rating (push (format nil "r=~a" (string-downcase rating)) parameters))
    (puri:merge-uris (format nil "avatar/~a~@[?~{~a~^&~}~]"
                             (hash email) parameters)
                     +base-uri+)))

(defun generate-profile-url (email type parameters)
  (puri:merge-uris (format nil "g2-~a.~a~@[?~:{~a=~a~^&~}~]"
                           (hash email)
                           (string-downcase type)
                           (mapcar (lambda (parameter)
                                     (list (car parameter) (cdr parameter)))
                                   parameters))
                   +base-uri+))

(defun profile (email &optional js-callback)
  (json:decode-json-from-string
   (babel:octets-to-string
    (drakma:http-request (generate-profile-url
                          email
                          :json
                          (when js-callback
                            `(("callback" . ,js-callback))))))))

(defun qr-code-url (email &optional size)
  (generate-profile-url email :qr (when size `(("s" . ,size)))))
