// Select the 'most promising' model from the list of provided models for the user defined problem
// this is done in a cross validated manner with the best model selected based on its generalizability
// prior to the application of grid/random/sobol search optimization
\d .automl

// @kind function
// @category node
// @fileoverview 
// @param cfg  {dict} Location and method by which to retrieve the data
// @param tts  {dict} Feature and target data split into training and testing set
// @param mdl  {tab}  Potential models to be applied to feature data
// @return {dict} Best model returned along with name of model
runModels.node.function:{[cfg;tts;mdls]
  runModels.setSeed[cfg];
  holdoutSet:runModels.holdoutSplit[cfg;tts];
  xValStart:.z.T;
  predicts:runModels.xValSeed[holdoutSet;cfg]'[mdls];
  scoreFunc:runModels.scoringFunc[cfg;mdls];
  show scores:runModels.orderModels[mdls;scoreFunc;predicts];
  xValTime:.z.T-xValStart;
  holdoutRun:runModels.bestModelFit[scores;holdoutSet;mdls;scoreFunc;cfg];
  metaData:runModels.createMeta[holdoutRun;scores;scoreFunc;xValTime];
  returnKeys:`bestModel`bestScoringName`metaData;
  returnVals:(holdoutRun`model;holdoutRun`bestModel;metaData);
  returnKeys!returnVals
  }

// Input information
runModels.node.inputs  :`config`ttsObject`models!"!!+"

// Output information
runModels.node.outputs :`bestModel`bestScoringName`metaData!"<s!"
