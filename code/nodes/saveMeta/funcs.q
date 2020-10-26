\d .automl

// Definitions of the main callable functions used in the application of .automl.saveMeta


// @kind function
// @category saveMeta
// @fileoverview Extract appropriate model meta data
// @param mdlMeta {dict} All model meta data generated the process
// return {dict} Appropriate model meta data extracted
saveMeta.extractMdlMeta:{[mdlMeta]
  pythonLib:mdlMeta`pythonLib;
  mdlType  :mdlMeta`mdlType;
  `pythonLib`mdlType!(pythonLib;mdlType)
   }


// @kind function
// @category saveMeta
// @fileoverview Save metaData
// @param mdlMeta  {dict} Appropriate model meta data generated during the process
// @param params   {dict} All data generated during the process
// return {null} Save metadict to appropriate location
saveMeta.saveMeta:{[mdlMeta;params]
  cfg:params`config;
  metaDict:mdlMeta,cfg;
  `:metadata set metaDict;
  savePath:path,params[`pathDict;`config];
  // move the metadata information to the appropriate location based on OS
  $[.z.o like "w*";
    system"move metadata ",;
    system"mv metadata ",
    ]savePath;
  -1"Saving down model parameters to ",utils.ssrsv[savePath];
  }
