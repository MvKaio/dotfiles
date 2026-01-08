;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Kaio Vieira"
      user-mail-address "kaiomassevieira@gmail.com")

;; Github Codespaces
(use-package! codespaces
  :config (codespaces-setup)
  :bind ("C-c S" . #'codespaces-connect))

;; Freemarker Syntax Highlighting
(use-package web-mode
  :ensure t
  :mode
  (("\\.phtml\\'" . web-mode)
   ("\\.php\\'" . web-mode)
   ("\\.tpl\\'" . web-mode)
   ("\\.[agj]sp\\'" . web-mode)
   ("\\.as[cp]x\\'" . web-mode)
   ("\\.erb\\'" . web-mode)
   ("\\.mustache\\'" . web-mode)
   ("\\.djhtml\\'" . web-mode)))

;; Github Copilot Configuration
;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (add-to-list 'copilot-indentation-alist '(c-mode 2))
  (add-to-list 'copilot-indentation-alist '(cpp-mode 2))
  (add-to-list 'copilot-indentation-alist '(python-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2))
  )

;; Github CopilotChat Models
(gptel-make-gh-copilot "Copilot")

;; Configuring default gptel backend & model
(setq gptel-backend (alist-get "Copilot" gptel--known-backends nil nil #'equal))
(setq gptel-model 'gemini-2.5-pro)

;; Configuring resize windows
(map! "M-L" #'enlarge-window-horizontally
      "M-H" #'shrink-window-horizontally
      "M-K" #'enlarge-window
      "M-J" #'shrink-window
      "C-x C-x" #'evil-mode)

;; Make org-mode open html files in firefox
'(org-file-apps
   (quote
     ((auto-mode . emacs)
      ("\\.mm\\'" . default)
      ("\\.x?html?\\'" . "/usr/bin/firefox %s")
      ("\\.pdf\\'" . default))))

;; Key Bindings LSP
(map! :map lsp-mode-map
      :desc "Find References"
      :n "gr" #'lsp-find-references)

;; Maximize Buffer with <leader> z
(defun toggle-maximize-buffer () "Maximize buffer"
  (interactive)
  (if (= 1 (length (window-list)))
    (jump-to-register '_)
    (progn
      (window-configuration-to-register '_)
      (delete-other-windows))))
(map! :leader :desc "Toggle Maximize Buffer" :n "z" #'toggle-maximize-buffer)

;; Using zsh (?) in vterm
(setq vterm-shell "/usr/bin/zsh")

; configure telega
(map! :map telega-chat-button-map "h" nil)

(use-package! telega
  :commands telega
  :config
  (setq telega-completing-read-function 'completing-read
        telega-sticker-set-download 't
        telega-emoji-use-images nil))

; Fix Tex shell escape
(setq-default TeX-shell-escape t)

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
(setq doom-font (font-spec :family "Iosevka Term" :size 30 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 31 :weight 'light))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'timu-rouge)


;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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

(after! competitive-companion
  (setq competitive-companion-task-template-file "~/code/template.cpp")
  (setq competitive-companion-separate-stderr 1))
