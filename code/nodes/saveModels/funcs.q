\d .automl

// Definitions of the main callable functions used in the application of .automl.saveModels

// @kind function
// @category saveGraph
// @fileoverview Save best Model
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save best model to appropriate location
saveModels.saveModel:{[params;savePath]
  lib:params[`modelMetaData;`pythonLib];
  bestModel:params`bestModel;
  modelName:string params`modelName
  filePath:savePath,"/",modelName;
  joblib:.p.import`joblib;
  $[`sklearn~lib;
    joblib[`:dump][bestModel;filePath]
    `keras~lib;
    bestModel[`:save][filePath,".h5"];
    `pytorch~lib;
    torch[`:save][bestModel;filePath];
    -1"Saving of non keras/sklearn models types is not currently supported"
   ]; 
  -1"Saving down ",modelName," model to ",savePath
  }


// @kind function
// @category saveGraph
// @fileoverview Save nlp w2v model
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save nlp w2v to appropriate location
saveModels.saveW2V:{[params;savePath]
  featType:params[`config;`ExtractionType];
  if[not featType~`nlp;:()];
  w2vModel:params[`featModel];
  w2vModel[`:save][savePath,"w2v.model"];
  } 
