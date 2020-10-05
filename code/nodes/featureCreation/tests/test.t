\l automl.q
.automl.loadfile`:init.q

// The following utilities are used to test that a function is returning the expected
// error message or data, these functions will likely be provided in some form within
// the test.q script provided as standard for the testing of q and embedPy code

// @kind function
// @category tests
// @fileoverview Ensure that a test that is expected to fail, 
//   does so with an appropriate message
// @param function {(func;proj)} The function or projection to be tested
// @param data {any} The data to be applied to the function as an individual item for
//   unary functions or a list of variables for multivariant functions
// @param applyType {boolean} Is the function to be applied unary(1b) or multivariant(0b)
// @param expectedError {string} The expected error message on failure of the function
// @return {boolean} Function errored with appropriate message (1b), function failed
//   inappropriately or passed (0b)
failingTest:{[function;data;applyType;expectedError]
  // Is function to be applied unary or multivariant
  applyType:$[applyType;@;.];
  failureFunction:{[err;ret](`TestFailing;ret;err~ret)}[expectedError;];
  functionReturn:applyType[function;data;failureFunction];
  $[`TestFailing~first functionReturn;last functionReturn;0b]
  }

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
  
  
// Feature creation function tabular return
featureCreationTable:{[cfg;feat].automl.featureCreation.node.function[cfg;feat]`prepTab}


// Testing functionality for normal feature creation

// Load in appropriate data for ech feature extraction type
normalFileList:`normalTable`normalBulkTable`normalTruncTable
{load hsym`$":code/nodes/featureCreation/tests/data/normal/",string x}each normalFileList;

// Create suitable normal config and feature table
normalConfig    :`featExtractType`funcs!`normal`.automl.featureCreation.normal.default
normalConfigBulk:`featExtractType`funcs!`normal`.automl.featureCreation.normal.bulktransform
normalConfigTrunc:`featExtractType`funcs!`normal`.automl.featureCreation.normal.truncSingleDecomp


// Test all appropriate normal feature creation inputs
passingTest[featureCreationTable;(normalConfig     ;normalTable);0b;"f"$normalTable]
passingTest[featureCreationTable;(normalConfigBulk ;normalTable);0b;normalBulkTable]
passingTest[featureCreationTable;(normalConfigTrunc;normalTable);0b;normalTruncTable]

// Testing functionality for fresh feature creation

// Load in appropriate data for fresh feature extraction type
freshFileList:`freshTable`freshReturnTable
{load hsym`$":code/nodes/featureCreation/tests/data/fresh/",string x}each freshFileList;

// Create suitable fresh config and feature table
freshConfig :`featExtractType`aggcols`funcs!`fresh`idx`.ml.fresh.params

// Test all appropriate fresh feature creation inputs
passingTest[featureCreationTable;(freshConfig     ;freshTable);0b;freshReturnTable]


// Testing functionality for nlp feature creation

// Load in appropriate data for nlp feature extraction type
nlpFileList:`nlpTable`nlpMultiTable`nlpReturnTable`nlpMultiReturnTable
{load hsym`$":code/nodes/featureCreation/tests/data/nlp/",string x}each nlpFileList;

// Create suitable normal config and feature table
nlpConfig   :`featExtractType`funcs`w2v`seed!`nlp`.automl.featureCreation.normal.default,0,1234

// Test all appropriate nlp feature creation inputs
passingTest[featureCreationTable;(nlpConfig     ;nlpTable     );0b;nlpReturnTable]
passingTest[featureCreationTable;(nlpConfig     ;nlpMultiTable);0b;nlpMultiReturnTable]

// Testing inappropriate input type for Feature creation function
inapprConfig:`featExtractType`funcs!`test`.automl.featureCreation.normal.default

// Return for inappropriate creation type
inapprReturn:"Feature extraction type is not currently supported";

failingTest[featureCreationTable;(inapprConfig;normalTable);0b;inapprReturn]
