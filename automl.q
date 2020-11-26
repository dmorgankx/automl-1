// Fix for windows argv matplotlib conflict
\l p.q

\d .automl
version:@[{AUTOMLVERSION};`;`development]
path:{string`automl^`$@[{"/"sv -1_"/"vs ssr[;"\\";"/"](-3#get .z.s)0};`;""]}`
loadfile:{$[.z.q;;-1]"Loading ",x:_[":"=x 0]x:$[10=type x;;string]x;system"l ",path,"/",x;}

// Retrieve command line parameters
commandLineInput:first each .Q.opt .z.x

if[all `config`run in lower key commandLineInput;
  loadfile`:init.q;
  .ml.updDebug[];
  runCommandLine[];
  exit 0]

