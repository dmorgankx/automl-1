\d .automl

// Generate the complete graph following the definition of configuration information
// as displayed in `graph/Automl_graph.png`, code is structured through the addition
// of all relevant nodes followed by the connection of input nodes for these nodes to
// the relevant source node.

// Generate an empty graph
graph:.ml.createGraph[]

// Populate all required Nodes for the graph
graph:.ml.addNode[graph;`configuration      ;configuration.node]
graph:.ml.addNode[graph;`featureData        ;featureData.node]
graph:.ml.addNode[graph;`targetData         ;targetData.node]
graph:.ml.addNode[graph;`dataCheck          ;dataCheck.node]
graph:.ml.addNode[graph;`modelGeneration    ;modelGeneration.node]
graph:.ml.addNode[graph;`featureModification;featureModification.node]
graph:.ml.addNode[graph;`labelEncode        ;labelEncode.node]
graph:.ml.addNode[graph;`dataPreprocessing  ;dataPreprocessing.node]
graph:.ml.addNode[graph;`featureCreation    ;featureCreation.node]
graph:.ml.addNode[graph;`featureSignificance;featureSignificance.node]
graph:.ml.addNode[graph;`trainTestSplit     ;trainTestSplit.node]
graph:.ml.addNode[graph;`selectModels       ;selectModels.node]
graph:.ml.addNode[graph;`runModels          ;runModels.node]
graph:.ml.addNode[graph;`optimizeModels     ;optimizeModels.node]
graph:.ml.addNode[graph;`preprocParams      ;preprocParams.node]
graph:.ml.addNode[graph;`predictParams      ;predictParams.node]
graph:.ml.addNode[graph;`paramConsolidate   ;paramConsolidate.node]
graph:.ml.addNode[graph;`saveGraph          ;saveGraph.node]
graph:.ml.addNode[graph;`saveMeta           ;saveMeta.node]
graph:.ml.addNode[graph;`saveReport         ;saveReport.node]


// Connect all possible edges prior to the data/config ingestion

// Data_Check
graph:.ml.connectEdge[graph;`configuration;`output;`dataCheck;`config];
graph:.ml.connectEdge[graph;`featureData ;`output;`dataCheck;`features];
graph:.ml.connectEdge[graph;`targetData  ;`output;`dataCheck;`target];

// Model_Generation
graph:.ml.connectEdge[graph;`dataCheck;`config;`modelGeneration;`config]
graph:.ml.connectEdge[graph;`dataCheck;`target;`modelGeneration;`target]

// Feature_Modification
graph:.ml.connectEdge[graph;`dataCheck;`config  ;`featureModification;`config]
graph:.ml.connectEdge[graph;`dataCheck;`features;`featureModification;`features]

// Label_Encode
graph:.ml.connectEdge[graph;`dataCheck;`target;`labelEncode;`input]

// Data_Preprocessing
graph:.ml.connectEdge[graph;`dataCheck          ;`config  ;`dataPreprocessing;`config]
graph:.ml.connectEdge[graph;`featureModification;`features;`dataPreprocessing;`features]
graph:.ml.connectEdge[graph;`labelEncode        ;`output  ;`dataPreprocessing;`target]

// Feature_Creation
graph:.ml.connectEdge[graph;`dataPreprocessing;`features;`featureCreation;`features]
graph:.ml.connectEdge[graph;`dataCheck        ;`config  ;`featureCreation;`config]

// Feature_Significance
graph:.ml.connectEdge[graph;`featureCreation;`features;`featureSignificance;`features]
graph:.ml.connectEdge[graph;`labelEncode    ;`output  ;`featureSignificance;`target]
graph:.ml.connectEdge[graph;`dataCheck      ;`config  ;`featureSignificance;`config]

// Train_Test_Split
graph:.ml.connectEdge[graph;`featureSignificance;`features;`trainTestSplit;`features]
graph:.ml.connectEdge[graph;`featureSignificance;`sigFeats;`trainTestSplit;`sigFeats]
graph:.ml.connectEdge[graph;`labelEncode        ;`output  ;`trainTestSplit;`target]
graph:.ml.connectEdge[graph;`dataCheck          ;`config  ;`trainTestSplit;`config]

// Select_Models
graph:.ml.connectEdge[graph;`dataCheck      ;`config;`selectModels;`config]
graph:.ml.connectEdge[graph;`trainTestSplit ;`output;`selectModels;`ttsObject]
graph:.ml.connectEdge[graph;`modelGeneration;`output;`selectModels;`models]

// Run_Models
graph:.ml.connectEdge[graph;`selectModels;`ttsObject;`runModels;`ttsObject]
graph:.ml.connectEdge[graph;`selectModels;`models ;`runModels;`models]
graph:.ml.connectEdge[graph;`dataCheck   ;`config ;`runModels;`config]

// Optimize_Models
graph:.ml.connectEdge[graph;`runModels   ;`bestModel      ;`optimizeModels;`bestModel]
graph:.ml.connectEdge[graph;`runModels   ;`bestScoringName;`optimizeModels;`bestScoringName]
graph:.ml.connectEdge[graph;`selectModels;`models         ;`optimizeModels;`models]
graph:.ml.connectEdge[graph;`selectModels;`ttsObject      ;`optimizeModels;`ttsObject]
graph:.ml.connectEdge[graph;`dataCheck   ;`config         ;`optimizeModels;`config]


// Preproc_Params
graph:.ml.connectEdge[graph;`dataCheck          ;`config         ;`preprocParams;`config]
graph:.ml.connectEdge[graph;`dataPreprocessing  ;`dataDescription;`preprocParams;`dataDescription]
graph:.ml.connectEdge[graph;`featureCreation    ;`creationTime   ;`preprocParams;`creationTime]
graph:.ml.connectEdge[graph;`featureSignificance;`sigFeats       ;`preprocParams;`sigFeats]
graph:.ml.connectEdge[graph;`featureModification;`symEncode      ;`preprocParams;`symEncode]

// Predict_Params
graph:.ml.connectEdge[graph;`optimizeModels;`bestModel  ;`predictParams;`bestModel]
graph:.ml.connectEdge[graph;`optimizeModels;`testScore  ;`predictParams;`testScore]
graph:.ml.connectEdge[graph;`optimizeModels;`predictions;`predictParams;`predictions]

// Param_Consolidate
graph:.ml.connectEdge[graph;`predictParams;`output;`paramConsolidate;`predictionStore]
graph:.ml.connectEdge[graph;`preprocParams;`output;`paramConsolidate;`preprocParams]

// Save_Graph
graph:.ml.connectEdge[graph;`paramConsolidate;`output;`saveGraph;`input]

// Save_Meta
graph:.ml.connectEdge[graph;`paramConsolidate;`output;`saveMeta;`input]

// Save_Report
graph:.ml.connectEdge[graph;`paramConsolidate;`output;`saveReport;`input]

