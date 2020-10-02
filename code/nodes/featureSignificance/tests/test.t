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
  applyType:$[applyType;@;.];
  functionReturn:applyType[function;data];
  expectedReturn~functionReturn
  }

\S 10

// Start date and time  
startDateTime:`startDate`startTime!(.z.D;.z.T);

// Features and targets
featData   :([]100?1f;100?1f;asc 100?1f);
targClass  :100?0b;
targReg    :100?1f;

// Normal Configuration
configNormalClass:startDateTime,`featExtractType`problemType!`normal`class;
configNormalReg  :startDateTime,`featExtractType`problemType!`normal`reg;
configNormalClass:.automl.dataCheck.updateConfig[featData;configNormalClass];
configNormalReg  :.automl.dataCheck.updateConfig[featData;configNormalReg];

// FRESH Feature Data, Target and Configuration
configFRESHClass :startDateTime,`featExtractType`problemType!`fresh`class;
configFRESHReg   :startDateTime,`featExtractType`problemType!`fresh`reg;
configFRESHClass:.automl.dataCheck.updateConfig[featData;configFRESHClass];
configFRESHReg  :.automl.dataCheck.updateConfig[featData;configFRESHReg];

// Passing tests
sigFunction:{[cfg;feats;tgt] 
  sigFeats:.automl.featureSignificance.node.function[cfg;feats;tgt];
  (type sigFeats;sigFeats`sigFeats)
  };
passingTest[sigFunction;(configNormalClass;featData;targClass);0b;(99h;enlist`x1)];
passingTest[sigFunction;(configNormalReg  ;featData;targReg  );0b;(99h;enlist`x )];
passingTest[sigFunction;(configFRESHClass ;featData;targClass);0b;(99h;enlist`x1)];
passingTest[sigFunction;(configFRESHReg   ;featData;targReg  );0b;(99h;enlist`x )];

// Failing tests
configNormalClass[`sigFeats]:`.automl.newSignificanceFunction;
errMsg:"Feature significance function not defined";
failingTest[.automl.featureSignificance.node.function;(configNormalClass;featData;targClass);0b;errMsg];