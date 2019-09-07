(defvar packages
  '(cider
    elpy
    enh-ruby-mode
    exec-path-from-shell
    haskell-mode
    helm
    js2-mode
    markdown-mode
    rust-mode
    slime))

(defun install-packages ()
  (package-refresh-contents)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

(defun init-package ()
  (require 'package)
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (package-initialize))

(init-package)
(install-packages)
