\d .automl

// Definitions of the main callable functions used in the application of .automl.optimize

// @kind function
// @category optimizeModels
// @fileoverview Optimize models using hyperparmeter search procedures if appropriate, 
//  otherwise predict on test data
// @param mdls  {tab} Information about models applied to the data
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
// @return {(float[];bool[];int[])} Predicted scores  
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
// @return {(float[];bool[];int[])} Predicted scores  
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
// @return {(float[];bool[];int[])} Predicted scores  
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
  numReps:cfg[hyperTyp;2];
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
