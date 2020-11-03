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

\S 42

-1"\nCreating output directory";

savePath:.automl.utils.ssrWindows .automl.path,"/outputs/testing/reports/";
system"mkdir",$[.z.o like "w*";" ";" -p "],savePath;

n:100
start:`startDate`startTime!(.z.D;.z.T)

genCfg:{[start;feat;ftype;ptype]  out:"/outputs/testing/";  cfg:start,`featExtractType`problemType!(ftype;ptype);  cfg:.automl.dataCheck.updateConfig[feat;cfg];  cfg[`reportSavePath]:(.automl.path,rep;rep:out,"report/");  cfg[`imagesSavePath]:(.automl.path,img;img:"/code/nodes/saveReport/tests/images/");  cfg  }[start]

savedPlots:`conf`data`impact`target!("Confusion_Matrix.png";"Data_Split.png";"Impact_Plot.png";"Target_Distribution.png")

modelMetaData:`xValTime`metric`modelScores`holdoutScore`holdoutTime!(first 1?0t;`.ml.mse;`a`b`c!3?1f;1?1f;first 1?0t)

params:`modelName`modelMetaData`savedPlots`creationTime`hyperParams!(`a;modelMetaData;savedPlots;first 1?0t;`a`b`c!3?1f)

featFRESH:([]asc 1000?n;1000?1f;asc 1000?1f)
descFRESH:.automl.featureDescription.dataDescription featFRESH
targFRESHClass :asc n?0b
targFRESHReg   :asc n?1f
confFRESHClass :genCfg[featFRESH;`fresh;`class]
prmsFRESHClass :params,`config`dataDescription!(confFRESHClass;descFRESH)
confFRESHReg   :genCfg[featFRESH;`fresh;`reg]
prmsFRESHClass :params,`config`dataDescription!(confFRESHReg;descFRESH)

featNormal:([]n?1f;n?1f;asc n?1f)
descNormal:.automl.featureDescription.dataDescription featNormal
targNormalClass:asc n?0b
targNormalReg  :asc n?5f
confNormalClass:genCfg[featNormal;`normal;`class]
prmsNormalClass:params,`config`dataDescription!(confNormalClass;descNormal)
confNormalReg  :genCfg[featNormal;`normal;`reg]
prmsNormalReg  :params,`config`dataDescription!(confNormalReg;descNormal)

featNLP:([]asc n?`a`b`c;asc n?("yes";"no";"maybe");n?1f;desc n?1f)
descNLP:.automl.featureDescription.dataDescription featNLP
targNLPClass   :asc n?0b
targNLPClass   :asc n?1f
confNLPClass   :genCfg[featNLP;`nlp;`class]
prmsNLPClass   :params,`config`dataDescription!(confNLPClass;descNLP)
confNLPReg     :genCfg[featNLP;`nlp;`reg]
prmsNLPReg     :params,`config`dataDescription!(confNLPReg;descNLP)


-1"\nRunning tests for saveReport";



-1"\nRemoving any directories created";

rmPath:.automl.utils.ssrwin .automl.path,"/outputs/testing/";
system $[.z.o like "w*";"rmdir ",rmPath," /s";"rm -r ",rmPath];
