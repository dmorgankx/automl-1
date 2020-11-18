\d .automl

cli.userInput:first each .Q.opt .z.x

// List of acceptable command line arguments to Automl
cli.isNonDefault:cli.i.acceptableKeys in key cli.userInput

if[all cli.isNonDefault;
  -1"Only one of 'updateDefault'/'CommandLine' can be passed in command line\n";
  exit 1];

cli.path:$[any cli.isNonDefault;
  [customLocation:cli.userInput cli.i.acceptableKeys where cli.isNonDefault;
   cli.i.checkCustom[customLocation]
   ];
  path,"/code/customization/configuration/default.json"
  ]

cli.input:.j.k raze read0 `$cli.path

generalParameters:cli.i.parseJson[cli.input;`general]
freshParameters  :cli.i.parseJson[cli.input;`fresh]
normalParameters :cli.i.parseJson[cli.input;`normal]
nlpParameters    :cli.i.parseJson[cli.input;`nlp]
