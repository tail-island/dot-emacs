(defvar packages
  '(cider
    clojure-mode
    csharp-mode
    elpy
    exec-path-from-shell
    helm
    js2-mode
    kotlin-mode
    markdown-mode))

(defun install-packages ()
  (package-refresh-contents)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(defun init-package ()
  (require 'package)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
  (package-initialize))

(init-package)
(install-packages)
