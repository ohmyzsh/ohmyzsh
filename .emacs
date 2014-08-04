; list the packages you want
(setq package-list '(auctex expand-region gist magit magithub markdown-mode paredit projectile
                            python sass-mode rainbow-mode scss-mode solarized-theme anything
                            volatile-highlights evil evil-leader scala-mode2 sbt-mode flx-ido
                            js2-mode js2-refactor tern tern-auto-complete yasnippet auto-complete))

; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

; Solarized Theme
(load-theme 'solarized-dark)

; Enable VIM Mode
(global-evil-leader-mode)
(evil-mode 1)

(evil-leader/set-leader ",")
; Use evil-leader in magit and gnus mode
(setq evil-leader/no-prefix-mode-rx '("magit-.*-mode" "gnus-.*-mode"))
(evil-leader/set-key "t" 'projectile-find-file)

; Map escape to exit all modes
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

; Disable line wrapping
(setq-default truncate-lines t)

; UI Tweaks
(tool-bar-mode -1)
(scroll-bar-mode -1)

; Ido
(require 'flx-ido)
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq projectile-enable-caching t)
; Special GC Setting
(setq gc-cons-threshold 20000000)

; Scala
; Load the ensime lisp code...
(add-to-list 'load-path "~/.emacs.d/ensime/elisp")
(require 'ensime)
(setq exec-path (append exec-path '("~/Work/universe/sbt")))

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

; Javascript
(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

; Tern auto completion, install tern
; sudo npm install -g tern
(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

; Gpicker
; git clone https://github.com/emacsmirror/gpicker.git                                         1 ↵ ✭
(add-to-list 'load-path "~/.emacs.d/gpicker")
(require 'gpicker)
(setq exec-path (append exec-path '("~/.emacs.d/gpicker")))

; Powerline
; https://github.com/Dewdrops/powerline.git
(add-to-list 'load-path "~/.emacs.d/powerline")
(require 'powerline)
(powerline-center-evil-theme)

; Projectile Project Management
(projectile-global-mode)

; Debug
;(setq debug-on-error t)

; Disable Stupid Bell
(setq ring-bell-function #'ignore)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
