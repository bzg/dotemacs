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

;; Hide fringe background and fringe indicators
(set-face-attribute 'fringe nil :background nil)
(mapc (lambda (fb) (set-fringe-bitmap-face fb 'org-hide)) fringe-bitmaps)

;; Increase GC threshold during startup
(setopt gc-cons-threshold 100000000)

;; Reset after init
(add-hook 'emacs-startup-hook (lambda () (setopt gc-cons-threshold 800000)))

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
(add-to-list 'Info-directory-list "~/install/git/org/org-mode/doc/")
(add-to-list 'Info-directory-list "~/install/git/emacs/info/")

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

;; Ignore case when sorting
(setopt sort-fold-case t)

;; Stop polluting the directory with auto-saved files and backup
(setopt auto-save-default nil)
(setopt make-backup-files nil)

;; Well, it's more so that you know this option
(setopt kill-whole-line t)
(setopt kill-read-only-ok t)
(setopt require-final-newline t)

;; Scrolling done right
(setopt scroll-error-top-bottom t)
(setopt focus-follows-mouse t)
(setopt recenter-positions '(top bottom middle))

;; Number of lines of continuity when scrolling by screenfulls
(setopt next-screen-context-lines 0)

;; Always use "y" for "yes"
(fset 'yes-or-no-p 'y-or-n-p)

(setopt with-editor-emacsclient-executable "emacsclient")

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

(setopt modus-themes-common-palette-overrides '((fringe bg-main)))
(load-theme 'modus-operandi)

;; Reset some font stuff
(set-face-attribute 'default nil :family "Roboto Mono" :height 120)
(set-face-attribute 'italic nil :family "Roboto Mono" :weight 'semi-light :slant 'normal)
(set-face-attribute 'bold-italic nil :slant 'normal)
;; (set-face-attribute 'default nil :family "Roboto Mono" :weight 'semi-light :height 120)
;; (set-face-attribute 'default nil :family "Roboto Mono" :weight 'regular :height 120)
;; (set-face-attribute 'bold nil :family "Roboto Mono" :weight 'regular)

;; Define options and functions I will later bind
(setopt bzg-default-font-size 120)
(setopt bzg-alt-font-size 200)

(defun bzg-toggle-default-font-size ()
  (interactive)
  (if (< (abs (- (face-attribute 'default :height) bzg-alt-font-size)) 10)
      (custom-set-faces
       `(default ((t (:height ,bzg-default-font-size)))))
    (custom-set-faces
     `(default ((t (:height ,bzg-alt-font-size)))))))

;; Easily jump to my main org file
(defun bzg-find-bzg nil
  "Find the bzg.org file."
  (interactive)
  (find-file "~/org/bzg.org")
  (hidden-mode-line-mode 1)
  (delete-other-windows))

;; Easily unfill paragraphs
(defun unfill-paragraph ()
  "Make a multi-line paragraph into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

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
(global-set-key (kbd "C-è") 'bzg-toggle-browser)
(global-set-key (kbd "C-_") 'global-hl-line-mode)
(global-set-key (kbd "C-ç") 'calc)
(global-set-key (kbd "C-à") (lambda () (interactive) (if (eq major-mode 'calendar-mode) (calendar-exit) (calendar))))
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-=") 'bzg-toggle-default-font-size)
(global-set-key (kbd "C-M-=") 'bzg-toggle-fringe-width)
(global-set-key (kbd "C-c F") 'auto-fill-mode)
(global-set-key (kbd "C-c f") 'find-name-dired)
(global-set-key (kbd "C-c g") 'deadgrep)
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-x <C-backspace>") 'bzg-find-bzg)
(global-set-key (kbd "C-x C-<left>") 'tab-previous)
(global-set-key (kbd "C-x C-<right>") 'tab-next)
(global-set-key (kbd "C-é") 'bzg-cycle-view)
(global-set-key (kbd "C-M-]") 'origami-toggle-all-nodes)
(global-set-key (kbd "M-]") 'origami-toggle-node)
(global-set-key (kbd "C-,") 'find-variable-or-function-at-point)
(global-set-key (kbd "C-M-<backspace>") 'backward-kill-word-noring)

;; Translation
(load-file "~/install/git/txl.el/txl.el")
(global-set-key (kbd "C-x R")   'txl-rephrase-region-or-paragraph)
(global-set-key (kbd "C-x T")   'txl-translate-region-or-paragraph)

;; Elfeed
(global-set-key (kbd "C-x w") 'elfeed)

(require 'org-tempo)
(require 'org-bullets)
(setopt org-bullets-bullet-list '("►" "▸" "•" "★" "◇" "◇" "◇" "◇"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook (lambda () (electric-indent-local-mode -1)))
(add-hook 'message-mode-hook (lambda () (abbrev-mode 0)))
(require 'ol-gnus)

;; org-mode global keybindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cL" 'org-occur-link-in-agenda-files)

;; Hook to update all blocks before saving
(add-hook 'org-mode-hook
	  (lambda() (add-hook 'before-save-hook
			      'org-update-all-dblocks t t)))

;; Hook to display dormant article in Gnus
(add-hook 'org-follow-link-hook
	  (lambda ()
	    (if (eq major-mode 'gnus-summary-mode)
		(gnus-summary-insert-dormant-articles))))

(setopt org-adapt-indentation 'headline-data)
(setopt org-priority-start-cycle-with-default nil)
(setopt org-pretty-entities t)
(setopt org-fast-tag-selection-single-key 'expert)
(setopt org-footnote-auto-label 'confirm)
(setopt org-footnote-auto-adjust t)
(setopt org-hide-emphasis-markers t)
(setopt org-hide-macro-markers t)
(setopt org-log-into-drawer t)
(setopt org-refile-allow-creating-parent-nodes t)
;; (setopt org-refile-use-cache t)
(setq org-refile-targets '((org-agenda-files :maxlevel . 2)))
(setopt org-element-use-cache t)
(setopt org-return-follows-link t)
(setopt org-reverse-note-order t)
(setopt org-scheduled-past-days 100)
(setopt org-special-ctrl-a/e 'reversed)
(setopt org-special-ctrl-k t)
(setopt org-tag-alist
	'((:startgroup)
	  ("!Handson" . ?o)
	  (:grouptags)
	  ("Write" . ?w) ("Code" . ?c)
	  (:endgroup)
	  (:startgroup)
	  ("_Handsoff" . ?f)
	  (:grouptags)
	  ("Read" . ?r) ("Watch" . ?W) ("Listen" . ?l)
	  (:endgroup)))
(setopt org-todo-keywords '((sequence "STRT(s)" "NEXT(n)" "TODO(t)" "WAIT(w)" "|" "DONE(d)" "CANX(c)")))
(setopt org-todo-repeat-to-state t)
(setopt org-use-property-inheritance t)
(setopt org-use-sub-superscripts '{})
(setopt org-insert-heading-respect-content t)
(setopt org-confirm-babel-evaluate nil)
(setopt org-id-uuid-program "uuidgen")
(setopt org-use-speed-commands
	(lambda nil
	  (and (looking-at org-outline-regexp-bol)
	       (not (org-in-src-block-p t)))))
(setopt org-todo-keyword-faces
	'(("STRT" . (:inverse-video t))
	  ("NEXT" . (:weight bold :background "#eeeeee"))
	  ("WAIT" . (:box t))
	  ("CANX" . (:strike-through t))))
(setopt org-footnote-section "Notes")
(setopt org-attach-id-dir "~/org/data/")
(setopt org-allow-promoting-top-level-subtree t)
(setopt org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
(setopt org-enforce-todo-dependencies t)
(setopt org-fontify-whole-heading-line t)
(setopt org-file-apps
	'((auto-mode . emacs)
	  (directory . emacs)
	  ("\\.mm\\'" . default)
	  ("\\.x?html?\\'" . default)
	  ("\\.pdf\\'" . "evince %s")))
(setopt org-hide-leading-stars t)
(setopt org-cycle-include-plain-lists nil)
(setopt org-link-email-description-format "%c: %.50s")
(setopt org-support-shift-select t)
(setopt org-ellipsis "…")
(setopt org-archive-location "~/org/archives/%s::")

(org-clock-persistence-insinuate)

(setopt org-clock-display-default-range 'thisweek)
(setopt org-clock-persist t)
(setopt org-clock-idle-time 60)
(setopt org-clock-in-resume t)
(setopt org-clock-out-remove-zero-time-clocks t)
(setopt org-clock-sound "~/Music/clock.wav")

;; Set headlines to STRT when clocking in
(add-hook 'org-clock-in-hook (lambda() (org-todo "STRT")))

;; Set headlines to STRT and clock-in when running a countdown
(add-hook 'org-timer-set-hook
	  (lambda ()
	    (if (eq major-mode 'org-agenda-mode)
		(call-interactively 'org-agenda-clock-in)
	      (call-interactively 'org-clock-in))))
(add-hook 'org-timer-done-hook
	  (lambda ()
	    (if (and (eq major-mode 'org-agenda-mode)
		     org-clock-current-task)
		(call-interactively 'org-agenda-clock-out)
	      (call-interactively 'org-clock-out))))
(add-hook 'org-timer-pause-hook
	  (lambda ()
	    (if org-clock-current-task
		(if (eq major-mode 'org-agenda-mode)
		    (call-interactively 'org-agenda-clock-out)
		  (call-interactively 'org-clock-out)))))
(add-hook 'org-timer-stop-hook
	  (lambda ()
	    (if org-clock-current-task
		(if (eq major-mode 'org-agenda-mode)
		    (call-interactively 'org-agenda-clock-out)
		  (call-interactively 'org-clock-out)))))

(setopt org-capture-templates
	'((":" "Rendez-vous" entry (file+headline "~/org/bzg.org" "Rendez-vous")
	   "* %:fromname %?\n  SCHEDULED: %^T\n\n- %a" :prepend t)
	  ;; (!) To indicate the captured item is immediately stored
	  ("s" "A trier (!)" entry (file "~/org/bzg.org") ; "s" for "sort"
	   "* TODO %a" :prepend t :immediate-finish t)
	  ("r" "Divers à lire (!)" entry (file+headline "~/org/bzg.org" "Divers") ; "r" for read
	   "* TODO %a :Read:" :prepend t :immediate-finish t)
	  ("w" "Mission" entry (file+headline "~/org/bzg.org" "Mission") ; "w" for work
	   "* TODO %?\n\n- %a\n\n%i" :prepend t)))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)
   (dot . t)
   (clojure . t)
   (org . t)
   (ditaa . t)
   (org . t)
   (ledger . t)
   (scheme . t)
   (plantuml . t)
   (R . t)
   (gnuplot . t)))

(setopt org-babel-default-header-args
	'((:session . "none")
	  (:results . "replace")
	  (:exports . "code")
	  (:cache . "no")
	  (:noweb . "yes")
	  (:hlines . "no")
	  (:tangle . "no")
	  (:padnewline . "yes")))

(setopt org-edit-src-content-indentation 0)
(setopt org-babel-clojure-backend 'babashka)
(setopt org-link-elisp-confirm-function nil)
(setopt org-link-shell-confirm-function nil)
(setopt org-plantuml-jar-path "/home/bzg/bin/plantuml.jar")
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
(org-babel-do-load-languages 'org-babel-load-languages '((plantuml . t)))

(require 'ox-md)
(require 'ox-beamer)
(require 'ox-latex)
(require 'ox-odt)
(require 'ox-koma-letter)
(setopt org-koma-letter-use-email t)
(setopt org-koma-letter-use-foldmarks nil)

(add-to-list 'org-latex-classes
	     '("my-letter"
	       "\\documentclass\{scrlttr2\}
	    \\usepackage[english,frenchb]{babel}
	    \[NO-DEFAULT-PACKAGES]
	    \[NO-PACKAGES]
	    \[EXTRA]"))

(setopt org-export-with-broken-links t)
(setopt org-export-default-language "fr")
(setopt org-export-backends '(latex odt icalendar html ascii koma-letter))
(setopt org-export-with-archived-trees nil)
(setopt org-export-with-drawers '("HIDE"))
(setopt org-export-with-section-numbers nil)
(setopt org-export-with-sub-superscripts nil)
(setopt org-export-with-tags 'not-in-toc)
(setopt org-export-with-timestamps t)
(setopt org-html-head "")
(setopt org-html-head-include-default-style nil)
(setopt org-export-with-toc nil)
(setopt org-export-with-priority t)
(setopt org-export-dispatch-use-expert-ui t)
(setopt org-export-use-babel t)
(setopt org-latex-pdf-process
	'("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f" "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f" "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))
(setopt org-export-allow-bind-keywords t)
(setopt org-publish-list-skipped-files nil)
(setopt org-html-table-row-tags
	(cons '(cond (top-row-p "<tr class=\"tr-top\">")
		     (bottom-row-p "<tr class=\"tr-bottom\">")
		     (t (if (= (mod row-number 2) 1)
			    "<tr class=\"tr-odd\">"
			  "<tr class=\"tr-even\">")))
	      "</tr>"))

(setopt org-html-head-include-default-style nil)

(add-to-list 'org-latex-packages-alist '("AUTO" "babel" t ("pdflatex")))

(org-agenda-to-appt)

;; Hook to display the agenda in a single window
(add-hook 'org-agenda-finalize-hook 'delete-other-windows)

(setopt org-deadline-warning-days 3)
(setopt org-agenda-inhibit-startup t)
(setopt org-agenda-diary-file "/home/bzg/org/bzg.org")
(setopt org-agenda-files '("~/org/bzg.org"))
(setopt org-agenda-remove-tags t)
(setopt org-agenda-restore-windows-after-quit t)
(setopt org-agenda-show-inherited-tags nil)
(setopt org-agenda-skip-deadline-if-done t)
(setopt org-agenda-skip-scheduled-if-done t)
(setopt org-agenda-skip-timestamp-if-done t)
(setopt org-agenda-sorting-strategy
	'((agenda time-up deadline-up scheduled-up todo-state-up priority-down)
	  (todo todo-state-up priority-down deadline-up)
	  (tags todo-state-up priority-down deadline-up)
	  (search todo-state-up priority-down deadline-up)))
(setopt org-agenda-tags-todo-honor-ignore-options t)
(setopt org-agenda-use-tag-inheritance nil)
(setopt org-agenda-window-frame-fractions '(0.0 . 0.5))

;; icalendar stuff
(setopt org-icalendar-include-todo 'all)
(setopt org-icalendar-combined-name "Bastien Guerry ORG")
(setopt org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo))
(setopt org-icalendar-use-deadline '(todo-due event-if-todo event-if-not-todo))
(setopt org-icalendar-timezone "Europe/Paris")
(setopt org-icalendar-store-UID t)

(setopt org-agenda-custom-commands
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

(use-package epa
  :config
  (setopt epa-popup-info-window nil))

(use-package epg
  :config
  (setopt epg-pinentry-mode 'loopback))

(use-package gnus
  :config
  (gnus-delay-initialize)
  (setopt gnus-delay-default-delay "2d")
  (setopt gnus-refer-thread-limit t)
  (setopt gnus-use-atomic-windows nil)
  (setopt nndraft-directory "~/News/drafts/")
  (setopt nnfolder-directory "~/Mail/archive")
  (setopt gnus-summary-ignore-duplicates t)
  (setopt gnus-suppress-duplicates t)
  (setopt gnus-auto-select-first nil)
  (setopt gnus-ignored-from-addresses
	  (regexp-opt '("bastien.guerry@free.fr"
			"bastien.guerry@data.gouv.fr"
			"bastien.guerry@code.gouv.fr"
			"bastien.guerry@mail.numerique.gouv.fr"
			"bastien.guerry@numerique.gouv.fr"
			"bzg@bzg.fr"
			"bzg@gnu.org"
			)))

  (setopt send-mail-function 'sendmail-send-it)
  (setopt mail-use-rfc822 t)

  ;; Sources and methods
  (setopt mail-sources nil
	  gnus-select-method '(nnnil "")
	  gnus-secondary-select-methods
	  '(;; (nnmaildir "nnml" (directory "~/Mail/nnml"))
	    (nnimap "localhost"
		    (nnimap-server-port "imaps")
		    (nnimap-authinfo-file "~/.authinfo")
		    (nnimap-stream ssl)
		    (nnimap-expunge t))))

  (add-hook 'gnus-exit-gnus-hook
	    (lambda ()
	      (if (get-buffer "bbdb")
		  (with-current-buffer "bbdb" (save-buffer)))))

  (setopt read-mail-command 'gnus
	  gnus-directory "~/News/"
	  gnus-gcc-mark-as-read t
	  gnus-inhibit-startup-message t
	  gnus-interactive-catchup nil
	  gnus-interactive-exit nil
	  gnus-no-groups-message ""
	  gnus-novice-user nil
	  gnus-nov-is-evil t
	  gnus-use-cross-reference nil
	  gnus-verbose 6
	  mail-specify-envelope-from t
	  mail-envelope-from 'header
	  mail-user-agent 'gnus-user-agent
	  message-kill-buffer-on-exit t
	  message-forward-as-mime t)

  (setopt gnus-subscribe-newsgroup-method 'gnus-subscribe-interactively)

  (setopt nnir-notmuch-remove-prefix "/home/bzg/Mail")

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
     (t "nnimap+localhost:bzg@bzg.fr/Sent")))

  (setopt gnus-message-archive-group 'my-gnus-message-archive-group)

  ;; Group sorting
  (setopt gnus-group-sort-function
	  '(gnus-group-sort-by-unread
	    gnus-group-sort-by-rank
	    ;; gnus-group-sort-by-score
	    ;; gnus-group-sort-by-level
	    ;; gnus-group-sort-by-alphabet
	    ))

  (add-hook 'gnus-summary-exit-hook 'gnus-summary-bubble-group)
  (add-hook 'gnus-summary-exit-hook 'gnus-group-sort-groups-by-rank)
  (add-hook 'gnus-suspend-gnus-hook 'gnus-group-sort-groups-by-rank)
  (add-hook 'gnus-exit-gnus-hook 'gnus-group-sort-groups-by-rank)

  ;; Headers we wanna see:
  (setopt gnus-visible-headers
	  "^From:\\|^Subject:\\|^Date:\\|^To:\\|^Cc:\\|^Newsgroups:\\|^Comments:\\|^User-Agent:"
	  message-draft-headers '(References From In-Reply-To)
	  ;; message-generate-headers-first t ;; FIXME: Not needed Emacs>=29?
	  message-hidden-headers
	  '("^References:" "^Face:" "^X-Face:" "^X-Draft-From:" "^In-Reply-To:" "^Message-ID:"))

  ;; Sort mails
  (setopt nnmail-split-abbrev-alist
	  '((any . "From\\|To\\|Cc\\|Sender\\|Apparently-To\\|Delivered-To\\|X-Apparently-To\\|Resent-From\\|Resent-To\\|Resent-Cc")
	    (mail . "Mailer-Daemon\\|Postmaster\\|Uucp")
	    (to . "To\\|Cc\\|Apparently-To\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
	    (from . "From\\|Sender\\|Resent-From")
	    (nato . "To\\|Cc\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
	    (naany . "From\\|To\\|Cc\\|Sender\\|Resent-From\\|Resent-To\\|Delivered-To\\|X-Apparently-To\\|Resent-Cc")))

  ;; Simplify the subject lines
  (setopt gnus-simplify-subject-functions
	  '(gnus-simplify-subject-re gnus-simplify-whitespace))

  ;; Thread by Xref, not by subject
  (setopt gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
	  gnus-thread-sort-functions '(gnus-thread-sort-by-number
				       gnus-thread-sort-by-total-score
				       gnus-thread-sort-by-date)
	  gnus-sum-thread-tree-false-root ""
	  gnus-sum-thread-tree-indent " "
	  gnus-sum-thread-tree-leaf-with-other "├► "
	  gnus-sum-thread-tree-root ""
	  gnus-sum-thread-tree-single-leaf "╰► "
	  gnus-sum-thread-tree-vertical "│")

  ;; Dispkay a button for MIME parts
  (setopt gnus-buttonized-mime-types '("multipart/alternative"))

  (setopt gnus-user-date-format-alist
	  '(((gnus-seconds-today) . "     %k:%M")
	    ((+ 86400 (gnus-seconds-today)) . "hier %k:%M")
	    ((+ 604800 (gnus-seconds-today)) . "%a  %k:%M")
	    ((gnus-seconds-month) . "%a  %d")
	    ((gnus-seconds-year) . "%b %d")
	    (t . "%b %d '%y")))

  ;; Add a time-stamp to a group when it is selected
  (add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)

  ;; Format group line
  (setopt gnus-group-line-format "%M%S%p%P %(%-40,40G%)\n")
  (setopt gnus-group-line-default-format "%M%S%p%P %(%-40,40G%) %-3y %-3T %-3I\n")

  (defun bzg-gnus-toggle-group-line-format ()
    (interactive)
    (if (equal gnus-group-line-format
	       gnus-group-line-default-format)
	(setopt gnus-group-line-format
		"%M%S%p%P %(%-40,40G%)\n")
      (setopt gnus-group-line-format
	      gnus-group-line-default-format)))

  ;; Toggle the group line format
  (define-key gnus-group-mode-map "("
	      (lambda () (interactive) (bzg-gnus-toggle-group-line-format) (gnus)))

  ;; Scoring
  (setopt gnus-use-adaptive-scoring '(word line)
	  gnus-adaptive-pretty-print t
          gnus-adaptive-word-length-limit 5
	  gnus-score-exact-adapt-limit nil
	  gnus-default-adaptive-word-score-alist
	  '((42 . 3) ;cached
            (65 . 2) ;replied
            (70 . 1) ;forwarded
            (82 . 1) ;read
            (67 . -1) ;catchup
            (69 . 0) ;expired
            (75 . -3) ;killed
            (114 . -3))
	  ;; gnus-score-decay-constant 1
	  ;; gnus-decay-scores t
	  ;; gnus-decay-score 1000
	  )

  (setopt gnus-summary-line-format
	  (concat "%*%0{%U%R%z%}"
		  "%0{ %}(%2t)"
		  "%2{ %}%-23,23n"
		  "%1{ %}%1{%B%}%2{%-102,102s%}%-140="
		  "\n")))

(use-package gnus-alias
  :config
  (define-key message-mode-map (kbd "C-c C-x C-i")
	      'gnus-alias-select-identity))

(use-package gnus-art
  :config
  ;; Highlight my name in messages
  (add-to-list 'gnus-emphasis-alist
	       '("Bastien\\|bzg" 0 0 gnus-emphasis-highlight-words)))

(use-package gnus-icalendar
  :config
  (gnus-icalendar-setup)
  ;; To enable optional iCalendar->Org sync functionality
  ;; NOTE: both the capture file and the headline(s) inside must already exist
  (setopt gnus-icalendar-org-capture-file "~/org/bzg.org")
  (setopt gnus-icalendar-org-capture-headline '("Rendez-vous"))
  (setopt gnus-icalendar-org-template-key "I")
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
  :config
  (setopt message-send-mail-function 'message-send-mail-with-sendmail)
  (setopt message-dont-reply-to-names gnus-ignored-from-addresses)
  (setopt message-alternative-emails gnus-ignored-from-addresses))

(use-package bbdb
  :config
  (require 'bbdb-com)
  (require 'bbdb-anniv)
  (require 'bbdb-gnus)
  (setopt bbdb-file "~/Documents/config/bbdb")
  (bbdb-initialize 'message 'gnus)
  (bbdb-mua-auto-update-init 'message 'gnus)

  (setopt bbdb-mua-pop-up nil)
  (setopt bbdb-allow-duplicates t)
  (setopt bbdb-pop-up-window-size 5)
  (setopt bbdb-ignore-redundant-mails t)

  (add-hook 'mail-setup-hook 'bbdb-mail-aliases)
  (add-hook 'message-setup-hook 'bbdb-mail-aliases)
  (add-hook 'bbdb-notice-mail-hook 'bbdb-auto-notes)
  ;; (add-hook 'list-diary-entries-hook 'bbdb-include-anniversaries)

  (setopt bbdb-add-aka nil
	  bbdb-add-name nil
	  bbdb-add-mails t
	  bbdb-ignore-message-alist '(("Newsgroup" . ".*")))

  (defalias 'bbdb-y-or-n-p #'(lambda (prompt) t))

  (setopt bbdb-auto-notes-alist
	  '(("Newsgroups" ("[^,]+" newsgroups 0))
	    ("Subject" (".*" last-subj 0 t))
	    ("User-Agent" (".*" mailer 0))
	    ("X-Mailer" (".*" mailer 0))
	    ("Organization" (".*" organization 0))
	    ("X-Newsreader" (".*" mailer 0))
	    ("X-Face" (".+" face 0 'replace))
	    ("Face" (".+" face 0 'replace)))))

(appt-activate t)
(setopt display-time-24hr-format t
	display-time-day-and-date t
	appt-audible nil
	appt-display-interval 10
	appt-message-warning-time 120)

(use-package calendar
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
	     "Fête des mères")))

  (setopt calendar-date-style 'european
	  calendar-mark-holidays-flag t
	  calendar-week-start-day 1))

;; notmuch configuration
(use-package notmuch
  :config
  (setopt notmuch-fcc-dirs nil)
  (add-hook 'gnus-group-mode-hook 'bzg-notmuch-shortcut)

  (defun bzg-notmuch-shortcut ()
    (define-key gnus-group-mode-map "GG" 'notmuch-search))

  (defun bzg-notmuch-file-to-group (file)
    "Calculate the Gnus group name from the given file name."
    (cond ((string-match "/home/bzg/Mail/nnml/\\([^/]+\\)/" file)
	   (format "nnml:mail.%s" (match-string 1 file)))
	  ((string-match "/home/bzg/Mail/Maildir/\\([^/]+\\)/\\([^/]+\\)" file)
	   (format "nnimap+localhost:%s/%s" (match-string 1 file) (match-string 2 file)))
	  (t (user-error "Unknown group"))))

  (defun bzg-notmuch-goto-message-in-gnus ()
    "Open a summary buffer containing the current notmuch article."
    (interactive)
    (let ((group (bzg-notmuch-file-to-group (notmuch-show-get-filename)))
	  (message-id (replace-regexp-in-string
		       "^id:\\|\"" "" (notmuch-show-get-message-id))))
      (if (and group message-id)
	  (progn (org-gnus-follow-link group message-id))
	(message "Couldn't get relevant infos for switching to Gnus."))))

  (define-key notmuch-show-mode-map
	      (kbd "C-c C-c") #'bzg-notmuch-goto-message-in-gnus))

(use-package dired-x
  :config
  ;; (define-key dired-mode-map "\C-cd" 'dired-clean-tex)
  (setopt dired-guess-shell-alist-user
	  (list
	   (list "\\.pdf$" "evince &")
	   (list "\\.docx?$" "libreoffice &")
	   (list "\\.aup?$" "audacity")
	   (list "\\.pptx?$" "libreoffice &")
	   (list "\\.odf$" "libreoffice &")
	   (list "\\.odt$" "libreoffice &")
	   (list "\\.odt$" "libreoffice &")
	   (list "\\.kdenlive$" "kdenlive")
	   (list "\\.svg$" "gimp")
	   (list "\\.csv$" "libreoffice &")
	   (list "\\.sla$" "scribus")
	   (list "\\.od[sgpt]$" "libreoffice &")
	   (list "\\.xls$" "libreoffice &")
	   (list "\\.xlsx$" "libreoffice &")
	   (list "\\.txt$" "gedit")
	   (list "\\.sql$" "gedit")
	   (list "\\.css$" "gedit")
	   (list "\\.jpe?g$" "sxiv")
	   (list "\\.png$" "sxiv")
	   (list "\\.gif$" "sxiv")
	   (list "\\.psd$" "gimp")
	   (list "\\.xcf" "gimp")
	   (list "\\.xo$" "unzip")
	   (list "\\.3gp$" "vlc")
	   (list "\\.mp3$" "vlc")
	   (list "\\.flac$" "vlc")
	   (list "\\.avi$" "vlc")
	   ;; (list "\\.og[av]$" "vlc")
	   (list "\\.wm[va]$" "vlc")
	   (list "\\.flv$" "vlc")
	   (list "\\.mov$" "vlc")
	   (list "\\.divx$" "vlc")
	   (list "\\.mp4$" "vlc")
	   (list "\\.webm$" "vlc")
	   (list "\\.mkv$" "vlc")
	   (list "\\.mpe?g$" "vlc")
	   (list "\\.m4[av]$" "vlc")
	   (list "\\.mp2$" "vlc")
	   (list "\\.pp[st]$" "libreoffice &")
	   (list "\\.ogg$" "vlc")
	   (list "\\.ogv$" "vlc")
	   (list "\\.rtf$" "libreoffice &")
	   (list "\\.ps$" "gv")
	   (list "\\.mp3$" "play")
	   (list "\\.wav$" "vlc")
	   (list "\\.rar$" "unrar x")
	   ))
  (setopt dired-tex-unclean-extensions
	  '(".toc" ".log" ".aux" ".dvi" ".out" ".nav" ".snm")))

(setopt list-directory-verbose-switches "-al")
(setopt dired-listing-switches "-l")
(setopt dired-dwim-target t)
(setopt dired-maybe-use-globstar t)
(setopt dired-recursive-copies 'always)
(setopt dired-recursive-deletes 'always)
(setopt delete-old-versions t)

(setopt browse-url-browser-function 'browse-url-generic)
(setopt browse-url-secondary-browser-function 'eww-browse-url)
(setopt browse-url-generic-program "firefox")
(setopt browse-url-firefox-new-window-is-tab t)

(defun bzg-toggle-browser ()
  (interactive)
  (if (eq browse-url-browser-function 'browse-url-generic)
      (progn (setopt browse-url-browser-function 'eww-browse-url)
	     (setopt browse-url-secondary-browser-function 'browse-url-generic)
	     (message "Browser set to eww"))
    (setopt browse-url-browser-function 'browse-url-generic)
    (setopt browse-url-secondary-browser-function 'eww-browse-url)
    (message "Browser set to generic")))

;; Paredit initialization
(use-package paredit
  :config
  (define-key paredit-mode-map (kbd "C-M-w") 'sp-copy-sexp))

(use-package slime
  :config
  (setq inferior-lisp-program "sbcl"))

;; Clojure initialization
(setopt inf-clojure-generic-cmd "clojure")

;; Use LSP
(use-package lsp-mode
  :commands lsp
  :hook ((clojure-ts-mode . lsp)
	 (slime-mode . lsp)
         (emacs-lisp-mode . lsp))
  :config
  (setopt lsp-warn-no-matched-clients nil)
  (setopt lsp-prefer-flymake nil))

(use-package clojure-ts-mode
  :config
  (require 'flycheck-clj-kondo)
  (setopt clojure-align-forms-automatically t)
  (add-hook 'clojure-ts-mode-hook 'company-mode)
  (add-hook 'clojure-ts-mode-hook 'origami-mode)
  (add-hook 'clojure-ts-mode-hook 'paredit-mode)
  ;; (add-hook 'clojure-mode-hook 'clj-refactor-mode)
  (add-hook 'clojure-ts-mode-hook 'aggressive-indent-mode))

;; (use-package clj-refactor
;;   :config
;;   ;; (setopt clojure-thread-all-but-last t)
;;   (define-key clj-refactor-map "\C-ctf" #'clojure-thread-first-all)
;;   (define-key clj-refactor-map "\C-ctl" #'clojure-thread-last-all)
;;   (define-key clj-refactor-map "\C-cu" #'clojure-unwind)
;;   (define-key clj-refactor-map "\C-cU" #'clojure-unwind-all))

(use-package cider
  :config
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (setopt cider-use-fringe-indicators nil)
  (setopt cider-repl-pop-to-buffer-on-connect nil)
  (setopt nrepl-hide-special-buffers t))

;; Emacs Lisp initialization
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'electric-indent-mode 'append)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
(add-hook 'emacs-lisp-mode-hook 'origami-mode)

(setopt bzg-cycle-view-current nil)

(defun bzg-cycle-view ()
  "Cycle through my favorite views."
  (interactive)
  (let ((splitted-frame
	 (or (< (window-height) (1- (frame-height)))
	     (< (window-width) (frame-width)))))
    (cond ((not (eq last-command 'bzg-cycle-view))
	   (delete-other-windows)
	   (bzg-big-fringe-mode)
	   (setopt bzg-cycle-view-current 'one-window-with-fringe))
	  ((and (not bzg-cycle-view-current) splitted-frame)
	   (delete-other-windows))
	  ((not bzg-cycle-view-current)
	   (delete-other-windows)
	   (if bzg-big-fringe-mode
	       (progn (bzg-big-fringe-mode)
		      (setopt bzg-cycle-view-current 'one-window-no-fringe))
	     (bzg-big-fringe-mode)
	     (setopt bzg-cycle-view-current 'one-window-with-fringe)))
	  ((eq bzg-cycle-view-current 'one-window-with-fringe)
	   (delete-other-windows)
	   (bzg-big-fringe-mode -1)
	   (setopt bzg-cycle-view-current 'one-window-no-fringe))
	  ((eq bzg-cycle-view-current 'one-window-no-fringe)
	   (delete-other-windows)
	   (split-window-right)
	   (bzg-big-fringe-mode -1)
	   (other-window 1)
	   (balance-windows)
	   (setopt bzg-cycle-view-current 'two-windows-balanced))
	  ((eq bzg-cycle-view-current 'two-windows-balanced)
	   (delete-other-windows)
	   (bzg-big-fringe-mode 1)
	   (setopt bzg-cycle-view-current 'one-window-with-fringe)))))

(advice-add 'split-window-horizontally :before (lambda () (interactive) (bzg-big-fringe-mode 0)))
(advice-add 'split-window-right :before (lambda () (interactive) (bzg-big-fringe-mode 0)))

(setopt bzg-big-fringe 300)
(defun bzg-toggle-fringe-width ()
  (interactive)
  (if (equal bzg-big-fringe 300)
      (progn (setopt bzg-big-fringe 700)
	     (message "Fringe set to 700"))
    (setopt bzg-big-fringe 300)
    (message "Fringe set to 300")))

(define-minor-mode bzg-big-fringe-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global t
  :variable bzg-big-fringe-mode
  :group 'editing-basics
  (if (not bzg-big-fringe-mode)
      (fringe-mode 10)
    (fringe-mode bzg-big-fringe)))

;; (bzg-big-fringe-mode 1)

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
  :config
  (add-to-list 'whitespace-style 'lines-tail))

(use-package ibuffer
  :config
  (global-set-key (kbd "C-x C-b") 'ibuffer))

;; M-x package-install RET register-list RET
(use-package register-list
  :config
  (global-set-key (kbd "C-x r L") 'register-list))

;; Displays a helper about the current available keybindings
(which-key-mode)

(use-package eww
  :config
  (add-hook 'eww-mode-hook 'visual-line-mode)
  (setopt eww-header-line-format ""
	  shr-width 80
	  shr-inhibit-images t
	  shr-use-colors nil
	  shr-use-fonts nil))

(envrc-global-mode)

(global-set-key (kbd "C-<dead-circumflex>") (lambda () (interactive) (vterm)))

(setopt ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package dired-subtree
  :config
  (setopt dired-subtree-use-backgrounds nil)
  (define-key dired-mode-map (kbd "I") 'dired-subtree-toggle)
  (define-key dired-mode-map (kbd "TAB") 'dired-subtree-cycle))

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

(add-hook 'dired-mode-hook #'turn-on-gnus-dired-mode)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Fontifying todo items outside of org-mode
(defface bzg-todo-comment-face
  '((t (:weight bold :bold t)))
  "Face for TODO in code buffers."
  :group 'org-faces)

(defvar bzg-todo-comment-face 'bzg-todo-comment-face)

(pdf-tools-install)

(defun bzg-gnus-toggle-nntp ()
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

(define-key gnus-group-mode-map (kbd "%") #'bzg-gnus-toggle-nntp)

(load-file "~/.emacs.d/gptel.el")
