\d .automl

// Definitions of the main callable functions used in the application of .automl.featureSignificance

// @kind function
// @category featureSignificance
// @fileoverview Apply feature significance function to data post feature extraction
// @param cfg   {dict}          Configuration information assigned by the user and related to the current run
// @param feats {tab}           The feature data as a table 
// @param tgt   {(num[];sym[])} Numerical or symbol vector containing the target dataset
// @return      {sym[]}         List of significant features
featureSignificance.significance:{[feats;tgt]
  sigFeats:.ml.fresh.significantfeatures[feats;tgt;.ml.fresh.benjhoch .05];
  if[0=count sigFeats;
    sigFeats:.ml.fresh.significantfeatures[feats;tgt;.ml.fresh.percentile .25]];
  sigFeats
  }

// @kind function
// @category featureSignificance
// @fileoverview Count how many significant columns were returned by significance tests
// @param feats    {tab}   The feature data as a table 
// @param sigFeats {sym[]} List of columns
// @return         {sym[]} List of columns
featureSignificance.countCols:{[feats;sigFeats]
  $[0<>count sigFeats;
    sigFeats;
    [-1 i.runout`nosig;
     cols t]]
  }