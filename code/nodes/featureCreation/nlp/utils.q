\d .automl

// The functionality below pertains to the utility functions used within the NLP implementation

// @kind function
// @category featureCreationUtility
// @fileoverview Retrieves the word2vec items for sentences based on the model
// @param model    {<} model to be applied
// @param sentence {char} sentence to retrieve information from 
// @return {float[]} word2vec transformation for sentence
featureCreation.nlp.i.w2vItem:{[model;sentence]
  $[()~sentence;0;model[`:wv.__getitem__][sentence]`]
   }

// @kind function
// @category featureCreationUtility
// @fileoverview Count each expression within a single text
// @param text {str} textual data
// @return {dict} count of each expression found
featureCreation.nlp.i.regexCheck:{[text]
  count each .nlp.findRegex[text;featureCreation.nlp.i.regexList]}

// @kind function
// @category featureCreationUtility
// @fileoverview Retrieves the word2vec items for sentences based on the model
// @param  attrCheck {char[]} attributes to check 
// @param  attrAll   {char[]} all possible attributes 
// @return {dict} percentage of each attribute present in NLP
featureCreation.nlp.i.percentDict:{[attrCheck;attrAll]
  countAttr:count each attrCheck;
  attrDictAll:attrAll!count[attrAll]#0f;
  percentValue:`float$(countAttr)%sum countAttr;
  attrDictAll,percentValue
  }

// @kind function
// @category featureCreationUtility
// @fileoverview Generates column names based on a fixed list and multiple options
// @param  attr1 {char[]} 1st attribute of new column name
// @param  attr2 {char[]} 2nd attribute of new column name
// @return {char[]} new column names
featureCreation.nlp.i.colNaming:{[attr1;attr2]
  `${string[x],\:"_",string y}[attr1]each attr2
  }

// @kind function
// @category featureCreationUtility
// @fileoverview Rename columns with individual columns razed together
// @param  colNames {char[]} column name
// @param  feat     {tab[]} nlp features as a table 
// @return {char[]} renamed columns, with individual columns razed together
featureCreation.nlp.i.nameRaze:{[colNames;feat]
  (,'/){xcol[x;y]}'[colNames;feat]
  }

// @kind function
// @category featureCreationUtility
// @fileoverview Finds all names according to a regex search
// @param  col       {char[]} column names
// @param  attrCheck {char[]} attributes to check 
// @return {char[]} all names according to a regex search
featureCreation.nlp.i.colCheck:{[col;attrCheck]col where col like attrCheck}

// @kind list
// @category featureCreationUtility
// @fileoverview Expressions to search for within text
featureCreation.nlp.i.regexList:`specialChars`money`phoneNumber`emailAddress`url`zipCode`postalCode`day`month`year`time
