\d .automl

// Save an encoded representation of the best model retrieved during the automl process

// @kind function
// @category node
// @fileoverview Save all models needed to predict on new data
// @param params {dict} All data generated during the preprocessing and
//  prediction stages
// @return {null} All models saved to appropriate location
saveModels.node.function:{[params]
  saveOpt:params[`config;`saveopt];
  if[saveOpt=0;:()];
  savePath:path,params[`pathDict;`models];
  saveModels.saveModel[params;savePath]
  }

// Input information
saveModels.node.inputs  :"!"

// Output information
saveModels.node.outputs :"!"

