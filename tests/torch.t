\l automl.q
\d .automl

loadfile`:init.q

if[0~checkimport[1];

  // check pytorch models if pytorch installed

  // Replace the defaults with an example containing torch
  og2tst:(("/code/models/lib_support/torch.q";"/code/models/lib_support/oldtorch.q");("/code/models/lib_support/torch.p";"/code/models/lib_support/oldtorch.p");("/code/models/models/classmodels.txt";"/code/models/models/oldclassmodels.txt");("/tests/files/torch.q";"/code/models/lib_support/");("/tests/files/torch.p";"/code/models/lib_support/");("/tests/files/classmodels.txt";"/code/models/models/classmodels.txt"));
  og2tst:{" "sv x,/:y}[path]each og2tst;
  system"c 1000 1000";
  $[w:"w"=string[.z.o]0;{system"move ",ssr[x;"/";"\\"]};{system"mv ",x}]each og2tst;

  // Run tests to ensure nothing is failing when running with only a pytorch model

  tgt_f  :asc 100?1f;
  tgt_b  :100?0b;
  tgt_mul:100?3;
  normtab1:([]100?1f;100?0b;asc 100?`1;100?100);

  $[(::)~@[{.automl.run[x;tgt_f  ;`normal;`reg  ;::];};normtab1;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_b  ;`normal;`class;::];};normtab1;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_mul;`normal;`class;::];};normtab1;{[err]err;0b}];1b;0b];
  
  normtab2:([]100?0Ng;100?1f;asc 100?1000;100?`1);

  $[(::)~@[{.automl.run[x;tgt_f  ;`normal;`reg  ;::];};normtab2;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_b  ;`normal;`class;::];};normtab2;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_mul;`normal;`class;::];};normtab2;{[err]err;0b}];1b;0b];
  
  freshtab1:([]5000?100?0p;asc 5000?100?1f;5000?1f;desc 5000?10f;5000?0b);

  $[(::)~@[{.automl.run[x;tgt_f  ;`fresh;`reg  ;::];};freshtab1;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_b  ;`fresh;`class;::];};freshtab1;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_mul;`fresh;`class;::];};freshtab1;{[err]err;0b}];1b;0b];
  
  freshtab2:([]5000?100?0p;5000?0Ng;desc 5000?1f;asc 5000?1f;5000?`1);

  $[(::)~@[{.automl.run[x;tgt_f  ;`fresh;`reg  ;::];};freshtab2;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_b  ;`fresh;`class;::];};freshtab2;{[err]err;0b}];1b;0b];
  $[(::)~@[{.automl.run[x;tgt_mul;`fresh;`class;::];};freshtab2;{[err]err;0b}];1b;0b];

  // Revert to the default torch setup
  tst2og:(("/code/models/lib_support/torch.q";"/tests/files/");("/code/models/lib_support/torch.p";"/tests/files/");("/code/models/models/classmodels.txt";"/tests/files/");("/code/models/lib_support/oldtorch.q";"/code/models/lib_support/torch.q");("/code/models/lib_support/oldtorch.p";"/code/models/lib_support/torch.p");("/code/models/models/oldclassmodels.txt";"/code/models/models/classmodels.txt"));
  tst2og:{" "sv x,/:y}[path]each tst2og;
  $[w;{system"move ",ssr[x;"/";"\\"]};{system"mv ",x}]each tst2og;
  ]