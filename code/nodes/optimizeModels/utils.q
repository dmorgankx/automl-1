\d .automl

// Utility functions for optimizeModels

// @kind function
// @category optimizeModelsUtility
// @fileoverview Extract the hyperparameter dictionaries based on the applied model
// @param bestModel  {<} Fitted best Model
// @param cfg        {dict} Configuration information assigned by the user and related to the current run
// @return {dict} The hyperparameters appropriate for the model being used
optimizeModels.i.extractdict:{[bestModel;cfg]
  hyperParam:cfg`hp;
  // get grid/random hyperparameter file name
  hyperTyp:$[`grid=hyperParam;
      `gs;
      hyperParam in`random`sobol;
       `rs;
       '"unsupported hyperparameter generation method"];
  // load in table of hyperparameters to dictionary with (hyperparameter!values)
  hyperParamsDir:path,"/code/customization/hyperParameters/";
  system"l ",hyperParamsDir,string[hyperTyp],"Hyperparameters.q";
  extractParams:hyperparams bestModel;
  returnKeys:`hyperTyp`hyperDict;
  returnVals:(hyperTyp;extractParams[`hyperparams]!extractParams`values);
  returnKeys!returnVals
  }

// @kind function
// @category optimizeModelsUtility
// @fileoverview Split the training data into a representation of the breakdown of data for 
//  the hyperparameter search. This is used to ensure that if a hyperparameter search is done 
//  on KNN that there are sufficient, data points in the validation set for all hyperparameter 
//  nearest neighbour calculations.
// @param hyperFunc {sym} Hyperparameter function to be used
// @param hyperTyp  {sym} Type of hyperparameter to be used
// @param numFolds  {int} Number of folds to use
// @param tts       {dict} Feature and target data split into training and testing set
// @param cfg       {dict} Configuration information assigned by the user and related to the current run
// @return {dict} The hyperparameters appropriate for the model being used
optimizeModels.i.splitCount:{[hyperFunc;hyperTyp;numFolds;tts;cfg]
 $[hyperFunc in `mcsplit`pcsplit;
   1-numFolds;
   (numFolds-1)%numFolds
   ]*count[tts`xtrain]*1-cfg[`hld]
  }

// @kind function
// @category optimizeModelsUtility
// @fileoverview Alter hyperParameter dictionary depending on bestModel and type
//  of hyperopt to be used
// @param modelName {sym} Name of best model
// @param hyperTyp  {sym} Type of hyperparameter to be used
// @param splitCnt  {int} How data shoudl be split for hyperParam search
// @param hyperDict {dict} HyperParameters used for hyperParam search  
// @param cfg       {dict} Configuration information assigned by the user and related to the current run
// @return {dict} The hyperparameters appropriate for the model being used
optimizeModels.i.updDict:{[modelName;hyperTyp;splitCnt;hyperDict;cfg]
  knModel:modelName in`KNeighborsClassifier`KNeighborsRegressor;
  if[knModel&hyperTyp~`gs;
    if[0<count where n:splitCnt<hyperDict`n_neighbors;
      hyperDict[`n_neighbors]@:where not n;
      ]
     ];
  if[hyperTyp~`rs;
    if[knModel;
      if[splitCnt<hyperDict[`n_neighbors;2];
        hyperDict[`n_neighbors;2]:"j"$splitCnt
        ]
      ]; 
   // if random add extra parameters
   // check can you join all to 1 dict?
    hyperDict:`typ`random_state`n`p!(cfg`hp;cfg`seed;cfg`trials;hyperDict)
    ];
  hyperDict
  }

