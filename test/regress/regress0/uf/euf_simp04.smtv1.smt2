(set-option :incremental false)
(set-info :status unsat)
(set-info :category "crafted")
(set-logic QF_UF)
(declare-sort U 0)
(declare-fun x () U)
(declare-fun y () U)
(declare-fun z () U)
(declare-fun f (U) U)
(declare-fun g (U) U)
(declare-fun H (U U) U)
(declare-fun J (U U) U)
(check-sat-assuming ( (let ((_let_0 (J z y))) (let ((_let_1 (f x))) (let ((_let_2 (= x _let_1))) (and (= (H x y) (H y x)) (or (= x _let_0) (= y _let_0)) (= _let_0 _let_1) (or _let_2 (not (= y _let_1))) (or (not _let_2) (not (= (H x _let_1) (H _let_1 x)))))))) ))
