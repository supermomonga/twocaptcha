(in-package :cl-user)
(defpackage twocaptcha
  (:use :cl))
(in-package :twocaptcha)

(defun queue (file apikey &optional options)
  (let* ((file-params (if (pathnamep file)
                          '(("method" "post") ("file" file))
                          '(("method" "base64") ("body" file))))
         (params (append
                  '("key" apikey)
                  file-params
                  options))
         (res (handler-bind (dex:http-request-service-unavailable
                             (dex:retry-request 5 :interval 3))
                (dex:post "http://2captcha.com/in.php" :content params)))
         (body (nth-value 0 res))
         (status (intern (car (split-sequence:split-sequence #\| body))))
         (captcha-id (nth-value 1 (split-sequence:split-sequence #\| body))))
    (if (= 'OK status)
        captcha-id
        status)))

(defun result (captcha-id apikey)
  (let* ((uri (quri:make-uri :defaults "http://2captcha.com/res.php"
                             :query '(("key" apikey)
                                      ("id" captcha-id)
                                      ("action" "get"))))
         (res (handler-bind (dex:http-request-service-unavailable
                             (dex:retry-request 5 :interval 3))
                (dex:get uri)))
         (body (nth-value 0 res))
         (status (intern (car (split-sequence:split-sequence #\| body))))
         (text (nth-value 1 (split-sequence:split-sequence #\| body))))
    (case status
      ('OK text)
      ('CAPCHA_NOT_READY
       (sleep 5)
       (result captcha-id apikey))
      (otherwise status))))
