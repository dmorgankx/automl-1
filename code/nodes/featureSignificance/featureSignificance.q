// Apply feature significance logic to data post feature extraction, returning the original dataset
// and a list of significant features to be used both for selection of data from new runs and 
// within the current run.

\d .automl

// @kind function
// @category node
// @fileoverview Apply feature significance logic to data post feature extraction
// @param cfg   {dict}          Configuration information assigned by the user and related to the current run
// @param feats {tab}           The feature data as a table 
// @param tgt   {(num[];sym[])} Numerical or symbol vector containing the target dataset
// @return      {dict}          List of significant features and the feature data post feature extraction
featureSignificance.node.function:{[cfg;feats;tgt]
  sigFunc:@[get;cfg`sigFeats;{'"Feature significance function ",x," not defined"}];
  sigFeats:sigFunc[feats;tgt];
  sigFeats:featureSignificance.countCols[feats;sigFeats];
  `sigFeats`features!(sigFeats;feats)
  }

// Input information
featureSignificance.node.inputs  :`config`features`target!"!+F"

// Output information
featureSignificance.node.outputs :`sigFeats`features!"S+"
