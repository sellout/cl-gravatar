(defpackage gravatar.system
  (:use #:cl #:asdf))

(in-package #:gravatar.system)

(defsystem gravatar
  :depends-on (md5 drakma puri cl-json babel)
  :components ((:file "package")
               (:file "gravatar" :depends-on ("package"))))
