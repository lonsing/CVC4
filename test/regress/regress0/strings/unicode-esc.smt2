; COMMAND-LINE: --strings-exp --lang=smt2.6.1
; EXPECT: sat
(set-logic ALL)

(assert (= "\u{14}" "\u0014"))
(assert (= "\u{00}" "\u{0}"))
(assert (= "\u0000" "\u{0}"))
(assert (= (str.len "\u1234") 1))
(assert (= (str.len "\u{1}") 1))
(assert (= (str.len "\u{99}") 1))
(assert (= (str.len "\u{779}") 1))
(assert (= (str.len "\u{0779}") 1))
(assert (= (str.len "\u{01779}") 1))
(assert (= (str.len "\u{001779}") 10))
(assert (= (str.len "\u{0vv79}") 9))
(assert (= (str.len "\u{11\u1234}") 7))
(assert (= (str.len "\u12345") 2))
(assert (= (str.len "\uu") 3))
(assert (= (str.len "\u{123}\u{567}") 2))
(assert (= (str.len "\u{0017") 7))
(assert (= (str.len "\\u00178") 3))
(assert (= (str.len "2\u{}") 5))
(assert (= (str.len "\uaaaa") 1))
(assert (= (str.len "\uAAAA") 1))
(assert (= (str.len "\u{0AbC}") 1))
(assert (= (str.len "\u{E}") 1))
(assert (= (str.len "\u{44444}") 9))
(assert (= (str.len "\u") 2))
(assert (= (str.len "\u001") 5))
(assert (= (str.len "\u0001") 1))

(check-sat)