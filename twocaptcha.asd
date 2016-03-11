#|
  This file is a part of twocaptcha project.
  Copyright (c) 2016 supermomonga
|#

#|
  Author: supermomonga
|#

(in-package :cl-user)
(defpackage twocaptcha-asd
  (:use :cl :asdf))
(in-package :twocaptcha-asd)

(defsystem twocaptcha
  :version "0.1"
  :author "supermomonga"
  :license "MIT"
  :depends-on (:unix-opts
               :dexador
               :split-sequence)
  :components ((:module "src"
                :components
                ((:file "twocaptcha"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (test-op twocaptcha-test))))
