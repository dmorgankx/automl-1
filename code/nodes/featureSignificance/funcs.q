\d .automl

// Definitions of the main callable functions used in the application of .automl.featureSignificance

// @kind function
// @category featureSignificance
// @fileoverview Extract feature significant tests and apply to feature data
// @param cfg   {dict} Configuration information assigned by the user and related to the current run
// @param feats {tab}  The feature data as a table 
// @param tgt   {(num[];sym[])} Numerical or symbol vector containing the target dataset
// @return {sym[]} Significant features or error if function does not exist
featureSignificance.applySigFunc:{[cfg;feats;tgt]
  sigFunc:@[get;cfg`sigFeats;{'"Feature significance function ",x," not defined"}];
  sigFunc[feats;tgt]
  }

// @kind function
// @category featureSignificance
// @fileoverview Apply feature significance function to data post feature extraction
// @param cfg   {dict}          Configuration information assigned by the user and related to the current run
// @param feats {tab}           The feature data as a table 
// @param tgt   {(num[];sym[])} Numerical or symbol vector containing the target dataset
// @return      {sym[]}         Significant features
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
// @param sigFeats {sym[]} Significant columns
// @return {sym[]} Significant columns
featureSignificance.countCols:{[feats;sigFeats]
  $[0<>count sigFeats;
    sigFeats;
    [-1"Feature significance extraction deemed none of the features to be important. Continuing with all features.";
     cols feats]]
  }

// @kind function
// @category featureSignificance
// @fileoverview Find any correlated columns and remove them
// @param sigFeats {tab} Significant data features
// @return {sym[]} Significant columns
featureSignificance.correlationCols:{[sigFeats]
  thres:0.95;
  boolMat:t>\:t:til count first sigFeats;
  corrMat:abs .ml.corrmat sigFeats;
  cols2drop:where featureSignificance.threshVal[thres]'[corrMat;boolMat];
  if[0<count cols2drop;
    -1 sv[", ";string cols2drop]," removed during correlation checks."
    ];
  cols[sigFeats]except cols2drop
  }


// @kind function
// @category featureSignificance
// @fileoverview Find any corrlated columns within threshold
// @param threshold {int} Threshold value to search within
// @param corrMat   {tab} Correlation Matrix
// @param boolMat  {matrix} Lower traingle boolean 
// @return {sym[]} Columns within threshold
featureSignificance.threshVal:{[threshold;corrMat;boolMat]
  any threshold<value[corrMat]where boolMat
  }
