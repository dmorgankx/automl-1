// Following the initial selection of the most promising model apply the user defined optimization
// grid/random/sobol if feasible (ignore for keras/pytorch etc)
\d .automl

/ @kind function
// @category node
// @fileoverview Optimize models using hyperparmeter search procedures if appropriate, 
//  otherwise predict on test data
// @param cfg   {dict} Configuration information assigned by the user and related to the current run
// @param mdls  {tab} Information about models applied to the data
// @param bmdl  {<} Fitted best model
// @param bname {sym} Name of best model
// @param tts   {dict} Feature and target data split into training and testing set 
// @return {dict} Score, prediction and best model
optimizeModels.node.function:{[cfg;mdls;bmdl;bname;tts]
   scoreFunc:cfg[`scf][cfg`problemType];
   optimizeModels.hyperSearch[mdls;bmdl;bname;tts;scoreFunc;cfg]
  }

// Input information
optimizeModels.node.inputs  :`config`models`bestModel`bestScoringName`ttsObject!"!+<s "

// Output information
optimizeModels.node.outputs :`bestModel`hyperParams`predictions`testScore!"<!Ff"
