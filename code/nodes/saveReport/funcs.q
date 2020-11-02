\d .automl

// Definitions of the main callable functions used in the application of .automl.saveReport

// @kind function
// @category saveReport
// @fileoverview  Create dictionary with image filenames for report generation
// @param params {dict} All data generated during the process
// @return {dict} Dictionary with image filenames for report generation
saveReport.reportDict:{[params]
  config:params`config;
  savedPlots:key hsym`$config[`imagesSavePath]0;
  plotNames:$[`class~config`problemType;`conf`data`impact;`data`impact`rfr],`target;
  savedPlots:enlist[`savedPlots]!enlist plotNames!savedPlots;
  params,savedPlots
  }

// @kind function
// @category saveReport
// @fileoverview  Generate and save down procedure report
// @param params {dict} All data generated during the process
// @return {} 
saveReport.saveReport:{[params]
  -1"\nSaving down procedure report to ",params[`config;`reportSavePath;0],"\n";
  saveReport.i.FPDFReport params
  }
