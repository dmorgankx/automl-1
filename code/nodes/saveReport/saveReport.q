\d .automl

// @kind function
// @category node
// @fileoverview  Save a latex/python generated report summarising the 
//   process of reaching the users final model
// @param params {dict} All data generated during the preprocessing and
//  prediction stages
// @return {null} Report saved to appropriate location
saveReport.node.function:{[params]
  if[2<>params[`config]`saveopt;:()];
  params:saveReport.reportDict params;
  saveReport.saveReport params
  }

// Input information
saveReport.node.inputs  :"!"

// Output information
saveReport.node.outputs :"!"