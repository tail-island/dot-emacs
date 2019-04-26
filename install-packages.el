(defvar packages
  '(elpy
    enh-ruby-mode
    haskell-mode
    helm
    js2-mode
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
