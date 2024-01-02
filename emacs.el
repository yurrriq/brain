(column-number-mode 1)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)

(require 'package)
(setq-default frames-only-mode t
              indent-tabs-mode nil
              inhibit-splash-screen t
              package-archives nil
              package-enable-at-startup nil)
(package-initialize)

(load-theme 'wombat)

(global-set-key (kbd "C-x C-k") 'kill-this-buffer)
(global-set-key (kbd "s-u") 'revert-buffer)

(set-face-attribute 'default nil :family "Iosevka Nerd Font Mono" :height 110)

(eval-when-compile
  (require 'use-package))

(setq-default use-package-always-ensure t)

(use-package crux
  :config
  (global-set-key (kbd "C-a") 'crux-move-beginning-of-line))

(use-package deadgrep
  :demand
  :config (global-set-key (kbd "M-s-f") #'deadgrep))

(use-package direnv
  :config
  (direnv-mode))

(use-package fill-column-indicator
  :config
  (setq-default fill-column 80)
  (global-display-fill-column-indicator-mode))

(use-package hl-todo
  :demand
  :config (global-hl-todo-mode t))

(use-package multiple-cursors
  :demand
  :config (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines))

(use-package magit
  :bind
  (("C-x g" . magit-status)))

(use-package nix-mode)

(use-package nyan-mode
  :config (nyan-mode 1)
  :demand)

(use-package org-roam
  :after org
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-completion-everywhere t)
  ;; FIXME
  (org-roam-graph-link-builder 'eb/org-roam-custom-link-builder)
  :bind
  (("C-c n f" . org-roam-node-find)
   ("C-c n l" . org-roam-buffer-toggle)
   (:map org-mode-map
         (("C-c n a" . org-roam-alias-add)
          ("C-c n i" . org-roam-node-insert)
          ("C-c n o" . org-id-get-create)
          ("C-c n t" . org-roam-tag-add)
          ("C-M-i" . completion-at-point))))
  :config
  ;; FIXME: update for v2
  (add-to-list 'org-roam-capture-templates
               '("c" "concept" plain "%?"
                 :target (file+head "${slug}.org"
                                    "#+title: ${title}\n")
                 :unnarrowed t))
  (org-roam-setup)
  ;; TODO
  ;; (add-hook 'org-roam-graph-generation-hook
  ;;           (lambda (dot svg)
  ;;             (let ((publishing-directory
  ;;                    (plist-get (cdr (assoc "category-theory-html" org-publish-project-alist))
  ;;                               :publishing-directory)))
  ;;               (copy-file svg (concat publishing-directory "/sitemap.svg") 't)
  ;;               ;; (kill-buffer (file-name-nondirectory svg))
  ;;               )))
  ;; https://github.com/org-roam/org-roam-ui/issues/236
  (setq
   org-roam-directory (expand-file-name (concat default-directory "category-theory/"))
   org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory)
   org-id-locations-file (expand-file-name ".org-id-locations" org-roam-directory)
   org-publish-project-alist
   `(("category-theory-html"
      :base-directory       ,org-roam-directory
      :auto-sitemap         t
      :sitemap-filename     "index.org"
      ;; FIXME:
      ;; :sitemap-function     eb/org-roam-sitemap
      :sitemap-title        "Category Theory"
      :publishing-directory ,(file-name-concat default-directory "docs")
      :publishing-function  eb/org-roam-publish-to-html
      :fontify-natively     t
      :section-numbers      nil
      :with-toc             nil
      :html-doctype         "html5"
      :html-extension       "html"
      :htmlized-source      t)
     ("category-theory-svg"
      :base-directory       ,(expand-file-name (concat org-roam-directory "svg/"))
      :base-extension       "svg"
      :publishing-directory ,(file-name-concat default-directory "docs" "svg")
      :publishing-function  org-publish-attachment)
     ("category-theory"
      :components
      ("category-theory-html"
       "category-theory-svg")))))

(eval-and-compile
  (defun eb/org-roam-custom-link-builder (node)
    (let ((file (org-roam-node-file node)))
      (concat (file-name-base file) ".html")))

  (defun eb/org-roam-publish-to-html (plist filename pubdir)
    ;; FIXME:
    ;; (org-roam-graph)
    (org-html-publish-to-html plist filename pubdir))

  (defun eb/org-roam-sitemap (title list)
    (concat "#+OPTIONS: ^:nil author:nil html-postamble:nil\n"
            "#+TITLE: " title "\n\n"
            (org-list-to-org list)
            ;; FIXME:
            ;; "\nfile:sitemap.svg\n"
            )))

(use-package org-roam-ui
  :after org-roam
  :config
  (setq
   org-roam-ui-sync-theme t
   org-roam-ui-follow t
   org-roam-ui-update-on-save t
   org-roam-ui-open-on-start t))

(use-package paredit
  :hook (emacs-lisp-mode . paredit-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package smex
  :demand
  :config
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(use-package whitespace-cleanup-mode
  :config (global-whitespace-cleanup-mode t))

(use-package yaml-mode)
