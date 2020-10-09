// The purpose of this file is to house  utilities that are useful across more
// than one node or as part of the automl run/new/savedefault functionality and graph

// @kind function
// @category util
// @fileoverview Load function from q. If function not found, try python and error out if 
//   function still unavailable.
// @param funcName {sym} Name of function to retrieve
// @return {function} Loaded function
util.qpyFuncSearch:{[funcName]
  func:@[get;funcName;()];
  $[()~func;
    @[.p.get[;<];funcName;{'"Function ",x," not defined in q or Python"}];
    func
    ]
  }