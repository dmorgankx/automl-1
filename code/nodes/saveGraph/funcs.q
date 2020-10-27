\d .automl

// Definitions of the main callable functions used in the application of .automl.saveGraph

// @kind function
// @category saveGraph
// @fileoverview Save down target distribution plot
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save target distribution plot to appropriate location
saveGraph.targetPlot:{[params;savePath]
  problemTyp:string params[`config;`problemType];
  plotFunc:".automl.saveGraph.i.",problemTyp,"TargetPlot";
  get[plotFunc][params;savePath];
  }

// @kind function
// @category saveGraph
// @fileoverview Save down result plot depending on problem Type
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save confusion matrix or residual plot to appropriate location
saveGraph.resultPlot:{[params;savePath]
  problemTyp:params[`config;`problemType];
  $[`class~problemTyp;
    saveGraph.confusionMatrix;
    saveGraph.residualPlot
    ][params;savePath]
  }


// @kind function
// @category saveGraph
// @fileoverview Save down confusion matrix
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save confusion matrix to appropriate location
saveGraph.confusionMatrix:{[params;savePath]
  confMatrix:params[`analyzeModel;`confMatrix];
  modelName :params`modelName;
  classes:`$string key confMatrix;
  saveGraph.i.displayConfMatrix[value confMatrix;classes;modelName;savePath]
  }


// @kind function
// @category saveGraph
// @fileoverview Save down residual plot
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save residual plot to appropriate location
saveGraph.residualPlot:{[params;savePath]
  residuals:params[`analyzeModel;`residuals];
  modelName:params`modelName;
  tts      :params`tts;
  saveGraph.i.plotResiduals[residuals;tts;modelName;savePath]
  }


// @kind function
// @category saveGraph
// @fileoverview Save down impact plot
// @param params   {dict} All data generated during the process
// @param savePath {str} Path where images are to be saved
// return {null} Save impact plot to appropriate location
saveGraph.impactPlot:{[params;savePath]
  modelName:params`modelName;
  sigFeats:params`sigFeats;
  impact:params[`analyzeModel;`impact];
  // update impact dictionary to include actual column names
  // instead of just indexes
  updKeys:sigFeats key impact;
  updImpact:updKeys!value impact;
  saveGraph.i.plotImpact[updImpact;modelName;savePath];
  }