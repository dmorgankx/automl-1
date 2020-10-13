// The purpose of this file is to house  utilities that are useful across more
// than one node or as part of the automl run/new/savedefault functionality and graph

// @kind function
// @category util
// @fileoverview Load function from q. If function not found, try python 
// @param funcName {sym} Name of function to retrieve
// @return {function} Loaded function
util.qpyFuncSearch:{[funcName]
  func:@[get;funcName;()];
  $[()~func;.p.get[funcName;<];func]
  }
