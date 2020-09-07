(hall-description
  (name "guile-netpbm")
  (prefix "")
  (version "0.1")
  (author "Tim Van den Langenbergh")
  (copyright (2020))
  (synopsis "")
  (description "")
  (home-page "")
  (license gpl3+)
  (dependencies `())
  (files (libraries
           ((directory
              "guile-netpbm"
              ((scheme-file "image")
               (scheme-file "ppm")
               (scheme-file "pgm")
               (scheme-file "pbm")))))
         (tests ())
         (programs ())
         (documentation
           ((org-file "README")
            (symlink "README" "README.org")
            (text-file "HACKING")
            (text-file "COPYING")
            (directory "doc" ((texi-file "guile-netpbm")))
            (text-file "NEWS")
            (text-file "AUTHORS")
            (text-file "ChangeLog")
            (text-file "NEWS")
            (text-file "AUTHORS")
            (text-file "ChangeLog")))
         (infrastructure
           ((scheme-file "guix")
            (scheme-file "hall")
            (directory
              "build-aux"
              ((scheme-file "test-driver")))
            (autoconf-file "configure")
            (automake-file "Makefile")
            (in-file "pre-inst-env")
            (directory
              "build-aux"
              ((scheme-file "test-driver")))
            (autoconf-file "configure")
            (automake-file "Makefile")
            (in-file "pre-inst-env")))))
