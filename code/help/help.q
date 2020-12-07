\d .automl

// Utilities specific to the .automl.help function

// @kind string
// @category helpUtility
// @fileoverview Header string for all help printouts
utils.help.header:"****************************************************************************\n\n"

// @kind string
// @category helpUtility
// @fileoverview Footer string for all help printouts
utils.help.footer:reverse utils.help.header

// @kind dictionary
// @category helpUtility
// @fileoverview Dictionary of AutoML nodes with description, parameters and available node functions
utils.help.functions:.j.k raze read0 hsym`$.automl.path,"/code/help/help.json"

// @kind function
// @category helpUtility
// @fileoverview Overview of help functionality available within AutoML
utils.help.overview:{[]
  -1 utils.help.header,
    "Welcome to the Kx Automated Machine Learning Platform.\n\n",
    "All documentation can be found at https://code.kx.com/q/ml/automl/\n\n",
    "To query a function within AutoML, pass the complete function name as a\n",
    "string to .automl.help e.g.\n\n",
    "  q).automl.help[\".automl.dataCheck.node.function\"]",
    utils.help.footer;
  }

// @kind function
// @category helpUtility
// @fileoverview Overview of help functionality available within AutoML
utils.help.node:{[node]
  if[not node in key utils.help.functions;'string[node]," - node not found"];
  info:utils.help.functions node;
  params:$[""~p:info`parameters;
    "No parameters";
    "\n"sv"  ",/:string[key p],'" - ",/:value p
    ];
  funcs:$[""~f:info`functions;
    "No callable node functions";
    "\n"sv"  ",/:f
    ];
  -1 utils.help.header,
    "Node: ",@[string node;0;upper],"\n\n",
    "Description:\n\n",
    info[`description],"\n\n",
    "Parameters:\n\n",params,"\n\n",
    "Functions:\n\n",funcs,
    utils.help.footer;
  }