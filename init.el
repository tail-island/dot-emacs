;; 機種を判定します。

(defvar linux?
  (eq system-type 'gnu/linux))

(defvar mac?
  (eq system-type 'darwin))

(defvar windows?
  (eq system-type 'windows-nt))

;; packageを設定します。

(defun init-package ()
  (require 'package)
  (add-to-list 'package-archives '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
  (package-initialize))

;; PATHを設定します。

(defun init-exec-path-for-mac ()
  (exec-path-from-shell-initialize))

(defun init-exec-path ()
  (when mac?
    (init-exec-path-for-mac)))

;; 言語を設定します。

(defun set-language-for-mac ()
  ;; (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs))

(defun set-language-for-windows ()
  (set-file-name-coding-system 'cp932))

(defun init-language ()
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)
  (when mac?
    (set-language-for-mac))
  (when windows?
    (set-language-for-windows)))

;; 見た目を設定します。

(defun init-appearance-for-linux ()
  (set-face-attribute 'default nil :family "Ricty Diminished" :height 120)  ; Linuxは、スケーリング1.0（もしくは0.875）で運用します。解像度が低い場合は120 * 0.875 = 105になって、全角と半角の比率が2:1になってキレイ。
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 (font-spec :family "Ricty Diminished"))
  (custom-set-faces
   '(default ((t (:background "#300a24" :foreground "white"))))))

(defun init-appearance-for-mac ()
  (set-face-attribute 'default nil :family "Ricty Diminished" :height 120)
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 (font-spec :family "Ricty Diminished")))

(defun init-appearance-for-windows ()
  (set-face-attribute 'default nil :family "VL Gothic" :height 96)   ; Windowsは、スケーリング1.25で運用します。96 * 1.25 = 120になって、全角と半角の比率が2:1になってキレイ。
  (custom-set-faces
   '(default ((t (:background "black" :foreground "white"))))))

(defun init-appearance ()
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (fringe-mode 0)
  (column-number-mode t)
  (setq inhibit-startup-message t)
  (setq-default line-spacing 2)
  (when linux?
    (init-appearance-for-linux))
  (when mac?
    (init-appearance-for-mac))
  (when windows?
    (init-appearance-for-windows)))

;; 動作を設定します。

(defun init-behavior-for-linux ()
  (setq x-select-enable-clipboard t))

(defun init-behavior ()
  (setq inhibit-startup-message t)
  (setq ring-bell-function 'ignore)
  (setq-default indent-tabs-mode nil)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (when linux?
    (init-behavior-for-linux)))

;; インデントを設定します。

(defun init-indent ()
  (setq c-basic-offset    2)
  (setq css-indent-offset 2)
  (setq js-indent-level   2))

;; キーボードを設定します。

(defun init-keyboard-for-linux ()
  (define-key global-map (kbd "<mouse-6>") 'scroll-right)
  (define-key global-map (kbd "<mouse-7>") 'scroll-left)
  (put 'scroll-left 'disabled nil))

(defun init-keyboard-for-mac ()
  (define-key global-map (kbd "M-c") 'kill-ring-save)  ; Karabiner-ElementsがM-wをM-cに割り当てるので、再割当てします。
  (setq ns-command-modifier   'meta)
  (setq ns-alternate-modifier 'super))

(defun init-keyboard ()
  (define-key global-map (kbd "RET") 'newline-and-indent)
  (define-key global-map (kbd "C-t") 'toggle-truncate-lines)
  (define-key global-map (kbd "C-o") 'other-window)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
  (require 'dired)
  (define-key dired-mode-map (kbd "C-o") 'other-window)
  (when linux?
    (init-keyboard-for-linux))
  (when mac?
    (init-keyboard-for-mac)))

;; Input Methodを設定します。

(defun init-input-method-for-linux ()
  (require 'mozc)
  (setq default-input-method "japanese-mozc"))

(defun init-input-method-for-mac ()
  (setq default-input-method "MacOSX"))

(defun init-input-method-for-windows ()
  (setq default-input-method "W32-IME")
  (setq-default w32-ime-mode-line-state-indicator "[--]")
  (setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))
  (w32-ime-initialize))

(defun init-input-method ()
  (when linux?
    (init-input-method-for-linux))
  (when mac?
    (init-input-method-for-mac))
  (when windows?
    (init-input-method-for-windows)))

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
  (setq cider-lein-parameters "repl :headless :host localhost")
  (define-clojure-indent
    (apply 1)))

;; c++-modeを設定します。

(defun c++-mode-hook-handler ()
  (c-set-style "bsd")
  (setq c-basic-offset 2))

(defun init-c++-mode ()
  (add-hook 'c++-mode-hook
            'c++-mode-hook-handler))

;; elpyを設定します。

(defun init-elpy-for-windows ()
  (setq python-shell-completion-native-enable nil))

(defun init-elpy ()
  (elpy-enable)
  (pyvenv-activate "~/Documents/Projects/python")
  (if windows?
      (init-elpy-for-windows)))

;; markdown-modeを設定します。

(defun markdown-mode-hook-handler ()
  (auto-fill-mode 0))

(defun init-markdown-mode ()
  (add-hook 'markdown-mode-hook
            'markdown-mode-hook-handler))

(init-package)
(init-exec-path)
(init-language)
(init-appearance)
(init-behavior)
(init-indent)
(init-keyboard)
(init-input-method)
(init-helm)
(init-clojure-mode)
(init-c++-mode)
(init-elpy)
(init-markdown-mode)
