; list the packages you want
(setq package-list '(auctex expand-region gist magit magithub markdown-mode paredit projectile
                            python sass-mode rainbow-mode scss-mode solarized-theme anything
                            volatile-highlights evil evil-leader scala-mode2 sbt-mode))

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
(ido-mode 1)

; Scala
; Load the ensime lisp code...
(add-to-list 'load-path "~/.emacs.d/ensime/elisp")
(require 'ensime)

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)

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
