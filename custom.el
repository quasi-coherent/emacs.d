(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(package-archives
   '(("marmalade" . "https://marmalade-repo.org/packages/")
     ("melpa" . "https://melpa.org/packages/")
     ("elpa" . "https://elpa.gnu.org/packages/")))
 '(safe-local-variable-values
   '((eval font-lock-add-keywords nil
           `((,(concat "("
                       (regexp-opt
                        '("sp-do-move-op" "sp-do-move-cl" "sp-do-put-op" "sp-do-put-cl" "sp-do-del-op" "sp-do-del-cl")
                        t)
                       "\\_>")
              1 'font-lock-variable-name-face)))))
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
