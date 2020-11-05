\d .automl

// Python report generation using reportlab

// @kind function
// @category saveReport
// @fileoverview Generate a report using the Python package 'reportlab'.
//  This report outlines the results from a timed + dated run of automl.
// @param params   {dict} All data generated during the process
// @param filePath {str} Location to save report
// @return {null} Associated pdf report saved to disk
saveReport.reportlabGenerate:{[params;filePath]

  // Main variables
  bestModel:params`modelName;
  modelMeta:params`modelMetaData;
  config   :params`config;
  pdf      :saveReport.i.canvas[`:Canvas]filePath,".pdf";
  ptype    :$[`class~config`problemType;"classification";"regression"];
  plots    :params`savedPlots;

  // Report generation
 
  // Title
  saveReport.i.font[pdf;"Helvetica-BoldOblique";15];  
  f:saveReport.i.title[pdf;775;0;"kdb+/q AutoML Procedure Report"];

  // Summary
  saveReport.i.font[pdf;"Helvetica";11];
  f:saveReport.i.cell[pdf;f;40;"This report outlines the results for a ",ptype," problem achieved through running kdb+/q AutoML."];
  f:saveReport.i.cell[pdf;f;30;"This run started on ",string[config`startDate]," at ",string[config`startTime],"."];

  // Input data
  saveReport.i.font[pdf;"Helvetica-Bold";13];
  f:saveReport.i.cell[pdf;f;30;"Description of Input Data"];

  saveReport.i.font[pdf;"Helvetica";11];
  f:saveReport.i.cell[pdf;f;30;"The following is a breakdown of information for each of the relevant columns in the dataset:"];
  ht:saveReport.i.printDescripTab params`dataDescription;
  f:saveReport.i.makeTable[pdf;ht`t;f;ht`h;10;10];

  f:saveReport.i.image[pdf;plots`target;f;250;280;210];
  saveReport.i.font[pdf;"Helvetica";10];
  f:saveReport.i.cell[pdf;f;25;"Figure 1: Distribution of input target data"];
  
  // Feature extraction and selection
  saveReport.i.font[pdf;"Helvetica-Bold";13];
  f:saveReport.i.cell[pdf;f;30;"Breakdown of Pre-Processing"];

  numSig:count params`sigFeats;
  saveReport.i.font[pdf;"Helvetica";11];
  f:saveReport.i.cell[pdf;f;30;@[string config`featExtractType;0;upper]," feature extraction and selection was performed",
    " with a total of ",string[numSig]," feature",$[1~numSig;;"s",]" produced."];
  f:saveReport.i.cell[pdf;f;30;"Feature extraction took ",string[params`creationTime]," time in total."];

  // Cross validation
  saveReport.i.font[pdf;"Helvetica-Bold";13];
  f:saveReport.i.cell[pdf;f;30;"Initial Scores"];

  saveReport.i.font[pdf;"Helvetica";11];
  xvalFunc:string config[`xv]0;
  xvalSize:config[`xv]1;
  xvalType:`$last"."vs xvalFunc;
  xval:$[xvalType in`mcsplit`pcsplit;
    "Percentage based cross validation, ",xvalFunc,", was performed with a testing set created from ",string[100*xvalSize],
      "% of the training data.";
    string[xvalSize],"-fold cross validation was performed on the training set to find the best model using ",xvalFunc,"."
    ];

  f:saveReport.i.cell[pdf;f;30;xval];
  f:saveReport.i.image[pdf;plots`data;f;90;500;100];
  saveReport.i.font[pdf;"Helvetica";10];
  f:saveReport.i.cell[pdf;f;25;"Figure 2: The data split used within this run of AutoML, with data split into training, holdout and testing sets"];

  saveReport.i.font[pdf;"Helvetica";11];
  f:saveReport.i.cell[pdf;f;30;"The total time taken to carry out cross validation for each model on the training set was ",
    string[modelMeta`xValTime]];
  f:saveReport.i.cell[pdf;f;15;"where models were scored and optimized using ",string[modelMeta`metric],"."];
  f:saveReport.i.cell[pdf;f;30;"Model scores:"];

  // Feature impact
  f:saveReport.i.printKDBTable[pdf;f;modelMeta`modelScores];
  f:saveReport.i.image[pdf;plots`impact;f;250;280;210];
  saveReport.i.font[pdf;"Helvetica";10];
  f:saveReport.i.cell[pdf;f;25;"Figure 3: Feature impact of each significant feature as determined by the training set"];

  // Run models
  saveReport.i.font[pdf;"Helvetica-Bold";13];
  f:saveReport.i.cell[pdf;f;30;"Model selection summary"];
  saveReport.i.font[pdf;"Helvetica";11];
  f:saveReport.i.cell[pdf;f;30;"Best scoring model = ",string bestModel];
  f:saveReport.i.cell[pdf;f;30;"The score on the holdout set for this model was = ",string[ modelMeta`holdoutScore],"."];
  f:saveReport.i.cell[pdf;f;30;"The total time taken to complete the running of this model on the holdout set was: ",string[modelMeta`holdoutTime],"."];

  // Hyperparameter search
  hptyp:@[;0;upper]string srch:config`hp;
  hptyp:enlist[hptyp],$[srch=`grid;`gs;srch in`random`sobol;`rs];
  hpStr:string config hptyp 1;
  hpFunc:hpStr 0;
  hpSize:hpStr 1;
  hpMethod:`$last"."vs hpFunc;

  saveReport.i.font[pdf;"Helvetica-Bold";13];
  f:saveReport.i.cell[pdf;f;30;"Best Model"];

  if[not bestModel in utils.excludeList;
    saveReport.i.font[pdf;"Helvetica";11];
    f:saveReport.i.cell[pdf;f;30;]$[hpMethod in`mcsplit`pcsplit;
      "The hyperparameter search was completed using ",hpFunc," with a percentage of ",hpSize,"% of training data used for validation";
      "A ",hpSize,"-fold ",lower[hptyp 0]," search was performed on the training set to find the best model using, ",hpFunc,"."
      ];
    f:saveReport.i.cell[pdf;f;30;"The following are the hyperparameters which have been deemed optimal for the model:"];
    f:saveReport.i.printKDBTable[pdf;f;params`hyperParams];
    ];
  
  // Final results
  f:saveReport.i.cell[pdf;f;30;"The score for the best model fit on the entire training set and scored on the testing set was = ",
    string params`testScore];

  $[ptype like"*class*";
    [f:saveReport.i.image[pdf;plots`conf;f;300;250;250];
     saveReport.i.font[pdf;"Helvetica";10];
     saveReport.i.cell[pdf;f;25;"Figure 4: This is the confusion matrix produced for predictions made on the testing set"]];
    [f:saveReport.i.image[pdf;plots`reg;f;300;250;250];
     saveReport.i.font[pdf;"Helvetica";10];
     saveReport.i.cell[pdf;f;25;"Figure 4: Regression analysis plot produced for predictions made on the testing set"]];
    ];

  pdf[`:save][];
  }

