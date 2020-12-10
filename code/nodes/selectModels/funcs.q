\d .automl

// Definitions of the main callable functions used in the application of 
//   .automl.selectModels

// @kind function
// @category selectModels
// @fileoverview Remove Keras models if criteria met
// @param modelTab {tab} Models which are to be applied to the dataset
// @param tts {dict} Feature and target data split into train and testing sets
// @param target {(num[];sym[])} Numerical or symbol target vector
// @return {tab} Keras model removed if needed and removal highlighted
selectModels.targetKeras:{[modelTab;tts;target]
  if[1~checkimport 0;:?[modelTab;enlist(<>;`lib;enlist`keras);0b;()]];
  multiCheck:`multi in modelTab`typ;
  targetCount:min count@'distinct each tts`ytrain`ytest;
  targetCheck:count[distinct target]>targetCount;
  if[multiCheck&targetCheck;
    -1"\n Test set does not contain examples of each class. ",
	  "Removed any multi-Keras models";
    :delete from modelTab where lib=`keras,typ=`multi
    ];
  modelTab
  }

// @kind function
// @category selectModels
// @fileoverview Update models available for use based on the number datapoints
//   in the target vector
// @param modelTab {tab} Models which are to be applied to the dataset
// @param target {(num[];sym[])} Numerical or symbol target vector
// @return {tab} Appropriate models removed and highlighted to the user
selectModels.targetLimit:{[modelTab;target]
  if[10000<count target;
    -1"\nLimiting the models being applied due to number targets>10,000\n",
      "No longer running neural nets or svms\n";
    :select from modelTab where lib<>`keras,not fnc in`neural_network`svm
    ];
  modelTab
  }
