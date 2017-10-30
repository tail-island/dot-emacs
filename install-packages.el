(defvar packages
  '(cider
    clojure-mode
    elpy
    exec-path-from-shell
    helm
    markdown-mode))

(defun install-packages ()
  (package-refresh-contents)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(defun init-package ()
  (require 'package)
  (add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
  (package-initialize))

(init-package)
(install-packages)
