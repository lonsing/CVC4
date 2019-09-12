(set-option :incremental false)
(set-info :status unsat)
(set-logic QF_BV)
(declare-fun v0 () (_ BitVec 4))
(declare-fun v1 () (_ BitVec 4))
(declare-fun v2 () (_ BitVec 4))
(declare-fun v3 () (_ BitVec 4))
(declare-fun v4 () (_ BitVec 4))
(declare-fun v5 () (_ BitVec 4))
(check-sat-assuming ( (let ((_let_0 ((_ extract 0 0) v2))) (let ((_let_1 ((_ zero_extend 2) ((_ zero_extend 1) _let_0)))) (let ((_let_2 ((_ sign_extend 3) (ite (distinct (_ bv0 4) v4) (_ bv1 1) (_ bv0 1))))) (let ((_let_3 (bvadd _let_1 _let_2))) (let ((_let_4 ((_ zero_extend 3) (ite (bvsge (_ bv11 4) v5) (_ bv1 1) (_ bv0 1))))) (let ((_let_5 (ite (bvult ((_ sign_extend 3) (ite (bvsle _let_3 (_ bv0 4)) (_ bv1 1) (_ bv0 1))) _let_4) (_ bv1 1) (_ bv0 1)))) (let ((_let_6 (bvmul v5 (bvlshr v4 ((_ sign_extend 3) (ite (bvsge v2 (_ bv11 4)) (_ bv1 1) (_ bv0 1))))))) (let ((_let_7 (bvashr v1 ((_ sign_extend 3) (ite (bvsge v1 ((_ zero_extend 3) (ite (bvugt v0 (_ bv0 4)) (_ bv1 1) (_ bv0 1)))) (_ bv1 1) (_ bv0 1)))))) (let ((_let_8 (bvashr v3 _let_1))) (let ((_let_9 (ite (bvule _let_8 (_ bv1 4)) (_ bv1 1) (_ bv0 1)))) (let ((_let_10 (ite (bvsge ((_ sign_extend 1) (ite (bvsge ((_ zero_extend 3) _let_9) _let_7) (_ bv1 1) (_ bv0 1))) (_ bv0 2)) (_ bv1 1) (_ bv0 1)))) (let ((_let_11 (ite (= (ite (bvslt _let_6 v2) (_ bv1 1) (_ bv0 1)) _let_10) (_ bv1 1) (_ bv0 1)))) (let ((_let_12 (bvneg v4))) (let ((_let_13 ((_ sign_extend 3) (_ bv1 1)))) (and (bvugt v3 ((_ zero_extend 3) (ite (bvsge _let_5 (ite (bvslt _let_6 v2) (_ bv1 1) (_ bv0 1))) (_ bv1 1) (_ bv0 1)))) (bvult _let_7 (_ bv10 4)) (or false (not (distinct _let_11 (ite (bvugt ((_ sign_extend 3) (bvashr (bvadd (_ bv1 1) (ite (bvult _let_6 v1) (_ bv1 1) (_ bv0 1))) (ite (bvslt _let_12 (_ bv0 4)) (_ bv1 1) (_ bv0 1)))) ((_ sign_extend 3) _let_11)) (_ bv1 1) (_ bv0 1)))) (bvule (_ bv1 1) (bvcomp v3 ((_ sign_extend 3) _let_9)))) (bvsle _let_13 _let_12) (not (bvsle ((_ sign_extend 3) (ite (distinct (_ bv0 4) ((_ sign_extend 3) _let_0)) (_ bv1 1) (_ bv0 1))) (bvxnor _let_3 ((_ zero_extend 3) (ite (bvsle _let_6 (_ bv0 4)) (_ bv1 1) (_ bv0 1)))))) (or false (bvsle (concat ((_ extract 2 0) v3) _let_10) _let_13) (bvsle (_ bv0 1) (ite (bvsge ((_ sign_extend 3) (ite (bvsgt (bvmul v4 ((_ zero_extend 3) (ite (bvuge (_ bv0 4) _let_2) (_ bv1 1) (_ bv0 1)))) (_ bv0 4)) (_ bv1 1) (_ bv0 1))) ((_ zero_extend 3) (ite (bvsge (ite (bvsgt _let_4 (_ bv0 4)) (_ bv1 1) (_ bv0 1)) (ite (bvult v4 v4) (_ bv1 1) (_ bv0 1))) (_ bv1 1) (_ bv0 1)))) (_ bv1 1) (_ bv0 1)))) (bvuge (_ bv0 4) ((_ zero_extend 3) _let_5)) (= ((_ sign_extend 2) (ite (bvule _let_6 (_ bv0 4)) (_ bv1 1) (_ bv0 1))) (concat (ite (bvsle (_ bv0 4) (ite (= _let_0 (_ bv1 1)) _let_6 _let_8)) (_ bv1 1) (_ bv0 1)) ((_ extract 1 0) _let_7)))))))))))))))))) ))