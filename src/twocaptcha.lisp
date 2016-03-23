(in-package :cl-user)
(defpackage twocaptcha
  (:use :cl))
(in-package :twocaptcha)

(cl-annot:enable-annot-syntax)

@export
(defun queue (file apikey &optional options)
  (let* ((file-params (if (pathnamep file)
                          (list '("method" . "post") (cons "file" file))
                          (list '("method" . "base64") (cons "body" file))))
         (params (append
                  (list (cons "key" apikey))
                  file-params
                  options))
         (res (multiple-value-list (handler-bind ((dex:http-request-service-unavailable (dex:retry-request 5 :interval 3)))
                                     (dex:post "http://2captcha.com/in.php" :content params))))
         (body (first res))
         (captcha-args (split-sequence:split-sequence #\| body))
         (captcha-status (intern (first captcha-args) "TWOCAPTCHA"))
         (captcha-id (second captcha-args)))
    (if (eq 'OK captcha-status)
        (values captcha-status captcha-id)
        (values captcha-status nil))))

@export
(defun result (captcha-id apikey)
  (let* ((uri (quri:make-uri :defaults "http://2captcha.com/res.php"
                             :query (list (cons "key" apikey)
                                          (cons "id" captcha-id)
                                          '("action" . "get"))))
         (res (multiple-value-list
               (handler-bind ((dex:http-request-service-unavailable (dex:retry-request 5 :interval 3)))
                 (dex:get uri))))
         (body (first res))
         (captcha-args (split-sequence:split-sequence #\| body))
         (captcha-status (intern (first captcha-args) "TWOCAPTCHA"))
         (captcha-text (second captcha-args)))
    (case captcha-status
      ('OK (values captcha-status captcha-text))
      ('CAPCHA_NOT_READY
       (sleep 1.5)
       (result captcha-id apikey))
      (otherwise (values captcha-status nil)))))


@export
(defun -parse-query-string (option-string)
  (mapcar (lambda (pair) (apply #'cons pair))
          (remove-if-not (lambda (it) (= (length it) 2))
                         (mapcar (lambda (seq) (split-sequence:split-sequence #\= seq))
                                 (split-sequence:split-sequence #\  option-string)))))
