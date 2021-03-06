/*********************                                                        */
/*! \file theory_bv.h
 ** \verbatim
 ** Top contributors (to current version):
 **   Liana Hadarean, Andrew Reynolds, Tim King
 ** This file is part of the CVC4 project.
 ** Copyright (c) 2009-2020 by the authors listed in the file AUTHORS
 ** in the top-level source directory) and their institutional affiliations.
 ** All rights reserved.  See the file COPYING in the top-level source
 ** directory for licensing information.\endverbatim
 **
 ** \brief Bitvector theory.
 **
 ** Bitvector theory.
 **/

#include "cvc4_private.h"

#ifndef CVC4__THEORY__BV__THEORY_BV_H
#define CVC4__THEORY__BV__THEORY_BV_H

#include <unordered_map>
#include <unordered_set>

#include "context/cdhashset.h"
#include "context/cdlist.h"
#include "context/context.h"
#include "theory/bv/bv_subtheory.h"
#include "theory/bv/theory_bv_rewriter.h"
#include "theory/bv/theory_bv_utils.h"
#include "theory/theory.h"
#include "util/hash.h"
#include "util/statistics_registry.h"

// Forward declarations, needed because the BV theory and the BV Proof classes
// are cyclically dependent
namespace CVC4 {
namespace proof {
class BitVectorProof;
}
}  // namespace CVC4

namespace CVC4 {
namespace theory {
namespace bv {

class CoreSolver;
class InequalitySolver;
class AlgebraicSolver;
class BitblastSolver;

class EagerBitblastSolver;

class AbstractionModule;

class TheoryBV : public Theory {

  /** The context we are using */
  context::Context* d_context;

  /** Context dependent set of atoms we already propagated */
  context::CDHashSet<Node, NodeHashFunction> d_alreadyPropagatedSet;
  context::CDHashSet<Node, NodeHashFunction> d_sharedTermsSet;

  std::vector<std::unique_ptr<SubtheorySolver>> d_subtheories;
  std::unordered_map<SubTheory, SubtheorySolver*, std::hash<int> > d_subtheoryMap;

public:

  TheoryBV(context::Context* c, context::UserContext* u, OutputChannel& out,
           Valuation valuation, const LogicInfo& logicInfo,
           std::string name = "");

  ~TheoryBV();

  TheoryRewriter* getTheoryRewriter() override { return &d_rewriter; }

  void setMasterEqualityEngine(eq::EqualityEngine* eq) override;

  void finishInit() override;

  Node expandDefinition(Node node) override;

  void preRegisterTerm(TNode n) override;

  void check(Effort e) override;

  bool needsCheckLastEffort() override;

  void propagate(Effort e) override;

  Node explain(TNode n) override;

  bool collectModelInfo(TheoryModel* m) override;

  std::string identify() const override { return std::string("TheoryBV"); }

  /** equality engine */
  eq::EqualityEngine* getEqualityEngine() override;
  bool getCurrentSubstitution(int effort,
                              std::vector<Node>& vars,
                              std::vector<Node>& subs,
                              std::map<Node, std::vector<Node> >& exp) override;
  int getReduction(int effort, Node n, Node& nr) override;

  PPAssertStatus ppAssert(TNode in, SubstitutionMap& outSubstitutions) override;

  void enableCoreTheorySlicer();

  Node ppRewrite(TNode t) override;

  void ppStaticLearn(TNode in, NodeBuilder<>& learned) override;

  void presolve() override;

  bool applyAbstraction(const std::vector<Node>& assertions, std::vector<Node>& new_assertions);

  void setProofLog(proof::BitVectorProof* bvp);

 private:

  class Statistics {
  public:
    AverageStat d_avgConflictSize;
    IntStat     d_solveSubstitutions;
    TimerStat   d_solveTimer;
    IntStat     d_numCallsToCheckFullEffort;
    IntStat     d_numCallsToCheckStandardEffort;
    TimerStat   d_weightComputationTimer;
    IntStat     d_numMultSlice;
    Statistics();
    ~Statistics();
  };

  Statistics d_statistics;

  void spendResource(ResourceManager::Resource r);

  /**
   * Return the uninterpreted function symbol corresponding to division-by-zero
   * for this particular bit-width
   * @param k should be UREM or UDIV
   * @param width
   *
   * @return
   */
  Node getBVDivByZero(Kind k, unsigned width);

  typedef std::unordered_set<TNode, TNodeHashFunction> TNodeSet;
  typedef std::unordered_set<Node, NodeHashFunction> NodeSet;
  NodeSet d_staticLearnCache;

  /**
   * Maps from bit-vector width to division-by-zero uninterpreted
   * function symbols.
   */
  std::unordered_map<unsigned, Node> d_BVDivByZero;
  std::unordered_map<unsigned, Node> d_BVRemByZero;

  typedef std::unordered_map<Node, Node, NodeHashFunction>  NodeToNode;

  context::CDO<bool> d_lemmasAdded;

  // Are we in conflict?
  context::CDO<bool> d_conflict;

  // Invalidate the model cache if check was called
  context::CDO<bool> d_invalidateModelCache;

  /** The conflict node */
  Node d_conflictNode;

  /** Literals to propagate */
  context::CDList<Node> d_literalsToPropagate;

  /** Index of the next literal to propagate */
  context::CDO<unsigned> d_literalsToPropagateIndex;

  /**
   * Keeps a map from nodes to the subtheory that propagated it so that we can explain it
   * properly.
   */
  typedef context::CDHashMap<Node, SubTheory, NodeHashFunction> PropagatedMap;
  PropagatedMap d_propagatedBy;

  std::unique_ptr<EagerBitblastSolver> d_eagerSolver;
  std::unique_ptr<AbstractionModule> d_abstractionModule;
  bool d_isCoreTheory;
  bool d_calledPreregister;
  
  //for extended functions
  bool d_needsLastCallCheck;
  context::CDHashSet<Node, NodeHashFunction> d_extf_range_infer;
  context::CDHashSet<Node, NodeHashFunction> d_extf_collapse_infer;
  /** do extended function inferences
   *
   * This method adds lemmas on the output channel of TheoryBV based on
   * reasoning about extended functions, such as bv2nat and int2bv. Examples
   * of lemmas added by this method include:
   *   0 <= ((_ int2bv w) x) < 2^w
   *   ((_ int2bv w) (bv2nat x)) = x
   *   (bv2nat ((_ int2bv w) x)) == x + k*2^w
   * The purpose of these lemmas is to recognize easy conflicts before fully
   * reducing extended functions based on their full semantics.
   */
  bool doExtfInferences( std::vector< Node >& terms );
  /** do extended function reductions
   *
   * This method adds lemmas on the output channel of TheoryBV based on
   * reducing all extended function applications that are preregistered to
   * this theory and have not already been reduced by context-dependent
   * simplification (see theory/ext_theory.h). Examples of lemmas added by
   * this method include:
   *   (bv2nat x) = (ite ((_ extract w w-1) x) 2^{w-1} 0) + ... +
   *                (ite ((_ extract 1 0) x) 1 0)
   */
  bool doExtfReductions( std::vector< Node >& terms );
  
  bool wasPropagatedBySubtheory(TNode literal) const {
    return d_propagatedBy.find(literal) != d_propagatedBy.end();
  }

  SubTheory getPropagatingSubtheory(TNode literal) const {
    Assert(wasPropagatedBySubtheory(literal));
    PropagatedMap::const_iterator find = d_propagatedBy.find(literal);
    return (*find).second;
  }

  /** Should be called to propagate the literal.  */
  bool storePropagation(TNode literal, SubTheory subtheory);

  /**
   * Explains why this literal (propagated by subtheory) is true by adding assumptions.
   */
  void explain(TNode literal, std::vector<TNode>& assumptions);

  void addSharedTerm(TNode t) override;

  bool isSharedTerm(TNode t) { return d_sharedTermsSet.contains(t); }

  EqualityStatus getEqualityStatus(TNode a, TNode b) override;

  Node getModelValue(TNode var) override;

  inline std::string indent()
  {
    std::string indentStr(getSatContext()->getLevel(), ' ');
    return indentStr;
  }

  void setConflict(Node conflict = Node::null());

  bool inConflict() {
    return d_conflict;
  }

  void sendConflict();

  void lemma(TNode node) { d_out->lemma(node, RULE_CONFLICT); d_lemmasAdded = true; }

  void checkForLemma(TNode node);

  /** The theory rewriter for this theory. */
  TheoryBVRewriter d_rewriter;

  friend class LazyBitblaster;
  friend class TLazyBitblaster;
  friend class EagerBitblaster;
  friend class BitblastSolver;
  friend class EqualitySolver;
  friend class CoreSolver;
  friend class InequalitySolver;
  friend class AlgebraicSolver;
  friend class EagerBitblastSolver;
};/* class TheoryBV */

}/* CVC4::theory::bv namespace */
}/* CVC4::theory namespace */

}/* CVC4 namespace */

#endif /* CVC4__THEORY__BV__THEORY_BV_H */
