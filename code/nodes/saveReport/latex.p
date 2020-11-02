import pylatex as pl
from pylatex import Document, Section, Subsection, Command, Figure, NewPage, Center
from pylatex.utils import italic, NoEscape

#  Add a table to the document
## doc   = document to which the table is to be added
## tab   = Pandas dataframe
## ncols = list of c's indicating number of columns in the table i.e 'cccc' is 4 columns

def createTable(doc,tab,ncols):
  with doc.create(Center()) as centered:
    with centered.create(pl.Tabular(ncols)) as table:
      table.add_hline()
      table.add_row(list(tab.columns))
      table.add_hline()
      for row in tab.index:
        table.add_row(list(tab.loc[row,:]))
      table.add_hline()


#  Add an image to the document
## doc     = document to which the image is to be added
## img     = location of the image being added
## caption = caption to be displayed under to image

def createImage(doc,img,caption):
  with doc.create(Figure(position='h!')) as images:
     images.add_image(img,width = NoEscape(r'0.65\textwidth'))
     images.add_caption(caption)


# Main report generation function
## dict    = extensive configDictonary containing required information
## paths   = configDictonary containing the paths to images and where the report is to be generated
## dscrb   = pandas dataframe describing the 'main' table
## score   = pandas dataframe containing the scores achieved in cross validation
## grid    = pandas dataframe containing 'where required' the hyperparameters
## exclude = list of methods (NN/deterministic) on which a hyperparameter search is not applied 

def python_latex(dict,paths,dscrb,score,grid,exclude):
  configDict = dict['config']
  metaDict =dict['modelMetaData']
  ptype = configDict['problemType']
  filepath = paths['fpath']

  geometry_options = {"margin": "2.5cm"}
  doc = Document(filepath, geometry_options=geometry_options)
  doc.preamble.append(Command('title', 'kdb+/q Automated Machine Learning - Generated Report'))
  doc.preamble.append(Command('author', 'KxSystems'))
  doc.preamble.append(Command('date', 'Date: ' + configDict['startDate']))
  doc.append(NoEscape(r'\maketitle'))
  with doc.create(Section('Introduction')):
    doc.append('This report outlines the results achieved through the running ') 
    doc.append('of the kdb+/q automated machine learning framework.\n')
    doc.append('This run started on ' + configDict['startDate'] + ' at ' + configDict['startTime'])
  
  with doc.create(Section('Description of input data')):
    doc.append('The following is a breakdown of information for a number of the relevant columns in the dataset\n\n')
    createTable(doc,dscrb,'cccccccc')

    createImage(doc,''.join(paths['target']),'This plot shows the distribution of target data.')
  
  with doc.create(Section('Pre-processing Breakdown')):
    doc.append(configDict['featExtractType'] + ' feature extraction was performed with a total of ' + str(len(dict['sigFeats'])) + ' features produced\n')
    doc.append('Feature extraction took a total time of ' +dict['creationTime'] + '.\n')
 
  with doc.create(Section('Initial Scores')):
    # Check how cross validation was completed and tailor output appropriately
    if(configDict['xv'][0] in ['.ml.xv.mcsplit','.ml.xv.pcsplit']):
      doc.append('Cross validation was completed using ' + configDict['xv'][0] + ' with a split of ' + configDict['xv'][1] + ' of training data used for validation.\n')
    else:
      doc.append(configDict['xv'][1] + '-fold cross validation was performed on the training set using ' + configDict['xv'][0] + '.\n')
    createImage(doc,''.join(paths['data']),'This image shows a general representation of how the data is split into training, testing and validation sets')
    doc.append('The total time that was required to complete selection of the best model based on the training set was ' + metaDict['xValTime'])
    doc.append('\n\nThe metric that is being used for scoring and optimizing the models was ' + metaDict['metric'] + '\n\n')
    doc.append('The following table outlines the scores achieved for each of the models tested \n')
    createTable(doc,score,'cc')
    createImage(doc,''.join(paths['impact']),'This is the feature impact for a number of the most significant features as determined on the training set')
  
  with doc.create(Section('Model selection summary')):
    doc.append('Best scoring model = ' + dict['modelName'] + '\n\n')
    doc.append('The score on the validation set for this model was = ' + configDict['hld'] + '\n\n')
    doc.append('The total time to complete the running of this model on the validation set was: ' + metaDict['xValTime'])
  
  # Check for hyperparameter search type
  typ_upper = ''
  typ_lower = ''
  typ_key = ''
  if configDict['hp']=='sobol':
      typ_upper = 'Sobol'
      typ_key = 'rs'
  elif configDict['hp']=='random':
      typ_upper = 'Random'
      typ_key = 'rs'
  else:
      typ_upper = 'Grid'
      typ_key = 'gs'
    
  # If appropriate return the output from a completed hyperparameter search
  if(not dict['modelName'] in exclude):
    with doc.create(Section(typ_upper + ' search for a ' + dict['modelName'] + ' model.')):
      if(configDict[typ_key][0] in ['.ml.gs.mcsplit','.ml.gs.pcsplit']):
        doc.append('The ' + configDict['hp'] + ' search was completed using ' + configDict[typ_key][0] + ' with a split of ' + configDict[typ_key][1] + ' of training data used for validation.\n')
      else:
        doc.append('A ' + configDict[typ_key][1] + '-fold ' + configDict['hp'] + ' search was performed on the training set to find the best model using ' + configDict[typ_key][0] + '.\n')
      doc.append('The following are the hyper parameters which have been deemed optimal for the model.\n')
      createTable(doc,grid,'cc')
      doc.append('The score for the best model fit on the entire training set and scored on the testing set was = ' + dict['testScore'])
  
  # If the problem is classification then display the appropriate confusion matrix
  if(ptype=="class"):
    with doc.create(Section('Classification summary')):
      doc.append('The following displays the performance of the classification model on the testing set\n\n')
      createImage(doc,''.join(paths['conf']),'This is a confusion matrix produced for preconfigDictons made on the testing set')
  else:
    with doc.create(Section('Regression summary')):
      doc.append('The following displays the performance of the regression model on the testing set\n\n')
      createImage(doc,''.join(paths['rfr']),'This is a confusion matrix produced for preconfigDictons made on the testing set')

  # Generate the pdf using the pdflatex compiler (this compiler flag may change depending on final choice of install instructions)
  doc.generate_pdf(clean_tex=False, compiler='pdflatex')
