%{
#include <stdio.h>
#include <stdlib.h>
#include "types.h"
#include "data_type.h"
#include "generic_tree.h"
#include "lexical_value.h"
#include "symbol_table.h"
#include "iloc_generator.h"
#include "print.h"

DataType declaredType = DATA_TYPE_NON_DECLARED;

int yylex(void);
void yyerror (char const *message);
int get_line_number();
extern Node* tree;
extern SymbolTableStack* symbolTableStack;
extern GlobalVariableList* globalVariableList;
extern FunctionList* functionList;
extern int shouldOptimize;
%}

%code requires {
    #include "generic_tree.h"
    #include "lexical_value.h"
    #include "symbol_table.h"
}

%union {
    LexicalValue LexicalValue;
    Dimension Dimension;
    DataType DataType;
    struct Node* Node;
    struct FunctionArgument* FunctionArgument;
    struct FunctionCallArgument* FunctionCallArgument;
}

%define parse.error verbose

%token<LexicalValue> TK_PR_INT
%token<LexicalValue> TK_PR_FLOAT
%token<LexicalValue> TK_PR_BOOL
%token<LexicalValue> TK_PR_CHAR
%token<LexicalValue> TK_PR_IF
%token<LexicalValue> TK_PR_THEN
%token<LexicalValue> TK_PR_ELSE
%token<LexicalValue> TK_PR_WHILE
%token<LexicalValue> TK_PR_INPUT
%token<LexicalValue> TK_PR_OUTPUT
%token<LexicalValue> TK_PR_RETURN
%token<LexicalValue> TK_PR_FOR
%token<LexicalValue> TK_OC_LE
%token<LexicalValue> TK_OC_GE
%token<LexicalValue> TK_OC_EQ
%token<LexicalValue> TK_OC_NE
%token<LexicalValue> TK_OC_AND
%token<LexicalValue> TK_OC_OR
%token<LexicalValue> TK_LIT_INT
%token<LexicalValue> TK_LIT_FLOAT
%token<LexicalValue> TK_LIT_FALSE
%token<LexicalValue> TK_LIT_TRUE
%token<LexicalValue> TK_LIT_CHAR
%token<LexicalValue> TK_IDENTIFICADOR
%token<LexicalValue> ',' ';' ':' '(' ')' '{' '}' '|' '-' '+' '%' '^' '!' '<' '>' '=' '*' '/' '[' ']' 
%token TK_ERRO

%type<Node> program
%type<Node> elements_list
%type<DataType> type
%type<Node> literal
%type<Node> global_declaration
%type<Node> var_list
%type<Node> array
%type<Dimension> dimension
%type<Node> function
%type<Node> header
%type<LexicalValue> function_name
%type<Node> body
%type<FunctionArgument> arguments
%type<FunctionArgument> arg_list
%type<Node> command_block
%type<Node> simple_command_list
%type<Node> simple_command
%type<Node> var_declaration
%type<Node> var_decl_list
%type<Node> attribution
%type<Node> attr_array
%type<Node> function_call
%type<FunctionCallArgument> arg_fn_list
%type<Node> return_command
%type<Node> flow_control_commands
%type<Node> start_flow_control_block
%type<Node> flow_control_else
%type<Node> expression
%type<Node> expression_grade_eight
%type<Node> expression_grade_seven
%type<Node> expression_grade_six
%type<Node> expression_grade_five
%type<Node> expression_grade_four
%type<Node> expression_grade_three
%type<Node> expression_grade_two
%type<Node> expression_grade_one
%type<Node> expression_list

%start program

%%
program:  { 
    $$ = NULL; 
    tree = NULL;
};

program: elements_list { 
    $$ = $1; 
    tree = $$;

    IlocOperationList* operationList = createIlocList();

    addIlocListToIlocList(operationList, $$->operationList);

    $$->operationList = operationList;
};

elements_list: function elements_list { 
    $$ = $1;
    addChild($$, $2);
    addIlocListToIlocList($$->operationList, $2->operationList);
};

elements_list: global_declaration elements_list {
    $$ = $2;
};

elements_list: function { 
    $$ = $1;
};

elements_list: global_declaration { 
    $$ = NULL;
};


// =======================
// =        Tipos        =
// =======================
type: TK_PR_INT {
    $$ = DATA_TYPE_INT; 
    freeLexicalValue($1);
    declaredType = DATA_TYPE_INT;
};

type: TK_PR_FLOAT { 
    $$ = DATA_TYPE_FLOAT; 
    freeLexicalValue($1);
    declaredType = DATA_TYPE_FLOAT;
};

type: TK_PR_BOOL { 
    $$ = DATA_TYPE_BOOL; 
    freeLexicalValue($1);
    declaredType = DATA_TYPE_BOOL;
};

type: TK_PR_CHAR { 
    $$ = DATA_TYPE_CHAR; 
    freeLexicalValue($1);
    declaredType = DATA_TYPE_CHAR;
};


// =======================
// =      Literais       =
// =======================
literal: TK_LIT_INT { 
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_LITERAL, $1, DATA_TYPE_INT);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeFromSymbol($1, symbol);

    IlocOperationList* operationList = createIlocList();

    int c1 = $1.value.value_int;
    int r1 = generateRegister(globalVariableList);

    IlocOperation operation = generateUnaryOpWithOneOut(OP_LOADI, c1, r1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r1;
    $$->operationList = operationList;
};

literal: TK_LIT_FLOAT {     
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_LITERAL, $1, DATA_TYPE_FLOAT);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeFromSymbol($1, symbol);
};

literal: TK_LIT_FALSE { 
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_LITERAL, $1, DATA_TYPE_BOOL);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeFromSymbol($1, symbol);
};

literal: TK_LIT_TRUE { 
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_LITERAL, $1, DATA_TYPE_BOOL);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeFromSymbol($1, symbol);
};

literal: TK_LIT_CHAR { 
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_LITERAL, $1, DATA_TYPE_CHAR);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeFromSymbol($1, symbol);
};


// =======================
// =  Variaveis globais  =
// =======================
global_declaration: type var_list ';' { 
    $$ = NULL;
    freeLexicalValue($3);
};

var_list: TK_IDENTIFICADOR { 
    $$ = NULL; 
    
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    addVariableToGlobalVariableList(globalVariableList, $1, declaredType);
};

var_list: array { 
    $$ = NULL; 
};

var_list: TK_IDENTIFICADOR ',' var_list {
    $$ = NULL;
    freeLexicalValue($2);

    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);
};

var_list: array ',' var_list { 
    $$ = NULL;
    freeLexicalValue($2);
};

// Arranjos
array: TK_IDENTIFICADOR '[' dimension ']' {
    $$ = NULL;
    freeLexicalValue($2);
    freeLexicalValue($4);

    SymbolTableValue symbol = createSymbolTableValueWithTypeAndDimension(SYMBOL_TYPE_ARRAY, $1, declaredType, $3);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    validateArrayDeclaration(symbol);
}; 

dimension: TK_LIT_INT {
    $$ = getDimension($1);
    freeLexicalValue($1);
};

dimension: TK_LIT_INT '^' dimension {
    $$ = getDimensionMultipling($1, $3);
    freeLexicalValue($1);
    freeLexicalValue($2);
};


// =======================
// =       Funcoes       =
// =======================
function: header body {
    $$ = $1;
    addChild($$, $2);    
    if ($2) {
        addIlocListToIlocList($$->operationList, $2->operationList);
        updateFunctionLastPosition(symbolTableStack, $$->lexicalValue, $2->lastPosition);
    }
    if (shouldOptimize && strcmp($$->lexicalValue.label, "main"))
    {    
        IlocOperation leaveOperation = generateUnaryOp(OP_LEAVE);
        addOperationToIlocList($$->operationList, leaveOperation);
        addFunctionToFunctionList(functionList, $$->lexicalValue, $$->operationList);
        $$->operationList = createIlocList();
    }
    else
    {
        IlocOperation leaveOperation = generateUnaryOp(OP_LEAVE);
        addOperationToIlocList($$->operationList, leaveOperation);
        IlocOperation returnOperation = generateUnaryOp(OP_RETURN);
        addOperationToIlocList($$->operationList, returnOperation);
    }
};

header: type function_name arguments {
    int functionLabel = generateLabel();

    SymbolTableValue symbol = createSymbolTableValueWithTypeAndArguments(SYMBOL_TYPE_FUNCTION, $2, $1, $3, functionLabel);
    symbol = addValueToSecondSymbolTableOnStack(symbolTableStack, symbol);

    addVariableToGlobalVariableList(globalVariableList, $2, DATA_TYPE_FUNCTION);

    $$ = createNodeFromSymbol($2, symbol);

    IlocOperationList* operationList = createIlocList();

    IlocOperation operationNop = generateFunctionNop($2.label);
    operationNop = addLabelToOperation(operationNop, functionLabel); 
    operationNop.rspSub = symbolTableStack->lastPosition;
    addOperationToIlocList(operationList, operationNop);

    FunctionArgument* argument = $3;
    int argumentNumber = 1;
    while(argument)
    {
        IlocOperation argOperation = generateUnaryOpWithOneOut(OP_READ_ARG_FROM_CALL, argumentNumber, argument->position);
        addOperationToIlocList(operationList, argOperation);
        argument = argument->nextArgument;
        argumentNumber = argumentNumber + 1;
    }

    $$->operationList = operationList;
};

function_name: TK_IDENTIFICADOR {
    $$ = $1;
    symbolTableStack = createNewTableOnSymbolTableStack(symbolTableStack);

    addBlankSpaceToSymbolTableStack(symbolTableStack);
}

body: command_block { 
    $$ = $1;
};

arguments: '(' ')' { 
    $$ = NULL;

    freeLexicalValue($1);
    freeLexicalValue($2);
};

arguments: '(' arg_list ')' { 
    $$ = $2;

    freeLexicalValue($1);
    freeLexicalValue($3);
};

arg_list: type TK_IDENTIFICADOR {
    $$ = createFunctionArgument($2, $1);

    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $2, $1);
    symbol = addValueToSymbolTableStack(symbolTableStack, symbol);
    
    $$->position = symbol.position;
};

arg_list: type TK_IDENTIFICADOR ',' arg_list {
    $$ = addFunctionArgument($4, $2, $1);
    
    freeLexicalValue($3);

    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $2, $1);
    symbol = addValueToSymbolTableStack(symbolTableStack, symbol);

    $$->position = symbol.position;
};


// =======================
// =  Bloco de comandos  =
// =======================
command_block: '{' '}' { 
    $$ = NULL;
    freeLexicalValue($1);
    freeLexicalValue($2);
    symbolTableStack = freeFirstTableFromSymbolTableStack(symbolTableStack);
};

command_block: '{' simple_command_list '}' { 
    $$ = $2;
    $$->lastPosition = symbolTableStack->lastPosition;
    freeLexicalValue($1);
    freeLexicalValue($3);
    symbolTableStack = freeFirstTableFromSymbolTableStack(symbolTableStack);
};

simple_command_list: simple_command { 
    $$ = $1;
};

simple_command_list: simple_command simple_command_list {
    if ($1)
    {
        $$ = $1;
        addChild($$, $2);
        addIlocListToIlocList($1->operationList, $2->operationList);
    }
    else
    {        
        $$ = $2;
    }
};


// =======================
// =  Comandos simples   =
// =======================
simple_command: var_declaration ';' { 
    $$ = $1;
    freeLexicalValue($2);
};

simple_command: attribution ';' { 
    $$ = $1;
    freeLexicalValue($2);
};

simple_command: function_call ';' { 
    $$ = $1;
    freeLexicalValue($2);
};

simple_command: return_command ';' {
    $$ = $1;
    freeLexicalValue($2);
};

simple_command: flow_control_commands ';' { 
    $$ = $1;
    freeLexicalValue($2);
};

simple_command: command_block ';' { 
    $$ = $1;
    freeLexicalValue($2);
    symbolTableStack = createNewTableOnSymbolTableStack(symbolTableStack);
};

var_declaration: type var_decl_list { 
    $$ = $2;
};

var_decl_list: TK_IDENTIFICADOR { 
    $$ = NULL;

    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);
};

var_decl_list: TK_IDENTIFICADOR TK_OC_LE literal {
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeWithType($2, declaredType);
    addChild($$, createNodeFromSymbol($1, symbol));
    addChild($$, $3);
};

var_decl_list: TK_IDENTIFICADOR ',' var_decl_list { 
    $$ = $3;
    freeLexicalValue($2);

    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);
};

var_decl_list: TK_IDENTIFICADOR TK_OC_LE literal ',' var_decl_list { 
    SymbolTableValue symbol = createSymbolTableValueWithType(SYMBOL_TYPE_VARIABLE, $1, declaredType);
    addValueToSymbolTableStack(symbolTableStack, symbol);

    $$ = createNodeWithType($2, declaredType);
    addChild($$, createNodeFromSymbol($1, symbol));
    addChild($$, $3);
    addChild($$, $5);
    freeLexicalValue($4);
};

attribution: TK_IDENTIFICADOR '=' expression {
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);
    validateVariableUse(symbol, $1);

    Node* variable = createNodeWithType($1, symbol.dataType);

    $$ = createNodeFromAttribution($2, variable, $3); 
    addChild($$, variable);
    addChild($$, $3);

    IlocOperationList* operationList = createIlocListFromOtherList($3->operationList);

    int address = symbol.position;
    int r1 = $3->outRegister;

    IlocOperation operation;
    
    if (symbol.isGlobal)
    {
        operation = generateUnaryOpWithOneOutForGlobalVariable(OP_STOREAI_GLOBAL, symbol.lexicalValue.label, r1);
    }
    else
    {
        operation = generateUnaryOpWithOneOut(OP_STOREAI_LOCAL, r1, address);
    }

    addOperationToIlocList(operationList, operation);

    $$->operationList = operationList;
};

attribution: TK_IDENTIFICADOR '[' attr_array ']' '=' expression {
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);

    validateArrayUse(symbol, $1);

    Node* variable = createNodeWithType($1, symbol.dataType);
    
    Node* array = createNodeFromUnaryOperator($2, variable);
    addChild(array, variable); 
    addChild(array, $3);

    $$ = createNodeFromAttribution($5, array, $6);
    addChild($$, array);
    addChild($$, $6);

    freeLexicalValue($4);
};

attr_array: attr_array '^' expression {  
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);
};

attr_array: expression { 
    $$ = $1;
};

// Chamada de funcao
function_call: TK_IDENTIFICADOR '(' ')' { 
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);

    validateFunctionCall(symbol, $1);

    $$ = createNodeForFunctionCallFromSymbol($1, symbol);
    freeLexicalValue($2);
    freeLexicalValue($3);

    int r1 = generateRegister(globalVariableList);

    IlocOperationList* operationList = createIlocList();

    IlocOperation operationEraseReturn = generateUnaryOp(OP_ERASE_RETURN);
    addOperationToIlocList(operationList, operationEraseReturn);

    if (shouldOptimize)
    {
        IlocOperationList* functionOperationList = getFunctionCodeByLexicalValue(functionList, $1);
        addIlocListToIlocList(operationList, functionOperationList);
    }
    else
    {
        IlocOperation operationCall = generateFunctionCall(symbol.lexicalValue.label);
        addOperationToIlocList(operationList, operationCall);
    }

    IlocOperation operationReadReturnValue = generateUnaryOpWithoutInput(OP_READ_RETURN, r1);
    addOperationToIlocList(operationList, operationReadReturnValue);

    $$->operationList = operationList;
    $$->outRegister = r1;
};

function_call: TK_IDENTIFICADOR '(' arg_fn_list ')' {
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);

    validateFunctionCall(symbol, $1);

    $$ = createNodeForFunctionCallFromSymbol($1, symbol);
    addChild($$, $3->node);
    freeLexicalValue($2);
    freeLexicalValue($4);

    int r1 = generateRegister(globalVariableList);

    IlocOperationList* operationList = createIlocListFromOtherList($3->node->operationList);

    int functionLabel = symbol.lexicalValue.functionLabel;

    FunctionCallArgument* argument = $3;
    int argumentNumber = 1;
    while(argument) {
        IlocOperation argOperation = generateUnaryOpWithOneOut(OP_ADD_ARG_TO_CALL, argument->value, argumentNumber);
        addOperationToIlocList(operationList, argOperation);
        argument = argument->nextArgument;
        argumentNumber = argumentNumber + 1;
    }

    IlocOperation operationEraseReturn = generateUnaryOp(OP_ERASE_RETURN);
    addOperationToIlocList(operationList, operationEraseReturn);

    if (shouldOptimize)
    {
        IlocOperationList* functionOperationList = getFunctionCodeByLexicalValue(functionList, $1);
        addIlocListToIlocList(operationList, functionOperationList);
    }
    else
    {
        IlocOperation operationCall = generateFunctionCall(symbol.lexicalValue.label);
        addOperationToIlocList(operationList, operationCall);
    }

    IlocOperation operationReadReturnValue = generateUnaryOpWithoutInput(OP_READ_RETURN, r1);
    addOperationToIlocList(operationList, operationReadReturnValue);

    $$->operationList = operationList;
    $$->outRegister = r1;
};

arg_fn_list: expression { 
    $$ = createFunctionCallArgument($1->outRegister);
    $$->node = $1;
};

arg_fn_list: expression ',' arg_fn_list { 
    $$ = addFunctionCallArgument($3, $1->outRegister);
    $$->node = $1;
    addChild($$->node, $3->node);
    freeLexicalValue($2);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->node->operationList);
    $$->node->operationList = operationList;
};

// Comando de retorno
return_command: TK_PR_RETURN expression { 
    $$ = createNodeFromUnaryOperator($1, $2);
    addChild($$, $2);

    IlocOperationList* operationList = createIlocListFromOtherList($2->operationList);

    IlocOperation loadReturnOperation = generateUnaryOpWithoutOut(OP_LOAD_FUNCTION_RETURN, $2->outRegister);
    addOperationToIlocList(operationList, loadReturnOperation);

    $$->operationList = operationList;
};

// Comando de controle de fluxo
flow_control_commands: TK_PR_IF '(' expression start_flow_control_block TK_PR_THEN command_block { 
    $$ = createNodeFromUnaryOperator($1, $3);
    addChild($$, $3);
    addChild($$, $6);
    freeLexicalValue($2);
    freeLexicalValue($5);

    IlocOperationList* operationList = createIlocListFromOtherList($3->operationList);

    int rExpression = $3->outRegister;
    int rFalse = generateRegister(globalVariableList);
    int rCmpResult = generateRegister(globalVariableList);

    int labelTrue = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationLoadFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, rFalse);
    addOperationToIlocList(operationList, operationLoadFalse);

    IlocOperation operationCmpFalse = generateBinaryOpWithOneOut(OP_CMP_NE, rExpression, rFalse, labelEnd);
    addOperationToIlocList(operationList, operationCmpFalse);

    // IF TRUE
    IlocOperation operationNopTrue = generateNop();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);    
    addOperationToIlocList(operationList, operationNopTrue);
    addIlocListToIlocList(operationList, $6->operationList);

    IlocOperation operationNopEnd = generateNop();
    operationNopEnd = addLabelToOperation(operationNopEnd, labelEnd);
    addOperationToIlocList(operationList, operationNopEnd);

    $$->operationList = operationList;
};

flow_control_commands: TK_PR_IF '(' expression start_flow_control_block TK_PR_THEN command_block flow_control_else command_block { 
    $$ = createNodeFromUnaryOperator($1, $3);
    addChild($$, $3);
    addChild($$, $6);
    addChild($$, $8);
    freeLexicalValue($2);
    freeLexicalValue($5);

    IlocOperationList* operationList = createIlocListFromOtherList($3->operationList);

    int rExpression = $3->outRegister;
    int rFalse = generateRegister(globalVariableList);
    int rCmpResult = generateRegister(globalVariableList);

    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationLoadFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, rFalse);
    addOperationToIlocList(operationList, operationLoadFalse);
    
    IlocOperation operationCmpFalse = generateBinaryOpWithOneOut(OP_CMP_NE, rExpression, rFalse, labelFalse);
    addOperationToIlocList(operationList, operationCmpFalse);
    
    // IF TRUE
    IlocOperation operationNopTrue = generateNop();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);    
    addOperationToIlocList(operationList, operationNopTrue);

    addIlocListToIlocList(operationList, $6->operationList);

    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationJumpAfterTrue);
    // END TRUE

    // ELSE
    IlocOperation operationNopFalse = generateNop();
    operationNopFalse = addLabelToOperation(operationNopFalse, labelFalse);
    addOperationToIlocList(operationList, operationNopFalse);

    addIlocListToIlocList(operationList, $8->operationList);
    // END ELSE

    IlocOperation operationNopEnd = generateNop();
    operationNopEnd = addLabelToOperation(operationNopEnd, labelEnd);
    addOperationToIlocList(operationList, operationNopEnd);

    $$->operationList = operationList;
};

flow_control_commands: TK_PR_WHILE '(' expression start_flow_control_block command_block { 
    $$ = createNodeFromUnaryOperator($1, $3);
    addChild($$, $3);
    addChild($$, $5);
    freeLexicalValue($2);

    int rExpression = $3->outRegister;
    int rFalse = generateRegister(globalVariableList);
    int rCmpResult = generateRegister(globalVariableList);

    int labelStart = generateLabel();
    int labelTrue = generateLabel();
    int labelEnd = generateLabel();

    IlocOperationList* operationList = createIlocList();

    // Carrega o valor falso para comparação
    IlocOperation operationLoadFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, rFalse);
    addOperationToIlocList(operationList, operationLoadFalse);

    // Ponto de inicío do loop
    IlocOperation operationNopStart = generateNop();
    operationNopStart = addLabelToOperation(operationNopStart, labelStart);    
    addOperationToIlocList(operationList, operationNopStart);

    // Gerar valor do condicional
    addIlocListToIlocList(operationList, $3->operationList);

    // Gerar salto condicional
    IlocOperation operationCmpFalse = generateBinaryOpWithOneOut(OP_CMP_NE, rExpression, rFalse, labelEnd);
    addOperationToIlocList(operationList, operationCmpFalse);

    // Executar bloco de comando em caso verdadeiro
    IlocOperation operationNopTrue = generateNop();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);    
    addOperationToIlocList(operationList, operationNopTrue);
    addIlocListToIlocList(operationList, $5->operationList);
    
    // Retonar ao condicional para validar próxima execução
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelStart);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // Definir o final da execução
    IlocOperation operationNopEnd = generateNop();
    operationNopEnd = addLabelToOperation(operationNopEnd, labelEnd);
    addOperationToIlocList(operationList, operationNopEnd);

    $$->operationList = operationList;
};

start_flow_control_block: ')' {
    $$ = NULL;
    freeLexicalValue($1);
    symbolTableStack = createNewTableOnSymbolTableStack(symbolTableStack);
};

flow_control_else: TK_PR_ELSE {
    $$ = NULL;
    freeLexicalValue($1);
    symbolTableStack = createNewTableOnSymbolTableStack(symbolTableStack);
}
 
// =======================
// =     Expressoes      =
// =======================
expression: expression_grade_eight { 
    $$ = $1;
};

expression_grade_eight: expression_grade_eight TK_OC_OR expression_grade_seven { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationOr = generateBinaryOpWithTwoOuts(OP_OR, r1, r2, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationOr);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r3);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r3);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_eight: expression_grade_seven { 
    $$ = $1;
};

expression_grade_seven: expression_grade_seven TK_OC_AND expression_grade_six { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationAnd = generateBinaryOpWithOneOut(OP_AND, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationAnd);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r3);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r3);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_seven: expression_grade_six { 
    $$ = $1;
};

expression_grade_six: expression_grade_six TK_OC_EQ expression_grade_five { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpEQ = generateBinaryOpWithOneOut(OP_CMP_EQ, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpEQ);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_six: expression_grade_six TK_OC_NE expression_grade_five { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);    

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpNE = generateBinaryOpWithOneOut(OP_CMP_NE, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpNE);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_six: expression_grade_five { 
    $$ = $1; 
};

expression_grade_five: expression_grade_five '>' expression_grade_four { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpGT = generateBinaryOpWithOneOut(OP_CMP_GT, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpGT);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five '<' expression_grade_four { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpLT = generateBinaryOpWithOneOut(OP_CMP_LT, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpLT);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five TK_OC_LE expression_grade_four { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpLE = generateBinaryOpWithOneOut(OP_CMP_LE, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpLE);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five TK_OC_GE expression_grade_four { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r4 = generateRegister(globalVariableList);

    int labelFalse = generateLabel();
    int labelEnd = generateLabel();
    
    IlocOperation operationCmpGE = generateBinaryOpWithOneOut(OP_CMP_GE, r1, r2, labelFalse);
    addOperationToIlocList(operationList, operationCmpGE);

    // IF TRUE
    IlocOperation operationTrue = generateUnaryOpWithOneOut(OP_LOADI, 1, r4);
    IlocOperation operationJumpAfterTrue = generateUnaryOpWithoutOut(OP_JUMPI, labelEnd);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpAfterTrue);

    // ELSE
    IlocOperation operationFalse = generateUnaryOpWithOneOut(OP_LOADI, 0, r4);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    IlocOperation operationNop = generateNop();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_four { 
    $$ = $1;
};

expression_grade_four: expression_grade_four '+' expression_grade_three { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    IlocOperation operation = generateBinaryOpWithOneOut(OP_ADD, r1, r2, r3);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_four: expression_grade_four '-' expression_grade_three { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    IlocOperation operation = generateBinaryOpWithOneOut(OP_SUB, r1, r2, r3);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_four: expression_grade_three {
    $$ = $1;
};

expression_grade_three: expression_grade_three '*' expression_grade_two {
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    IlocOperation operation = generateBinaryOpWithOneOut(OP_MULT, r1, r2, r3);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_three: expression_grade_three '/' expression_grade_two { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);

    IlocOperationList* operationList = unifyOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister(globalVariableList);

    IlocOperation operation = generateBinaryOpWithOneOut(OP_DIV, r1, r2, r3);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_three: expression_grade_three '%' expression_grade_two { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_two {
    $$ = $1;
};

expression_grade_two: '!' expression_grade_one { 
    $$ = createNodeFromUnaryOperator($1, $2); 
    addChild($$, $2);
};

expression_grade_two: '-' expression_grade_one { 
    $$ = createNodeFromUnaryOperator($1, $2); 
    addChild($$, $2);

    IlocOperationList* operationList = createIlocListFromOtherList($2->operationList);

    int r1 = $2->outRegister;
    int r2 = generateRegister(globalVariableList);

    IlocOperation operation = generateUnaryOpWithOneOut(OP_NEG, r1, r2);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r2;
    $$->operationList = operationList;
};

expression_grade_two: expression_grade_one {
    $$ = $1;
};

expression_grade_one: TK_IDENTIFICADOR { 
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);

    validateVariableUse(symbol, $1);

    $$ = createNodeWithType($1, symbol.dataType);

    IlocOperationList* operationList = createIlocList();

    int address = symbol.position;
    int r1 = generateRegister(globalVariableList);

    IlocOperation operation;
    
    if (symbol.isGlobal)
    {
        operation = generateUnaryOpWithOneOutForGlobalVariable(OP_LOADAI_GLOBAL, symbol.lexicalValue.label, r1);
    }
    else
    {
        operation = generateUnaryOpWithOneOut(OP_LOADAI_LOCAL, address, r1);
    }

    addOperationToIlocList(operationList, operation);

    $$->outRegister = r1;
    $$->operationList = operationList;
};

expression_grade_one: TK_IDENTIFICADOR '[' expression_list ']' {
    SymbolTableValue symbol = getByLexicalValueOnSymbolTableStack(symbolTableStack, $1);

    validateArrayUse(symbol, $1);

    Node* variable = createNodeWithType($1, symbol.dataType);

    $$ = createNodeFromUnaryOperator($2, variable);
    addChild($$, variable);
    addChild($$, $3);
    freeLexicalValue($4);
};

expression_grade_one: literal { 
    $$ = $1;
};

expression_grade_one: function_call {
    $$ = $1;
};

expression_grade_one: '(' expression ')' { 
    $$ = $2;
    freeLexicalValue($1);
    freeLexicalValue($3);
};

expression_list: expression_list '^' expression { 
    $$ = createNodeFromBinaryOperator($2, $1, $3);
    addChild($$, $1);
    addChild($$, $3);        
};

expression_list: expression { 
    $$ = $1;
};
%%

void yyerror (const char *message) {
	printf("Erro sintatico [%s] na linha %d\n", message, get_line_number());
	return;
}
