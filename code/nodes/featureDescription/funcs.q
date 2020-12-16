\d .automl

// Definition of the main callable functions used in the application of
//   .automl.featureDescription

// @kind function
// @category featureDescription
// @fileoverview  Symbol encoding function to generate the encoding map 
//   used when applying this workflow to new data
// @param features {tab} Feature data as a table
// @param nVals {int} The number of distinct symbols in a column which can be
//   one-hot encoded. If a column has more than this number of symbols the 
//   column will be frequency encoded.
// @param config {dict} Information regarding current run of AutoML
// @returns {dict} Mapping of the columns which require symbol encoding and 
//   denoting if these columns are to be frequency or one-hot encoded based on
//   the number of unique symbols allowing a user to appropriately encode data
//   when running on new datasets.
featureDescription.symEncodeSchema:{[features;nVals;config]
  aggcols:$[`fresh~config`featureExtractionType;
    config`aggregationColumns;
    (::)
    ];
  symbolCols:.ml.i.fndcols[features;"s"]except aggcols;
  $[0=count symbolCols;
    `freq`ohe!``;
    [
     // List of frequency encoding columns
     symDict:symbolCols!flip[features]symbolCols;
     frequencyCols:where nVals<count each distinct each symDict;
     // List of one-hot encoded columns
     oneHotCols:symbolCols where not symbolCols in frequencyCols;
     // Return encoding schema or apply encoding as appropriate
     `freq`ohe!(frequencyCols;oneHotCols)
     ]
    ]
  }

// @kind function
// @category featureDescription
// @fileoverview Outline statistics for the feature dataset being supplied for
//   the current run
// @param features {tab} Feature data as a table
// @returns {keyed tab} Description of the feature dataset highlighting useful 
//   statistics including min/max/avg/unique/type/std dev/count
featureDescription.dataDescription:{[features]
  columns :`count`unique`mean`std`min`max`type;
  // Find columns based on their type
  numcols :.ml.i.fndcols[features;"hijef"];
  timecols:.ml.i.fndcols[features;"pmdznuvt"];
  boolcols:.ml.i.fndcols[features;"b"];
  catcols :.ml.i.fndcols[features;"s"];
  textcols:.ml.i.fndcols[features;"cC"];
  // Projection for the retrieval of appropriate metadata information
  featureMeta:featureDescription.i.metaData[features;;];
  // Apply metadata retrieval to different columns types
  num:featureMeta[numcols;(count;{count distinct x};avg;sdev;min;max;{`numeric})];
  symb:featureMeta[catcols;featureDescription.i.nonNumeric{`categorical}];
  times:featureMeta[timecols;featureDescription.i.nonNumeric{`time}];
  text:featureMeta[textcols;featureDescription.i.nonNumeric{`text}];
  bool:featureMeta[boolcols;featureDescription.i.nonNumeric{`boolean}];
  flip columns!flip num,symb,times,bool,text
  }
