\d .automl

// The purpose of this file is to house  utilities that are useful across more
// than one node or as part of the automl run/new/savedefault functionality and graph

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

// @kind function
// @category Utility
// @fileoverview Load function from q. If function not found, try python 
// @param funcName {sym} Name of function to retrieve
// @return {function} Loaded function
utils.qpyFuncSearch:{[funcName]
  func:@[get;funcName;()];
  $[()~func;.p.get[funcName;<];func]
  }

// @kind function
// @category Utility
// @fileoverview Load NLP library if requirements met
// @params {null}
// @return {null} Library loaded if requirements met or statement printed to terminal
utils.loadNLP:{
  $[(0~checkimport[3])&(::)~@[{system"l ",x};"nlp/nlp.q";{0b}];
    .nlp.loadfile`:init.q;
    -1"Requirements for NLP models are not satisfied. gensim must be installed. NLP module will not be available.";
    ]
  }

// @kind function
// @category Utility
// @fileoverview Used throughout the library to convert linux/mac file names to windows equivalent
// @param path {str} the linux 'like' path
// @retutn {str} path modified to be suitable for windows systems
utils.ssrWindows:{[path]
  $[.z.o like "w*";ssr[path;"/";"\\"];path]
  }

// Python plot functionality
utils.plt:.p.import`matplotlib.pyplot;

// @kind function
// @category Utility
// @fileoverview Used throughout when printing directory of saved objects.
//  this is to keep linux/windows consistent
// @param path {str} the linux 'like' path
// @retutn {str} path modified to be suitable for windows systems
utils.ssrsv:{[path]
  ssr[path;"\\";"/"]
  }

// @kind function
// @category Utility
// @fileoverview Split data into train and testing set without shuffling
// @param feat {tab}   The feature data as a table 
// @param tgt  {num[]} Numerical vector containing target data
// @param size {float} Proportion of data to be left as testing
// @retutn {dict}  Data separated into training and testing sets
utils.ttsNonShuff:{[feat;tgt;size]
  `xtrain`ytrain`xtest`ytest!raze(feat;tgt)@\:/:(0,floor n*1-size)_til n:count feat
  }

// @kind function
// @category Utility
// @fileoverview Return column value based on best model
// @param mdls      {tab}  Models to be applied to feature data
// @param modelName {sym} The name of the model
// @param col       {sym} Column to search
// @return {sym} Column value
utils.bestModelDef:{[mdls;modelName;col]
  first?[mdls;enlist(=;`model;enlist modelName);();col]
  }

// @kind function
// @fileoverview Retrieve the feature and target data based on user defined json
i.getCommandLineData:{[method]
  methodSpecification:cli.input`retrievalMethods;
  // Using if statements rather than if else (neater as logic contained inside is slightly complicated)
  if[`csv=method;
    dict:methodSpecification[method],enlist[`typ]!enlist`csv;
    data:.ml.i.loaddset[dict];
    targetName:`$dict`targetColumn;
    :`features`target!(flip targetName _ flip data;data targetName)
  ];
  if[`ipc=method;
    dict:methodSpecification[method];
    dict:("J";"c";`)$/:dict,\:enlist[`typ]!enlist"ipc";
    features:.ml.i.loaddset dict`featureData;
    target  :.ml.i.loaddset dict`targetData;
    :`features`target!.ml.i.loaddset each dict`featureData`targetData
  ];
  '"Method defined by user for data retrieval not currently supported";
  }

util.generatePredict:{[params;saved;feats]
  config:$[saved;params;
    [saveMetaInfo:exec from params where nodeId=`saveMeta;
     saveMetaInfo[`outputs;`output]]
    ];
  bestModel:config`bestModel;
  feats:util.featureCreation[config;saved;feats];
  modelLibrary:$[saved;config`modelLib;config[`modelMetaData;`modelLib]];
  $[`sklearn~modelLibrary;bestModel[`:predict;<]feats;
    `keras~modelLibrary;
    [feats:enlist[`xtest]!enlist feats;
     get[".automl.models.keras.",(neg[5]_string config`modelName),".predict"][feats;bestModel]];
    '"NotYetImplemented"]
  }

// Apply feature creation and encoding procedures for 'normal' on new data
/. r > table with feature creation and encodings applied appropriately
util.featureCreation:{[config;saved;feats]
  problemConfig:$[saved;config;config`config];
  sigFeats     :config`sigFeats;
  extractType  :problemConfig`featExtractType;
  if[`nlp  ~extractType;problemConfig[`w2v]:1b];
  if[`fresh~extractType;
    relevantFuncs:raze`$distinct{("_" vs string x)1}each sigFeats;
    appropriateFuncs:1!select from 0!.ml.fresh.params where f in relevantFuncs;
    problemConfig[`funcs]:appropriateFuncs];
  feats:dataPreprocessing.node.function[problemConfig;feats;config`symEncode];
  feats:featureCreation.node.function[problemConfig;feats]`features;
  if[not all newFeats:sigFeats in cols feats;
    newColumns:sigFeats where not newFeats;
    feats:sigFeats xcols flip flip[feats],newColumns!((count newColumns;count feats)#0f),()];
  flip value flip sigFeats#"f"$0^feats
  }

util.loadModel:{[modelMeta;modelPath]
  modelLibrary:modelMeta`modelLib;
  loadFunction:$[modelLibrary~`sklearn;
    .p.import[`joblib][`:load];
    modelLibrary~`keras;
    $[0~checkimport[0];.p.import[`keras.models][`:load_model];'"Keras model could not be loaded"]
   ];
  modelFile:modelPath,"models/",$[modelLibrary~`sklearn;
    string[modelMeta`modelName];
    modelLibrary~`keras;string[modelMeta`modelName],".h5";
    '"Unsupported model type provided"];
  loadFunction modelFile
  }

util.modelPath:{[dict]
  pathStem:path,"/outputs/";
  keyDict:key dict;
  if[dateTime:all `startDate`startTime in keyDict;
    if[not all (-14h;-19h)=type each dict`startDate`startTime;
      '"Types provided for date/time retrieval must be a date and time respectively"]
    ];
  if[modelName:`savedModelName in keyDict;
    if[not 10h=type dict`savedModelName;
      '"Types provided for model name based retrieval must be a string"]
    ];
  if[modelName;:pathStem,"namedModels/",dict`savedModelName];
  if[dateTime ;:pathStem,ssr[string[dict`startDate],"/run_",string[dict`startTime],"/";":";"."]];
  '"A user must define model start date/time or model name.";
  }
