(eval-when-compile
  (setq package-archives
	'(("gnu" . "http://elpa.gnu.org/packages/")
	  ("melpa" . "http://melpa.org/packages/")))
  (require 'use-package))

;; Unset C-z
(global-unset-key (kbd "C-z"))

;; Load custom file
(setq custom-file "/home/guerry/.emacs.d/emacs-custom.el")
(load custom-file)

;; Initialize Org
(add-to-list 'load-path "~/install/git/org-mode/lisp/")
(add-to-list 'load-path "~/install/git/org-mode/contrib/lisp/")
(add-to-list 'load-path "~/install/git/org-caldav/")

;; Initialize other important modes
(add-to-list 'load-path "~/install/cvs/emacs-w3m/")
(add-to-list 'load-path "~/install/git/notmuch/emacs/")

;; Initialize `exec-path' and `load-path'
(add-to-list 'exec-path "~/bin/")
(let ((default-directory "~/Documents/elisp/"))
  (normal-top-level-add-subdirs-to-load-path))

;; Load theme
;; (add-to-list 'custom-theme-load-path "~/install/git/vxid-theme/")
;; (load-theme 'vxid)
(load-theme 'doom-nord)

;; Start server to use emacsclient
(server-start)

;; Initialize `Info-directory-list' to include org-mode
(setq Info-refill-paragraphs t)
(add-to-list 'Info-directory-list "~/install/git/org-mode/doc/")
(add-to-list 'Info-directory-list "~/install/git/emacs/info/")

;; Don't ask for confirmation for "dangerous" commands
(put 'erase-buffer 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

;; We expect local variables to be known
(setq enable-local-eval t)

;; Enabling and disabling some modes
(show-paren-mode 1)
(auto-insert-mode 1)
(display-time-mode 1)
(tooltip-mode -1)
(blink-cursor-mode -1)
(scroll-bar-mode -1)
(pixel-scroll-mode 1)
(mouse-avoidance-mode 'cat-and-mouse)
(setq max-lisp-eval-depth 10000)

;; Default Frame
(setq initial-frame-alist
      '((alpha . 85)
	(left-margin-width . 10)
	(menu-bar-lines . 0)
	(tool-bar-lines . 0)
	(horizontal-scroll-bars . nil)
	(vertical-scroll-bars . nil)))

;; Don't display initial messages
(setq initial-scratch-message "")
(setq initial-major-mode 'org-mode)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message "guerry")
(setq use-dialog-box nil)
(setq search-invisible 'open)
(setq default-frame-alist initial-frame-alist)
(set-frame-parameter nil 'fullscreen 'fullboth)

;; Who I am
(setq user-full-name "Bastien")
(setq user-mail-address "bzg@bzg.fr")

;; Let's get a backtrace when errors are
(setq debug-on-error t)

;; Display byte-compiler warnings on error
(setq byte-compile-debug t)

;; The default is to wait 1 second, which I find a bit long
(setq echo-keystrokes 0.1)

;; Stop polluting the directory with auto-saved files and backup
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq auto-save-list-file-prefix nil)

;; Well, it's more so that you know this option
(setq kill-whole-line t)
(setq kill-read-only-ok t)
(setq require-final-newline t)

;; Scrolling done right
(setq scroll-error-top-bottom t)

;; Number of lines of continuity when scrolling by screenfulls
(setq next-screen-context-lines 0)

;; Always use "y" for "yes"
(fset 'yes-or-no-p 'y-or-n-p)

;; elp.el is the Emacs Lisp profiler, sort by average time
(setq elp-sort-by-function 'elp-sort-by-average-time)

(setq fill-column 72)
(setq line-move-visual nil)
(setq visible-bell t)
(setq spell-command "aspell")
(setq tab-always-indent 'always)
(setq display-time-mail-string "#")
(setq focus-follows-mouse t)
(setq text-mode-hook '(turn-on-auto-fill text-mode-hook-identify))

(setenv "EDITOR" "emacsclient")
(setenv "CVS_RSH" "ssh")

(setq recenter-positions '(top bottom middle))

(use-package whitespace
  :config
  (add-to-list 'whitespace-style 'lines-tail)
  (setq whitespace-line-column 80))

(use-package ibuffer
  :defer t
  :config
  (global-set-key (kbd "C-x C-b") 'ibuffer))

;; (use-package dash :defer t)

(use-package cider
  :defer t
  :config
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (setq cider-use-fringe-indicators nil)
  (setq cider-repl-pop-to-buffer-on-connect nil)
  (setq nrepl-hide-special-buffers t))

;; (global-company-mode)
;; (global-set-key (kbd "M-TAB") #'company-complete) ; use M-TAB, a.k.a. C-M-i, as manual trigger
;; (setq company-idle-delay nil) ; never start completions automatically
(use-package company
  :defer t)

;; M-x package-install RET register-list RET
(use-package register-list
  :config
  (global-set-key (kbd "C-x r L") 'register-list))

;; `line-spacing' is nil by default, I change it from time to time
;; (setq line-spacing 0)

(global-set-key (kbd "C-x <C-backspace>") 'bzg-find-bzg)
(global-set-key (kbd "<home>") 'beginning-of-buffer)
(global-set-key (kbd "<end>") 'end-of-buffer)
(global-set-key (kbd "C-²") (lambda () (interactive) (org-agenda nil "  ")))
(global-set-key (kbd "C-&") 'gnus)
(global-set-key (kbd "C-é") 'bzg-cycle-view)
(global-set-key (kbd "C-\"") (lambda () (interactive) (dired "~") (revert-buffer)))
(global-set-key (kbd "C-c f") 'find-name-dired)
(global-set-key (kbd "C-c g") 'grep-find)
(global-set-key (kbd "C-c A") 'helm-ag)
(global-set-key (kbd "C-c F") 'auto-fill-mode)
(global-set-key (kbd "C-c o") 'occur)
(global-set-key (kbd "C-c O") 'multi-occur)
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-à") (lambda () (interactive) (if (eq major-mode 'calendar-mode) (calendar-exit) (calendar))))
(global-set-key (kbd "C-ç") 'calc)
(global-set-key (kbd "C-+") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "C-=") 'text-scale-adjust)
(global-set-key (kbd "C-M-]") 'origami-toggle-all-nodes)
(global-set-key (kbd "M-]") 'origami-toggle-node)
(global-set-key "\M- " 'hippie-expand)

(require 'google-translate)

(defun google-translate-word-at-point ()
  (interactive)
  (let ((w (thing-at-point 'word)))
    (google-translate-translate "auto" "fr" w)))

(global-set-key (kbd "C-c t") (lambda (s) (interactive "sTranslate: ")
				(google-translate-translate "auto" "fr" s)))
(global-set-key (kbd "C-c T") 'google-translate-word-at-point)

(defun unfill-paragraph ()
  "Make a multi-line paragraph into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)

(use-package helm
  :config
  (require 'helm-config)
  ;; (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x c x") #'helm-M-x)
  ;; (global-set-key (kbd "C-x F") #'helm-find-files)
  (global-set-key (kbd "C-x c A") #'helm-ag))

(setq bzg-cycle-view-current nil)

(defun bzg-cycle-view ()
  "Cycle through my favorite views."
  (interactive)
  (let ((splitted-frame
	 (or (< (window-height) (1- (frame-height)))
	     (< (window-width) (frame-width)))))
    (cond ((not (eq last-command 'bzg-cycle-view))
	   (delete-other-windows)
	   (bzg-big-fringe-mode)
	   (setq bzg-cycle-view-current 'one-window-with-fringe))
	  ((and (not bzg-cycle-view-current) splitted-frame)
	   (delete-other-windows))
	  ((not bzg-cycle-view-current)
	   (delete-other-windows)
	   (if bzg-big-fringe-mode
	       (progn (bzg-big-fringe-mode)
		      (setq bzg-cycle-view-current 'one-window-no-fringe))
	     (bzg-big-fringe-mode)
	     (setq bzg-cycle-view-current 'one-window-with-fringe)))
	  ((eq bzg-cycle-view-current 'one-window-with-fringe)
	   (delete-other-windows)
	   (bzg-big-fringe-mode -1)
	   (setq bzg-cycle-view-current 'one-window-no-fringe))
	  ((eq bzg-cycle-view-current 'one-window-no-fringe)
	   (delete-other-windows)
	   (split-window-right)
	   (bzg-big-fringe-mode -1)
	   (other-window 1)
	   (balance-windows)
	   (setq bzg-cycle-view-current 'two-windows-balanced))
	  ((eq bzg-cycle-view-current 'two-windows-balanced)
	   (delete-other-windows)
	   (bzg-big-fringe-mode 1)
	   (setq bzg-cycle-view-current 'one-window-with-fringe)))))

(advice-add 'split-window-horizontally :before (lambda () (interactive) (bzg-big-fringe-mode 0)))
(advice-add 'split-window-right :before (lambda () (interactive) (bzg-big-fringe-mode 0)))

(use-package dired
  :config
  (define-key dired-mode-map "a" #'helm-ag))

(use-package dired-x
  :config
  ;; (define-key dired-mode-map "\C-cd" 'dired-clean-tex)
  (setq dired-guess-shell-alist-user
	(list
	 (list "\\.pdf$" "evince &")
	 (list "\\.docx?$" "libreoffice")
	 (list "\\.aup?$" "audacity")
	 (list "\\.pptx?$" "libreoffice")
	 (list "\\.odf$" "libreoffice")
	 (list "\\.odt$" "libreoffice")
	 (list "\\.odt$" "libreoffice")
	 (list "\\.kdenlive$" "kdenlive")
	 (list "\\.svg$" "gimp")
	 (list "\\.csv$" "libreoffice")
	 (list "\\.sla$" "scribus")
	 (list "\\.od[sgpt]$" "libreoffice")
	 (list "\\.xls$" "libreoffice")
	 (list "\\.xlsx$" "libreoffice")
	 (list "\\.txt$" "gedit")
	 (list "\\.sql$" "gedit")
	 (list "\\.css$" "gedit")
	 (list "\\.jpe?g$" "geeqie")
	 (list "\\.png$" "geeqie")
	 (list "\\.gif$" "geeqie")
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
	 (list "\\.pp[st]$" "libreoffice")
	 (list "\\.ogg$" "vlc")
	 (list "\\.ogv$" "vlc")
	 (list "\\.rtf$" "libreoffice")
	 (list "\\.ps$" "gv")
	 (list "\\.mp3$" "play")
	 (list "\\.wav$" "vlc")
	 (list "\\.rar$" "unrar x")
	 ))
  (setq dired-tex-unclean-extensions
	'(".toc" ".log" ".aux" ".dvi" ".out" ".nav" ".snm")))

(setq directory-free-space-args "-Pkh")
(setq list-directory-verbose-switches "-al")
(setq dired-listing-switches "-l")
(setq dired-dwim-target t)
(setq dired-omit-mode nil)
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
(setq delete-old-versions t)

(appt-activate t)
(setq display-time-24hr-format t
      display-time-day-and-date t
      appt-audible nil
      appt-display-interval 10
      appt-message-warning-time 120)
(setq diary-file "~/.diary")

(require 'ox-rss)
(require 'ox-md)
(require 'ox-beamer)
(require 'ox-latex)
(require 'ox-odt)
(require 'ol-gnus)
(require 'ox-koma-letter)
(setq org-koma-letter-use-email t)
(setq org-koma-letter-use-foldmarks nil)

;; org-mode global keybindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-cL" 'org-occur-link-in-agenda-files)

;; Hook to display the agenda in a single window
(add-hook 'org-agenda-finalize-hook 'delete-other-windows)

;; Hook to update all blocks before saving
(add-hook 'org-mode-hook
	  (lambda() (add-hook 'before-save-hook
			      'org-update-all-dblocks t t)))

;; Hook to display dormant article in Gnus
(add-hook 'org-follow-link-hook
	  (lambda ()
	    (if (eq major-mode 'gnus-summary-mode)
		(gnus-summary-insert-dormant-articles))))

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

(setq org-babel-default-header-args
      '((:session . "none")
	(:results . "replace")
	(:exports . "code")
	(:cache . "no")
	(:noweb . "yes")
	(:hlines . "no")
	(:tangle . "no")
	(:padnewline . "yes")))

(org-clock-persistence-insinuate)

;; Set headlines to STRT when clocking in
(add-hook 'org-clock-in-hook (lambda() (org-todo "STRT")))

(setq org-adapt-indentation 'headline-data)
(setq org-edit-src-content-indentation 0)
(setq org-babel-clojure-backend 'inf-clojure)
(setq inf-clojure-generic-cmd "clojure")
(setq org-agenda-inhibit-startup t)
(setq org-agenda-diary-file "/home/guerry/org/rdv.org")
(setq org-priority-start-cycle-with-default nil)
(setq org-agenda-dim-blocked-tasks t)
(setq org-log-into-drawer "LOGBOOK")
(setq org-agenda-entry-text-maxlines 10)
(setq org-timer-default-timer 25)
(setq org-agenda-files '("~/org/rdv.org" "~/org/bzg.org"))
(setq org-agenda-prefix-format
      '((agenda . " %i %-12:c%?-14t%s")
	(timeline . "  % s")
	(todo . " %i %-14:c")
	(tags . " %i %-14:c")
	(search . " %i %-14:c")))
(setq org-agenda-remove-tags t)
(setq org-agenda-restore-windows-after-quit t)
(setq org-agenda-show-inherited-tags nil)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-timestamp-if-done t)
(setq org-agenda-sorting-strategy
      '((agenda time-up) (todo time-up) (tags time-up) (search time-up)))
(setq org-agenda-tags-todo-honor-ignore-options t)
(setq org-agenda-use-tag-inheritance nil)
(setq org-agenda-window-frame-fractions '(0.0 . 0.5))
(setq org-agenda-deadline-faces
      '((1.0001 . org-warning)              ; due yesterday or before
	(0.0    . org-upcoming-deadline)))  ; due today or later
(setq org-export-default-language "fr")
(setq org-export-backends '(latex odt icalendar html ascii rss koma-letter))
(setq org-export-with-archived-trees nil)
(setq org-export-with-drawers '("HIDE"))
(setq org-export-with-section-numbers nil)
(setq org-export-with-sub-superscripts nil)
(setq org-export-with-tags 'not-in-toc)
(setq org-export-with-timestamps t)
(setq org-html-head "")
(setq org-html-head-include-default-style nil)
(setq org-export-with-toc nil)
(setq org-export-with-priority t)
(setq org-export-dispatch-use-expert-ui t)
(setq org-export-babel-evaluate t)
(setq org-latex-listings t)
(setq org-latex-pdf-process
      '("pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f" "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f" "pdflatex -interaction nonstopmode -shell-escape -output-directory %o %f"))
(setq org-export-allow-bind-keywords t)
(setq org-publish-list-skipped-files nil)
(setq org-html-table-row-tags
      (cons '(cond (top-row-p "<tr class=\"tr-top\">")
		   (bottom-row-p "<tr class=\"tr-bottom\">")
		   (t (if (= (mod row-number 2) 1)
			  "<tr class=\"tr-odd\">"
			"<tr class=\"tr-even\">")))
	    "</tr>"))
(setq org-pretty-entities t)
(setq org-fast-tag-selection-single-key 'expert)
(setq org-fontify-done-headline t)
(setq org-footnote-auto-label 'confirm)
(setq org-footnote-auto-adjust t)
(setq org-hide-emphasis-markers t)
(setq org-hide-macro-markers t)
(setq org-icalendar-include-todo 'all)
(setq org-link-frame-setup '((gnus . gnus) (file . find-file-other-window)))
(setq org-link-mailto-program '(browse-url-mail "mailto:%a?subject=%s"))
(setq org-log-note-headings
      '((done . "CLOSING NOTE %t") (state . "State %-12s %t") (clock-out . "")))
(setq org-refile-targets '((org-agenda-files . (:maxlevel . 3))
			   (("~/org/libre.org") . (:maxlevel . 1))))
(setq org-refile-use-outline-path t)
(setq org-refile-allow-creating-parent-nodes t)
(setq org-refile-use-cache t)
(setq org-return-follows-link t)
(setq org-reverse-note-order t)
(setq org-scheduled-past-days 100)
(setq org-special-ctrl-a/e 'reversed)
(setq org-special-ctrl-k t)
(setq org-stuck-projects '("+LEVEL=1" ("NEXT" "TODO" "DONE")))
(setq org-tag-persistent-alist '(("Write" . ?w) ("Read" . ?r)))
(setq org-tag-alist
      '((:startgroup)
	("Handson" . ?o)
	(:grouptags)
	("Write" . ?w) ("Code" . ?c) ("Tel" . ?t)
	(:endgroup)
	(:startgroup)
	("Handsoff" . ?f)
	(:grouptags)
	("Read" . ?r) ("View" . ?v) ("Listen" . ?l)
	(:endgroup)
	("Mail" . ?@) ("Print" . ?P) ("Buy" . ?b)))
(setq org-tags-column -74)
(setq org-todo-keywords '((type "STRT" "NEXT" "TODO" "WAIT" "|" "DONE" "DELEGATED" "CANCELED")))
(setq org-todo-repeat-to-state t)
(setq org-use-property-inheritance t)
(setq org-use-sub-superscripts '{})
(setq org-clock-persist t)
(setq org-clock-idle-time 60)
(setq org-clock-history-length 35)
(setq org-clock-in-resume t)
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-clock-sound "~/Music/clock.wav")
(setq org-insert-heading-respect-content t)
(setq org-id-method 'uuidgen)
(setq org-combined-agenda-icalendar-file "~/org/bzg.ics")
(setq org-icalendar-combined-name "Bastien Guerry ORG")
(setq org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo))
(setq org-icalendar-use-deadline '(todo-due event-if-todo event-if-not-todo))
(setq org-icalendar-timezone "Europe/Paris")
(setq org-icalendar-store-UID t)
(setq org-confirm-babel-evaluate nil)
(setq org-archive-default-command 'org-archive-to-archive-sibling)
(setq org-id-uuid-program "uuidgen")
(setq org-use-speed-commands
      (lambda nil
	(and (looking-at org-outline-regexp-bol)
	     (not (org-in-src-block-p t)))))
(setq org-src-tab-acts-natively t)
(setq org-todo-keyword-faces
      '(("STRT" . (:foreground "white" :inverse-video t))
	("NEXT" . (:foreground "white" :weight bold))
	("WAIT" . (:foreground "#889699" :inverse-video t))
	("CANCELED" . (:foreground "#889699"))))
(setq org-footnote-section "Notes")
(setq org-plantuml-jar-path "~/bin/plantuml.jar")
(setq org-link-abbrev-alist
      '(("ggle" . "http://www.google.com/search?q=%s")
	("gmap" . "http://maps.google.com/maps?q=%s")
	("omap" . "http://nominatim.openstreetmap.org/search?q=%s&polygon=1")))

(setq org-attach-directory "~/org/data/")
(setq org-loop-over-headlines-in-active-region t)
(setq org-agenda-loop-over-headlines-in-active-region t)
(setq org-create-formula-image-program 'dvipng) ;; imagemagick
(setq org-allow-promoting-top-level-subtree t)
(setq org-html-head-include-default-style nil)
(setq org-html-head-include-scripts nil)
(setq org-clock-display-default-range 'thisweek)
(setq org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
(setq org-crypt-key "Bastien Guerry")
(setq org-enforce-todo-dependencies t)
(setq org-fontify-whole-heading-line t)
(setq org-file-apps
      '((auto-mode . emacs)
	(directory . emacs)
	("\\.mm\\'" . default)
	("\\.x?html?\\'" . default)
	("\\.pdf\\'" . "evince %s")))
(setq org-hide-leading-stars t)
(setq org-global-properties '(("Effort_ALL" . "0:10 0:30 1:00 2:00 3:30 7:00")))
(setq org-confirm-elisp-link-function nil)
(setq org-confirm-shell-link-function nil)
(setq org-cycle-include-plain-lists nil)
(setq org-deadline-warning-days 7)
(setq org-default-notes-file "~/org/notes.org")
(setq org-directory "~/org/")
(setq org-email-link-description-format "%c: %.50s")
(setq org-support-shift-select t)
(setq org-export-filter-planning-functions
      '(my-org-html-export-planning))
(setq org-export-with-broken-links t)
(setq org-ellipsis "…")

(add-to-list 'org-latex-classes
	     '("my-letter"
	       "\\documentclass\{scrlttr2\}
	    \\usepackage[english,frenchb]{babel}
	    \[NO-DEFAULT-PACKAGES]
	    \[NO-PACKAGES]
	    \[EXTRA]"))

(org-agenda-to-appt)

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

(setq org-agenda-custom-commands
      `(
	;; Week agenda for rendez-vous and tasks
	("%" "Rendez-vous" agenda* "Week planning"
	 ((org-agenda-span 'week)
	  (org-agenda-files '("~/org/rdv.org"))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))

	("@" tags-todo "+Mail+TODO={NEXT\\|STRT\\|WAIT}")
	("#" "DONE/CANCELED/DELEGATED"
	 todo "DONE|CANCELED|DELEGATED"
	 ((org-agenda-files '("~/org/bzg.org" "~/org/rdv.org" "~/org/libre.org"))
	  (org-agenda-sorting-strategy '(timestamp-up))))

	(" " . "Task and rendez-vous for today")
	("  " "Travail (tout)" agenda "Tasks and rdv for today"
	 ((org-agenda-span 1)
	  (org-agenda-files '("~/org/bzg.org"))
	  (org-deadline-warning-days 3)
	  (org-agenda-max-entries 7)
	  (org-agenda-sorting-strategy
	   '(time-up todo-state-up priority-down))))
	(" 	" "Libre (tout)" agenda "Tasks and rdv for today"
	 ((org-agenda-span 1)
	  (org-agenda-files '("~/org/libre.org"))
	  (org-deadline-warning-days 3)
	  (org-agenda-max-entries 12)
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))
	
	("E" "Etalab (today)" agenda "Etalab tasks and rdv for today"
	 ((org-agenda-span 1)
	  (org-agenda-category-filter-preset '("+ETL" "+RTL"))
	  (org-agenda-files '("~/org/rdv.org" "~/org/bzg.org"))
	  (org-deadline-warning-days 3)
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))

	("n" . "What's next?")
	("nn" "Etalab NEXT" tags-todo "TODO={STRT\\|NEXT}"
	 ((org-agenda-files '("~/org/bzg.org"))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))
	("nN" "Libre NEXT" tags-todo "TODO={STRT\\|NEXT}"
	 ((org-agenda-files '("~/org/libre.org"))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))

	("x" . "Scheduled for today")
	("xx" "Agenda work" agenda "Work scheduled for today"
	 ((org-agenda-span 1)
	  (org-deadline-warning-days 3)
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))
	("xX" "Agenda libre" agenda "Libre scheduled for today"
	 ((org-agenda-span 1)
	  (org-deadline-warning-days 3)
	  (org-agenda-files '("~/org/libre.org"))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))

	("z" . "Deadlines for today")
	("zz" "Work deadlines" agenda "Past/upcoming work deadlines"
	 ((org-agenda-span 1)
	  (org-deadline-warning-days 15)
	  (org-agenda-entry-types '(:deadline))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))
	("zZ" "Libre deadlines" agenda "Past/upcoming leisure deadlines"
	 ((org-agenda-span 1)
	  (org-deadline-warning-days 15)
	  (org-agenda-files '("~/org/libre.org"))
	  (org-agenda-entry-types '(:deadline))
	  (org-agenda-sorting-strategy
	   '(todo-state-up time-up priority-down))))

	("A" "Read, Listen, View (work)" tags-todo
         "+TAGS={Read\\|Listen\\|View}+TODO={NEXT\\|STRT}")

	("r" . "Read")
	("rr" tags-todo "+Read+TODO={NEXT\\|STRT}")
	("rR" tags-todo "+Read+TODO={NEXT\\|STRT}"
	 ((org-agenda-files '("~/org/libre.org"))))
	("v" . "View")
	("vv" tags-todo "+View+TODO={NEXT\\|STRT}")
	("vV" tags-todo "+View+TODO={NEXT\\|STRT}"
	 ((org-agenda-files '("~/org/libre.org"))))
	("l" . "Listen")
	("ll" tags-todo "+Listen+TODO={NEXT\\|STRT}")
	("lL" tags-todo "+Listen+TODO={NEXT\\|STRT}"
	 ((org-agenda-files '("~/org/libre.org"))))
	("w" . "Write")
	("ww" tags-todo "+Write+TODO={NEXT\\|STRT}")
	("wW" tags-todo "+Write+TODO={NEXT\\|STRT}"
	 ((org-agenda-files '("~/org/libre.org"))))
	("c" . "Code")
	("cc" tags-todo "+Code+TODO={NEXT\\|STRT}")
	("cC" tags-todo "+Code+TODO={NEXT\\|STRT}"
	 ((org-agenda-files '("~/org/libre.org"))))
	))

(setq org-capture-templates
      '(("C" "Misc" entry (file "~/org/bzg.org")
	 "* TODO %a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n"
	 :prepend t :immediate-finish t)

	("c" "Misc (edit)" entry (file "~/org/bzg.org")
	 "* TODO %?\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)

	("r" "RDV Perso" entry (file+headline "~/org/rdv.org" "RDV Perso")
	 "* RDV avec %:fromname %?\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)

	("R" "RDV Etalab" entry (file+headline "~/org/rdv.org" "RDV Etalab")
	 "* RDV avec %:fromname %?\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a" :prepend t)

	("o" "Org" entry (file+headline "~/org/bzg.org" "Org-mode : passer la maintenance fin 2020")
	 "* TODO %a\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n" :prepend t)

	("e" "Etalab" entry (file+headline "~/org/bzg.org" "Etalab : impulser dynamique LL via la DINUM")
	 "* TODO %?\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a\n\n%i" :prepend t)

	("g" "Garden" entry (file+headline "~/org/libre.org" "Garden")
	 "* TODO %?\n  :PROPERTIES:\n  :CAPTURED: %U\n  :END:\n\n- %a\n\n%i" :prepend t)))

(setq org-capture-templates-contexts
      '(("r" ((in-mode . "gnus-summary-mode")
	      (in-mode . "gnus-article-mode")
	      (in-mode . "message-mode")))
	("R" ((in-mode . "gnus-summary-mode")
	      (in-mode . "gnus-article-mode")
	      (in-mode . "message-mode")))))

(defun my-org-html-export-planning (planning-string backend info)
  (when (string-match "<p>.+><\\([0-9]+-[0-9]+-[0-9]+\\)[^>]+><.+</p>" planning-string)
    (concat "<span class=\"planning\">" (match-string 1 planning-string) "</span>")))

(require 'org-caldav)

(defun bzg-caldav-sync-perso ()
  (interactive)
  (let ((org-caldav-inbox "~/org/rdv.org")
	(org-caldav-calendar-id "personnel")
	(org-caldav-url "https://box.bzg.io/cloud/remote.php/caldav/calendars/bzg%40bzg.fr")
	(org-caldav-files nil))
    (call-interactively 'org-caldav-sync)))

;; notmuch configuration
(use-package notmuch
  :config
  (setq notmuch-fcc-dirs nil)
  (add-hook 'gnus-group-mode-hook 'bzg-notmuch-shortcut)

  (defun bzg-notmuch-shortcut ()
    (define-key gnus-group-mode-map "GG" 'notmuch-search))

  (defun bzg-notmuch-file-to-group (file)
    "Calculate the Gnus group name from the given file name."
    (cond ((string-match "/home/guerry/Maildir/Mail/mail/\\([^/]+\\)/" file)
	   (format "nnml:mail.%s" (match-string 1 file)))
	  ((string-match "/home/guerry/Maildir/\\([^/]+\\)/\\([^/]+\\)" file)
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
    (kbd "C-c C-c") #'bzg-notmuch-goto-message-in-gnus)

  (define-key global-map (kbd "C-*")
    #'(lambda() (interactive) (notmuch-search "tag:flagged")))

  (define-key global-map (kbd "C-ù")
    #'(lambda() (interactive) (notmuch-search "tag:unread"))))

(use-package starttls :defer t)
(use-package epg :defer t)
(use-package epa
  :defer t
  :config
  (setq epa-popup-info-window nil))

(use-package ecomplete :defer t)
(use-package gnus
  :defer t
  :config
  (gnus-delay-initialize)
  (setq gnus-delay-default-delay "1d")
  (setq gnus-use-atomic-windows nil)
  (setq gnus-always-read-dribble-file t)
  (setq nndraft-directory "~/News/drafts/")
  (setq nnmh-directory "~/News/drafts/")
  (setq nnfolder-directory "~/Mail/archive")
  (setq nnml-directory "~/Maildir/Mail/")
  (setq gnus-summary-ignore-duplicates t)
  (setq gnus-suppress-duplicates t)
  (setq gnus-auto-select-first nil)
  (setq gnus-ignored-from-addresses
	(regexp-opt '("bastien.guerry@free.fr"
		      "bastien.guerry@data.gouv.fr"
		      "bzg@data.gouv.fr"
		      "bzg+emacs@bzg.fr"
		      "bzg@bzg.fr"
		      "bzg@jecode.org"
		      "bzg@altern.org"
		      "bzg@gnu.org"
		      )))

  (setq send-mail-function 'sendmail-send-it)

  ;; (setq mail-header-separator "----")
  (setq mail-use-rfc822 t)

  ;; Attachments
  (setq mm-content-transfer-encoding-defaults
	(quote
	 (("text/x-patch" 8bit)
	  ("text/.*" 8bit)
	  ("message/rfc822" 8bit)
	  ("application/emacs-lisp" 8bit)
	  ("application/x-emacs-lisp" 8bit)
	  ("application/x-patch" 8bit)
	  (".*" base64))))

  (setq mm-url-use-external nil)

  (setq nnmail-extra-headers
	'(X-Diary-Time-Zone X-Diary-Dow X-Diary-Year
			    X-Diary-Month X-Diary-Dom
			    X-Diary-Hour X-Diary-Minute
			    To Newsgroups Cc))


  ;; Sources and methods
  (setq mail-sources nil
	gnus-select-method '(nnnil "")
	gnus-secondary-select-methods
	'((nnimap "localhost"
		  (nnimap-server-port 143)
		  (nnimap-authinfo-file "~/.authinfo")
		  (nnimap-stream network))
	  (nntp "news" (nntp-address "news.gmane.io"))
	  ))

  (setq gnus-check-new-newsgroups nil)

  (add-hook 'gnus-exit-gnus-hook
	    (lambda ()
	      (if (get-buffer "bbdb")
		  (with-current-buffer "bbdb" (save-buffer)))))

  (setq read-mail-command 'gnus
	gnus-asynchronous t
	gnus-directory "~/News/"
	gnus-gcc-mark-as-read t
	gnus-inhibit-startup-message t
	gnus-interactive-catchup nil
	gnus-interactive-exit nil
	gnus-large-newsgroup 10000
	gnus-no-groups-message ""
	gnus-novice-user nil
	gnus-play-startup-jingle nil
	gnus-show-all-headers nil
	gnus-use-bbdb t
	gnus-use-correct-string-widths nil
	gnus-use-cross-reference nil
	gnus-verbose 6
	mail-specify-envelope-from t
	mail-envelope-from 'header
	message-sendmail-envelope-from 'header
	mail-user-agent 'gnus-user-agent
	message-fill-column 70
	message-kill-buffer-on-exit t
	message-mail-user-agent 'gnus-user-agent
	message-use-mail-followup-to nil
	nnimap-expiry-wait 'never
	nnmail-crosspost nil
	nnmail-expiry-target "nnml:expired"
	nnmail-expiry-wait 'never
	nnmail-split-methods 'nnmail-split-fancy
	nnmail-treat-duplicates 'delete)

  (setq gnus-subscribe-newsgroup-method 'gnus-subscribe-interactively
	gnus-group-default-list-level 6 ; 3
	gnus-level-default-subscribed 3
	gnus-level-default-unsubscribed 7
	gnus-level-subscribed 6
	gnus-activate-level 6
	gnus-level-unsubscribed 7)

  (setq nnir-notmuch-remove-prefix "/home/guerry/Maildir/")
  (setq nnir-method-default-engines
	'((nnimap . notmuch)))

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
     (t "nnimap+localhost:bzgfrio/Sent")))

  (setq gnus-message-archive-group 'my-gnus-message-archive-group)

  ;; Delete mail backups older than 1 days
  (setq mail-source-delete-incoming 1)

  ;; Group sorting
  (setq gnus-group-sort-function
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
  (setq gnus-visible-headers
	"^From:\\|^Subject:\\|^X-Mailer:\\|^X-Newsreader:\\|^Date:\\|^To:\\|^Cc:\\|^User-agent:\\|^Newsgroups:\\|^Comments:")

  ;; Sort mails
  (setq nnmail-split-abbrev-alist
	'((any . "From\\|To\\|Cc\\|Sender\\|Apparently-To\\|Delivered-To\\|X-Apparently-To\\|Resent-From\\|Resent-To\\|Resent-Cc")
	  (mail . "Mailer-Daemon\\|Postmaster\\|Uucp")
	  (to . "To\\|Cc\\|Apparently-To\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
	  (from . "From\\|Sender\\|Resent-From")
	  (nato . "To\\|Cc\\|Resent-To\\|Resent-Cc\\|Delivered-To\\|X-Apparently-To")
	  (naany . "From\\|To\\|Cc\\|Sender\\|Resent-From\\|Resent-To\\|Delivered-To\\|X-Apparently-To\\|Resent-Cc")))

  ;; Simplify the subject lines
  (setq gnus-simplify-subject-functions
	'(gnus-simplify-subject-re
	  gnus-simplify-whitespace))

  ;; Display faces
  (setq gnus-treat-display-face 'head)

  ;; Thread by Xref, not by subject
  (setq gnus-thread-ignore-subject t)
  (setq gnus-thread-hide-subtree nil)
  (setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
	gnus-thread-sort-functions '(gnus-thread-sort-by-date)
	gnus-sum-thread-tree-false-root ""
	gnus-sum-thread-tree-indent " "
	gnus-sum-thread-tree-leaf-with-other "├► "
	gnus-sum-thread-tree-root ""
	gnus-sum-thread-tree-single-leaf "╰► "
	gnus-sum-thread-tree-vertical "│")

  ;; Dispkay a button for MIME parts
  (setq gnus-buttonized-mime-types '("multipart/alternative"))

  ;; Use w3m to display HTML mails
  (setq mm-text-html-renderer 'gnus-w3m
	mm-inline-text-html-with-images t
	mm-inline-large-images nil
	mm-attachment-file-modes 420)

  ;; Avoid spaces when saving attachments
  (setq mm-file-name-rewrite-functions
	'(mm-file-name-trim-whitespace
	  mm-file-name-collapse-whitespace
	  mm-file-name-replace-whitespace))

  (setq gnus-user-date-format-alist
	'(((gnus-seconds-today) . "     %k:%M")
	  ((+ 86400 (gnus-seconds-today)) . "hier %k:%M")
	  ((+ 604800 (gnus-seconds-today)) . "%a  %k:%M")
	  ((gnus-seconds-month) . "%a  %d")
	  ((gnus-seconds-year) . "%b %d")
	  (t . "%b %d '%y")))

  (setq gnus-topic-indent-level 3)

  ;; Add a time-stamp to a group when it is selected
  (add-hook 'gnus-select-group-hook 'gnus-group-set-timestamp)

  ;; Format group line
  (setq gnus-group-line-format "%M%S%p%P %(%-30,30G%)\n")
  (setq gnus-group-line-default-format "%M%S%p%P %(%-40,40G%) %-3y %-3T %-3I\n")

  (defun bzg-gnus-toggle-group-line-format ()
    (interactive)
    (if (equal gnus-group-line-format
	       gnus-group-line-default-format)
	(setq gnus-group-line-format
	      "%M%S%p%P %(%-30,30G%)\n")
      (setq gnus-group-line-format
	    gnus-group-line-default-format)))

  ;; Toggle the group line format
  (define-key gnus-group-mode-map "("
    (lambda () (interactive) (bzg-gnus-toggle-group-line-format) (gnus)))

  (define-key gnus-summary-mode-map "$" 'gnus-summary-mark-as-spam)

  ;; Scoring
  (setq gnus-use-adaptive-scoring '(line)
	;; gnus-score-expiry-days 14
	gnus-default-adaptive-score-alist
	'((gnus-dormant-mark (from 5) (subject 30))
	  (gnus-ticked-mark (from 10) (subject 50))
	  (gnus-unread-mark)
	  (gnus-read-mark (from 1) (subject 30))
	  (gnus-del-mark (from -4) (subject -10))
	  (gnus-catchup-mark (subject -150))
	  (gnus-killed-mark (subject -100))
	  (gnus-expirable-mark (from -100) (subject -100)))
	gnus-score-exact-adapt-limit nil
	gnus-score-decay-constant 1    ; default = 3
	gnus-score-decay-scale 0.05    ; default = 0.05
	gnus-decay-scores t)           ; (gnus-decay-score 1000)

  (setq gnus-summary-line-format
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
  :defer t
  :config
  ;; Highlight my name in messages
  (add-to-list 'gnus-emphasis-alist
	       '("Bastien\\|bzg" 0 0 gnus-emphasis-highlight-words)))

(use-package gnus-icalendar
  :config
  (gnus-icalendar-setup)
  ;; To enable optional iCalendar->Org sync functionality
  ;; NOTE: both the capture file and the headline(s) inside must already exist
  (setq gnus-icalendar-org-capture-file "~/org/rdv.org")
  (setq gnus-icalendar-org-capture-headline '("RDV Etalab"))
  (setq gnus-icalendar-org-template-key "I")
  (gnus-icalendar-org-setup))

(use-package gnus-dired
  :defer t
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
  :defer t
  :config
  ;; Use electric completion in Gnus
  ;; (setq message-mail-alias-type 'abbrev)
  (setq message-directory "~/Mail/")
  (setq message-mail-alias-type 'ecomplete)
  (setq message-send-mail-function 'message-send-mail-with-sendmail)
  (setq message-cite-function 'message-cite-original-without-signature)
  (setq message-dont-reply-to-names gnus-ignored-from-addresses)
  (setq message-alternative-emails gnus-ignored-from-addresses))

(use-package bbdb
  :config
  (require 'bbdb-com)
  (require 'bbdb-anniv)
  (require 'bbdb-gnus)
  (setq bbdb-file "~/Documents/config/bbdb")
  (bbdb-initialize 'message 'gnus)
  (bbdb-mua-auto-update-init 'message 'gnus)

  (setq bbdb-mua-pop-up nil)
  (setq bbdb-allow-duplicates t)
  (setq bbdb-pop-up-window-size 5)
  (setq bbdb-update-records-p 'create)
  (setq bbdb-mua-update-interactive-p '(create . query))
  (setq bbdb-mua-auto-update-p 'create)

  (add-hook 'mail-setup-hook 'bbdb-mail-aliases)
  (add-hook 'message-setup-hook 'bbdb-mail-aliases)
  (add-hook 'bbdb-notice-mail-hook 'bbdb-auto-notes)
  ;; (add-hook 'list-diary-entries-hook 'bbdb-include-anniversaries)

  (setq bbdb-always-add-addresses t
	bbdb-complete-name-allow-cycling t
	bbdb-completion-display-record t
	bbdb-default-area-code nil
	bbdb-dwim-net-address-allow-redundancy t
	bbdb-electric-p nil
	bbdb-add-aka nil
	bbdb-add-name nil
	bbdb-add-mails t
	bbdb-new-nets-always-primary 'never
	bbdb-north-american-phone-numbers-p nil
	bbdb-offer-save 'auto
	bbdb-pop-up-target-lines 3
	bbdb-print-net 'primary
	bbdb-print-require t
	bbdb-use-pop-up nil
	bbdb-user-mail-names gnus-ignored-from-addresses
	bbdb/gnus-split-crosspost-default nil
	bbdb/gnus-split-default-group nil
	bbdb/gnus-split-myaddr-regexp gnus-ignored-from-addresses
	bbdb/gnus-split-nomatch-function nil
	bbdb/gnus-summary-known-poster-mark "+"
	bbdb/gnus-summary-mark-known-posters t
	bbdb-ignore-message-alist '(("Newsgroup" . ".*")))

  (defalias 'bbdb-y-or-n-p '(lambda (prompt) t))

  (setq bbdb-auto-notes-alist
	`(("Newsgroups" ("[^,]+" newsgroups 0))
	  ("Subject" (".*" last-subj 0 t))
	  ("User-Agent" (".*" mailer 0))
	  ("X-Mailer" (".*" mailer 0))
	  ("Organization" (".*" organization 0))
	  ("X-Newsreader" (".*" mailer 0))
	  ("X-Face" (".+" face 0 'replace))
	  ("Face" (".+" face 0 'replace)))))

(use-package erc
  :config
  (require 'erc-services)

  ;; highlight notifications in ERC
  (font-lock-add-keywords
   'erc-mode
   '((";;.*\\(bzg2\\|éducation\\|clojure\\|emacs\\|orgmode\\)"
      (1 bzg-todo-comment-face t))))

  (setq erc-modules '(autoaway autojoin irccontrols log netsplit noncommands
			       notify pcomplete completion ring services stamp
			       track truncate)
	erc-keywords nil
	erc-prompt-for-nickserv-password t
	erc-prompt-for-password nil
	erc-timestamp-format "%s "
	erc-hide-timestamps t
	erc-log-channels t
	erc-log-write-after-insert t
	erc-log-insert-log-on-open nil
	erc-save-buffer-on-part t
	erc-input-line-position 0
	erc-fill-function 'erc-fill-static
	erc-fill-static-center 0
	erc-fill-column 130
	erc-insert-timestamp-function 'erc-insert-timestamp-left
	erc-insert-away-timestamp-function 'erc-insert-timestamp-left
	erc-whowas-on-nosuchnick t
	erc-public-away-p nil
	erc-save-buffer-on-part t
	erc-echo-notice-always-hook '(erc-echo-notice-in-minibuffer)
	erc-auto-set-away nil
	erc-autoaway-message "%i seconds out..."
	erc-away-nickname "bzg"
	erc-kill-queries-on-quit nil
	erc-kill-server-buffer-on-quit t
	erc-log-channels-directory "~/.erc_log"
	erc-enable-logging t
	erc-query-on-unjoined-chan-privmsg t
	erc-auto-query 'window-noselect
	erc-server-coding-system '(utf-8 . utf-8)
	erc-encoding-coding-alist '(("#emacs" . utf-8)
				    ("&bitlbee" . utf-8)))

  (add-hook 'erc-mode-hook
	    '(lambda ()
	       (auto-fill-mode -1)
	       (pcomplete-erc-setup)
	       (erc-completion-mode 1)
	       (erc-ring-mode 1)
	       (erc-log-mode 1)
	       (erc-netsplit-mode 1)
	       (erc-button-mode -1)
	       (erc-match-mode 1)
	       (erc-autojoin-mode 1)
	       (erc-nickserv-mode 1)
	       (erc-timestamp-mode 1)
	       (erc-services-mode 1)))

  (defun erc-notify-on-msg (msg)
    (if (string-match "bzg:" msg)
	(shell-command (concat "notify-send \"" msg "\""))))

  (add-hook 'erc-insert-pre-hook 'erc-notify-on-msg)

  (defun bzg-erc-connect-freenode ()
    "Connect to Freenode server with ERC."
    (interactive)
    (erc-select :server "irc.freenode.net"
		:port 6666
		:nick "bzg"
		:full-name "Bastien"))

  (require 'tls))

;; Set browser
(if window-system
    (setq browse-url-browser-function 'browse-url-firefox)
    ;; (setq browse-url-browser-function 'browse-url-chromium)
    ;; (setq browse-url-browser-function 'eww-browse-url)
  (setq browse-url-browser-function 'eww-browse-url))
(setq browse-url-text-browser "w3m")
(setq browse-url-new-window-flag t)
(setq browse-url-generic-program "firefox")
(setq browse-url-firefox-new-window-is-tab t)

(use-package w3m
  :defer t
  :config
  (setq w3m-accept-languages '("fr;" "q=1.0" "en;"))
  (setq w3m-antenna-sites '(("http://eucd.info" "EUCD.INFO" time)))
  (setq w3m-broken-proxy-cache t)
  (setq w3m-confirm-leaving-secure-page nil)
  (setq w3m-cookie-accept-bad-cookies nil)
  (setq w3m-cookie-accept-domains nil)
  (setq w3m-cookie-file "/home/guerry/.w3m/cookie")
  (setq w3m-fill-column 70)
  (setq w3m-form-textarea-edit-mode 'org-mode)
  (setq w3m-icon-directory nil)
  (setq w3m-key-binding 'info)
  (setq w3m-use-cookies t)
  (setq w3m-use-tab t)
  (setq w3m-use-toolbar nil))

(use-package eww
  :defer t
  :config
  (add-hook 'eww-mode-hook 'visual-line-mode)
  (setq eww-header-line-format nil
	shr-width 80
	shr-use-fonts nil
	shr-color-visible-distance-min 10
	shr-color-visible-luminance-min 80))

(use-package calendar
  :defer t
  :config
  (setq french-holiday
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

  (setq calendar-date-style 'european
	calendar-holidays (append french-holiday)
	calendar-mark-holidays-flag t
	calendar-week-start-day 1
	calendar-mark-diary-entries-flag nil))

;; (setq TeX-master 'dwim)

;; Hide fringe indicators
(mapcar (lambda (fb) (set-fringe-bitmap-face fb 'org-hide))
	fringe-bitmaps)

(setq fringe-styles
      '(("default" . nil)
	("no-fringes" . 0)
	("right-only" . (0 . nil))
	("left-only" . (nil . 0))
	("half-width" . (4 . 4))
	("big" . (400 . 400))
	("300" . (300 . 300))
	("bzg" . (200 . 200))
	("100" . (100 . 100))
	("minimal" . (1 . 1))))

(defvar bzg-big-fringe-mode nil)

(defvar bzg-big-fringe-size 300)

(define-minor-mode bzg-big-fringe-mode
  "Minor mode to hide the mode-line in the current buffer."
  :init-value nil
  :global t
  :variable bzg-big-fringe-mode
  :group 'editing-basics
  (if (not bzg-big-fringe-mode)
      (set-fringe-mode 10)
    (set-fringe-mode bzg-big-fringe-size)))

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
(add-hook 'org-mode-hook 'hidden-mode-line-mode)

(use-package paredit
  :config
  (define-key paredit-mode-map (kbd "C-M-w") 'sp-copy-sexp))

;; Clojure initialization
(use-package clojure-mode
  :defer t
  :config
  (add-hook 'clojure-mode-hook 'company-mode)
  (add-hook 'clojure-mode-hook 'origami-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode)
  ;; (add-hook 'clojure-mode-hook 'lispy-mode)
  (add-hook 'clojure-mode-hook 'aggressive-indent-mode)
  (add-hook 'clojure-mode-hook 'clj-refactor-mode))

;; Emacs Lisp initialization
(setq clojure-align-forms-automatically t)
(add-hook 'emacs-lisp-mode-hook 'company-mode)
(add-hook 'emacs-lisp-mode-hook 'electric-indent-mode 'append)
(add-hook 'emacs-lisp-mode-hook 'paredit-mode)
;; (add-hook 'emacs-lisp-mode-hook 'lispy-mode)
(add-hook 'emacs-lisp-mode-hook 'origami-mode)

(use-package clj-refactor
  :defer t
  :config
  (setq cljr-thread-all-but-last t)
  (cljr-add-keybindings-with-prefix "C-c r")
  (define-key clj-refactor-map "\C-ctf" #'cljr-thread-first-all)
  (define-key clj-refactor-map "\C-ctl" #'cljr-thread-last-all)
  (define-key clj-refactor-map "\C-cu" #'cljr-unwind)
  (define-key clj-refactor-map "\C-cU" #'cljr-unwind-all)
  (add-to-list 'cljr-magic-require-namespaces '("s"  . "clojure.string")))

;; Geiser
(setq geiser-active-implementations '(guile racket))
(setq geiser-scheme-implementation 'racket)
(setq geiser-repl-startup-time 20000)

;; doc-view and eww/shr configuration
(setq doc-view-continuous t)
(setq doc-view-scale-internally nil)

;; Use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

(add-hook 'dired-mode-hook #'turn-on-gnus-dired-mode)
(add-hook 'dired-mode-hook #'dired-hide-details-mode)

;; Personal stuff
(defun bzg-find-bzg nil
  "Find the bzg.org file."
  (interactive)
  (find-file "~/org/bzg.org")
  (delete-other-windows))

(defun uniquify-all-lines-region (start end)
  "Find duplicate lines in region START to END keeping first occurrence."
  (interactive "*r")
  (save-excursion
    (let ((end (copy-marker end)))
      (while
	  (progn
	    (goto-char start)
	    (re-search-forward "^\\(.*\\)\n\\(\\(.*\n\\)*\\)\\1\n" end t))
	(replace-match "\\1\n\\2")))))

(defun uniquify-all-lines-buffer ()
  "Delete duplicate lines in buffer and keep first occurrence."
  (interactive "*")
  (uniquify-all-lines-region (point-min) (point-max)))

(defun org-dblock-write:amazon (params)
  "Dynamic block for inserting the cover of a book."
  (interactive)
  (let* ((asin (plist-get params :asin))
	 (tpl "<a style=\"float:right;width:160px;margin:2em;\" href=\"https://www.amazon.fr/gp/product/%s/ref=as_li_qf_sp_asin_il?ie=UTF8&tag=bastguer-21&linkCode=as2&camp=1642&creative=6746&creativeASIN=%s\"><img border=\"0\" src=\"https://images.amazon.com/images/P/%s.jpg\" ></a><img src=\"https://www.assoc-amazon.fr/e/ir?t=bastguer-21&l=as2&o=8&a=%s\" width=\"1\" height=\"1\" border=\"0\" alt=\"\" style=\"border:none !important; margin:0px !important;\" />")
	 (str (format tpl asin asin asin asin)))
    (insert "#+begin_export html\n" str "\n#+end_export")))

;; Fontifying todo items outside of org-mode
(defface bzg-todo-comment-face
  '((t (:weight bold :bold t)))
  "Face for TODO in code buffers."
  :group 'org-faces)

(defvar bzg-todo-comment-face 'bzg-todo-comment-face)

(pdf-tools-install)

(defun backward-kill-word-noring (arg)
  (interactive "p")
  (let ((kr kill-ring))
    (backward-kill-word arg)
    (setq kill-ring (reverse kr))))

(global-set-key (kbd "C-M-<backspace>") 'backward-kill-word-noring)

(require 'which-key)
(which-key-mode)

(use-package multi-term
  :config
  (global-set-key (kbd "C-!")
		  (lambda ()
		    (interactive)
		    (funcall #'multi-term-dedicated-open)
		    (funcall #'multi-term-dedicated-select)))
  (setq multi-term-program "/bin/zsh"))

(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package dired-subtree
  :config
  (setq dired-subtree-use-backgrounds nil)
  (define-key dired-mode-map (kbd "I") 'dired-subtree-toggle)
  (define-key dired-mode-map (kbd "TAB") 'dired-subtree-cycle))

(require 'org-bullets)
(setq org-bullets-bullet-list '("►" "▸" "•" "★" "◇" "◇" "◇" "◇"))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(defun find-variable-or-function-at-point ()
  (interactive)
  (or (find-variable-at-point)
      (find-function-at-point)
      (message "No variable or function at point.")))

(global-set-key (kbd "C-:") 'find-variable-or-function-at-point)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c C->") 'mc/mark-all-dwim)

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq tab-bar-show nil)
