#include <stdio.h>
#include "free.h"
#include "generic_tree.h"
#include "symbol_table.h"
#include "iloc_generator.h"

extern int yyparse(void);

Node* tree;
SymbolTableStack* symbolTableStack;
GlobalVariableList* globalVariableList;
FunctionList* functionList;
int shouldOptimize;

void initOptions() {
  shouldOptimize = 0;
}

void checkOptions(int argc, char **argv) {
  initOptions();
  for (int i = 0; i < argc; ++i)
  {
    if (!strcmp(argv[i], "-O")) 
    {
        shouldOptimize = 1;
    }
  }
}

int main(int argc, char **argv)
{
  checkOptions(argc, argv);
  initGlobalSymbolStack();
  globalVariableList = createGlobalVariableList();
  functionList = createEmptyFunctionList();

  int ret = yyparse(); 
  if (tree != NULL) 
  {
    // exportTree(tree);
    generateGlobalDeclarationCode(globalVariableList);
    generateCode(tree->operationList, shouldOptimize);
  }
  freeGlobalVariables();
  return 0;
}