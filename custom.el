(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(package-archives
   (quote
    (("marmalade" . "https://marmalade-repo.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("elpa" . "https://elpa.gnu.org/packages/"))))
 '(package-selected-packages
   (quote
    (vue-mode js2-mode typescript-mode elpy lsp-metals sbt-mode ace-window git-gutter-fringe undo-tree yasnippet use-package-ensure-system-package switch-window swiper-helm smartparens scala-mode python-mode projectile nix-mode multiple-cursors magit lsp-ui lsp-haskell json-mode hl-sexp hemisu-theme helm-lsp helm-flx flycheck exec-path-from-shell dockerfile-mode direnv dhall-mode dash-at-point company avy)))
 '(safe-local-variable-values
   (quote
    ((eval font-lock-add-keywords nil
           (\`
            (((\,
               (concat "("
                       (regexp-opt
                        (quote
                         ("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl"))
                        t)
                       "\\_>"))
              1
              (quote font-lock-variable-name-face))))))))
 '(show-trailing-whitespace t)
 '(use-package-always-defer t)
 '(use-package-always-ensure t)
 '(use-package-verbose nil)
 '(whitespace-line-column 100 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
