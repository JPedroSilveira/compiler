#ifndef ILOC_GENERATOR_HEADER
#define ILOC_GENERATOR_HEADER

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "types.h"
#include "print.h"
#include "lexical_value.h"
#include "errors.h"
#include "free.h"

int generateLabel();
int generateRegister(GlobalVariableList* globalVariableList);
IlocOperation generate_empty_operation();
IlocOperation generateNop();
IlocOperation generateFunctionNop(char* functioLabel);
IlocOperation generateFunctionCall(char* functioLabel);
IlocOperation generateUnaryOp(IlocOperationType type);
IlocOperation generateBinaryOpWithOneOut(IlocOperationType type, int op1, int op2, int out);
IlocOperation generateBinaryOpWithTwoOuts(IlocOperationType type, int op1, int op2, int out1, int out2);
IlocOperation generateUnaryOpWithOneOut(IlocOperationType type, int op, int out);
IlocOperation generateUnaryOpWithOneOutForGlobalVariable(IlocOperationType type, char* label, int out);
IlocOperation generateUnaryOpWithTwoOuts(IlocOperationType type, int op, int out1, int out2);
IlocOperation generateUnaryOpWithoutOut(IlocOperationType type, int op);
IlocOperation generateUnaryOpWithoutInput(IlocOperationType type, int out1);
IlocOperation addLabelToOperation(IlocOperation operation, int label);
void generateCode(IlocOperationList* operationList, int shouldOptimize);
void generateGlobalDeclarationCode(GlobalVariableList* globalVariableList);
IlocOperationList* createIlocList();
IlocOperationList* createIlocListFromOtherList(IlocOperationList* operationList);
void addOperationToIlocList(IlocOperationList* operationList, IlocOperation operation);
void addIlocListToIlocList(IlocOperationList* operationList, IlocOperationList* operationListToCopy);
IlocOperationList* unifyOperationLists(IlocOperationList* operationListOne, IlocOperationList* operationListTwo);
FunctionCallArgument* createFunctionCallArgument(int value);
FunctionCallArgument* addFunctionCallArgument(FunctionCallArgument* functionCallArgument, int value);
GlobalVariableList* createGlobalVariableList();
void addVariableToGlobalVariableList(GlobalVariableList* globalVariableList, LexicalValue lexicalValue, DataType dataType);
FunctionList* createEmptyFunctionList();
FunctionList* createFunctionList(LexicalValue lexicalValue, IlocOperationList* operationList);
void addFunctionToFunctionList(FunctionList* functionList, LexicalValue lexicalValue, IlocOperationList* operationList);
IlocOperationList* getFunctionCodeByLexicalValue(FunctionList* functionList, LexicalValue lexicalValue);

#endif