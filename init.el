;; packageを設定します。

(defun init-package ()
  (require 'package)
  (add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
  (package-initialize))

;; 言語を設定します。

(defun init-language ()
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8))

;; 見た目を設定します。

(defun init-appearance ()
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (fringe-mode 0)
  (column-number-mode t)
  (setq inhibit-startup-message t)
  (set-face-attribute 'default nil :family "VL Gothic" :height 120)
  (setq-default line-spacing 2)
  (custom-set-faces
   '(default ((t (:background "#300a24" :foreground "white"))))))

;; 動作を設定します。

(defun init-behavior ()
  (setq inhibit-startup-message t)
  (setq ring-bell-function 'ignore)
  (setq-default indent-tabs-mode nil)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq x-select-enable-clipboard t)
  (add-hook 'before-save-hook 'delete-trailing-whitespace))

;; インデントを設定します。

(defun init-indent ()
  (setq c-basic-offset    2)
  (setq css-indent-offset 2)
  (setq js-indent-level   2))

;; キーボードを設定します。

(defun init-keyboard ()
  (define-key global-map (kbd "RET") 'newline-and-indent)
  (define-key global-map (kbd "C-t") 'toggle-truncate-lines)
  (define-key global-map (kbd "C-o") 'other-window)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
  (require 'dired)
  (define-key dired-mode-map (kbd "C-o") 'other-window)
  (define-key global-map (kbd "<mouse-6>") 'scroll-right)
  (define-key global-map (kbd "<mouse-7>") 'scroll-left)
  (put 'scroll-left 'disabled nil))

;; Input Methodを設定します。

(defun init-input-method ()
  (require 'mozc)
  (setq default-input-method "japanese-mozc"))

;; helmを設定します。

(defun init-helm ()
  (define-key global-map (kbd "C-;") 'helm-for-files)
  (put 'upcase-region 'disabled nil))

;; clojure-modeを設定します。

(defun init-clojure-mode ()
  (require 'clojure-mode)
  (setq nrepl-hide-special-buffers t)
  (setq cider-repl-display-help-banner nil)
  (setq cider-show-error-buffer nil)
  (define-clojure-indent
    (apply                 1)
    ;; for compojure
    (defroutes             'defun)
    (context               2)
    ))

;; c++-modeを設定します。

(defun c++-mode-hook-handler ()
  (c-set-style "bsd")
  (setq c-basic-offset 2))

(defun init-c++-mode ()
  (add-hook 'c++-mode-hook
            'c++-mode-hook-handler))

;; elpyを設定します。

(defun init-elpy ()
  (elpy-enable)
  (setq elpy-rpc-python-command "python3")
  (setq python-shell-interpreter "python3"))

;; markdown-modeを設定します。

(defun markdown-mode-hook-handler ()
  (auto-fill-mode 0))

(defun init-markdown-mode ()
  (add-hook 'markdown-mode-hook
            'markdown-mode-hook-handler))

(init-package)
(init-language)
(init-appearance)
(init-behavior)
(init-indent)
(init-keyboard)
(init-input-method)
(init-helm)
;; (init-clojure-mode)
;; (init-c++-mode)
;; (init-elpy)
(init-markdown-mode)
