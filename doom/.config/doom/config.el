;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Kaio Vieira"
      user-mail-address "kaiomassevieira@gmail.com")

;; Make cpp-mode the default for .cpp files (not sure why it isn't already)
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . cpp-mode))

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

;; Typst Mode and eglot config
(require 'typst-ts-mode)
(add-to-list 'auto-mode-alist '("\\.typ\\'" . typst-ts-mode))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(typst-ts-mode . ("tinymist"))))
(add-hook 'typst-ts-mode-hook 'eglot-ensure)

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
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)
  (add-to-list 'copilot-indentation-alist '(typst-ts-mode 2))))

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
(defun toggle-maximize-buffer ()
  "Maximize buffer, workspace aware."
  (interactive)
  (if (and (= 1 (length (window-list)))
           (assoc 'maximized-state (persp-parameter 'maximized-state)))
      (progn
        (set-window-configuration (cdr (assoc 'maximized-state (persp-parameter 'maximized-state))))
        (set-persp-parameter 'maximized-state nil))
    (progn
      (set-persp-parameter 'maximized-state (list (cons 'maximized-state (current-window-configuration))))
      (delete-other-windows))))

(map! :leader :desc "Toggle Maximize Buffer" :n "z" #'toggle-maximize-buffer)

;; Using zsh (?) in vterm
(setq vterm-shell "/usr/bin/zsh")

;; Make Doom vterm open in the current buffer's directory, not project root.
(defadvice! kaio/+vterm-use-current-directory-a (orig-fn _arg display-fn)
  :around #'+vterm--configure-project-root-and-display
  (funcall orig-fn t display-fn))

(use-package! telega
  :commands telega
  :init
  (setq telega-server-libs-prefix "/usr")
  :config
  (setq telega-completing-read-function 'completing-read
        telega-sticker-set-download 't
        telega-emoji-use-images nil)
  (map! :map telega-chat-button-map "h" nil))

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
(setq doom-font (font-spec :family "Iosevka Term" :size 28 :weight 'light)
      doom-variable-pitch-font (font-spec :family "Iosevka" :size 28 :weight 'light))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'noctalia)


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

(use-package! competitive-companion
  :config
  (competitive-companion-setup-evil)
  (setq competitive-companion-task-template-file "~/code/template.cpp")
  (setq competitive-companion-separate-stderr 1)

  ;; Variable to remember which buffer initiated the compile
  (defvar my/cc-source-buffer nil)

  (defun my/cc-copy-source-on-all-tests-passed (orig-fn &rest args)
    "If all tests passed, copy source code to clipboard."
    (let ((result (apply orig-fn args)))
      (when (eq result t)
        (let ((original-message (current-message)))
          (with-current-buffer (or my/cc-source-buffer (current-buffer))
            (kill-new (buffer-string)))
          (message "%s Source code copied." (or original-message ""))))
      result))

  (advice-add #'competitive-companion-run-tests :around #'my/cc-copy-source-on-all-tests-passed)

  (defun my/cc-run-tests-on-success (buf str)
    "Hook to run CC tests if compilation finishes successfully."
    ;; Check if compilation finished without errors
    (when (string-match-p "finished" str)
      ;; Close the compilation window
      (ignore-errors (delete-window (get-buffer-window buf)))

      ;; Ensure the source buffer is still alive
      (when (buffer-live-p my/cc-source-buffer)
        (with-current-buffer my/cc-source-buffer
          ;; Determine the command to run, mirroring the logic in the
          ;; interactive part of `competitive-companion-run-tests`.
          (let ((command (or competitive-companion--current-command
                             (funcall competitive-companion-guess-program (buffer-file-name)))))
            (if command
                (competitive-companion-run-tests command)
              (warn "Could not guess command to run tests."))))))

    ;; Clean up: remove this hook so it doesn't run on unrelated compilations
    (remove-hook 'compilation-finish-functions #'my/cc-run-tests-on-success))

  (defun my/cc-compile-and-run ()
    "Compile current file, then run competitive-companion tests on success."
    (interactive)
    (setq my/cc-source-buffer (current-buffer))
    (let* ((filename (file-name-nondirectory buffer-file-name))
           (basename (file-name-sans-extension filename)))
           (setq compile-command (format "make -B %s" basename)))
    (add-hook 'compilation-finish-functions #'my/cc-run-tests-on-success)
    (if (fboundp 'recompile)
        (recompile)
      (call-interactively 'compile)))

  ;; Bind to <leader> r
  (map! :leader
        :desc "CC Compile & Run" "r" #'my/cc-compile-and-run))
