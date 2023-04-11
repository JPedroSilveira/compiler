#include "iloc_generator.h"

int generateLabel()
{
  static int label_counter = 1;
  return label_counter++;
}

int generateRegister(GlobalVariableList* globalVariableList)
{
  static int register_counter = 1;
  int new_register = register_counter++;
  // Working only with integers
  LexicalValue lexicalValue = createLexicalValueFromTemporary(new_register);
  addVariableToGlobalVariableList(globalVariableList, lexicalValue, DATA_TYPE_INT);
  return new_register;
}

IlocOperation generate_empty_operation() 
{
    IlocOperation operation;
    operation.label = -1;
    operation.functionLabel = NULL;
    operation.globalVariable = NULL;
    operation.rspSub = 0;
    operation.op1 = -1;
    operation.op2 = -1;
    operation.out1 = -1;
    operation.out2 = -1;
    operation.type = -1;
    operation.isMain = 0;
    operation.isFunction = 0;
    return operation;
}

IlocOperation generateInvalid()
{
    IlocOperation operation = generate_empty_operation();
    operation.type = OP_INVALID;
    return operation;
}

IlocOperation generateNop()
{
    IlocOperation operation = generate_empty_operation();
    operation.type = OP_NOP;
    return operation;
}

IlocOperation generateFunctionNop(char* functioLabel)
{
    IlocOperation operation = generate_empty_operation();
    operation.type = OP_NOP;
    operation.isFunction = 1;
    operation.functionLabel = malloc(strlen(functioLabel) + 1);
    strcpy(operation.functionLabel, functioLabel);

    if (strncmp(operation.functionLabel, "main", 4) == 0) {
        operation.isMain = 1;
    }  

    return operation;
}

IlocOperation generateFunctionCall(char* functioLabel)
{
    IlocOperation operation = generate_empty_operation();
    operation.type = OP_CALL;
    operation.functionLabel = malloc(strlen(functioLabel) + 1);
    strcpy(operation.functionLabel, functioLabel);
    return operation;
}

IlocOperation generateUnaryOp(IlocOperationType type) 
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    return operation;
}

IlocOperation generateBinaryOpWithOneOut(IlocOperationType type, int op1, int op2, int out) 
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.op1 = op1;
    operation.op2 = op2;
    operation.out1 = out;
    return operation;
}

IlocOperation generateBinaryOpWithTwoOuts(IlocOperationType type, int op1, int op2, int out1, int out2) 
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.op1 = op1;
    operation.op2 = op2;
    operation.out1 = out1;
    operation.out2 = out2;
    return operation;
}

IlocOperation generateUnaryOpWithOneOut(IlocOperationType type, int op, int out) 
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.op1 = op;
    operation.out1 = out;
    return operation;
}

IlocOperation generateUnaryOpWithOneOutForGlobalVariable(IlocOperationType type, char* label, int out)
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.globalVariable = malloc(strlen(label) + 1);
    strcpy(operation.globalVariable, label);
    operation.out1 = out;
    return operation;
}



IlocOperation generateUnaryOpWithTwoOuts(IlocOperationType type, int op, int out1, int out2) 
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.op1 = op;
    operation.out1 = out1;
    operation.out2 = out2;
    return operation;
}

IlocOperation generateUnaryOpWithoutOut(IlocOperationType type, int op)
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.op1 = op;
    return operation;
}

IlocOperation generateUnaryOpWithoutInput(IlocOperationType type, int out1)
{
    IlocOperation operation = generate_empty_operation();
    operation.type = type;
    operation.out1 = out1;
    return operation;
}

IlocOperation addLabelToOperation(IlocOperation operation, int label)
{
    operation.label = label;   
    return operation;
}

// Only supports functions with 6 arguments
char* getArgumentRegister(int argumentNumber)
{
    switch (argumentNumber)
    {
        case 1:
            return "%edi";
        case 2:
            return "%esi";
        case 3:
            return "%edx";
        case 4:
            return "%ecx";
        case 5:
            return "%r8d";
        case 6:
            return "%r9d";
        default:
            return "%edi";
    }
}

void convertOperationWithLabel(IlocOperation operation) 
{
    if (operation.isMain) 
    {
        printf("    .text \n");
        printf("    .globl _main \n");
        printf("_main: \n");
    } 
    else if (operation.isFunction)
    {
        printf("    .text \n");
        printf("    .globl _%s \n", operation.functionLabel);
        printf("_%s: \n", operation.functionLabel);
    } 
    else 
    {
        printf("L%d: \n", operation.label);
    }

    if (operation.isFunction)
    {
        printf("    pushq   %s \n", "%rbp");
        printf("    movq    %s \n", "%rsp, %rbp");
        printf("    subq    $%d, %s \n", operation.rspSub, "%rsp");
    }
}

void convertOperationToCode(IlocOperation operation) 
{
    if (operation.type != OP_INVALID && operation.label != -1) {
        convertOperationWithLabel(operation);
    }
    switch (operation.type)
    {  
        case OP_LOADAI_GLOBAL:
            printf("    movl    _%s(%s), %s \n", operation.globalVariable, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_LOADAI_LOCAL:
            printf("    movl    -%d(%s), %s \n", operation.op1, "%rbp", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_LOADI:
            printf("    movl    $%d, _temp_r_%d(%s) \n", operation.op1, operation.out1, "%rip");
            break;
        case OP_STOREAI_GLOBAL:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.out1, "%rip", "%eax");
            printf("    movl    %s, _%s(%s) \n", "%eax", operation.globalVariable, "%rip");
            break;
        case OP_STOREAI_LOCAL:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    movl    %s, -%d(%s) \n", "%eax", operation.out1, "%rbp");
            break;
        case OP_LOAD_FUNCTION_RETURN:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            break;
        case OP_RETURN:
            printf("    leave \n");
            printf("    ret \n");             
            break;
        case OP_ADD:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%edx");
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    addl    %s, %s \n",  "%edx", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_SUB:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    subl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_MULT:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    imull   _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_DIV:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cltd \n");
            printf("    idivl	_temp_r_%d(%s) \n", operation.op2, "%rip");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_NEG:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    negl	%s \n", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_CMP_GE:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    jle     L%d \n", operation.out1);
            break;
        case OP_JUMPI:
            printf("    jmp     L%d \n", operation.op1);
            break;
        case OP_CMP_NE:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    je      L%d \n", operation.out1);
            break;
        case OP_CMP_LE:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    jg      L%d \n", operation.out1);
            break;
        case OP_CMP_LT:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    jge     L%d \n", operation.out1);
            break;
        case OP_CMP_GT:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    jle     L%d \n", operation.out1);
            break;
        case OP_CMP_EQ:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    cmpl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    jne     L%d \n", operation.out1);            
            break;
        case OP_AND:
            printf("    cmpl   $0, _temp_r_%d(%s) \n", operation.op1, "%rip");
            printf("    je     L%d \n", operation.out1);    
            printf("    cmpl   $0, _temp_r_%d(%s) \n", operation.op2, "%rip");
            printf("    je     L%d \n", operation.out1);   
            break;
        case OP_OR:
            printf("    cmpl   $0, _temp_r_%d(%s) \n", operation.op1, "%rip");
            printf("    jne     L%d \n", operation.out1);    
            printf("    cmpl   $0, _temp_r_%d(%s) \n", operation.op2, "%rip");
            printf("    je     L%d \n", operation.out2);
            break;
        case OP_ERASE_RETURN:
            printf("    movl	$0, %s \n", "%eax");
            break;
        case OP_CALL:
            printf("    call	_%s \n", operation.functionLabel);
            break;
        case OP_READ_RETURN:
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_ADD_ARG_TO_CALL:
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", getArgumentRegister(operation.out1));
            break;
        case OP_READ_ARG_FROM_CALL:
            printf("    movl    %s, -%d(%s) \n", getArgumentRegister(operation.op1), operation.out1, "%rbp");
            break;
        default:
            break;
    }
}

void generateCode(IlocOperationList* operationList) 
{
    IlocOperationList* nextOperation = operationList;

    while(nextOperation != NULL)
    {
        IlocOperation operation = nextOperation->operation;
        convertOperationToCode(operation);
        nextOperation = nextOperation->nextItem;
    }
}

void generateGlobalDeclarationCodeForInteger(GlobalVariableList* globalVariableList)
{
    LexicalValue lexicalValue = globalVariableList->lexicalValue;
    printf("    .text \n");
    if (lexicalValue.type == TOKEN_TYPE_TEMPORARY) 
    {
        printf("    .globl _temp_r_%d \n", lexicalValue.lineNumber);
        printf("    .data \n");
        printf("_temp_r_%d: \n", lexicalValue.lineNumber);
    }
    else 
    {
        printf("    .globl _%s \n", lexicalValue.label);
        printf("    .data \n");
        printf("_%s: \n", lexicalValue.label);
    }
    printf("    .int   4 \n");
}

void generateGlobalDeclarationCodeForFunction(GlobalVariableList* globalVariableList)
{
    LexicalValue lexicalValue = globalVariableList->lexicalValue;
    printf("    .text \n");
    printf("    .globl _%s \n", lexicalValue.label);
}


void generateGlobalDeclarationCode(GlobalVariableList* globalVariableList)
{
    GlobalVariableList* currentGlobalVariable = globalVariableList;
    while(currentGlobalVariable->dataType != DATA_TYPE_NON_DECLARED) 
    {
        if (currentGlobalVariable->dataType == DATA_TYPE_INT) 
        {
            generateGlobalDeclarationCodeForInteger(currentGlobalVariable);
        } 
        else if (currentGlobalVariable->dataType == DATA_TYPE_FUNCTION) 
        {
            // generateGlobalDeclarationCodeForFunction(currentGlobalVariable);
        }
        currentGlobalVariable = currentGlobalVariable->nextItem;
    }
}

IlocOperationList* createIlocList()
{
    IlocOperationList* list = malloc(sizeof(IlocOperationList));
    if (!list) 
    {
        printError("[IlocOperationList] Fail to create ILOC operations list!");
        return NULL;
    }
    list->operation = generateInvalid();
    list->nextItem = NULL;
    return list;
}

IlocOperationList* createIlocListFromOtherList(IlocOperationList* operationList)
{
    IlocOperationList* newOperationList = createIlocList();
    if (!newOperationList) 
    {
        printError("[IlocOperationList] Fail to create ILOC operations list!");
        return NULL;
    }
    IlocOperationList* operationToCopy = operationList;
    while(operationToCopy != NULL)
    {
        addOperationToIlocList(newOperationList, operationToCopy->operation);
        operationToCopy = operationToCopy->nextItem;
    }
    return newOperationList;
}

void addOperationToIlocList(IlocOperationList* operationList, IlocOperation operation)
{
    if (operationList == NULL)
    {
        printError("[IlocOperationList] Fail to add operation on null list!");
        return;
    }
    
    IlocOperationList* lastOperation = operationList;
    while(lastOperation->nextItem != NULL)
    {
        lastOperation = lastOperation->nextItem;
    }

    IlocOperationList* newOperation = createIlocList();
    newOperation->operation = operation;

    lastOperation->nextItem = newOperation;
}

void addIlocListToIlocList(IlocOperationList* operationList, IlocOperationList* operationListToCopy)
{
    IlocOperationList* operationToCopy = operationListToCopy;
    while(operationToCopy != NULL)
    {
        addOperationToIlocList(operationList, operationToCopy->operation);
        operationToCopy = operationToCopy->nextItem;
    }
}

IlocOperationList* unifyOperationLists(IlocOperationList* operationListOne, IlocOperationList* operationListTwo)
{
    if (operationListOne == NULL)
    {
        printError("[IlocOperationList] First list was null while unifying!");
        return NULL;
    }
    if (operationListTwo == NULL)
    {
        printError("[IlocOperationList] Second list was null while unifying!");
        return NULL;
    }

    IlocOperationList* newOperationList = createIlocList();

    IlocOperationList* operationToCopy = operationListOne;
    while(operationToCopy != NULL)
    {
        addOperationToIlocList(newOperationList, operationToCopy->operation);
        operationToCopy = operationToCopy->nextItem;
    }

    operationToCopy = operationListTwo;
    while(operationToCopy != NULL)
    {
        addOperationToIlocList(newOperationList, operationToCopy->operation);
        operationToCopy = operationToCopy->nextItem;
    }

    return newOperationList;
}

FunctionCallArgument* createFunctionCallArgument(int value)
{
    FunctionCallArgument* functionCallArgument = malloc(sizeof(FunctionCallArgument));
    if (!functionCallArgument) 
    {
        printf("Fail to create function call argument.");
    }
    functionCallArgument->value = value;

    return functionCallArgument;
}

FunctionCallArgument* addFunctionCallArgument(FunctionCallArgument* functionCallArgument, int value)
{
    FunctionCallArgument* newFunctionCallArgument = createFunctionCallArgument(value);
    newFunctionCallArgument->nextArgument = functionCallArgument;
    return newFunctionCallArgument;
}

GlobalVariableList* createGlobalVariableList()
{
    GlobalVariableList* list = malloc(sizeof(GlobalVariableList));
    if (!list) 
    {
        printError("[GlobalVariableList] Fail to create global variable list!");
        return NULL;
    }
    list->dataType = DATA_TYPE_NON_DECLARED;
    list->nextItem = NULL;
    return list;
}

void addVariableToGlobalVariableList(GlobalVariableList* globalVariableList, LexicalValue lexicalValue, DataType dataType)
{
    if (globalVariableList == NULL)
    {
        printError("[GlobalVariableList] Fail to add item to global variable list!");
        return;
    }
    
    GlobalVariableList* lastGlobalVariable = globalVariableList;
    while(lastGlobalVariable->dataType != DATA_TYPE_NON_DECLARED)
    {
        lastGlobalVariable = lastGlobalVariable->nextItem;
    }

    GlobalVariableList* newGlobalVariable = createGlobalVariableList();
    lastGlobalVariable->lexicalValue = lexicalValue;
    lastGlobalVariable->dataType = dataType;
    lastGlobalVariable->nextItem = newGlobalVariable;
}