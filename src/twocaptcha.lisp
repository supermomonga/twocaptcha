(in-package :cl-user)
(defpackage twocaptcha
  (:use :cl))
(in-package :twocaptcha)

(cl-annot:enable-annot-syntax)

@export
(defun queue (file apikey &optional options)
  (let* ((file-params (if (pathnamep file)
                          '(("method" "post") ("file" file))
                          '(("method" "base64") ("body" file))))
         (params (append
                  '("key" apikey)
                  file-params
                  options))
         (res (multiple-value-list (handler-bind ((dex:http-request-service-unavailable (dex:retry-request 5 :interval 3)))
                                     (dex:post "http://2captcha.com/in.php" :content params))))
         (body (first res))
         (captcha-args (split-sequence:split-sequence #\| body))
         (captcha-status (intern (first captcha-args) "TWOCAPTCHA"))
         (captcha-id (second captcha-args)))
    (if (eq 'OK captcha-status)
        captcha-id
        captcha-status)))

@export
(defun result (captcha-id apikey)
  (let* ((uri (quri:make-uri :defaults "http://2captcha.com/res.php"
                             :query '(("key" apikey)
                                      ("id" captcha-id)
                                      ("action" "get"))))
         (res (multiple-value-list
               (handler-bind ((dex:http-request-service-unavailable (dex:retry-request 5 :interval 3)))
                 (dex:get uri))))
         (body (first res))
         (captcha-args (split-sequence:split-sequence #\| body))
         (captcha-status (intern (first captcha-args) "TWOCAPTCHA"))
         (captcha-text (second captcha-args)))
    (case captcha-status
      ('OK captcha-text)
      ('CAPCHA_NOT_READY
       (sleep 5)
       (result captcha-id apikey))
      (otherwise status))))
