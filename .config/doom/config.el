;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Name Config
(setq user-full-name "Nathan Hay"
      user-mail-address "nathanblhay@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
                                        ;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(setq doom-theme 'catppuccin) ;; Theme I like

(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 16 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size 8 :weight 'medium))

;; Ensure that Evil Mode Toggle Doesn't Work
(map! :nvi "C-z" #'evil-undo)
(map! :nvi "C-S-z" #'evil-redo)

;; Mappings to center during scrolling
;; (map! :nv "C-d" (cmd! (evil-scroll-line-to-center 1) (evil-scroll-down 1)))
;; (map! :nv "C-u" (cmd! (evil-scroll-line-to-center 1) (evil-scroll-up 1)))
;; (map! :nv "C-f" (cmd! (evil-scroll-line-to-center 1) (evil-scroll-page-down 1)))
;; (map! :nv "C-b" (cmd! (evil-scroll-line-to-center 1) (evil-scroll-page-up 1)))

;; Bind Comment & Code Action
(map! :g "C-/" #'comment-line)

;; Switched s/S to be normal vim bindings
(remove-hook 'doom-first-input-hook
             #'evil-snipe-mode)

;; Relative position for vim jumps
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Org roam commands
(setq org-roam-directory (file-truename "~/MEGA/Obsidian Vault/"))
(setq org-roam-file-extensions '("org" "md"))
(after! md-roam
  (md-roam-mode 1))
(org-roam-db-autosync-mode 1)

;; Org Roam Latex Preview
;; (setq org-preview-latex-default-process 'dvisvgm)
(setq org-startup-with-latex-preview t)
(add-hook 'org-mode-hook 'org-fragtog-mode)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; I like my inlay hints for Rust/Java
(after! lsp-mode (setq lsp-inlay-hint-enable t))

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<S-tab>" . 'copilot-accept-completion)
              ("S-TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
