\l automl.q
.automl.loadfile`:init.q

// The following utilities are used to test that a function is returning the expected
// error message or data, these functions will likely be provided in some form within
// the test.q script provided as standard for the testing of q and embedPy code
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

// Generate input data to be passed to saveMeta

// Generate a path to save images to
filePath:"/outputs/testing/configs"
savePath:.automl.utils.ssrwin .automl.path,filePath
system"mkdir",$[.z.o like "w*";" ";" -p "],savePath;
pathDict:enlist[`config]!enlist filePath

// Generate model meta data
mdlMetaData:`pythonLib`mdlType!(`sklearn;`class)

// Generate config data
configDict0:`saveopt`featExtractType`problemType!(0;`normal;`reg)
configDict1:`saveopt`featExtractType`problemType!(1;`fresh ;`class)
configDict2:`saveopt`featExtractType`problemType!(2;`nlp   ;`reg)

paramDict0:`modelMetaData`config`pathDict!(mdlMetaData;configDict0;pathDict)
paramDict1:`modelMetaData`config`pathDict!(mdlMetaData;configDict1;pathDict)
paramDict2:`modelMetaData`config`pathDict!(mdlMetaData;configDict2;pathDict)

-1"\nTesting appropriate inputs to saveMeta";

passingTest[.automl.saveMeta.node.function;paramDict0;1b;(::)]
passingTest[.automl.saveMeta.node.function;paramDict1;1b;(::)]
passingTest[.automl.saveMeta.node.function;paramDict2;1b;(::)]


// Remove any directories made
rmPath:.automl.utils.ssrwin .automl.path,"/outputs/testing/";
system $[.z.o like "w*";"rmdir ",rmPath," /s";"rm -r ",rmPath];
