;; ============================================
;; EMACS CONFIGURATION
;; A VS Code-like setup for modern web and systems development
;; ============================================

;; ============================================
;; PERFORMANCE TWEAKS (Load faster)
;; ============================================
(setq gc-cons-threshold (* 50 1000 1000))  ; Reduce garbage collection during startup

;; ============================================
;; PACKAGE MANAGEMENT SETUP
;; ============================================
(require 'package)

;; Add package repositories
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

;; Refresh package list if it doesn't exist
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)  ; Auto-install packages if missing

;; ============================================
;; BASIC EMACS SETTINGS (Make it feel modern)
;; ============================================

;; UI Improvements
(setq inhibit-startup-message t)        ; No startup screen
(tool-bar-mode -1)                      ; No toolbar
(menu-bar-mode -1)                      ; No menu bar
(scroll-bar-mode -1)                    ; No scrollbar
(setq visible-bell t)                   ; Visual bell instead of beep

;; Line numbers (like VS Code)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)  ; Relative line numbers (useful for navigation)

;; Show column number in modeline
(column-number-mode t)

;; Highlight current line
(global-hl-line-mode t)

;; Show matching parentheses
(show-paren-mode t)
(setq show-paren-delay 0)

;; Better scrolling (smooth like VS Code)
(setq scroll-margin 8
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq js-indent-level 2)
(setq typescript-indent-level 2)
(setq css-indent-offset 2)

;; Auto-save and backup settings
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Remember cursor position
(save-place-mode 1)

;; Recent files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)

;; Better yes/no prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;; Auto-refresh files when they change on disk
(global-auto-revert-mode 1)

;; ============================================
;; THEME (Terminal-friendly, minimal modeline)
;; ============================================
;; No custom theme in terminal (use default)
;; Only load doom-themes in GUI
(when (display-graphic-p)
  (use-package doom-themes
    :config
    (setq doom-themes-enable-bold t
          doom-themes-enable-italic t)
    (load-theme 'doom-one t)
    (doom-themes-visual-bell-config)))

;; Minimal modeline for terminal
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 3
        ;; Only show what you want
        doom-modeline-buffer-file-name-style 'file-name  ; Just filename, not full path
        doom-modeline-icon nil                           ; No icons (saves space)
        doom-modeline-major-mode-icon nil                ; No mode icon
        doom-modeline-major-mode-color-icon nil          ; No colored icons
        doom-modeline-buffer-state-icon nil              ; No buffer state icon
        doom-modeline-buffer-modification-icon nil       ; No modification icon
        doom-modeline-minor-modes nil                    ; Hide minor modes
        doom-modeline-enable-word-count nil              ; No word count
        doom-modeline-buffer-encoding nil                ; No encoding
        doom-modeline-indent-info nil                    ; No indent info
        doom-modeline-checker-simple-format t            ; Simple error format
        doom-modeline-number-limit 99                    ; Show up to 99 errors
        doom-modeline-vcs-max-length 12                  ; Short git branch
        doom-modeline-persp-name nil                     ; No perspective name
        doom-modeline-lsp nil                            ; No LSP indicator
        doom-modeline-github nil                         ; No GitHub
        doom-modeline-mu4e nil                           ; No email
        doom-modeline-gnus nil                           ; No news
        doom-modeline-irc nil                            ; No IRC
        doom-modeline-env-version nil                    ; No env version
        doom-modeline-modal nil))                        ; No modal indicator

;; Fix modeline colors for better readability in terminal
(custom-set-faces
 '(mode-line ((t (:background "gray20" :foreground "white" :box nil))))
 '(mode-line-inactive ((t (:background "gray10" :foreground "gray50" :box nil)))))

;; Icons (only for GUI)
(use-package nerd-icons
  :if (display-graphic-p))

;; ============================================
;; CLIPBOARD INTEGRATION FOR TERMINAL EMACS
;; ============================================

;; Use system clipboard in terminal
(setq select-enable-clipboard t)
(setq select-enable-primary t)

;; Use xclip for clipboard integration (for X11/Wayland)
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))

;; ============================================
;; TREE-SITTER SETUP (Syntax highlighting)
;; ============================================

;; Auto-install and manage tree-sitter grammars
(use-package treesit-auto
  :demand t
  :config
  (setq treesit-auto-install 'prompt)  ; Ask before installing grammars
  (global-treesit-auto-mode))

;; ============================================
;; COMPLETION (Like IntelliSense in VS Code)
;; ============================================

;; Company mode for auto-completion
(use-package company
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.0
        company-show-numbers t
        company-tooltip-align-annotations t))

;; Better completion UI
(use-package company-box
  :hook (company-mode . company-box-mode))

;; ============================================
;; FUZZY FINDING (Like Ctrl+P in VS Code)
;; ============================================

;; Vertico - modern completion framework
(use-package vertico
  :init
  (vertico-mode))

;; Orderless - flexible matching
(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Marginalia - rich annotations in completion
(use-package marginalia
  :init
  (marginalia-mode))

;; Consult - enhanced commands
(use-package consult
  :bind (("C-x b" . consult-buffer)           ; Switch buffers
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x p b" . consult-project-buffer)
         ("C-s" . consult-line)               ; Search in file (like Ctrl+F)
         ("C-x r b" . consult-bookmark)
         ("M-y" . consult-yank-pop)))

;; ============================================
;; FILE TREE (Like Explorer in VS Code)
;; ============================================
(use-package neotree
  :bind (("<f8>" . neotree-toggle))
  :config
  (setq neo-smart-open t
        neo-theme 'nerd))

;; ============================================
;; PROJECT MANAGEMENT
;; ============================================
(use-package projectile
  :init
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-project-search-path '("~/projects/" "~/work/")))

;; ============================================
;; GIT INTEGRATION (Like Git in VS Code)
;; ============================================

;; Magit - the best Git interface ever made
(use-package magit
  :bind (("C-x g" . magit-status)))

;; Git gutter - show changes in the margin
(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

;; ============================================
;; LSP (Language Server Protocol)
;; Like VS Code's language features
;; ============================================
(use-package lsp-mode
  :hook ((typescript-ts-mode . lsp-deferred)
         (tsx-ts-mode . lsp-deferred)
         (javascript-ts-mode . lsp-deferred)
         (js-ts-mode . lsp-deferred)
         (go-ts-mode . lsp-deferred)
         (c++-ts-mode . lsp-deferred)
         (c-ts-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-keymap-prefix "C-c l"
        lsp-headerline-breadcrumb-enable t
        lsp-modeline-diagnostics-enable t
        lsp-completion-provider :company
        lsp-idle-delay 0.5))

;; LSP UI enhancements
(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t))

;; ============================================
;; LANGUAGE-SPECIFIC CONFIGURATIONS
;; ============================================

;; JavaScript/TypeScript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :config
  (setq typescript-indent-level 2))

;; Web mode for HTML/CSS/JSX
(use-package web-mode
  :mode ("\\.html\\'" "\\.css\\'")
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2))

;; Emmet for HTML/CSS expansion (like in VS Code)
(use-package emmet-mode
  :hook ((web-mode . emmet-mode)
         (css-mode . emmet-mode)))

;; Tailwind CSS support
(use-package lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t))

;; Go
(use-package go-mode
  :mode "\\.go\\'"
  :hook (go-mode . lsp-deferred))

;; C++
(use-package cc-mode
  :config
  (setq c-basic-offset 2))

;; ============================================
;; SYNTAX CHECKING (Like linting in VS Code)
;; ============================================
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)))

;; ============================================
;; SNIPPETS (Like snippets in VS Code)
;; ============================================
(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

;; ============================================
;; MULTIPLE CURSORS (Like in VS Code)
;; ============================================
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; ============================================
;; BETTER SEARCH AND REPLACE
;; ============================================
(use-package anzu
  :config
  (global-anzu-mode +1))

;; ============================================
;; WHITESPACE MANAGEMENT
;; ============================================
(use-package ws-butler
  :hook ((prog-mode . ws-butler-mode)))  ; Auto-trim trailing whitespace

;; ============================================
;; RAINBOW DELIMITERS (Colorful parentheses)
;; ============================================
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; ============================================
;; WHICH-KEY (Shows available keybindings)
;; ============================================
(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

;; ============================================
;; CUSTOM KEYBINDINGS (VS Code-like shortcuts)
;; ============================================

;; Project-wide search (like Ctrl+Shift+F in VS Code)
(global-set-key (kbd "C-c C-s") 'consult-ripgrep)  ; Ctrl+Shift+F

;; Save file
(global-set-key (kbd "C-s") 'consult-line)  ; Search in file
(global-set-key (kbd "C-x C-s") 'save-buffer)  ; Save

;; Comment/uncomment
(global-set-key (kbd "C-/") 'comment-line)

;; Duplicate line (like Ctrl+D in VS Code)
(defun duplicate-line ()
  "Duplicate the current line."
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-d") 'duplicate-line)

;; Move lines up/down (like Alt+Up/Down in VS Code)
(defun move-line-up ()
  "Move the current line up."
  (interactive)
  (transpose-lines 1)
  (forward-line -2))

(defun move-line-down ()
  "Move the current line down."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

;; ============================================
;; RESTART GARBAGE COLLECTION
;; ============================================
(setq gc-cons-threshold (* 2 1000 1000))

;; ============================================
;; DONE!
;; ============================================
(message "Emacs configuration loaded successfully!")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
