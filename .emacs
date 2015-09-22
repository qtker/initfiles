;display line number
(global-linum-mode t)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;theme
(load-theme 'molokai t)

(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8) ;これは最後に入れる。leim-list.elがロードされると japanese-iso-8bit (EUC-JP)に戻される。うまくいかない。
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;(setq default-buffer-file-coding-system 'utf-8)

;; delete white scapse when save the file
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; not use tab with indent
(setq-default indent-tabs-mode nil)

;; if there exitst shebang in first line, add execute authority
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; delete backward char
(global-set-key "\C-h" 'delete-backward-char)

;; insert pair of braces
(electric-pair-mode 1)
;===============
; package.elの設定
;===============
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


;===============
; jedi (package.elの設定より下に書く)
;===============
(require 'epc)
(require 'auto-complete-config)
(require 'python)

;;;;; PYTHONPATH上のソースコードがauto-completeの補完対象になる ;;;;;
(setenv "PYTHONPATH" "/usr/local/lib/python2.7/site-packages")
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;; sql indent
(eval-after-load "sql"
  '(load-library "sql-indent"))

;(autoload 'cperl-mode "cperl-mode" "alternate mode for editing Perl programs" t)

;;load file in elsip
(setq load-path
      (append
       (list
        (expand-file-name "~/.emacs.d/elisp/"))
       load-path))


;; auto-install
;(require 'auto-install)
;(setq auto-install-directory "~/.emacs.d/elisp/") ;Emacs Lispをインストールするディレクトリの指定
;(auto-install-update-emacswiki-package-name t)
;(auto-install-compatibility-setup) ;install-elisp.elとコマンド名を同期

; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-auto-start t)


;;javascript mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of php-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; php-mode
(require 'php-mode)
(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;*.phpのファイルのときにphp-modeを自動起動する
(setq auto-mode-alist (append '(("\\.ctp$" . php-mode)) auto-mode-alist))

;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
            (php-completion-mode t)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of cperl-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;use cperl mode
(defalias 'perl-mode 'cperl-mode)


;;use cperl mode in test file
(setq auto-mode-alist (cons '("\\.t$" . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pl$" . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.pm$" . cperl-mode) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.psgi$" . cperl-mode)) auto-mode-alist))
(setq auto-mode-alist (append '(("\\.cgi$" . cperl-mode)) auto-mode-alist))



(add-hook 'cperl-mode-hook
          '(lambda ()
                  (cperl-set-style "PerlStyle")))


;; perl-completion
(add-hook 'cperl-mode-hook
          (lambda()
            (require 'perl-completion)
            (perl-completion-mode t)))

(add-hook  'cperl-mode-hook
           (lambda ()
             (when (require 'auto-complete nil t) ; no error whatever auto-complete.el is not installed.
               (auto-complete-mode t)
               (make-variable-buffer-local 'ac-sources)
               (setq ac-sources
                     '(ac-source-perl-completion)))))


;; haskell indent
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of R-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/lisp/ess/ess-lisp/")

(require 'ess-site)
(setq auto-mode-alist
       (cons (cons "\\.r$" 'R-mode) auto-mode-alist))
(autoload 'R-mode "ess-site" "Emacs Speaks Statistics mode" t)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of scala-mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/lisp/scala2/")

(require 'scala-mode2)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))
(add-hook 'scala-mode-hook
  (function
    (lambda ()
      (setq scala-mode-indent:step 4)
      (scala-mode-lib:define-keys scala-mode-map
                                  ([(shift tab)]   'scala-undent-line)
                                  ([(control tab)] nil))
      (local-set-key [(return)] 'newline-and-indent))))
(add-hook 'scala-mode-hook 'jaspace-mode)





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of the others
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;一回に一行だけ
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))

;;スクロールを加速しない
(setq mouse-wheel-progressive-speed nil)

;;マウスでスクロール
(setq mouse-wheel-follow-mouse 't)

;;; スクロールを一行ずつにする
(setq scroll-step 1)

;;ビープ音を消す
(setq ring-bell-function 'ignore)

;;; 対応する括弧を光らせる。
(show-paren-mode 1)

;;;自動改行しない
(setq text-mode-hook 'turn-off-auto-fill)


;;copy to clipboard
(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;Settings of yatex
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; for YaTex
;; Add library path
(add-to-list 'load-path "~/.emacs.d/lisp/yatex/yatex1.77")
;; YaTeX mode
(setq auto-mode-alist
    (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq tex-command "platex")
(setq dviprint-command-format "dvipdfmx %s")
;; use Preview.app
(setq dvi2-command "open -a Preview")
(setq bibtex-command "pbibtex")


;; YaTeX
;; 文章作成時の日本語文字コード
;; 0: no-converion
;; 1: Shift JIS (windows & dos default)
;; 2: ISO-2022-JP (other default)
;; 3: EUC
;; 4: UTF-8
(setq YaTeX-kanji-code 4)

(setq yatex-mode-load-hook
'(lambda()
(YaTeX-define-begend-key "be" "eqnarray")
(YaTeX-define-begend-key "bE" "enumerate")
))



;====================================
;Setting the frame position (Window）
;====================================
(setq initial-frame-alist
      (append
       '((top . 20)    ; Y coordinate of the frame (pixel)
     (left . 44)    ; X coordinate of the frame (pixel)
   (width . 90)    ; Width of the frame (The number of letters)
    (height . 41)   ; Height of the frame (The number of letters)
    ) initial-frame-alist))


(if window-system (progn
   (set-background-color "White")
   (set-foreground-color "Black")
   (set-cursor-color "Gray")
;;  (set-frame-parameter nil 'alpha 90)
))

;You can complile a program if you type the meta-key and 'p'
(global-set-key "\M-p" 'compile)


;;;ues c++
;(setq auto-mode-alist
;(cons (cons "\\.cpp$" 'c++-mode) auto-mode-alist))



;;Use perl mode in filename extention psgi (perl)
;(load-library "perl-mode")
; (require 'perl-mode)
; (setq auto-mode-alist
;       (append '(("\\.psgi$" . perl-mode))
;           auto-mode-alist))


;C/C++ mode
(setq-default c-basic-offset 4     ;;基本インデント量4
              tab-width 4          ;;タブ幅4
               indent-tabs-mode nil)  ;;インデントをタブでするかスペースでするか

;; C++ style
(defun add-c++-mode-conf ()
  (c-set-style "stroustrup")  ;;スタイルはストラウストラップ
  (show-paren-mode t))        ;;カッコを強調表示する
(add-hook 'c++-mode-hook 'add-c++-mode-conf)

;; C style
(defun add-c-mode-common-conf ()
  (c-set-style "stroustrup")                  ;;スタイルはストラウストラップ
  (show-paren-mode t)                         ;;カッコを強調表示する
  )
(add-hook 'c-mode-common-hook 'add-c-mode-common-conf)


;??????
(put 'upcase-region 'disabled nil)
