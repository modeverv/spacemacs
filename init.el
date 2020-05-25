;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(defconst spacemacs-version         "0.200.13" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))


;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; spacemacsに乗っからないというか設定方法がわからない
;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; font
(set-face-attribute 'default nil :height 160)
;; \M-+ で拡大
(global-set-key [(meta ?+)] (lambda () (interactive) (text-scale-increase 1)))
;; \M-- で縮小
(global-set-key [(meta ?-)] (lambda () (interactive) (text-scale-decrease 1)))
;; \M-0 でデフォルトに戻す
(global-set-key [(meta ?0)] (lambda () (interactive) (text-scale-increase 0)))
;; dired
;;;; ナイスなdired
(require 'dired-x  nil t)
(add-hook 'dired-load-hook (lambda () (load "dired-x")))
;;;; 再帰コピー再帰削除
(setq dired-recursive-copies 'always)
(setq dired-recursive-deletes 'always)
;;;; diredからファイル名編集
(require 'wdired nil t)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;;; ちょっと見
(require 'bf-mode nil t)
(setq bf-mode-browsing-size 20000)
;; meta/super
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))
;; frame
(setq default-frame-alist
      (append '((width                . 85)  ; フレーム幅
                (height               . 38 ) ; フレーム高
             ;; (left                 . 70 ) ; 配置左位置
             ;; (top                  . 28 ) ; 配置上位置
                (line-spacing         . 0  ) ; 文字間隔
                (left-fringe          . 10 ) ; 左フリンジ幅
                (right-fringe         . 11 ) ; 右フリンジ幅
                (menu-bar-lines       . 1  ) ; メニューバー
                (tool-bar-lines       . nil  ) ; ツールバー
                (vertical-scroll-bars . nil  ) ; スクロールバー
                (scroll-bar-width     . 17 ) ; スクロールバー幅
                (cursor-type          . box) ; カーソル種別
                (alpha                . 90) ; 透明度
                ) default-frame-alist) )
(setq initial-frame-alist default-frame-alist)
;; フレーム タイトル
(setq frame-title-format
      '("emacs " emacs-version (buffer-file-name " - %f")))
;; 文字コード関連
;; デフォルトの文字コード
(set-default-coding-systems 'utf-8-unix)
;; テキストファイル／新規バッファの文字コード
(prefer-coding-system 'utf-8-unix)
;; ファイル名の文字コード
(set-file-name-coding-system 'utf-8-unix)
;; キーボード入力の文字コード
(set-keyboard-coding-system 'utf-8-unix)
;; サブプロセスのデフォルト文字コード
(setq default-process-coding-system '(undecided-dos . utf-8-unix))
;; 環境依存文字 文字化け対応
(set-charset-priority 'ascii 'japanese-jisx0208 'latin-jisx0201
                      'katakana-jisx0201 'iso-8859-1 'cp1252 'unicode)
(set-coding-system-priority 'utf-8 'euc-jp 'iso-2022-jp 'cp932)
;; cp932エンコードの表記変更
(coding-system-put 'cp932 :mnemonic ?P)
(coding-system-put 'cp932-dos :mnemonic ?P)
(coding-system-put 'cp932-unix :mnemonic ?P)
(coding-system-put 'cp932-mac :mnemonic ?P)
;; UTF-8エンコードの表記変更
(coding-system-put 'utf-8 :mnemonic ?U)
(coding-system-put 'utf-8-with-signature :mnemonic ?u)
;; 改行コードの表記追加
(setq eol-mnemonic-dos       ":Dos ")
(setq eol-mnemonic-mac       ":Mac ")
(setq eol-mnemonic-unix      ":Unx ")
(setq eol-mnemonic-undecided ":??? ")
;;;; misc
;; 同一バッファ名にディレクトリ付与
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")
;; auto-save
(require 'auto-save-buffers-enhanced)
(setq auto-save-buffers-enhanced-interval 1)
(setq auto-save-buffers-enhanced-quiet-save-p t)
(auto-save-buffers-enhanced t)
;; scratch persist
(persistent-scratch-setup-default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; key
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helm-mini
(global-set-key (kbd "C-x j") 'helm-mini)
(global-set-key (kbd "C-x C-j") 'helm-mini)
;; helm-show-kill-ring
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "M-s a") 'helm-ag)
;; kill buffer
(global-set-key (kbd "C-x C-k") 'kill-buffer)
;; 色
;;dotspacemacs-themes '(spolsky
;;                      spacemacs-dark
;;                      spacemacs-light)
;;dotspacemacs-additional-packages '(
;;                                   ;; auto-save
;;                                   auto-save-buffers-enhanced
;;                                   ;; scratch
;;                                   persistent-scratch
;;                                   )
;; org inline image
(load "~/.emacs.d/elisp/org-inline.el")
;; org コードを評価するとき尋ねない
(setq org-confirm-babel-evaluate nil)
(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (js . t)
   (ruby . t)
   (python . t)
   (sql . t)
   )
 )
;; company
(require 'company)
(global-company-mode) ; 全バッファで有効にする
(setq company-transformers '(company-sort-by-backend-importance)) ;; ソート順
(setq company-idle-delay 0) ; デフォルトは0.5
(setq company-minimum-prefix-length 2) ; デフォルトは4
(setq company-selection-wrap-around t) ; 候補の一番下でさらに下に行こうとすると一番上に戻る
(setq completion-ignore-case t)
(setq company-dabbrev-downcase nil)
(setq company-dabbrev-char-regexp "\\(\\sw\\|\\s_\\|_\\|-\\)")
(setq company-backends '((company-capf company-dabbrev)
                         ;;company-bbdb
                         ;;company-eclim
                         company-semantic
                         ;;company-clang
                         ;;company-xcode
                         ;;company-cmake
                         company-files
                         (company-dabbrev-code company-gtags
                                               company-etags company-keywords)
                         ;;company-oddmuse
                         ))
(global-set-key (kbd "C-M-i") 'company-complete)
(define-key company-active-map (kbd "M-n") nil)
(define-key company-active-map (kbd "M-p") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next)
(define-key company-active-map (kbd "C-p") 'company-select-previous)
(define-key company-active-map (kbd "C-h") nil)
(define-key company-active-map (kbd "C-n") 'company-select-next) ;; C-n, C-pで補完候補を次/前の候補を選択
;;(define-key company-active-map (kbd "C-p") 'company-select-previous)
;;(define-key company-search-map (kbd "C-n") 'company-select-next)
;;(define-key company-search-map (kbd "C-p") 'company-select-previous)
;;(define-key company-active-map (kbd "C-s") 'company-filter-candidates) ;; C-sで絞り込む
;;(define-key company-active-map (kbd "C-i") 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map [tab] 'company-complete-selection) ;; TABで候補を設定
(define-key company-active-map (kbd "C-f") 'company-complete-selection) ;; C-fで候補を設定
(define-key emacs-lisp-mode-map (kbd "C-M-i") 'company-complete) ;; 各種メジャーモードでも C-M-iで co
;; color settings
(set-face-attribute 'company-tooltip nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common nil
                    :foreground "black" :background "lightgrey")
(set-face-attribute 'company-tooltip-common-selection nil
                    :foreground "white" :background "steelblue")
(set-face-attribute 'company-tooltip-selection nil
                    :foreground "black" :background "steelblue")
(set-face-attribute 'company-preview-common nil
                    :background nil :foreground "lightgrey" :underline t)
(set-face-attribute 'company-scrollbar-fg nil
                    :background "grey60")
(set-face-attribute 'company-scrollbar-bg nil
                    :background "gray40")

;; 絵文字
;;(custom-set-variables '(emoji-fontset-check-version nil))
;;(emoji-fontset-enable "Symbola")

;; scratch
(setq initial-buffer-choice t)
