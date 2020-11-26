\d .automl

// Generate the relative path required to retrieve the JSON file used to 
// modify the acceptable inputs, if none provided then the system will use the
// default json representation
cli.path:$[`config in key commandLineInput;
  cli.i.checkCustom commandLineInput`config;
  path,"/code/customization/configuration/default.json"
  ]

// Retrieve model parameters from file 
cli.input:.j.k raze read0 `$cli.path
paramTypes:`general`fresh`normal`nlp
paramDict:paramTypes!cli.i.parseParameters[cli.input] each paramTypes

problemDict:cli.input`problemDetails
