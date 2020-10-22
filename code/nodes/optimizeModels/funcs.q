\d .automl

// Definitions of the main callable functions used in the application of .automl.optimizeModels

// @kind function
// @category optimizeModels
// @fileoverview Optimize models using hyperparmeter search procedures if appropriate, 
//  otherwise predict on test data
// @param mdls      {tab} Information about models applied to the data
// @param bestModel {<} Fitted best model
// @param modelName {sym} Name of best model
// @param tts       {dict} Feature and target data split into training and testing set 
// @param scoreFunc {func} Scoring function
// @return {dict} Score, prediction and best model
optimizeModels.hyperSearch:{[mdls;bestModel;modelName;tts;scoreFunc;cfg]
  mdlLib:first exec lib from mdls where model=modelName;
  customBool:mdlLib in key models;
  excludeLst:modelName in utils.excludeList; 
  predDict:$[customBool|excludeLst;
    optimizeModels.scorePred[mdls;bestModel;modelName;tts;customBool];
    optimizeModels.paramSearch[mdls;modelName;tts;scoreFunc;cfg]
    ];
  score:get[scoreFunc][predDict`predictions;tts`ytest];
  predDict,enlist[`testScore]!enlist score
  }


// @kind function
// @category optimizeModels
// @fileoverview Predict sklearn and custom models on test data
// @param mdls       {tab} Information about models applied to the data
// @param bestModel  {<} Fitted best model
// @param modelName  {sym} Name of best model
// @param tts        {dict} Feature and target data split into training and testing set
// @param customBool {bool} Whether it is a custom model or not
// @return {(float[];bool[];int[])} Predicted values  
optimizeModels.scorePred:{[mdls;bestModel;modelName;tts;customBool]
  preds:$[customBool;
    optimize.scoreCustom[mdls;bestModels;modelName;tts];
    optimize.scoreSklearn[bestModel;tts];
    ];
  returnKeys:`bestModel`hyperParams`predictions;
  returnKeys!(bestModel;()!();preds)
  }


// @kind function
// @category optimizeModels
// @fileoverview Predict custom models on test data
// @param mdls       {tab} Information about models applied to the data
// @param bestModel  {<} Fitted best model
// @param modelName  {sym} Name of best model
// @param tts        {dict} Feature and target data split into training and testing set
// @return {(float[];bool[];int[])} Predicted values  
optimizeModels.scoreCustom:{[mdls;bestModel;modelName;tts]
   modelLib:first exec lib from mdls where model=modelName;
   get[".automl.models",modelLib,".predict"][tts;bestModel]
   }


// @kind function
// @category optimizeModels
// @fileoverview Predict sklearn models on test data
// @param bestModel  {<} Fitted best model
// @param tts        {dict} Feature and target data split into training and testing set
// @return {(float[];bool[];int[])} Predicted scores
optimizeModels.scoreSklearn:{[bestModel;tts]
  bestModel[`:predict][tts`xtest]`
  }


// @kind function
// @category optimizeModels
// @fileoverview Predict custom models on test data
// @param mdls       {tab} Information about models applied to the data
// @param modelName  {sym} Name of best model
// @param tts        {dict} Feature and target data split into training and testing set
// @param scoreFunc  {} Scoring function
// @return {(float[];bool[];int[])} Predicted values 
optimizeModels.paramSearch:{[mdls;modelName;tts;scoreFunc;cfg]
  hyperParams:optimizeModels.i.extractdict[modelName;cfg];
  hyperTyp:hyperParams`hyperTyp;
  hyperDict:hyperParams`hyperDict;
  txtPath:utils.txtParse[;"/code/customization/"];
  module:` sv 2#txtPath[cfg`problemType]modelName;
  embedPyMdl:.p.import[module][hsym modelName];
  numFolds:cfg[hyperTyp;1];
  hyperFunc:cfg[hyperTyp;0];
  splitCnt:optimizeModels.i.splitCount[hyperFunc;hyperTyp;numFolds;tts;cfg];
  hyperDict:optimizeModels.i.updDict[modelName;hyperTyp;splitCnt;hyperDict;cfg];
  mdlFunc:first exec minit from mdls where model=modelName;
  numReps:1;
  xTrain:tts`xtrain;
  yTrain:tts`ytrain;
  scoreCalc:cfg[`prf]mdlFunc;
  // modification of final grid search parameter required to allow modified
  // results ordering and function definition to take place
  ordFunc:get string first txtPath[`score]scoreFunc;
  params:`val`ord`scf!(cfg`hld;ordFunc;scoreFunc);
  hyperSearch:get[hyperFunc][numFolds;numReps;xTrain;yTrain;scoreCalc;hyperDict;params];
  // Extract the best hyperparameter set based on scoring function
  bestParams:first key first hyperSearch;
  bestMdl:embedPyMdl[pykwargs bestParams][`:fit][xTrain;yTrain];
  preds:bestMdl[`:predict][tts`xtest]`;
  returnKeys:`bestModel`hyperParams`predictions;
  returnKeys!(bestMdl;bestParams;preds)
  }

// @kind function
// @category optimizeModels
// @fileoverview Create confusion matrix
// @param preds     {dict} All data generated during the process
// @param tts       {dict} Feature and target data split into training and testing set
// @param modelName {str} Name of best model
// @param cfg       {dict} Configuration information relating to the current run of AutoML
// return {dict} Confusion matrix created from predictions and true values
optimizeModels.confMatrix:{[preds;tts;modelName;cfg]
  if[`reg~cfg`problemType;:()!()];
  yTest:tts`ytest;
  if[not type[preds]~type[yTest];
    preds:`long$preds;
    yTest:`long$yTest
    ];
  -1"Confusion matrix for testing set:\n";
  show confMatrix:optimizeModels.i.confTab[preds;yTest];
  confMatrix
  }

// @kind function
// @category optimizeModels
// @fileoverview Create impact dictionary
// @param hyperSearch {dict} Values returned from hyperParameter search
// @param modelName   {str} Name of best model
// @param tts         {dict} Feature and target data split into training and testing set
// @param cfg         {dict} Configuration information relating to the current run of AutoML
// @param scoreFunc   {func} Scoring function
// @param mdls        {tab} Information about models applied to the data
// return {dict} Impact of each column in the data set 
optimizeModels.impactDict:{[hyperSearch;modelName;tts;cfg;scoreFunc;mdls]
  bestModel:hyperSearch`bestModel;
  countCols:count first tts`xtest;
  scores:optimizeModels.i.predShuffle[bestModel;modelName;tts;scoreFunc;cfg`seed;mdls]each til countCols;
  ordFunc:get string first utils.txtParse[`score;"/code/customization/"]scoreFunc;
  optimizeModels.i.impact[scores;countCols;ordFunc];
  }


// @kind function
// @category optimizeModels
// @fileoverview Consolidate all parameters created from node
// @param hyperSearch {dict} Values returned from hyperParameter search
// @param confMatrix  {dict} Confusion matrix created from model
// @param impactDict  {dict} Impact of each column in data
// @return {dict} All parameters created during node
optimizeModels.consolidateParams:{[hyperSearch;confMatrix;impactDict]
  analyzeKeys:`confMatrix`impact;
  analyzeVals:(confMatrix;impactDict);
  analyzeDict:analyzeKeys!analyzeVals;
  hyperSearch,enlist[`analyzeModel]!enlist analyzeDict
  }
