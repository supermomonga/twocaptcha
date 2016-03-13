(in-package :cl-user)
(defpackage twocaptcha-test
  (:use :cl
        :twocaptcha
        :prove))

;; TODO: Avoid re-definition warning
;; (declaim #+sbcl (sb-ext:muffle-conditions sb-kernel:redefinition-warning))

;; Mocking
(in-package :dex)
(defun get (&rest args)
  (declare (ignorable args))
  (values "OK|solved" 200 '() nil))
(defun post (&rest args)
  (declare (ignorable args))
  (values "OK|12345" 200 '() nil))

(in-package :twocaptcha-test)


;; Tests
(plan 2)

(is (twocaptcha:queue "benri" "apikey") "12345")
(is (twocaptcha:result "12345" "apikey") "solved")



(finalize)
