\d .automl

// The purpose of this file is to house  utilities that are useful across more
// than one node or as part of the automl run/new/savedefault functionality and graph

// update run models to include this in utilities
// @kind function
// @category utility
// @fileoverview Extraction of an appropriately valued dictionary from a non complex flat file
// @param nameMap  {sym} Name mapping to appropriate text file
// @param filePath {str} File path relative to .automl.path
// @return {dict} Parsed from an appropriate flat file
utils.txtParse:{[nameMap;filePath]
  fileName:`$path,filePath,utils.files nameMap;
  utils.readFile each(!).("S*";"|")0:hsym fileName
  }


// @kind function
// @category utility
// @fileoverview Extraction of data from a file
// @param filePath {str} File path from which to extract the data from 
// @return {dict} parsed from file
utils.readFile:{[filePath]
  key(!).("S=;")0:filePath
  }


// @kind function
// @category utility
// Text files that can be parsed from within the models folder
utils.files:`class`reg`score!("models/modelConfig/classmodels.txt";"models/modelConfig/regmodels.txt";"scoring/scoring.txt")

// @kind function
// @category utility
//List of models to exclude
utils.excludeList:`GaussianNB`LinearRegression;


// @kind function
// @category Utility
// @fileoverview Defaulted fitting and prediction functions for automl cross-validation 
//  and grid search, both models fit on a training set and return the predicted scores based 
//  on supplied scoring function.
// @param func {<} Function taking in parameters and data as input, returns appropriate score
// @param hyperParam {dict} hyperparameters on which to complete hyperparameter search
// @data {float[]} data as a ((xtrn;ytrn);(xval;yval)), this structure is defined from the data
// @return {(bool[];float[])} Value predicted on the validation set and the true value 
utils.fitPredict:{[func;hyperParam;data]
  predicts:$[0h~type hyperParam;
    func[data;hyperParam 0;hyperParam 1];
    @[.[func[][hyperParam]`:fit;data 0]`:predict;data[1]0]`
    ];
  (predicts;data[1]1)
  }
