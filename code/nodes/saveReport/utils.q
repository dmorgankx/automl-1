\d .automl

// Python report generation

// Python imports
canvas:.p.import`reportlab.pdfgen.canvas
table :.p.import[`reportlab.platypus]`:Table
np    :.p.import`numpy

// @kind function
// @category saveReportUtility
// @fileoverview Generate report using FPDF outlining results from current run of automl
// @param params {dict} All data generated during the process
// @return {null} Associated pdf report saved to disk
saveReport.i.FPDFReport:{[params]

  // main variables

  bestModel:params`modelName;
  modelMeta:params`modelMetaData;
  config   :params`config;
  ptype    :config`problemType;
  pdf      :canvas[`:Canvas]config[`reportSavePath;0],"FPDFReport_",string[bestModel],".pdf";
  imagePath:config[`imagesSavePath]0;
  plots    :params`savedPlots;

  // report generation

  font[pdf;"Helvetica-BoldOblique";15];  
  f:title[pdf;775;0;"kdb+/q AutoML Procedure Report"];

  font[pdf;"Helvetica";11];
  f:cell[pdf;f;40;"This report outlines the results for a ",ssr[string ptype;"_";" "]," problem achieved through running "];  
  f:cell[pdf;f;15;"kdb+/q AutoML. This run started on ",string[config`startDate]," at ",string[config`startTime],"."];

  font[pdf;"Helvetica-Bold";13];
  f:cell[pdf;f;30;"Description of Input Data"];

  font[pdf;"Helvetica";11];
  f:cell[pdf;f;30;"The following is a breakdown of information for each of the relevant columns in the dataset"];

  descripTab:value d:(dti:10&count descrip)#descrip:params`dataDescription;
  descripTab:.ml.df2tab .ml.tab2df[descripTab][`:round]3;
  t:enlist[enlist[`col],cols descripTab],key[d],'flip value flip descripTab;
  f:mktab[pdf;t;f;(27-(dti%2))*dti;10;10];

  f:image[pdf;imagePath,string plots`target;f;350;400;300];
  font[pdf;"Helvetica";10];
  f:cell[pdf;f;25;"Figure 1: This plot shows the distribution of target data."];

  font[pdf;"Helvetica-Bold";13];
  f:cell[pdf;f;30;"Breakdown of Pre-Processing"];

  font[pdf;"Helvetica";11];
  f:cell[pdf;f;30;string[config`featExtractType]," feature extraction and selection was performed",
    " with a total of ",string[count params`sigFeats]," features produced."];
  f:cell[pdf;f;30;"Feature extraction took ",string[params`creationTime]," time in total."];

  font[pdf;"Helvetica-Bold";13];
  f:cell[pdf;f;30;"Initial Scores"];

  font[pdf;"Helvetica";11];
  xvalFunc:string config[`xv]0;
  xvalSize:string 100*config[`xv]1;
  xvalType:`$last"."vs xvalFunc;
  xval:$[xvalType in`mcsplit`pcsplit;
    "Percentage based cross validation, ",xvalFunc,", was performed with a testing set created from ",xvalSize,"% of the training data.";
    xvalSize,"-fold cross validation was performed on the training set to find the best model using ",xvalFunc,"."
    ];

  f:cell[pdf;f;30;xval];
  f:image[pdf;imagePath,string plots`data;f;90;500;70];
  font[pdf;"Helvetica";10];
  f:cell[pdf;f;25;"Figure 2: This is representative image showing the data split into training, testing and holdout sets."];

  font[pdf;"Helvetica";11];
  f:cell[pdf;f;30;"The total time taken to carry out cross validation for each model on the training set was: "];
  f:cell[pdf;f;15;string[modelMeta`xValTime],"."];

  f:cell[pdf;f;30;"The metric that used for scoring and optimizing the models was: ",string[modelMeta`metric],"."];

  // Take in a kdb dictionary for printing line by line to the pdf file.
  dd:{(,'/)string(key x;count[x]#" ";count[x]#"=";count[x]#" ";value x)}modelMeta`modelScores;
  cntf:first[count dd]{[m;h;s]ff:cell[m;h[0];15;s[h[1]]];(ff;1+h[1])}[pdf;;dd]/(f-5;0);
  f:first cntf;

  f:image[pdf;imagePath,string plots`impact;f;350;400;300];
  font[pdf;"Helvetica";10];
  f:cell[pdf;f;25;"Figure 3: This is the feature impact for the most significant features as determined on the training set"];

  font[pdf;"Helvetica-Bold";13];
  f:cell[pdf;f;30;"Model selection summary"];

  font[pdf;"Helvetica";11];
  f:cell[pdf;f;30;"Best scoring model = ",string bestModel];
  f:cell[pdf;f;30;"The score on the holdout set for this model was = ",string[modelMeta`holdoutScore],"."];
  f:cell[pdf;f;30;"The total time taken to complete the running of this model on the holdout set was: ",string[modelMeta`holdoutTime],"."];

  hptyp:@[;0;upper]string srch:config`hp;
  hptyp:enlist[hptyp],$[srch=`grid;`gs;srch in`random`sobol;`rs];
  hpFunc:string[config hptyp 1]0;
  hpSize:string[config hptyp 1]1;
  hpMethod:`$last"."vs hpFunc;

  if[not bestModel in utils.excludeList;
    font[pdf;"Helvetica-Bold";13];
    hptitle:hptyp[0]," search for a ",string[bestModel]," model.";
    f:cell[pdf;f;30;hptyp[0]," search for a ",string[bestModel]," model."];
   
    font[pdf;"Helvetica";11];
    f:cell[pdf;f;30;]$[hpMethod in`mcsplit`pcsplit;
      "The hyperparameter search was completed using ",hpFunc," with a percentage of ",
        hpSize,"% of training data used for validation";
      "A ",hpSize,"-fold ",lower[hptyp 0]," search was performed on the training + testing",
        "set to find the best model using, ",hpFunc,"."
      ];
   
    font[pdf;"Helvetica";11];
    f:cell[pdf;f;30;"The following are the hyperparameters which have been deemed optimal for the model"];
   
    dhp:{(,'/)string(key x;count[x]#" ";count[x]#"=";count[x]#" ";value x)}params`hyperParams;
    cntf:first[count dhp]{[m;h;s]ff:cell[m;h[0];15;s[h[1]]];(ff;1+h[1])}[pdf;;dhp]/(f-5;0);
    f:first cntf
    ];
  
  f:cell[pdf;f;30;"The score for the best model fit on the entire training/testing set and scored on the holdout set was = ",string params`testScore];

  $[string[ptype]like"*class*";
    [f:image[pdf;imagePath,string plots`conf;f;350;350;350];
     font[pdf;"Helvetica";10];
     cell[pdf;f;25;"Figure 4: This is the confusion matrix produced for predictions made on the holdout set"]];
    [f:image[pdf;imagePath,string plots`rfr;f;350;350;350];
     font[pdf;"Helvetica";10];
     cell[pdf;f;25;"Figure 4: This is a regression analysis plot produced for predictions made on the holdout set"]];
    ];

  pdf[`:save][];
  }

// Utilities for the report generation functionality
/* m =   pdf gen module used
/* i =   how far below is the text
/* h =   the placement height from the bottom of the page 
/* f =   font size
/* s =   font size
/* txt = text to include
/* fp =  filepath
/* wi =  image width
/* hi =  image height
/* t  =  pandas table
font:{[m;f;s]m[`:setFont][f;s]}
cell:{[m;h;i;txt]if[(h-i)<100;h:795;m[`:showPage][]];
     m[`:drawString][30;h-:i;txt];h}
title:{[m;h;i;txt]if[(h-i)<100;h:795;m[`:showPage][]];
    m[`:drawString][150;h-:i;txt];h}
image:{[m;fp;h;i;wi;hi]if[(h-i)<100;h:795;m[`:showPage][]];
    m[`:drawImage][fp;40;h-:i;wi;hi];h}
mktab:{[m;t;h;i;wi;hi]if[(h-i)<100;h:795;m[`:showPage][]]
 t:table np[`:array][t][`:tolist][];
 t[`:wrapOn][m;wi;hi];
 t[`:drawOn][m;30;h-:i];h};
