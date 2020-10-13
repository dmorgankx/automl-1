\d .automl

// Definitions of the main callable functions used in the application of .automl.trainTestSplit


// Configuration update

// @kind function
// @category trainTestSplit
// @fileoverview Apply TTS function
// @param cfg      {dict}          Location and method by which to retrieve the data
// @param feat     {tab}           The feature data as a table 
// @param tgt      {(num[];sym[])} Numerical or symbol vector containing the target dataset
// @param sigFeats {sym[]}         Significant features
// @return         {dict}          Data separated into training and testing sets
trainTestSplit.applyTTS:{[cfg;feats;tgt;sigFeats]
  data:flip feats sigFeats;
  ttsFunc:util.qpyFuncSearch cfg`tts;
  testSize:trainTestSplit.sizeCheck[cfg`sz];
  ttsFunc[data;tgt;testSize]
  }

// @kind function
// @category trainTestSplit
// @fileoverview Checks that the size of testing set lies between 0 and 1
// @param sz  {float} Size of testing set
// @return    {float} Size of testing set
trainTestSplit.sizeCheck:{[sz]
  $[(0.<sz)&sz<1.;
    sz;
    '"Testing size must be in range 0-1"
    ]
  }

// @kind function
// @category trainTestSplit
// @fileoverview Returns train test split object if dictionary. If not error will occur.
// @param tts  {dict} Feature and target data split into training and testing set
// @return     {dict} Feature and target data split into training and testing set
trainTestSplit.ttsReturnType:{[tts]
  $[99h<>type tts;
    '"Train test split function must return a dictionary with `xtrain`xtest`ytrain`ytest";
    tts
    ]
  }