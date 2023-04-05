#include <stdio.h>
#include "free.h"
#include "generic_tree.h"
#include "symbol_table.h"
#include "iloc_generator.h"

extern int yyparse(void);

Node* tree;
SymbolTableStack* symbolTableStack;
GlobalVariableList* globalVariableList;

int main (int argc, char **argv)
{
  initGlobalSymbolStack();
  globalVariableList = createGlobalVariableList();

  int ret = yyparse(); 
  if (tree != NULL) 
  {
    // exportTree(tree);
    generateGlobalDeclarationCode(globalVariableList);
    generateCode(tree->operationList);
  }
  freeGlobalVariables();
  return 0;
}