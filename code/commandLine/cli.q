\d .automl

// Retrieve command line parameters
cli.userInput:first each .Q.opt .z.x

// Check if a suitable command line parameter has been provided limiting
// this to only allow one of the options to be invoked
cli.isNonDefault:cli.i.acceptableKeys in key cli.userInput
if[all cli.isNonDefault;
  -1"Only one of 'updateDefault'/'CommandLine' can be passed in command line\n";
  exit 1];

// Generate the path relative required to retrieve the JSON file used to 
// modify the acceptable input, if non provided then the system will use the
// default json representation
cli.path:$[any cli.isNonDefault;
  [customLocation:cli.userInput cli.i.acceptableKeys where cli.isNonDefault;
   cli.i.checkCustom customLocation];
  path,"/code/customization/configuration/default.json"
  ]

// Retrieve model parameters from file 
cli.input:.j.k raze read0 `$cli.path
paramTypes:`general`fresh`normal`nlp
paramDict:paramTypes!cli.i.parseParameters[cli.input] each paramTypes

problemDict:cli.input`Problem_Details
