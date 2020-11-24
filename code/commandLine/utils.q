\d .automl

cli.i.acceptableKeys:`UpdateDefault`CommandLine

cli.i.checkCustom:{[fileName]
  fileName:raze fileName;
  if[not ()~key hsym `$fpath:path,"/code/customization/configuration/customConfig/",fileName;:fpath];
  if[not ()~key hsym `$fpath:"./",fileName;:fpath];
  'fileName," doesn't exist in current or '",path,"code/configuration/customConfig' directories";
  }

cli.i.parseParameters:{[cliInput;sectionType]
  dataset:cliInput[`Problem_Parameters;sectionType;`meta;`typeConvert];
  datasetTypes:value[cliInput[`Problem_Parameters;sectionType;`meta;`typeConvert]];
  lambdaLocations:where datasetTypes like "lambda";
  notLambdaLocations:til[count datasetTypes]except lambdaLocations;
  lambdaKeys:key[dataset] lambdaLocations;
  symbolLocations:where datasetTypes like "symbol";
  generalTypeConvert:@[`$datasetTypes notLambdaLocations;symbolLocations;{`}];
  generalInfo:generalTypeConvert$lambdaKeys _ cliInput[`Problem_Parameters;sectionType;`Parameters];
  lambdaInfo:((),lambdaKeys)!((),get each cliInput[`Problem_Parameters;sectionType;`Parameters][lambdaKeys]);
  generalInfo,lambdaInfo
  }
