;;; ini.el --- Converting between INI files and association lists

;; Author: Daniel Ness <daniel.r.ness@gmail.com>

;;; License
;;
;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

(defun ini-decode (ini-text &optional comment-regexp)
  "Convert INI-TEXT into a lisp alist object.

By default treats a semicolon at the beginning of the line as a comment
unless something else is specified in the COMMENT-REGEXP."
  (if (not (stringp ini-text))
      (error "Must be a string"))
  (let ((lines (split-string ini-text "\n"))
	(section)
	(section-list)
	(alist)
        (cmt-regexp (or comment-regexp "^;")))
    (dolist (line lines)
      ;; skip comments
      (unless (or (string-match cmt-regexp line)
		  (string-match "^[ \t]*$" line))
	;; catch sections
	(when (string-match "^\\[\\(.*\\)\\]$" line)
          (if section
              ;; add as sub-list
              (setq alist (cons `(,section . ,section-list) alist))
            (setq alist section-list))
          (setq section (match-string 1 line))
          (setq section-list nil))
        ;; catch properties
	(if (string-match "^\\([^\s\t]+\\)[\s\t]*=[\s\t]*\\(.+\\)$" line)
	    (let ((property (match-string 1 line))
		  (value (match-string 2 line)))
	      (setq section-list (cons `(,property . ,value) section-list))))))
    (if section
	;; add as sub-list
	(setq alist (cons `(,section . ,section-list) alist))
      (setq alist section-list))
    (reverse alist)))

(defun ini-encode (ini-alist)
  "Convert a INI-ALIST into .INI formatted text."
  (if (not (listp ini-alist))
      (error "ini-alist is not a list"))
  (let ((txt ""))
    (dolist (element ini-alist)
      (let ((key (car element))
	    (value (cdr element)))
	(when (not (stringp key))
	  (error "key is not a string"))
	(if (listp value)
	    (setq txt
		  (concat txt
			  (format "[%s]\n" key)
			  (ini-encode value)))
	  (setq txt
		(concat txt (format "%s=%s\n" key value))))))
    txt))


(provide 'ini)
;;; ini.el ends here
