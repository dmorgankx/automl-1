\l automl.q
.automl.loadfile`:init.q

// The following utilities are used to test that a function is returning the expected
// error message or data, these functions will likely be provided in some form within
// the test.q script provided as standard for the testing of q and embedPy code

// @kind function
// @category tests
// @fileoverview Ensure that a test that is expected to pass, 
//   does so with an appropriate return
// @param function {(func;proj)} The function or projection to be tested
// @param data {any} The data to be applied to the function as an individual item for
//   unary functions or a list of variables for multivariant functions
// @param applyType {boolean} Is the function to be applied unary(1b) or multivariant(0b)
// @param expectedReturn {string} The data expected to be returned on 
//   execution of the function with the supplied data
// @return {boolean} Function returned the appropriate output (1b), function failed 
//   or executed with incorrect output (0b)
passingTest:{[function;data;applyType;expectedReturn]
  // Is function to be applied unary or multivariant
  applyType:$[applyType;@;.];
  functionReturn:applyType[function;data];
  expectedReturn~functionReturn
  }

// Generate input models to be saved 

-1"\nCreating output directory";

// Generate a path to save images to
filePath:"/outputs/testing/models"
savePath:.automl.utils.ssrwin .automl.path,filePath
system"mkdir",$[.z.o like"w*";" ";" -p "],savePath;

// Generate model meta data
mdlMetaData:enlist[`pythonLib]!enlist `sklearn

// Generate config data
configSave :enlist[`configSavePath]!enlist savePath

// NLP w2v models cannot be tested as gensim is not a requirement
configSave :enlist[`modelSavePath]!enlist savePath
configNormal0:configSave,`saveopt`featExtractType!(0;`normal)
configNormal1:configSave,`saveopt`featExtractType!(1;`normal)
configNormal2:configSave,`saveopt`featExtractType!(2;`normal)

// Generate Random Forest Regressor model

// Input features
feats:100 3#300?10f

// Target values
tgtReg:100?1f

// Target data split into train and testing sets
ttsReg:`xtrain`ytrain!(feats;tgtReg)

// RandomForestRegressor model
sklearnEnsemble   :{[mdl;train;test].p.import[`sklearn.ensemble][mdl][][`:fit][train;test]}
randomForestRegMdl:sklearnEnsemble[`:RandomForestRegressor;;]. ttsReg`xtrain`ytrain
modelName         :`RandomForestRegressor

// Input params
paramDict :`bestModel`modelName`modelMetaData!(randomForestRegMdl;modelName;mdlMetaData)
paramDict0:paramDict,enlist[`config]!enlist configNormal0
paramDict1:paramDict,enlist[`config]!enlist configNormal1
paramDict2:paramDict,enlist[`config]!enlist configNormal2

-1"\nTesting appropriate input data to saveModels";

passingTest[.automl.saveModels.node.function;paramDict0;1b;(::)]
passingTest[.automl.saveModels.node.function;paramDict1;1b;(::)]
passingTest[.automl.saveModels.node.function;paramDict2;1b;(::)]

-1"\nRemoving any directories created";

// Remove any directories made
rmPath:.automl.utils.ssrwin .automl.path,"/outputs/testing/";
system"rm -r ",rmPath;
