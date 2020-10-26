\d .automl

// Save relevant metadata information for the use of a persisted model on new data

// @kind function
// @category node
// @fileoverview Save all metadata information needed to predict on new data
// @param params {dict} All data generated during the preprocessing and
//  prediction stages
// @return {null} All metadata needed is saved to appropriate location
saveMeta.node.function:{[params]
  mdlMeta:saveMeta.extractMdlMeta[params`modelMetaData];
  saveMeta.saveMeta[mdlMeta;params]
  }

// Input information
saveMeta.node.inputs  :"!"

// Output information
saveMeta.node.outputs :"!"
