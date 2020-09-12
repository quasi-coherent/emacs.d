;;;;;;;;;;;;;;;;;;;;;;
;;; Initialization ;;;
;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-startup-hook
          (lambda ()
            (message "Emacs ready in %s with %d garbage collections."
                     (format "%.2f seconds"
                             (float-time
                              (time-subtract after-init-time before-init-time)))
                     gcs-done)))

(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq gc-cons-threshold most-positive-fixnum)
(defun package--save-selected-packages (&rest opt) nil) ; stop messing with my custom.el
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

(custom-set-variables '(package-archives
                        '(("marmalade" . "https://marmalade-repo.org/packages/")
                          ("melpa"     . "https://melpa.org/packages/")
                          ("elpa"      . "https://elpa.gnu.org/packages/"))))

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))


(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package)

(cd "~/")                               ; HOME is where the heart is
(setq ring-bell-function 'ignore)       ; The sound that plays when you press C-g is annoying
(setq inhibit-startup-message t)
(custom-set-variables '(use-package-always-ensure t))
(custom-set-variables '(use-package-always-defer t))
(custom-set-variables '(use-package-verbose nil))
(global-set-key (kbd "C-x C-b") 'ibuffer) ; use ibuffer instead of buffer-menu
(global-set-key (kbd "C-<return>") 'toggle-frame-fullscreen) ; easily enter fullscreen mode


(use-package use-package-ensure-system-package
  :ensure t)

;; Obviously need a theme
(use-package hemisu-theme
  :ensure t
  :init
  (load-theme 'hemisu-dark t))


;;;;;;;;;;;;;;;;;;;;
;;; Text editing ;;;
;;;;;;;;;;;;;;;;;;;;

;; Misc.
(setq whitespace-line-column 100)       ; line length limit
(setq tab-always-indent 'complete)      ; smart tab behavior
(setq-default indent-tabs-mode nil)     ; death to tabs!
(column-number-mode t)                  ; show the column number in the mode line
(global-auto-revert-mode t)             ; revert buffers when underlying files change
(delete-selection-mode t)               ; delete region with one keypress

;; Turn on smart parentheses globally
(use-package smartparens
  :ensure t
  :diminish smartparens-mode
  :init
  (require 'smartparens-config)
  (show-smartparens-global-mode)
  (smartparens-global-mode t))

;; Dealing with unnecessary whitespace
(custom-set-variables '(show-trailing-whitespace t))
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Store backup and autosave files in /var/folders/
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Autosave the undo-tree history
(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq undo-tree-auto-save-history t)

;; Show gutter line numbers in every buffer
(global-display-line-numbers-mode)

;; Kill lines backward
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; MacOS specific things ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; On MacOS, Emacs inherits a limited environment if not started from the shell.
;; And if you start from the shell, you're gonna have a bad time.
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (setq exec-path-from-shell-variables '("PATH" "SHELL"
                                           "PWD" "NIX_SSL_CERT_FILE"))
    (exec-path-from-shell-initialize)))


;;;;;;;;;;;;;;;
;;; General ;;;
;;;;;;;;;;;;;;;

;; Helm mode
(use-package helm
  :defer 1
  :diminish helm-mode
  :bind
  (("C-x C-f"       . helm-find-files)
   ("C-x C-b"       . helm-buffers-list)
   ("C-x b"         . helm-multi-files)
   ("M-x"           . helm-M-x)
   ("M-y"           . helm-show-kill-ring)
   :map helm-find-files-map
   ("C-<backspace>" . helm-find-files-up-one-level)
   ("C-f"           . helm-execute-persistent-action)
   ([tab]           . helm-ff-RET))
  :init
  (defun daedreth/helm-hide-minibuffer ()
    (when (with-helm-buffer helm-echo-input-in-header-line)
      (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
        (overlay-put ov 'window (selected-window))
        (overlay-put ov 'face
                     (let ((bg-color (face-background 'default nil)))
                       `(:background ,bg-color :foreground ,bg-color)))
        (setq-local cursor-type nil))))
  :custom
  (helm-autoresize-max-height 0)
  (helm-autoresize-min-height 40)
  (helm-buffers-fuzzy-matching t)
  (helm-recentf-fuzzy-match t)
  (helm-semantic-fuzzy-match t)
  (helm-imenu-fuzzy-match t)
  (helm-split-window-in-side-p nil)
  (helm-move-to-line-cycle-in-source nil)
  (helm-ff-search-library-in-sexp t)
  (helm-scroll-amount 8)
  (helm-echo-input-in-header-line nil)
  :config
  (require 'helm-config)
  (helm-mode 1)
  (helm-autoresize-mode 1)
  :hook
  (helm-mode .
             (lambda ()
               (setq completion-styles
                     (cond ((assq 'helm-flex completion-styles-alist)
                            '(helm-flex)) ;; emacs-26
                           ((assq 'flex completion-styles-alist)
                            '(flex))))))  ;; emacs-27+
  (helm-minibuffer-set-up . daedreth/helm-hide-minibuffer))

(use-package helm-flx
  :custom
  (helm-flx-for-helm-find-files t)
  (helm-flx-for-helm-locate t)
  :config
  (helm-flx-mode +1))

(use-package swiper-helm
  :bind
  ("C-s" . swiper))

(use-package avy
  :ensure t
  :bind
  ("M-s" . avy-goto-char))

;; Company mode
(use-package company
  :ensure t
  :hook
  (after-init . global-company-mode))

;; Projectile mode
(use-package projectile
  :ensure t
  :hook
  (after-init . projectile-mode)
  :config
  (global-set-key (kbd "C-c p") 'projectile-command-map))

;; Git interactivity
(use-package magit
  :ensure t
  :diminish auto-revert-mode
  :bind
  (("C-c C-g" . magit-status)
   :map magit-status-mode-map
   ("q"       . magit-quit-session))
  :config
  (defadvice magit-status (around magit-fullscreen activate)
    "Make magit-status run alone in a frame."
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun magit-quit-session ()
    "Restore the previous window configuration and kill the magit buffer."
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen)))

;; Direnv integration
(use-package direnv
 :ensure t
 :config
 (direnv-mode)
 (direnv-allow))

;; Multiple cursors mode
(use-package multiple-cursors
  :ensure t
  :bind
  ("C-c m c"   . mc/edit-lines)
  ("C-c m <"   . mc/mark-next-like-this)
  ("C-c m >"   . mc/mark-previous-like-this)
  ("C-c m C-<" . mc/mark-all-like-this))

;; Open Dash to describe a symbol
(use-package dash-at-point
  :if (eq system-type 'darwin)
  :ensure-system-package
  ("/Applications/Dash.app" . "brew cask install dash"))

;; Sometimes I want to close all the buffers
(defun close-all-buffers ()
  "Kill all buffers without regard for their origin."
  (interactive)
  (mapc 'kill-buffer (buffer-list)))
(global-set-key (kbd "C-M-s-k") 'close-all-buffers)

;; Easy switching between buffers
(use-package switch-window
  :ensure t
  :config
    (setq switch-window-input-style 'minibuffer)
    (setq switch-window-increase 4)
    (setq switch-window-threshold 2)
    (setq switch-window-shortcut-style 'qwerty)
    (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" "i" "o"))
  :bind
    ([remap other-window] . switch-window))


;;;;;;;;;;;;;;;;;
;;; Languages ;;;
;;;;;;;;;;;;;;;;;

;; Language Server Protocol support for emacs
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

(use-package yasnippet
  :ensure t)

(use-package lsp-mode
  :hook
  (haskell-mode . lsp)
  :commands lsp)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

;; Haskell
(use-package haskell-mode
  :ensure t
  :hook
  (haskell-mode . subword-mode)
  (haskell-mode . eldoc-mode)
  (haskell-mode . haskell-indentation-mode)
  (haskell-mode . interactive-haskell-mode))

(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie '()))

;; Scala

;; Python

;; Lisps
(use-package hl-sexp
  :ensure t
  :hook
  ((clojure-mode lisp-mode emacs-lisp-mode) . hl-sexp-mode))

;; Markdown files
(use-package markdown-mode
  :ensure t
  :hook
  (markdown-mode . visual-line-mode)
  (markdown-mode . variable-pitch-mode))

;; Dockerfile files
(use-package dockerfile-mode
  :ensure t)

;; Nix
(use-package nix-mode
  :ensure t)

;; JSON
(use-package json-mode
  :ensure t)

;; Dhall configuration language
(use-package dhall-mode
  :ensure t
  :mode "\\.dhall\\'")

;;; init.el ends here
