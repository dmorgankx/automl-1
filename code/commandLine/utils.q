\d .automl

cli.i.acceptableKeys:`config`run

cli.i.checkCustom:{[fileName]
  fileName:raze fileName;
  if[not ()~key hsym `$fpath:path,"/code/customization/configuration/customConfig/",fileName;:fpath];
  if[not ()~key hsym `$fpath:"./",fileName;:fpath];
  'fileName," doesn't exist in current or '",path,"code/configuration/customConfig' directories";
  }

cli.i.parseParameters:{[cliInput;sectionType]
  section:cliInput[`problemParameters;sectionType];
  cli.i.convertParameters each section
  }

cli.i.convertParameters:{[param]
  $["symbol"~param`type;`$param`value;
    "lambda"~param`type;get param`value;
    (`$param`type)$param`value
  ]
  }
