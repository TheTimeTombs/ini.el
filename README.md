# ini.el
**Original Author** Daniel Ness

**Author of new implementation** Pierre Rouleau


### About
This is a simple file that handles [INI](http://en.wikipedia.org/wiki/INI_file) style configuration files with
Emacs Lisp.

### Features
* Conversion of INI-format to Elisp Association Lists
* Conversion of an Association List to INI-format string
* The value part of the key-value pair may contain a list
  of values, each value being on a single line.

### Usage
```Lisp
(require 'ini)


;; To parse a .INI file and sore the resulting ELisp
;; association list into the variable alist:

(setq alist (ini-encode "/path/to/file.ini"))

;; To transform an association list to a string:

(setq text (ini-encode alist))

;; To write to an ini file:

(ini-store alist "/path/to/other/file.ini")

;; To write the data structure to a file
;; with extra comment written at the top of that file:

(ini-store alist
           "/path/to/other/file.ini"
           "; File Description: a .INI file example\n")

The above creates the file if it does not exists, otherwise
it appends the new text to it.

(ini-store alist2
           "/path/to/other/file.ini"
           "\n; More data:\n")


To overwrite text inside an existing file, set the OVERWRITE
optional argument to non-nil like this:


(ini-store alist
           "/path/to/other/file.ini"
           "Data re-written:\n"
           :overwrite)

```

### License
This file is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2, or (at your option)
any later version.

This file is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the

GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with GNU Emacs; see the file COPYING.  If not, write to the
Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
Boston, MA 02110-1301, USA.
