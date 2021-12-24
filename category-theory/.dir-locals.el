((nil
  . ((eval
      . (progn
          (setq-local org-roam-directory
                      (expand-file-name (locate-dominating-file
                                         default-directory ".dir-locals.el")))
          (setq-local org-roam-db-location
                      (expand-file-name "org-roam.db"
                                        org-roam-directory))
          (setq-local org-id-locations-file
                      (expand-file-name ".org-id-locations"
                                        org-roam-directory))
          (add-hook 'org-roam-graph-generation-hook
                    (lambda (dot svg)
                      (let ((publishing-directory
                             (plist-get (cdr (assoc "category-theory" org-publish-project-alist))
                                        :publishing-directory)))
                        (copy-file svg (concat publishing-directory "/sitemap.svg") 't)
                        ;; (kill-buffer (file-name-nondirectory svg))
                        )))
          (setq org-publish-project-alist
                `(("category-theory"
                   :base-directory       ,org-roam-directory
                   :auto-sitemap         t
                   :sitemap-function     eb/org-roam-sitemap
                   :sitemap-title        "Category Theory"
                   :publishing-directory ,(concat (file-name-directory (directory-file-name default-directory))
                                                  "public")
                   :publishing-function  eb/org-roam-publish-to-html
                   :fontify-natively     t
                   :section-numbers      nil
                   :with-toc             nil
                   :html-doctype         "html5"
                   :html-extension       "html"
                   :htmlized-source      t))))))))
