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
            (directory "doc" ((texi-file "guile-netpbm")))))
         (infrastructure ((scheme-file "hall")))))
