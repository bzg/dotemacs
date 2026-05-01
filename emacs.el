;;; emacs.el --- bzg's GNU Emacs configuration -*- lexical-binding: t; -*-

;; This is bzg's GNU Emacs configuration, refined over the years.
;; For more Emacs-related stuff, see https://bzg.fr/en/tags/emacs/
;;
;; Code in this file is licensed under the GNU GPLv3 or any later
;; version.

;; Set `package-archives' to the ones I use
(setopt package-native-compile t)

(setopt package-archives
	'(("gnu" . "http://elpa.gnu.org/packages/")
	  ("nongnu" . "http://elpa.nongnu.org/nongnu/")
	  ("melpa" . "http://melpa.org/packages/")))

;; Increase GC threshold during startup
(setopt gc-cons-threshold 100000000)

;; Reset after init
(add-hook 'emacs-startup-hook (lambda () (setopt gc-cons-threshold 800000)))

(setq-default bidi-display-reordering t)
(setq-default bidi-paragraph-direction 'left-to-right)
(setopt bidi-inhibit-bpa t)
(setopt redisplay-skip-fontification-on-input t)
(setopt read-process-output-max (* 4 1024 1024))
(setq-default cursor-in-non-selected-windows nil)
(setopt highlight-nonselected-windows nil)
(setopt save-interprogram-paste-before-kill t)
(setopt kill-do-not-save-duplicates t)
(setopt set-mark-command-repeat-pop t)

;; Unset C-z which is bound to `suspend-frame' by default
(global-unset-key (kbd "C-z"))

;; Load my customization file
(setopt custom-file "/home/bzg/.emacs.d/emacs-custom.el")
(load custom-file)

;; Initialize Org from sources
;; See https://orgmode.org/manual/Installation.html
(add-to-list 'load-path "~/install/git/org/org-mode/lisp/")
(add-to-list 'load-path "~/install/git/org/org-contrib/lisp/")

;; Initialize my `exec-path' and `load-path' with custom paths
(add-to-list 'exec-path "~/bin/")

;; Include org-mode and emacs local paths into Info
;; (add-to-list 'Info-directory-list "~/install/git/org/org-mode/doc/")
;; (add-to-list 'Info-directory-list "~/install/git/emacs/info/")

;; Don't ask for confirmation for "dangerous" commands
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'list-threads 'disabled nil)
(put 'scroll-left 'disabled nil)

;; Set `sentence-end-double-space' to nil
(setopt sentence-end-double-space nil)

;; Expect local variables to be known
(setopt enable-local-eval t)

;; Who I am
(setopt user-full-name "Bastien Guerry")
(setopt user-mail-address "bzg@bzg.fr")

;; Let's get a backtrace when errors are
(setopt debug-on-error t)

;; Display byte-compiler warnings on error
(setopt byte-compile-debug t)

;; The default is to wait 1 second, which I find a bit long
(setopt echo-keystrokes 0.1)

;; Let search for "e" match e.g. "é":
(setopt search-default-mode 'char-fold-to-regexp)

;; Stop polluting the directory with auto-saved files and backup
(setopt auto-save-default nil)
(setopt make-backup-files nil)

;; Well, it's more so that you know this option
(setopt kill-whole-line t)
(setopt kill-read-only-ok t)
(setopt require-final-newline 'visit)

;; Scrolling done right
(setopt scroll-error-top-bottom t)
(setopt focus-follows-mouse t)
(setopt recenter-positions '(top bottom middle))

;; Number of lines of continuity when scrolling by screenfulls
(setopt next-screen-context-lines 0)

;; Always use "y" for "yes"
(defalias 'yes-or-no-p 'y-or-n-p)

;; Enabling and disabling some modes
;; Less is more - see https://bzg.fr/en/emacs-strip-tease/
(auto-insert-mode 1)
(display-time-mode -1)
(tooltip-mode -1)
(blink-cursor-mode -1)
(pixel-scroll-mode 1)

;; Default Frame
(setopt default-frame-alist
	'((menu-bar-lines . 0)
	  (tool-bar-lines . 0)))

(set-frame-parameter nil 'fullscreen 'fullboth)

;; Don't display initial messages
(setopt initial-scratch-message "")
(setopt initial-major-mode 'org-mode)
(setopt inhibit-startup-screen t)
(setopt inhibit-startup-echo-area-message "bzg")
(setopt use-dialog-box nil)
(setopt line-move-visual nil)
(setopt visible-bell t)
(setopt tab-bar-show nil)

;; Hide fringe background and fringe indicators
(set-face-attribute 'fringe nil :background 'unspecified)
(mapc (lambda (fb) (set-fringe-bitmap-face fb 'org-hide)) fringe-bitmaps)
(load-theme 'doric-marble)

;; Reset some font stuff
(set-face-attribute 'default nil :family "Roboto Mono" :height 140)
(set-face-attribute 'italic nil :family "Roboto Mono" :weight 'semi-light :slant 'normal)
(set-face-attribute 'bold-italic nil :slant 'normal)

;; Define options and functions I will later bind
(setopt bzg/min-font-size 140)
(setopt bzg/default-font-size 192)
(custom-set-faces `(default ((t (:height ,bzg/default-font-size)))))

(defun bzg/toggle-default-font-size ()
  (interactive)
  (let* ((current (face-attribute 'default :height))
         (at-default (< (abs (- current bzg/default-font-size)) 10))
         (target (if at-default bzg/min-font-size bzg/default-font-size)))
    (custom-set-faces `(default ((t (:height ,target)))))))

;; Easily jump to my main org file
(defun bzg/find-bzg nil
  "Find the bzg.org file."
  (interactive)
  (find-file "~/org/bzg.org")
  (hidden-mode-line-mode 1)
  (delete-other-windows))

(defun find-variable-or-function-at-point ()
  (interactive)
  (or (find-variable-at-point)
      (find-function-at-point)
      (message "No variable or function at point.")))

;; By default, killing a word backward will put it in the ring, I don't want this
(defun backward-kill-word-noring (arg)
  (interactive "p")
  (let ((kr kill-ring))
    (backward-kill-word arg)
    (setopt kill-ring (reverse kr))))

;; Weekly appointments
(global-set-key (kbd "C-$") (lambda () (interactive) (org-agenda nil "$")))

;; Routine keybindings
(global-set-key (kbd "C-ù") (lambda () (interactive) (org-agenda nil "ù"))) ; Week tasks
(global-set-key (kbd "C-*") (lambda () (interactive) (org-agenda nil "µ"))) ; STRT/NEXT
(global-set-key (kbd "C-!") (lambda () (interactive) (org-agenda nil "!"))) ; Deadlines
(global-set-key (kbd "C-;") (lambda () (interactive) (org-agenda nil ";"))) ; Other TODOs
(global-set-key (kbd "C-:") (lambda () (interactive) (org-agenda nil ":"))) ; WAITing

;; Other useful global keybindings
(define-key global-map "\M-Q" 'unfill-paragraph)
(global-set-key "\M- " 'hippie-expand)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "C-&") 'gnus)
(global-set-key (kbd "C-_") 'global-hl-line-mode)
(global-set-key (kbd "C-ç") 'calc)
(global-set-key (kbd "C-à") (lambda () (interactive) (if (eq major-mode 'calendar-mode) (calendar-exit) (calendar))))
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-=") 'bzg/toggle-default-font-size)
(global-set-key (kbd "C-M-=") 'bzg/toggle-fringe-width)
(global-set-key (kbd "C-c F") 'auto-fill-mode)
(global-set-key (kbd "C-c f") 'find-name-dired)
(global-set-key (kbd "C-c g") 'deadgrep)
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-x <C-backspace>") 'bzg/find-bzg)
(global-set-key (kbd "C-x C-<left>") 'tab-previous)
(global-set-key (kbd "C-x C-<right>") 'tab-next)
(global-set-key (kbd "C-é") 'bzg/cycle-view)
(global-set-key (kbd "C-M-]") 'origami-toggle-all-nodes)
(global-set-key (kbd "M-]") 'origami-toggle-node)
(global-set-key (kbd "C-,") 'find-variable-or-function-at-point)
(global-set-key (kbd "C-M-<backspace>") 'backward-kill-word-noring)

;; Translation
(load-file "~/install/git/txl.el/txl.el")
(global-set-key (kbd "C-x R")   'txl-rephrase-region-or-paragraph)
(global-set-key (kbd "C-x T")   'txl-translate-region-or-paragraph)

;; magit-delta
(use-package magit-delta
  :hook (magit-mode . magit-delta-mode))


;; Elfeed
(use-package elfeed
  :bind ("C-x w" . elfeed))

(use-package org
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture)
         ("C-c L" . org-occur-link-in-agenda-files)
         :map org-mode-map
         ("C-c ç" . bzg/org-sort-todo-then-priority))
  :hook ((org-mode . (lambda () (electric-indent-local-mode -1)))
         (org-mode . (lambda ()
                       (add-hook 'before-save-hook #'bzg/org-cleanup-drawers nil t)
                       (add-hook 'before-save-hook 'org-update-all-dblocks t t)))
         (org-follow-link . (lambda ()
                              (when (eq major-mode 'gnus-summary-mode)
                                (gnus-summary-insert-dormant-articles)))))
  :custom
  (org-adapt-indentation 'headline-data)
  (org-priority-start-cycle-with-default nil)
  (org-pretty-entities t)
  (org-fast-tag-selection-single-key 'expert)
  (org-footnote-auto-label 'confirm)
  (org-footnote-auto-adjust t)
  (org-hide-emphasis-markers t)
  (org-hide-macro-markers t)
  (org-log-into-drawer t)
  (org-refile-allow-creating-parent-nodes t)
  ;; (org-refile-use-cache t)
  (org-refile-targets '((org-agenda-files :maxlevel . 2)))
  (org-return-follows-link t)
  (org-reverse-note-order t)
  (org-scheduled-past-days 100)
  (org-special-ctrl-a/e 'reversed)
  (org-special-ctrl-k t)
  (org-tag-alist
   '((:startgroup)
     ("!Handson" . ?o)
     (:grouptags)
     ("Write" . ?w) ("Mail" . ?@) ("Code" . ?c)
     (:endgroup)
     (:startgroup)
     ("_Handsoff" . ?f)
     (:grouptags)
     ("Read" . ?r) ("Watch" . ?W) ("Listen" . ?l)
     (:endgroup)))
  (org-todo-keywords '((sequence "STRT(s)" "NEXT(n)" "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANX(c)")))
  (org-todo-repeat-to-state t)
  (org-use-property-inheritance t)
  (org-use-sub-superscripts '{})
  (org-insert-heading-respect-content t)
  (org-id-uuid-program "uuidgen")
  (org-use-speed-commands
   (lambda nil
     (and (looking-at org-outline-regexp-bol)
          (not (org-in-src-block-p t)))))
  (org-todo-keyword-faces
   '(("STRT" . (:inverse-video t))
     ("NEXT" . (:weight bold :background "#eeeeee"))
     ("WAIT" . (:box t))
     ("CANX" . (:strike-through t))))
  (org-footnote-section "Notes")
  (org-attach-id-dir "~/org/data/")
  (org-allow-promoting-top-level-subtree t)
  (org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
  (org-enforce-todo-dependencies t)
  (org-fontify-whole-heading-line t)
  (org-file-apps
   '((auto-mode . emacs)
     (directory . emacs)
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "evince %s")))
  (org-hide-leading-stars t)
  (org-cycle-include-plain-lists nil)
  (org-link-email-description-format "%c: %.50s")
  (org-support-shift-select t)
  (org-ellipsis "…")
  (org-archive-location "~/org/archives/%s::")
  :config
  (require 'org-tempo)
  (require 'ol-gnus))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("►" "▸" "•" "★" "◇" "◇" "◇" "◇")))

(use-package org-clock
  :after org
  :custom
  (org-clock-display-default-range 'thisweek)
  (org-clock-persist t)
  (org-clock-idle-time 60)
  (org-clock-in-resume t)
  (org-clock-out-remove-zero-time-clocks t)
  (org-clock-sound "~/Music/clock.wav")
  :hook (org-clock-in . (lambda () (org-todo "STRT")))
  :config
  (org-clock-persistence-insinuate)

  ;; Set headlines to STRT and clock-in when running a countdown
  (defun bzg/org-timer-clock-out ()
    (when org-clock-current-task
      (call-interactively
       (if (eq major-mode 'org-agenda-mode)
           'org-agenda-clock-out
         'org-clock-out))))
  (add-hook 'org-timer-set-hook
            (lambda ()
              (call-interactively
               (if (eq major-mode 'org-agenda-mode)
                   'org-agenda-clock-in
                 'org-clock-in))))
  (add-hook 'org-timer-done-hook  #'bzg/org-timer-clock-out)
  (add-hook 'org-timer-pause-hook #'bzg/org-timer-clock-out)
  (add-hook 'org-timer-stop-hook  #'bzg/org-timer-clock-out))

(use-package org-capture
  :after org
  :custom
  (org-capture-templates
   '((":" "Rendez-vous" entry (file+headline "~/org/bzg.org" "Rendez-vous")
      "* %:fromname %?\n  SCHEDULED: %^T\n\n- %a" :prepend t)
     ("m" "Mission" entry (file+headline "~/org/bzg.org" "Mission") ; "m" for "mission"
      "* TODO %?\n\n- %a\n\n%i" :prepend t)
     ("@" "Mail" entry (file+headline "~/org/bzg.org" "Divers") ; "@" for "mail"
      "* TODO %a :Mail:" :prepend t)
     ("r" "Read" entry (file+headline "~/org/bzg.org" "Divers") ; "r" for "read"
      "* TODO %a :Read:" :prepend t)
     ;; (!) To indicate the captured item is immediately stored
     ("c" "Courant (!)" entry (file "~/org/bzg.org") ; "c" for "affaires (c)ourantes
      "* TODO %a" :prepend t :immediate-finish t))))

(use-package ob
  :after org
  :custom
  (org-confirm-babel-evaluate nil)
  (org-babel-default-header-args
   '((:session . "none")
     (:results . "replace")
     (:exports . "code")
     (:cache . "no")
     (:noweb . "yes")
     (:hlines . "no")
     (:tangle . "no")
     (:padnewline . "yes")))
  (org-edit-src-content-indentation 0)
  (org-babel-clojure-backend 'babashka)
  (org-link-elisp-confirm-function nil)
  (org-link-shell-confirm-function nil)
  (org-plantuml-jar-path "/home/bzg/bin/plantuml.jar")
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (dot . t)
     (clojure . t)
     (ditaa . t)
     (org . t)
     (ledger . t)
     (scheme . t)
     (plantuml . t)
     (R . t)
     (gnuplot . t)))
  (add-to-list 'org-src-lang-modes '("plantuml" . plantuml)))

(use-package ox
  :after org
  :custom
  (org-export-with-broken-links t)
  (org-export-default-language "fr")
  (org-export-with-archived-trees nil)
  (org-export-with-drawers '("HIDE"))
  (org-export-with-section-numbers nil)
  (org-export-with-sub-superscripts nil)
  (org-export-with-tags 'not-in-toc)
  (org-export-with-timestamps t)
  (org-export-with-toc nil)
  (org-export-with-priority t)
  (org-export-dispatch-use-expert-ui t)
  (org-export-use-babel t)
  (org-export-allow-bind-keywords t))

(use-package ox-publish
  :after ox
  :custom
  (org-publish-list-skipped-files nil))

(use-package ox-latex
  :after ox
  :custom
  (org-koma-letter-use-email t)
  (org-koma-letter-use-foldmarks nil)
  :config
  (add-to-list 'org-latex-classes
               '("my-letter"
                 "\\documentclass\{scrlttr2\}
	    \\usepackage[english,frenchb]{babel}
	    \[NO-DEFAULT-PACKAGES]
	    \[NO-PACKAGES]
	    \[EXTRA]")))

(use-package ox-html
  :after ox
  :custom
  (org-html-head "")
  (org-html-head-include-default-style nil)
  (org-html-table-row-tags
   (cons '(cond (top-row-p "<tr class=\"tr-top\">")
                (bottom-row-p "<tr class=\"tr-bottom\">")
                (t (if (= (mod row-number 2) 1)
                       "<tr class=\"tr-odd\">"
                     "<tr class=\"tr-even\">")))
         "</tr>")))

(use-package org-agenda
  :after org
  :hook (org-agenda-mode . (lambda ()
                             (let ((fringe-was-on (eq bzg/cycle-view-current 'one-window-with-fringe)))
                               (delete-other-windows)
                               (when fringe-was-on (bzg/big-fringe-mode 1)))))
  :custom
  (org-deadline-warning-days 3)
  (org-agenda-inhibit-startup t)
  (org-agenda-diary-file "/home/bzg/org/bzg.org")
  (org-agenda-files '("~/org/bzg.org"))
  (org-agenda-remove-tags t)
  (org-agenda-restore-windows-after-quit t)
  (org-agenda-show-inherited-tags nil)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-timestamp-if-done t)
  (org-agenda-skip-scheduled-if-deadline-is-shown t)
  (org-agenda-sorting-strategy
   '((agenda time-up deadline-up scheduled-up todo-state-up priority-down)
     (todo todo-state-up priority-down deadline-up)
     (tags todo-state-up priority-down deadline-up)
     (search todo-state-up priority-down deadline-up)))
  (org-agenda-tags-todo-honor-ignore-options t)
  (org-agenda-use-tag-inheritance nil)
  (org-agenda-window-frame-fractions '(0.0 . 0.5))
  (org-agenda-custom-commands
   '(;; Archive tasks
     ("#" "To archive" todo "DONE|CANX")

     ;; Review weekly appointements
     ("$" "Weekly appointments" agenda* "Weekly appointments")

     ;; Review weekly tasks
     ("ù" "Week tasks" agenda "Scheduled tasks for this week"
      ((org-agenda-category-filter-preset '("-RDV")) ; RDV for Rendez-vous
       (org-deadline-warning-days 0)
       (org-agenda-use-time-grid nil)))

     ;; Review started and next tasks
     ("µ" "STRT/NEXT" tags-todo "TODO={STRT\\|NEXT}")

     ;; Review other non-scheduled/deadlined to-do tasks
     (";" "TODO" tags-todo "TODO={TODO}+DEADLINE=\"\"+SCHEDULED=\"\"")

     ;; Review other non-scheduled/deadlined pending tasks
     (":" "WAIT" tags-todo "TODO={WAIT}+DEADLINE=\"\"+SCHEDULED=\"\"")

     ;; Review upcoming deadlines for the next 60 days
     ("!" "Deadlines all" agenda "Past/upcoming deadlines"
      ((org-agenda-span 1)
       (org-deadline-warning-days 60)
       (org-agenda-entry-types '(:deadline))))))
  :config
  (org-agenda-to-appt))

(use-package ox-icalendar
  :after org
  :custom
  (org-icalendar-use-scheduled '(event-if-not-todo))
  (org-icalendar-combined-name "Bastien Guerry Calendar")
  (org-icalendar-timezone "Europe/Paris"))

(defun bzg/org-sort-todo-then-priority ()
  "Sort entries by TODO state, then by priority within each state."
  (interactive)
  (let ((folded (save-excursion
		  (end-of-line)
		  (org-fold-core-get-folding-spec))))
    (org-sort-entries nil ?p)  ; Sort by priority first
    (org-sort-entries nil ?o)  ; Then by TODO state
    (when folded (org-fold-hide-subtree))))

(defun bzg/org-cleanup-drawers ()
  "Clean up drawers.
Remove all drawers except those containing :ARCHIVE:, :CATEGORY:, :ID:,
:ICAL_EVENT:, or :NOBLOCKING:, or an unfinished CLOCK line. If a drawer
is kept, remove the :LAST_REPEAT: property line from it. Ensure a blank
line remains between the headline/planning and the content."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward org-drawer-regexp nil t)
      (let ((element (org-element-at-point)))
        (when (memq (org-element-type element) '(property-drawer drawer))
          (let* ((begin (org-element-property :begin element))
                 (end (org-element-property :end element))
                 (contents-begin (org-element-property :contents-begin element))
                 (contents-end (org-element-property :contents-end element))
                 (contents (and contents-begin
                                contents-end
                                (buffer-substring-no-properties
                                 contents-begin contents-end)))
                 (keep-regexp (concat
                               (regexp-opt '(":ID:" ":ARCHIVE:" ":CATEGORY:"
                                             ":ICAL_EVENT:" ":NOBLOCKING:"))
                               "\\|CLOCK: \\[.*\\]\\s-*$"))
                 (keep (and contents (string-match-p keep-regexp contents))))
          (or keep
              (delete-region begin end)
              (when (and (not (looking-at-p "^[ \t]*$"))
                         (save-excursion
                           (forward-line -1)
                           (or (org-at-heading-p)
                               (org-at-planning-p))))
                (insert "\n")))))))))

(use-package epa
  :custom (epa-popup-info-window nil))

(use-package epg
  :custom (epg-pinentry-mode 'loopback))

(use-package gnus
  :custom
  (gnus-delay-default-delay "2d")
  (gnus-check-new-newsgroups nil)
  (gnus-save-newsrc-file nil)
  (gnus-refer-thread-limit t)
  (gnus-use-atomic-windows nil)
  (nndraft-directory "~/News/drafts/")
  (nnfolder-directory "~/Mail/archive")
  (gnus-summary-ignore-duplicates t)
  (gnus-suppress-duplicates t)
  (gnus-auto-select-first nil)
  (gnus-ignored-from-addresses
   (regexp-opt '("bastien.guerry@free.fr"
                 "bastien.guerry@data.gouv.fr"
                 "bastien.guerry@code.gouv.fr"
                 "bastien.guerry@mail.numerique.gouv.fr"
                 "bastien.guerry@numerique.gouv.fr"
                 "bzg@bzg.fr"
                 "bzg@gnu.org"
                 "bzg@softwareheritage.org"
                 "bastien.guerry@softwareheritage.org"
                 "bastien.guerry@inria.fr")))
  (mail-sources nil)
  (gnus-select-method '(nnnil ""))
  (gnus-secondary-select-methods
   '((nnimap "localhost"
             (nnimap-server-port "imaps")
             (nnimap-authinfo-file "~/.authinfo")
             (nnimap-stream ssl)
             (nnimap-expunge t))))
  (read-mail-command 'gnus)
  (gnus-directory "~/News/")
  (gnus-gcc-mark-as-read t)
  (gnus-inhibit-startup-message t)
  (gnus-interactive-catchup nil)
  (gnus-interactive-exit nil)
  (gnus-no-groups-message "")
  (gnus-novice-user nil)
  (gnus-nov-is-evil t)
  (gnus-use-cross-reference nil)
  (gnus-verbose 6)
  (mail-specify-envelope-from t)
  (mail-envelope-from 'header)
  (mail-user-agent 'gnus-user-agent)
  (message-kill-buffer-on-exit t)
  (message-forward-as-mime t)
  (gnus-subscribe-newsgroup-method 'gnus-subscribe-interactively)
  (nnir-notmuch-remove-prefix "/home/bzg/Mail")
  (gnus-message-archive-group 'my-gnus-message-archive-group)
  (gnus-group-sort-function
   '(gnus-group-sort-by-unread
     gnus-group-sort-by-rank
     ;; gnus-group-sort-by-score
     ;; gnus-group-sort-by-level
     ;; gnus-group-sort-by-alphabet
     ))
  (gnus-visible-headers
   "^From:\\|^Subject:\\|^Date:\\|^To:\\|^Cc:\\|^Newsgroups:\\|^Comments:\\|^User-Agent:")
  (message-draft-headers '(References From In-Reply-To))
  ;; message-generate-headers-first t ;; FIXME: Not needed Emacs>=29?
  (message-hidden-headers
   '("^References:" "^Face:" "^X-Face:" "^X-Draft-From:" "^In-Reply-To:" "^Message-ID:"))
  (nnmail-split-abbrev-alist
   '((any . "From\\|To\\|Cc\\|Sender\\|Apparently-To\\|Delivered-To\\|X-Apparently-To\\|Resent-From\\|Resent-To\\|Resent-Cc")
     (mail . "Mailer-Daemon\\|Postmaster\\|Uucp")
     (to . "To\\|Cc\\|Apparently-To\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
     (from . "From\\|Sender\\|Resent-From")
     (nato . "To\\|Cc\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
     (naany . "From\\|To\\|Cc\\|Sender\\|Resent-From\\|Resent-To\\|Delivered-To\\|X-Apparently-To\\|Resent-Cc")))
  (gnus-simplify-subject-functions
   '(gnus-simplify-subject-re gnus-simplify-whitespace))
  ;; Thread by Xref, not by subject
  (gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)
  (gnus-thread-sort-functions '(gnus-thread-sort-by-number
                                gnus-thread-sort-by-total-score
                                gnus-thread-sort-by-date))
  (gnus-sum-thread-tree-false-root "")
  (gnus-sum-thread-tree-indent " ")
  (gnus-sum-thread-tree-leaf-with-other "├► ")
  (gnus-sum-thread-tree-root "")
  (gnus-sum-thread-tree-single-leaf "╰► ")
  (gnus-sum-thread-tree-vertical "│")
  ;; Display a button for MIME parts
  (gnus-buttonized-mime-types '("multipart/alternative"))
  (gnus-user-date-format-alist
   '(((gnus-seconds-today) . "     %k:%M")
     ((+ 86400 (gnus-seconds-today)) . "hier %k:%M")
     ((+ 604800 (gnus-seconds-today)) . "%a  %k:%M")
     ((gnus-seconds-month) . "%a  %d")
     ((gnus-seconds-year) . "%b %d")
     (t . "%b %d '%y")))
  (gnus-group-line-format "%M%S%p%P %(%-40,40G%)\n")
  (gnus-group-line-default-format "%M%S%p%P %(%-40,40G%) %-3y %-3T %-3I\n")
  (gnus-use-adaptive-scoring nil)
  (gnus-adaptive-pretty-print nil)
  (gnus-summary-line-format
   (concat "%*%0{%U%R%z%}"
           "%0{ %}(%2t)"
           "%2{ %}%-23,23n"
           "%1{ %}%1{%B%}%2{%-102,102s%}%-140="
           "\n"))
  :hook ((gnus-summary-exit . gnus-summary-bubble-group)
         (gnus-summary-exit . gnus-group-sort-groups-by-rank)
         (gnus-suspend-gnus . gnus-group-sort-groups-by-rank)
         (gnus-exit-gnus . gnus-group-sort-groups-by-rank)
         (gnus-select-group . gnus-group-set-timestamp))
  :config
  (gnus-delay-initialize)
  ;; (setopt send-mail-function 'sendmail-send-it)
  ;; (setopt mail-use-rfc822 t)
  (add-hook 'gnus-exit-gnus-hook
            (lambda ()
              (if (get-buffer "bbdb")
                  (with-current-buffer "bbdb" (save-buffer)))))

  (defun my-gnus-message-archive-group (group-current)
    "Return prefered archive group."
    (cond
     ((and (stringp group-current)
           (or (message-news-p)
               (string-match "nntp\\+news" group-current 0)))
      (concat "nnfolder+archive:" (format-time-string "%Y-%m")
              "-divers-news"))
     ((and (stringp group-current) (< 0 (length group-current)))
      (concat (replace-regexp-in-string "[^/]+$" "" group-current) "Sent"))
     (t "nnimap+localhost:bzg.fr/bzg/Sent")))

  (defun bzg/gnus-toggle-group-line-format ()
    (interactive)
    (if (equal gnus-group-line-format
               gnus-group-line-default-format)
        (setopt gnus-group-line-format
                "%M%S%p%P %(%-40,40G%)\n")
      (setopt gnus-group-line-format
              gnus-group-line-default-format)))

  ;; Toggle the group line format
  (define-key gnus-group-mode-map "("
              (lambda () (interactive) (bzg/gnus-toggle-group-line-format) (gnus))))

(use-package gnus-alias
  :hook (message-setup . gnus-alias-determine-identity)
  :bind (:map message-mode-map ("C-c C-x C-i" . gnus-alias-select-identity))
  :custom (gnus-alias-default-identity nil))

(use-package gnus-art
  :config
  ;; Highlight my name in messages
  (add-to-list 'gnus-emphasis-alist
	       '("Bastien\\|bzg" 0 0 gnus-emphasis-highlight-words)))

(use-package gnus-icalendar
  :custom
  ;; To enable optional iCalendar->Org sync functionality
  ;; NOTE: both the capture file and the headline(s) inside must already exist
  (gnus-icalendar-org-capture-file "~/org/bzg.org")
  (gnus-icalendar-org-capture-headline '("Rendez-vous"))
  :config
  (gnus-icalendar-setup)
  (gnus-icalendar-org-setup))

(use-package gnus-dired
  :config
  ;; Make the `gnus-dired-mail-buffers' function also work on
  ;; message-mode derived modes, such as mu4e-compose-mode
  (defun gnus-dired-mail-buffers ()
    "Return a list of active message buffers."
    (let (buffers)
      (save-current-buffer
	(dolist (buffer (buffer-list t))
	  (set-buffer buffer)
	  (when (and (derived-mode-p 'message-mode)
		     (null message-sent-message-via))
	    (push (buffer-name buffer) buffers))))
      (nreverse buffers))))

(use-package message
  :hook (message-mode . (lambda () (abbrev-mode 0)))
  :custom
  (message-send-mail-function 'message-send-mail-with-sendmail)
  (message-dont-reply-to-names gnus-ignored-from-addresses)
  (message-alternative-emails gnus-ignored-from-addresses))

(define-key gnus-group-mode-map "GG" 'notmuch-search)

(use-package bbdb
  :hook ((gnus-startup . bbdb-insinuate-gnus)
         (message-setup . bbdb-mail-aliases)
         (mail-setup . bbdb-mail-aliases)
         (bbdb-notice-mail . bbdb-auto-notes))
  :commands (bbdb bbdb-search)
  :custom
  (bbdb-file "~/Documents/config/bbdb")
  (bbdb-mua-pop-up nil)
  (bbdb-mua-interactive-action '(query . create))
  (bbdb-allow-duplicates t)
  (bbdb-pop-up-window-size 5)
  (bbdb-ignore-redundant-mails t)
  (bbdb-add-aka nil)
  (bbdb-add-name nil)
  (bbdb-add-mails t)
  (bbdb-ignore-message-alist '(("Newsgroup" . ".*")))
  (bbdb-auto-notes-alist
   '(("Newsgroups" ("[^,]+" newsgroups 0))
     ("Subject" (".*" last-subj 0 t))
     ("User-Agent" (".*" mailer 0))
     ("X-Mailer" (".*" mailer 0))
     ("Organization" (".*" organization 0))
     ("X-Newsreader" (".*" mailer 0))
     ("X-Face" (".+" face 0 'replace))
     ("Face" (".+" face 0 'replace))))
  :config
  (require 'bbdb-com)
  (require 'bbdb-anniv)
  (require 'bbdb-gnus)
  (bbdb-initialize 'message 'gnus)
  (bbdb-mua-auto-update-init 'message 'gnus)
  ;; (add-hook 'list-diary-entries-hook 'bbdb-include-anniversaries)
  (defalias 'bbdb-y-or-n-p #'(lambda (prompt) t)))

(use-package time
  :custom
  (display-time-24hr-format t)
  (display-time-day-and-date t))

(use-package appt
  :custom
  (appt-audible nil)
  (appt-display-interval 10)
  (appt-message-warning-time 120)
  :config
  (appt-activate t))

(use-package calendar
  :defer t
  :custom
  (calendar-date-style 'european)
  (calendar-mark-holidays-flag t)
  (calendar-week-start-day 1)
  :config
  (setopt french-holiday
	  '((holiday-fixed 1 1 "Jour de l'an")
	    (holiday-fixed 5 8 "Victoire 45")
	    (holiday-fixed 7 14 "Fête nationale")
	    (holiday-fixed 8 15 "Assomption")
	    (holiday-fixed 11 1 "Toussaint")
	    (holiday-fixed 11 11 "Armistice 18")
	    (holiday-easter-etc 1 "Lundi de Pâques")
	    (holiday-easter-etc 39 "Ascension")
	    (holiday-easter-etc 50 "Lundi de Pentecôte")
	    (holiday-fixed 1 6 "Épiphanie")
	    (holiday-fixed 2 2 "Chandeleur")
	    (holiday-fixed 2 14 "Saint Valentin")
	    (holiday-fixed 5 1 "Fête du travail")
	    (holiday-fixed 5 8 "Commémoration de la capitulation de l'Allemagne en 1945")
	    (holiday-fixed 6 21 "Fête de la musique")
	    (holiday-fixed 11 2 "Commémoration des fidèles défunts")
	    (holiday-fixed 12 25 "Noël")
	    ;; fêtes à date variable
	    (holiday-easter-etc 0 "Pâques")
	    (holiday-easter-etc 49 "Pentecôte")
	    (holiday-easter-etc -47 "Mardi gras")
	    (holiday-float 6 0 3 "Fête des pères") ;; troisième dimanche de juin
	    ;; Fête des mères
	    (holiday-sexp
	     '(if (equal
		   ;; Pentecôte
		   (holiday-easter-etc 49)
		   ;; Dernier dimanche de mai
		   (holiday-float 5 0 -1 nil))
		  ;; -> Premier dimanche de juin si coïncidence
		  (car (car (holiday-float 6 0 1 nil)))
		;; -> Dernier dimanche de mai sinon
		(car (car (holiday-float 5 0 -1 nil))))
	     "Fête des mères"))))

(defun bzg/notmuch-file-to-group (file)
  "Calculate the Gnus group name from the given file name."
  (cond ((string-match "/home/bzg/Mail/Maildir/\\([^/]+\\)/\\([^/]+\\)\\(?:/\\([^/]+\\)\\)?" file)
	 (when-let* ((3rd-match (match-string 3 file)))
	   (if (not (string= "cur" 3rd-match))
	       (format "nnimap+localhost:%s/%s/%s"
		       (match-string 1 file)
		       (match-string 2 file)
		       3rd-match)
	     (format "nnimap+localhost:%s/%s"
		     (match-string 1 file)
		     (match-string 2 file)))))
	(t (user-error "Unknown group"))))

(defun bzg/notmuch-goto-message-in-gnus ()
  "Open a summary buffer containing the current notmuch article."
  (interactive)
  (let ((group (bzg/notmuch-file-to-group (notmuch-show-get-filename)))
	(message-id (replace-regexp-in-string
		     "^id:\\|\"" "" (notmuch-show-get-message-id))))
    (if (and group message-id)
	(progn (org-gnus-follow-link group message-id))
      (message "Couldn't get relevant infos for switching to Gnus."))))

;; notmuch configuration
(use-package notmuch
  :commands (notmuch-search notmuch-show)
  :config
  (setopt notmuch-fcc-dirs nil)
  (define-key notmuch-show-mode-map
	      (kbd "C-c C-c") #'bzg/notmuch-goto-message-in-gnus))

(use-package dired
  :hook ((dired-mode . turn-on-gnus-dired-mode)
         (dired-mode . dired-hide-details-mode))
  :custom
  (list-directory-verbose-switches "-al")
  (dired-listing-switches "-l")
  (dired-dwim-target t)
  (dired-maybe-use-globstar t)
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  (delete-old-versions t))

(use-package dired-x
  :after dired
  :config
  ;; (define-key dired-mode-map "\C-cd" 'dired-clean-tex)
  (setopt dired-guess-shell-alist-user
          (let ((by-app
                 '(("evince &"       "pdf")
                   ("libreoffice &"  "docx?" "pptx?" "odf" "odt" "csv"
                    "od[sgpt]" "xlsx?" "xls" "pp[st]" "rtf")
                   ("audacity"       "aup?")
                   ("kdenlive"       "kdenlive")
                   ("gimp"           "svg" "psd" "xcf")
                   ("gedit"          "txt" "sql" "css")
                   ("geeqie"         "jpe?g" "png" "gif")
                   ("scribus"        "sla")
                   ("unzip"          "xo")
                   ("vlc"            "3gp" "mp3" "flac" "avi" "wm[va]" "flv"
                    "mov" "divx" "mp4" "webm" "mkv" "mpe?g"
                    "m4[av]" "mp2" "ogg" "ogv" "wav")
                   ("gv"             "ps")
                   ("unrar x"        "rar"))))
            (mapcan (lambda (entry)
                      (let ((cmd (car entry)))
                        (mapcar (lambda (ext)
                                  (list (concat "\\." ext "$") cmd))
                                (cdr entry))))
                    by-app)))

  (setopt dired-tex-unclean-extensions
	  '(".toc" ".log" ".aux" ".dvi" ".out" ".nav" ".snm")))

(use-package browse-url
  :bind ("C-è" . bzg/toggle-browser)
  :custom
  (browse-url-browser-function 'browse-url-generic)
  (browse-url-secondary-browser-function 'eww-browse-url)
  (browse-url-generic-program "firefox")
  (browse-url-firefox-new-window-is-tab t)
  :config
  (defun bzg/toggle-browser ()
    (interactive)
    (if (eq browse-url-browser-function 'browse-url-generic)
        (progn (setopt browse-url-browser-function 'eww-browse-url)
	       (setopt browse-url-secondary-browser-function 'browse-url-generic)
	       (message "Browser set to eww"))
      (setopt browse-url-browser-function 'browse-url-generic)
      (setopt browse-url-secondary-browser-function 'eww-browse-url)
      (message "Browser set to generic"))))

;; Paredit initialization
(use-package paredit
  :bind (:map paredit-mode-map ("C-M-w" . sp-copy-sexp)))

(use-package slime
  :defer t
  :config
  (setopt inferior-lisp-program "sbcl"))

;; Use LSP
(use-package lsp-mode
  :commands lsp
  :hook ((clojure-ts-mode . lsp)
	 (slime-mode . lsp)
         (emacs-lisp-mode . lsp))
  :custom
  (lsp-warn-no-matched-clients nil)
  (lsp-prefer-flymake nil))

(use-package clojure-ts-mode
  :mode "\\.clj\\'"
  :hook ((clojure-ts-mode . company-mode)
         (clojure-ts-mode . origami-mode)
         (clojure-ts-mode . paredit-mode)
         (clojure-ts-mode . aggressive-indent-mode)
         (edn-mode . paredit-mode))
  :custom
  (clojure-align-forms-automatically t)
  (inf-clojure-generic-cmd "clojure")
  :config
  (require 'flycheck-clj-kondo))

;; (use-package clj-refactor
;;   :config
;;   ;; (setopt clojure-thread-all-but-last t)
;;   (define-key clj-refactor-map "\C-ctf" #'clojure-thread-first-all)
;;   (define-key clj-refactor-map "\C-ctl" #'clojure-thread-last-all)
;;   (define-key clj-refactor-map "\C-cu" #'clojure-unwind)
;;   (define-key clj-refactor-map "\C-cU" #'clojure-unwind-all))

(use-package cider
  :defer t
  :hook (cider-repl-mode . company-mode)
  :custom
  (cider-use-fringe-indicators nil)
  (cider-repl-pop-to-buffer-on-connect nil)
  (nrepl-hide-special-buffers t))

(use-package elisp-mode
  :hook ((emacs-lisp-mode . company-mode)
         (emacs-lisp-mode . electric-indent-mode)
         (emacs-lisp-mode . paredit-mode)
         (emacs-lisp-mode . origami-mode)))

(defvar bzg/cycle-view-states
  '(one-window-with-fringe one-window-no-fringe two-windows-balanced))

(defvar bzg/cycle-view-current nil)

(defun bzg/cycle-view ()
  "Cycle through my favorite views."
  (interactive)
  (cond
   ;; Two windows stacked top/bottom: always delete other windows first
   ((and (= (count-windows) 2)
         (window-combined-p nil nil))
    (delete-other-windows))
   ;; More than one window and previous command was NOT this one: just delete other windows
   ((and (> (count-windows) 1)
         (not (eq last-command 'bzg/cycle-view)))
    (delete-other-windows)
    (bzg/big-fringe-mode -1)
    (setq bzg/cycle-view-current 'one-window-no-fringe))
   ;; More than one window and previous command WAS this one: back to Center
   ((> (count-windows) 1)
    (delete-other-windows)
    (bzg/big-fringe-mode 1)
    (setq bzg/cycle-view-current 'one-window-with-fringe))
   ;; One window: cycle as before
   (t
    (setq bzg/cycle-view-current
          (or (cadr (memq bzg/cycle-view-current bzg/cycle-view-states))
              (car bzg/cycle-view-states)))
    (pcase bzg/cycle-view-current
      ('one-window-with-fringe
       (bzg/big-fringe-mode 1))
      ('one-window-no-fringe
       (bzg/big-fringe-mode -1))
      ('two-windows-balanced
       (bzg/big-fringe-mode -1)
       (split-window-right)
       (other-window 1)
       (balance-windows))))))

(advice-add 'split-window-horizontally :before (lambda () (interactive) (bzg/big-fringe-mode -1)))
(advice-add 'split-window-right :before (lambda () (interactive) (bzg/big-fringe-mode -1)))

(defvar bzg/big-fringe 320)
(defun bzg/toggle-fringe-width ()
  "Toggle fringe width between 320 and 820."
  (interactive)
  (setq bzg/big-fringe (if (= bzg/big-fringe 320) 820 320))
  (when bzg/big-fringe-mode
    (set-frame-parameter nil 'left-fringe bzg/big-fringe)
    (set-frame-parameter nil 'right-fringe bzg/big-fringe))
  (message "Fringe set to %d" bzg/big-fringe))

(define-minor-mode bzg/big-fringe-mode
  "Minor mode for wide fringes."
  :init-value nil
  :global t
  (let ((width (if bzg/big-fringe-mode bzg/big-fringe 10)))
    (set-frame-parameter nil 'left-fringe width)
    (set-frame-parameter nil 'right-fringe width)))

;; Persist fringe state per tab
(use-package tab-bar
  :config
  (advice-add 'tab-bar--current-tab-make :filter-return
              (lambda (tab)
                (nconc tab (list (cons 'bzg-big-fringe bzg/big-fringe-mode)))))

  (advice-add 'tab-bar-select-tab :after
              (lambda (&rest _)
                (when-let* ((tabs (funcall tab-bar-tabs-function))
                            (current (seq-find (lambda (tab) (eq (car tab) 'current-tab)) tabs)))
                  (bzg/big-fringe-mode (if (alist-get 'bzg-big-fringe (cdr current)) 1 -1)))))

  (add-hook 'tab-bar-tab-post-open-functions
            (lambda (_tab) (bzg/big-fringe-mode -1))))


;; See https://bzg.fr/emacs-hide-mode-line.html
(defvar-local hidden-mode-line-mode nil)
(defvar-local hide-mode-line nil)

(define-minor-mode hidden-mode-line-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global nil
  :variable hidden-mode-line-mode
  :group 'editing-basics
  (if hidden-mode-line-mode
      (setq hide-mode-line mode-line-format
    	    mode-line-format nil)
    (setq mode-line-format hide-mode-line
    	  hide-mode-line nil))
  (force-mode-line-update)
  ;; Apparently force-mode-line-update is not always enough to
  ;; redisplay the mode-line
  (redraw-display)
  (when (and (called-interactively-p 'interactive)
    	     hidden-mode-line-mode)
    (run-with-idle-timer
     0 nil 'message
     (concat "Hidden Mode Line Mode enabled.  "
    	     "Use M-x hidden-mode-line-mode to make the mode-line appear."))))

(add-hook 'after-change-major-mode-hook 'hidden-mode-line-mode)
(add-hook 'org-mode-hook (lambda () (electric-indent-mode 0)))

(use-package whitespace
  :defer t
  :config
  (add-to-list 'whitespace-style 'lines-tail))

(use-package ibuffer
  :defer t
  :bind ("C-x C-b" . ibuffer))

;; M-x package-install RET register-list RET
(use-package register-list
  :defer t
  :bind ("C-x r L" . register-list))

;; Displays a helper about the current available keybindings
(use-package which-key
  :config (which-key-mode))

(use-package eww
  :defer t
  :hook (eww-mode . visual-line-mode)
  :custom
  (eww-header-line-format "")
  (shr-width 80)
  (shr-inhibit-images t)
  (shr-use-colors nil)
  (shr-use-fonts nil))

(use-package envrc
  :config (envrc-global-mode))

(use-package vterm :bind ("C-)" . vterm))

(use-package ediff
  :custom (ediff-window-setup-function 'ediff-setup-windows-plain))

(use-package dired-subtree
  :bind (:map dired-mode-map
              ("I" . dired-subtree-toggle)
              ("TAB" . dired-subtree-cycle))
  :config
  (setopt dired-subtree-use-backgrounds nil))

;; Use ugrep
(setopt xref-search-program 'ugrep)

;; Always follow symbolic links when editing
(setopt vc-follow-symlinks t)

;; elp.el is the Emacs Lisp profiler, sort by average time
(setopt elp-sort-by-function 'elp-sort-by-average-time)

;; Don't show bookmark line in the margin
(setopt bookmark-fringe-mark nil)

;; doc-view and eww/shr configuration
(setopt doc-view-continuous t)

;; Use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; Fontifying todo items outside of org-mode
(defface bzg/todo-comment-face
  '((t (:weight bold :bold t)))
  "Face for TODO in code buffers."
  :group 'org-faces)

(defvar bzg/todo-comment-face 'bzg/todo-comment-face)

(use-package pdf-tools
  :config (pdf-tools-install))

(defun bzg/gnus-toggle-nntp ()
  (interactive)
  (if (= (length gnus-secondary-select-methods) 1)
      (progn (add-to-list
	      'gnus-secondary-select-methods
	      '(nntp "news" (nntp-address "news.gmane.io")))
	     (message "nntp server ON"))
    (progn
      (setopt gnus-secondary-select-methods
	      (remove '(nntp "news" (nntp-address "news.gmane.io"))
		      gnus-secondary-select-methods))
      (message "nntp server OFF"))))

(define-key gnus-group-mode-map (kbd "%") #'bzg/gnus-toggle-nntp)

;; Gptel configuration
(setq gptel-default-mode 'org-mode)
;; (load-file "~/.emacs.d/gptel.el")
(load-file "~/.emacs.d/gnus-icalendar.el")
