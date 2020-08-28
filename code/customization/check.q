\d .automl

// This file includes the logic for requirement checks and loading of optional
// functionality within the framework, namely dependancies for deep learning/nlp models etc.

// import checks and statements
i.loadkeras:{
  $[0~checkimport[0];
    [loadfile`:code/customization/models/libSupport/keras.q;
     loadfile`:code/customization/models/libSupport/keras.p
    ];
    [-1"Requirements for Keras models not satisfied. Keras and Tensorflow must be installed. Keras models will be excluded from model evaluation.";]
  ]
  }

i.loadtorch:{
  $[0~checkimport[1];
    [loadfile`:code/customization/models/libSupport/torch.q;
     loadfile`:code/customization/models/libSupport/torch.p
    ];
    [-1"Requirements for PyTorch models not satisfied. Torch must be installed. PyTorch models will be excluded from model evaluation.";]
  ]
  }
