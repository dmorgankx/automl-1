// The following utilities are used to test that a function is returning the 
//   expected error message or data. These functions will likely be provided in
//   some form within the test.q script provided as standard for the testing of
//   q and embedPy code.

// @kind function
// @category tests
// @fileoverview Ensure that a test that is expected to fail, does so with an 
//   appropriate message
// @param function {(<;proj)} The function or projection to be tested
// @param data {any} Data to be applied to the function as an individual item
//   for unary functions or a list of variables for multivariant functions
// @param applyType {bool} Is function to be applied unary/multivariant (1b/0b)
// @param expectedError {str} Expected error message on failure of the function
// @return {bool} Function errored with appropriate message (1b), function 
//   failed inappropriately or passed (0b)
failingTest:{[function;data;applyType;expectedError]
  // Is function to be applied unary or multivariant
  applyType:$[applyType;@;.];
  failureFunction:{[err;ret](`TestFailing;ret;err~ret)}expectedError;
  functionReturn:applyType[function;data;failureFunction];
  $[`TestFailing~first functionReturn;last functionReturn;0b]
  }

// @kind function
// @category tests
// @fileoverview Ensure that a test that is expected to pass, 
//   does so with an appropriate return
// @param function {(<;proj)} The function or projection to be tested
// @param data {any} Data to be applied to the function as an individual item
//   for unary functions or a list of variables for multivariant functions
// @param applyType {bool} Is function to be applied unary/multivariant (1b/0b)
// @param expectedReturn {string} The data expected to be returned on execution
//   of the function with the supplied data
// @return {bool} Function returned the appropriate output (1b), function
//   failed or executed with incorrect output (0b)
passingTest:{[function;data;applyType;expectedReturn]
  // Is function to be applied unary or multivariant
  applyType:$[applyType;@;.];
  functionReturn:applyType[function;data];
  expectedReturn~functionReturn
  }
