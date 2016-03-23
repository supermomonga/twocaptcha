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
(plan 8)

(multiple-value-bind (status id)
    (twocaptcha:queue "benri" "apikey")
  (is status 'TWOCAPTCHA::OK)
  (is id "12345"))

(multiple-value-bind (status text)
    (twocaptcha:result "benri" "apikey")
  (is status 'TWOCAPTCHA::OK)
  (is text "solved"))


(is (twocaptcha:-parse-query-string "a=1 b=2 c=3") '(("a" . "1") ("b" . "2") ("c" . "3")))
(is (twocaptcha:-parse-query-string "a=1 b c=3") '(("a" . "1") ("c" . "3")))
(is (twocaptcha:-parse-query-string "a=1  b=2") '(("a" . "1") ("b" . "2")))
(is (twocaptcha:-parse-query-string "a=1   b=2") '(("a" . "1") ("b" . "2")))


(finalize)
