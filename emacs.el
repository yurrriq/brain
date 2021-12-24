(column-number-mode 1)
(add-to-list 'exec-path "/run/current-system/sw/bin")
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
;; (let ((font "Iosevka-10"))
;;   (set-face-attribute 'default t :font font)
;;   (set-frame-font font nil t))
(require 'package)
(setq-default frames-only-mode t
              indent-tabs-mode nil
              package-archives nil
              package-enable-at-startup nil)
(package-initialize)

(load-theme 'wombat)

(global-set-key (kbd "C-x C-k") 'kill-this-buffer)
(global-set-key (kbd "s-u") 'revert-buffer)

(eval-when-compile
  (require 'use-package))

(setq-default use-package-always-ensure t)

(use-package nyan-mode
  :config (nyan-mode 1)
  :demand)

(use-package org-roam
  :demand)
