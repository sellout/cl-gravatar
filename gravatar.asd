(defpackage gravatar.system
  (:use #:cl #:asdf))

(in-package #:gravatar.system)

(defsystem gravatar
  :author "Greg Pfeil <greg@technomadic.org>"
  :description "Common Lisp bindings to the popular Gravatar service."
  :license "Apache 2.0"
  :version "0.0.1"
  :depends-on (md5 drakma puri cl-json babel)
  :components ((:file "package")
               (:file "gravatar" :depends-on ("package"))))
