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
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
  (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
  (package-initialize))

;; PATHを設定します。

(defun init-exec-path-for-linux ()
  (exec-path-from-shell-initialize))

(defun init-exec-path-for-mac ()
  (exec-path-from-shell-initialize))

(defun init-exec-path ()
  (when linux?
    (init-exec-path-for-linux))
  (when mac?
    (init-exec-path-for-mac)))

;; 言語を設定します。

(defun set-language-for-mac ()
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
  (set-face-attribute 'default nil :family "Noto Sans Mono CJK JP" :height 120)
  (set-fontset-font (frame-parameter nil 'font) 'japanese-jisx0208 (font-spec :family "Noto Sans Mono CJK JP"))
  (custom-set-faces
   `(default ((t (:background "white" :foreground "black"))))))

(defun init-appearance-for-mac ()
  (set-face-attribute 'default nil :family "Ricty Diminished" :height 120)
  (set-fontset-font nil 'japanese-jisx0208 (font-spec :family "Ricty Diminished")))

(defun init-appearance-for-windows ()
  (set-face-attribute 'default nil :family "Noto Sans Mono CJK JP Regular" :height 96)   ; Windowsは、スケーリング1.25で運用します。96 * 1.25 = 120になって、全角と半角の比率が2:1になってキレイ。
  (custom-set-faces
   '(default ((t (:background "black" :foreground "white"))))))

(defun init-appearance ()
  (menu-bar-mode 0)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (fringe-mode 0)
  (column-number-mode t)
  (load-theme 'adwaita t)
  (setq inhibit-startup-message t)
  ;; (setq-default line-spacing 2)
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
  (setq c-basic-offset    4)
  (setq css-indent-offset 4)
  (setq js-indent-level   4))

;; キーボードを設定します。

(defun init-keyboard-for-linux ()
  (define-key global-map (kbd "<mouse-6>") 'scroll-right)
  (define-key global-map (kbd "<mouse-7>") 'scroll-left)
  (put 'scroll-left 'disabled nil))

(defun init-keyboard ()
  (define-key global-map (kbd "RET") 'newline-and-indent)
  (define-key global-map (kbd "C-t") 'toggle-truncate-lines)
  (define-key global-map (kbd "C-o") 'other-window)
  (define-key global-map (kbd "M-y") 'helm-show-kill-ring)
  (require 'dired)
  (define-key dired-mode-map (kbd "C-o") 'other-window)
  (when linux?
    (init-keyboard-for-linux)))

;; Input Methodを設定します。

(defun init-input-method-for-linux ()
  (require 'mozc)
  (setq default-input-method "japanese-mozc"))
  ;; (setq mozc-candidate-style 'popup))

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

;; slimeを設定します。

(defun init-slime ()
  (load (expand-file-name "~/.roswell/helper.el")))

;; haskell-modeを設定します。

(defun init-haskell-mode ()
  (setq haskell-process-type 'stack-ghci)
  (setq haskell-process-path-ghci "stack")
  (setq haskell-process-args-ghci "ghci")
  (add-hook 'haskell-mode-hook 'haskell-indentation-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook 'haskell-decl-scan-mode)
  (add-hook 'haskell-mode-hook 'haskell-doc-mode))

;; clojure-modeを設定します。

(defun init-clojure-mode ()
  (require 'clojure-mode)
  (setq nrepl-hide-special-buffers t)
  (setq cider-repl-display-help-banner nil)
  (setq cider-show-error-buffer nil)
  (setq cider-lein-parameters "repl :headless :host localhost")
  (define-clojure-indent
    (apply 1)))

;; js2-modeを設定します。

(defun init-js2-mode ()
  (add-to-list 'auto-mode-alist '("\\.js"  . js2-mode))
  (add-to-list 'auto-mode-alist '("\\.mjs" . js2-mode)))

;; elpyを設定します。

(defun init-elpy ()
  (elpy-enable)
  ;; (pyvenv-activate "~/Documents/Environments/python")
  (setq python-shell-completion-native-enable nil))

;; enh-ruby-modeを設定します。

(defun init-enh-ruby-mode ()
  (setq enh-ruby-program "/home/ryo/.rbenv/shims/ruby")
  (add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
  (add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
  (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode))

;; projectile-railsを設定します。

(defun init-pojrectile-rails ()
  (projectile-global-mode)
  (add-hook 'projectile-mode-hook 'projectile-rails-on))

;; c++-modeを設定します。

(defun c++-mode-hook-handler ()
  (c-set-style "bsd")
  (setq c-basic-offset 4))

(defun init-c++-mode ()
  (add-hook 'c++-mode-hook
            'c++-mode-hook-handler))

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
;; (init-slime)
(init-haskell-mode)
(init-js2-mode)
(init-elpy)
(init-enh-ruby-mode)
(init-c++-mode)
(init-markdown-mode)
