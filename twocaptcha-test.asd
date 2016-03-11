#|
  This file is a part of twocaptcha project.
  Copyright (c) 2016 supermomonga
|#

(in-package :cl-user)
(defpackage twocaptcha-test-asd
  (:use :cl :asdf))
(in-package :twocaptcha-test-asd)

(defsystem twocaptcha-test
  :author "supermomonga"
  :license "MIT"
  :depends-on (:twocaptcha
               :prove)
  :components ((:module "t"
                :components
                ((:test-file "twocaptcha"))))
  :description "Test system for twocaptcha"

  :defsystem-depends-on (:prove-asdf)
  :perform (test-op :after (op c)
                    (funcall (intern #.(string :run-test-system) :prove-asdf) c)
                    (asdf:clear-system c)))
