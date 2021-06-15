%{
   #include <stdio.h>
   #include<stdlib.h>
   #include<math.h>
   #include<string.h>
   int yylex(void);

   typedef struct variable_collection
   {
       char *variable_name;
       char *variable_type;
       int   variable_value;
       float fVariable_value;
       char  cVariable_value;
   }variableWithValues;
   variableWithValues variableBox[1000];
   int Which_VariableBox_to_be_used_right_now = 0;
   int Which_VariableBox_to_be_used_right_now_for_array = 100;
   int switch_matched = 0;
   void AddIntValue  (variableWithValues *pointer,char *name , int value );
   void AddIntValueAsMathematicalOperation (char *name , int value );
   void AddIntValue_Checkwhetherfirstvariabledeclared ( char *name, char *firstVariable , char *operator , int second_value );
   void AddIntValue_Checkwhethersecondvariabledeclared ( char *name, int first_value , char *operator , char *secondVariable );
   void AddIntValue_Checkwhetherfirstsecondvariabledeclared ( char *name, char *firstVariable , char *operator , char *secondVariable );
   void AddFloatValue(variableWithValues *pointer,char *name , float value );
   void AddFloatValueAsMathematicalOperation (char *name , float value );
   void AddFloatValue_Checkwhetherfirstvariabledeclared ( char *name, char *firstVariable , char *operator , float second_value );
   void AddFloatValue_Checkwhethersecondvariabledeclared ( char *name, float first_value , char *operator , char *secondVariable );
   void AddCharValue(variableWithValues *pointer,char *name ,  char *value );
   void MakeAnArrayOfIntegers( char *name , int size);
   void StoreIntegersInAnArray( char *name,int index,int value);
   void StoreFloatInAnArray( char *name,int index,float value);
   void StoreCharInAnArray( char *name,int index,char *value);
   void StoreArrayByLoop ( char *name);
   void What_Values_Are_In_VariableBox();
   void Display_Function(char *name);
   void Display_Function_Array(char *name);
   void Display_Function_Array_loop(char *name,int loopIndex);
   void inc_dec_function(char *name , char * operator , int unit);
   void inc_dec_function_variableUnit(char *name , char * operator , char *unit);
   void GCD_Calculator(char *name, int val1 , int val2);
   void LCM_Calculator(char *name, int val1 , int val2);
   void Sort_Asc(char *name);
   void Sort_Des(char *name);
   void Find_Max(char *var ,char *name);
   void Find_Min(char *var ,char *name);
   void Sine(char *name , float var);
   void Cos(char *name , float var);
   void Tan(char *name , float var);
   void StoreAnArrrayValueToVariable(char *var,char *arr , int index);
   void FindLengthofArray(char *var , char *arr);
   
%}

%union
{
      char     *str;
      int      integerValue;
      float    floatValue;
}
%start begin
%token <integerValue>  INT 
%token <floatValue>  FLOAT
%token <str>           VARIABLE
%token <str>           EQUAL
%token <str>           CHAR
%token <str>           MATHEMATECAL_OPERATOR PLUS MINUS MUL DIV
%token <str>           INCREMENT_DECREMENT
%token PRINT ARRAY TYPE_INT TYPE_FLOAT TYPE_CHAR IF ELSE ELSEIF LOOP SWITCH DEF STORE BLOCKSTART TO BLOCKEND LEFTPARANTHESIS RIGHTPARANTHESIS AND OR GREATERTHAN LESSTHAN GREATEREQUAL LESSEQUAL EQUALEQUAL COMMA SEMICOLON
%token GCD LCM SORT ASC DES MAX MIN SIN COS TAN  STRING SHOW LENGTH NOTEQUAL NEWLINE
%type <integerValue> Conditions Condition_Checking if_else expression 
%type <floatValue> float_expression
%type <str> STRING
%left PLUS MINUS
%left MUL DIV

%%

begin : Statements ;

Statements : /* empty */ 
           | Statements variable_declaration
           | Statements inc_dec
           | Statements if_else
           | Statements expression   {printf("%d\n",$2);}
           | Statements looping
           | Statements Switch
           | Statements functions 
           | Statements PRINT STRING     {char *val = $3 ;for(int i =1 ; i<strlen($3)-1;i++) {printf("%c",val[i]);} }
           | Statements PRINT STRING NEWLINE    {char *val = $3 ;for(int i =1 ; i<strlen($3)-1;i++) {printf("%c",val[i]);} printf("\n");}
           | Statements PRINT VARIABLE                                          { Display_Function( $3); }
           | Statements PRINT ARRAY VARIABLE                                    { Display_Function_Array( $4); }
           | Statements SHOW                                                     {
                              for(int i=0;i<Which_VariableBox_to_be_used_right_now;i++)
                              {
                                  if( ! ( strcmp(variableBox[i].variable_type,"int") )  )   printf("%d => %d\n",i,variableBox[i].variable_value);
                                  if( ! ( strcmp(variableBox[i].variable_type,"float") )  ) printf("%d => %f\n",i,variableBox[i].fVariable_value);
                                  if( ! ( strcmp(variableBox[i].variable_type,"char") )  )  printf("%d => %c\n",i,variableBox[i].cVariable_value);
                              }
                              for(int i=100;i<Which_VariableBox_to_be_used_right_now_for_array;i++)
                              {
                                  if( ! ( strcmp(variableBox[i].variable_type,"int") )  )   printf("%d => %d\n",i,variableBox[i].variable_value);
                                  if( ! ( strcmp(variableBox[i].variable_type,"float") )  ) printf("%d => %f\n",i,variableBox[i].fVariable_value);
                                  if( ! ( strcmp(variableBox[i].variable_type,"char") )  )  printf("%d => %c\n",i,variableBox[i].cVariable_value);
                              }
           }
           ; 

variable_declaration :  
                        TYPE_INT VARIABLE EQUAL expression                      { AddIntValueAsMathematicalOperation( $2 , $4); }  
                     |  TYPE_FLOAT VARIABLE EQUAL float_expression              { AddFloatValueAsMathematicalOperation ($2,$4); }
                     |  VARIABLE EQUAL STRING                                   { AddCharValue ( &variableBox[Which_VariableBox_to_be_used_right_now_for_array] , $1 , $3 );}                              
                     |  ARRAY VARIABLE INT                                      { MakeAnArrayOfIntegers( $2 , $3);}    
                     |  ARRAY VARIABLE INT EQUAL INT                            { StoreIntegersInAnArray( $2 , $3 , $5 );}  
                     |  ARRAY VARIABLE INT EQUAL FLOAT                          { StoreFloatInAnArray( $2 , $3 , $5 );} 
                     |  ARRAY VARIABLE INT EQUAL CHAR                           { StoreCharInAnArray( $2 , $3 , $5 );}    
                     |  VARIABLE EQUAL ARRAY VARIABLE INT                       { StoreAnArrrayValueToVariable($1,$4,$5);}
                     |  VARIABLE EQUAL LENGTH VARIABLE                          { FindLengthofArray($1,$4);}
                     
                     
                     ;

expression : INT { $$ = $1 ; }
           | VARIABLE {  int found = 0;
                         for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                         { 
                             if ( ( !( strcmp (variableBox[i].variable_name,$1) )  ) )
                             {
                                 if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) )
                                 {
                                    $$ = variableBox[i].variable_value; found = 1;  break;
                                 }
                                  
                             }
                         }
                         if (found == 0) printf ("ERROR: VARIABLE NOT FOUND OR TYPE DOES NOT MATCH\n");
                      }      
        
           | expression PLUS expression  { $$ = $1 + $3;  }
           | expression MINUS expression { $$ = $1 - $3;  }
           | expression MUL expression   { $$ = $1 * $3;  }
           | expression DIV expression   { if ($3 != 0) { $$ = $1 / $3;  } else printf ("ERROR: DIVISION BY ZERO\n"); }
           ;

float_expression : FLOAT { $$ = $1 ; }
           | VARIABLE {  int found = 0;
                         for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                         { 
                             if ( ( !( strcmp (variableBox[i].variable_name,$1) )  ) )
                             {
                                 if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) )
                                 {
                                    $$ = variableBox[i].fVariable_value; found = 1;  break;
                                 }
                                 else("%s\n",variableBox[i].variable_type);
                                  
                             }
                             else("%s\n",$1);
                         }
                         if (found == 0) printf ("ERROR: VARIABLE NOT FOUND OR TYPE DOES NOT MATCH\n");
                      }      
        
           | float_expression PLUS float_expression  { $$ = $1 + $3;  }
           | float_expression MINUS float_expression { $$ = $1 - $3;  }
           | float_expression MUL float_expression   { $$ = $1 * $3;  }
           | float_expression DIV float_expression   { if ($3 != 0) { $$ = $1 / $3;  } else printf ("ERROR: DIVISION BY ZERO\n"); }
           ;           

inc_dec : VARIABLE INCREMENT_DECREMENT VARIABLE   { inc_dec_function_variableUnit($1,$2,$3);}
        | VARIABLE INCREMENT_DECREMENT INT        { inc_dec_function($1,$2,$3) ; }
        ;

if_else : IF  Condition_Checking  BLOCKSTART expression BLOCKEND  { if($2) printf("%d\n",$4);}
        | IF  Condition_Checking  BLOCKSTART expression BLOCKEND ELSE BLOCKSTART expression BLOCKEND  { if($2) printf("%d\n",$4); else printf("%d\n",$8); }
        | IF  Condition_Checking  BLOCKSTART expression BLOCKEND ELSEIF Condition_Checking BLOCKSTART expression BLOCKEND ELSE BLOCKSTART expression BLOCKEND 
                                                    {
                                                        if($2) printf ("%d\n",$4); 
                                                        else if($7) printf ("%d\n",$9);
                                                        else printf ("%d\n",$13); 
                                                    }
        | IF  Condition_Checking  BLOCKSTART 
                IF  Condition_Checking  BLOCKSTART expression BLOCKEND ELSE BLOCKSTART expression BLOCKEND
          BLOCKEND 
          ELSEIF Condition_Checking BLOCKSTART 
                IF  Condition_Checking  BLOCKSTART expression BLOCKEND ELSE BLOCKSTART expression BLOCKEND
          BLOCKEND 
          ELSE BLOCKSTART  
                IF  Condition_Checking  BLOCKSTART expression BLOCKEND ELSE BLOCKSTART expression BLOCKEND
          BLOCKEND                                        {
                                                               if($2)
                                                               {
                                                                  if($5) printf ("%d\n",$7);
                                                                  else   printf ("%d\n",$11);   
                                                               }
                                                               else if($15)
                                                               {
                                                                  if ($18) printf ("%d\n",$20);
                                                                  else     printf ("%d\n",$24);
                                                               }
                                                               else
                                                               {
                                                                  if($30)  printf ("%d\n",$32);
                                                                  else     printf ("%d\n",$36);
                                                               }
                                                          }  
        ;
            
Condition_Checking : Conditions AND Conditions   { if ($1 && $3) $$ = 1 ; else $$ = 0; }
                   | Conditions OR Conditions    { if ($1 || $3) $$ = 1 ; else $$ = 0; }
                   | Conditions    { $$ = $1; }
                   ;
                

Conditions : expression GREATERTHAN expression    { if($1>$3) $$ = 1; else $$ = 0;}
           | expression LESSTHAN expression       { if($1<$3) $$ = 1; else $$ = 0;}
           | expression GREATEREQUAL expression   { if($1>=$3) $$ = 1; else $$ = 0;}
           | expression LESSEQUAL expression      { if($1<=$3) $$ = 1; else $$ = 0;}
           | expression EQUALEQUAL expression     { if($1==$3) $$ = 1; else $$ = 0;}  
           | expression NOTEQUAL expression       { if($1!=$3) $$ = 1; else $$ = 0;}                                                 

looping :   LOOP INT COMMA INT COMMA PLUS INT BLOCKSTART PRINT  BLOCKEND {  
                                                                   for (int i=$2;i<=$4;i=i+$7)
                                                                   {
                                                                         printf("%d\n",i);
                                                                         //Display_Function($10);
                                                                         //printf("OK\n");
                                                                   }  
                                                                               }  
        |   LOOP INT COMMA INT COMMA MINUS INT BLOCKSTART PRINT  BLOCKEND {  
                                                                   for (int i=$2;i<=$4;i=i-$7)
                                                                   {
                                                                         printf("%d\n",i);
                                                                         //Display_Function($10);
                                                                         //printf("OK\n");
                                                                   }  
                                                                               }  
        |   LOOP INT COMMA INT COMMA MUL INT BLOCKSTART PRINT  BLOCKEND {  
                                                                   for (int i=$2;i<=$4;i=i*$7)
                                                                   {
                                                                         printf("%d\n",i);
                                                                         //Display_Function($10);
                                                                         //printf("OK\n");
                                                                   }  
                                                                               }  
        |   LOOP INT COMMA INT COMMA DIV INT BLOCKSTART PRINT  BLOCKEND {  
                                                                   for (int i=$2;i<=$4;i=i/$7)
                                                                   {
                                                                         printf("%d\n",i);
                                                                         //Display_Function($10);
                                                                         //printf("OK\n");
                                                                   }  
                                                                               }                                                                                                                                                                                                                       
        |   LOOP INT COMMA INT COMMA PLUS INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND {  
                                                                   for (int i=$2;i<=$4;i=i+$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }
        }
        |   LOOP INT COMMA INT COMMA MINUS INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND {  
                                                                   for (int i=$2;i>=$4;i=i-$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   } 
        }   
        |   LOOP INT COMMA INT COMMA MUL INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND {  
                                                                   for (int i=$2;i>=$4;i=i*$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }   
        }
        |   LOOP INT COMMA INT COMMA DIV INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND {  
                                                                   for (int i=$2;i>=$4;i=i/$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }                                                                                                                                                                          
        }
        |   LOOP VARIABLE COMMA VARIABLE COMMA PLUS INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND { 
                int var1 = 0,var2 = 0 , value1 , value2; 
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$2) )  ) )
                    {
                         var1 = 1 ; value1 =  variableBox[i].variable_value ; break ;
                    }
                }
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$4) )  ) )
                    {
                         var2 = 1 ; value2 =  variableBox[i].variable_value ; break ;
                    }
                } 
                 if (var1 && var2) {                               for (int i=value1;i<=value2;i=i+$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }
                                                                   }
        }
        |   LOOP VARIABLE COMMA VARIABLE COMMA MINUS INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND { 
                int var1 = 0,var2 = 0 , value1 , value2; 
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$2) )  ) )
                    {
                         var1 = 1 ; value1 =  variableBox[i].variable_value ; break ;
                    }
                }
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$4) )  ) )
                    {
                         var2 = 1 ; value2 =  variableBox[i].variable_value ; break ;
                    }
                } 
                 if (var1 && var2) {                               for (int i=value1;i>=value2;i=i-$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }
                                                                   }
        }
        |   LOOP VARIABLE COMMA VARIABLE COMMA MUL INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND { 
                int var1 = 0,var2 = 0 , value1 , value2; 
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$2) )  ) )
                    {
                         var1 = 1 ; value1 =  variableBox[i].variable_value ; break ;
                    }
                }
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$4) )  ) )
                    {
                         var2 = 1 ; value2 =  variableBox[i].variable_value ; break ;
                    }
                } 
                 if (var1 && var2) {                               for (int i=value1;i>=value2;i=i*$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }
                                                                   }                                                           
        }
        |   LOOP VARIABLE COMMA VARIABLE COMMA DIV INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND { 
                int var1 = 0,var2 = 0 , value1 , value2; 
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$2) )  ) )
                    {
                         var1 = 1 ; value1 =  variableBox[i].variable_value ; break ;
                    }
                }
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$4) )  ) )
                    {
                         var2 = 1 ; value2 =  variableBox[i].variable_value ; break ;
                    }
                } 
                 if (var1 && var2) {                               for (int i=value1;i>=value2;i=i/$7)
                                                                   {
                                                                         Display_Function_Array_loop($10,i);
                                                                         //printf("OK\n");
                                                                   }
                                                                   }
        } 
        |    LOOP INT TO INT BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND
             {
               for (int i=$2;i<=$4;i++)
               {
                      Display_Function_Array_loop($7,i);
               }
               //printf("sadsad\n");
             } 
        |    LOOP VARIABLE TO VARIABLE BLOCKSTART ARRAY VARIABLE PRINT BLOCKEND
             {
               int var1 = 0,var2 = 0 , value1 , value2; 
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$2) )  ) )
                    {
                         var1 = 1 ; value1 =  variableBox[i].variable_value ; break ;
                    }
                }
                for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
                {
                    if ( ( !( strcmp (variableBox[i].variable_name,$4) )  ) )
                    {
                         var2 = 1 ; value2 =  variableBox[i].variable_value ; break ;
                    }
                } 
                 if (var1 && var2) {                               for (int i=value1;i<=value2;i++)
                                                                   {
                                                                         Display_Function_Array_loop($7,i);
                                                                         //printf("OK\n");
                                                                   }
             }  
             }                                                                     
                                                                    
           ;                                                   

Switch: SWITCH BLOCKSTART CASE BLOCKEND
       ;

CASE :  PARTICULAR_CASE  DEFAULT_CASE 
      ; 

PARTICULAR_CASE : /* NULL */
                  | PARTICULAR_CASE CASE_NUMBER 
                  ;

CASE_NUMBER : expression RIGHTPARANTHESIS expression SEMICOLON  expression { if(switch_matched == 0) { if($1 == $5) { printf("Expected Value = %d\n",$3); switch_matched = 1;} } }
            ;

DEFAULT_CASE : DEF  expression { if(switch_matched == 0) printf("Expected Value = %d\n",$2); }
              ;           

functions: SORT ASC VARIABLE { Sort_Asc($3);}  
        |  SORT DES VARIABLE { Sort_Des($3);}
        |  VARIABLE EQUAL MAX VARIABLE { Find_Max($1 , $4);}
        |  VARIABLE EQUAL MIN VARIABLE { Find_Min($1,$4);}
        |  VARIABLE EQUAL SIN FLOAT    { Sine($1,$4);}
        |  VARIABLE EQUAL COS FLOAT    { Cos($1,$4);}
        |  VARIABLE EQUAL TAN FLOAT    { Tan($1,$4);}
        |  VARIABLE EQUAL GCD expression COMMA expression          { GCD_Calculator($1,$4,$6);}
        |  VARIABLE EQUAL LCM expression COMMA expression          { LCM_Calculator($1,$4,$6);}
%%

void FindLengthofArray(char *var , char *arr)
{
    int length;
    int arrayFound = 0;
    int varFound = 0;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,arr) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"char") )  ) )length = variableBox[i].variable_value - 2;
            else  length = variableBox[i].variable_value ;
            arrayFound = 1;
            break;
        }
    }
    if (arrayFound==1)
    {
        for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
        {
            if ( ( !( strcmp (variableBox[i].variable_name,var) )  ) )
            {
                 varFound = 1;
                 variableBox[i].variable_value = length;
                 break;
            }
        }
        if(varFound == 0)
        {
            variableBox[Which_VariableBox_to_be_used_right_now].variable_name = var;
            variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int";
            variableBox[Which_VariableBox_to_be_used_right_now].variable_value = length;
            variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0;
            variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0' ;
            Which_VariableBox_to_be_used_right_now ++ ;
        }
    }    

}

void StoreAnArrrayValueToVariable(char *var,char *arr , int index)
{
    int arrayFound = 0;
    int sizeMatched = 0;
    int varFound = 0 ;
    int arrayIndex , arrayValue , arraySize; 
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,arr) )  ) )
        {
            arrayFound = 1;
            arraySize = i + 1 + variableBox[i].variable_value ; 
            arrayIndex = (i+1)+index;
            if(arrayIndex <= arraySize)
            {
                sizeMatched = 1 ;
                arrayValue = variableBox[arrayIndex].variable_value ;
                for (int j = 0 ; j < Which_VariableBox_to_be_used_right_now ; j ++)
                {
                    if ( ( !( strcmp (variableBox[j].variable_name,var) )  ) )
                    {
                         varFound = 1;
                         variableBox[j].variable_value = arrayValue ;
                         break;
                    }
                }
            }
            break;
        }
    }
    if(varFound == 0 && arrayFound == 1 && sizeMatched == 1)
    {
        variableBox[Which_VariableBox_to_be_used_right_now].variable_name = var;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_value = arrayValue;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int" ;
        variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0 ; 
        variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0' ; 
        Which_VariableBox_to_be_used_right_now ++ ;
    } 
    else if (sizeMatched == 0) printf("ERROR: THE GIVEN INDEX IS OUT OF ARRAY BOUND\n");
    else if  (arrayFound == 0)  printf("ERROR: ARRAY NOT DECLARED\n");  
}

void Sine(char *name , float var)
{
     variableBox[Which_VariableBox_to_be_used_right_now].variable_name = name ; 
     variableBox[Which_VariableBox_to_be_used_right_now].variable_value = 0 ;
     variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "float" ; 
     variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0';
     variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = sin( var * (3.14159265359 / 180));
     Which_VariableBox_to_be_used_right_now ++ ;  
}

void Cos(char *name , float var)
{
     variableBox[Which_VariableBox_to_be_used_right_now].variable_name = name ; 
     variableBox[Which_VariableBox_to_be_used_right_now].variable_value = 0 ;
     variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "float" ; 
     variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0';
     variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = cos( var * (3.14159265359 / 180));
     Which_VariableBox_to_be_used_right_now ++ ;  
}

void Tan(char *name , float var)
{
     variableBox[Which_VariableBox_to_be_used_right_now].variable_name = name ; 
     variableBox[Which_VariableBox_to_be_used_right_now].variable_value = 0 ;
     variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "float" ; 
     variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0';
     variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = tan( var * (3.14159265359 / 180));
     Which_VariableBox_to_be_used_right_now ++ ;  
}

void Find_Max(char *var ,char *name)
{
    int declared = 0;
    int var_declared = 0;
    int max = 0;
    int size,index;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
             size = variableBox[i].variable_value + 1 ; 
             index = i + 1 ;
             declared = 1 ;
             break ;
        }
    }
    if(declared == 1)
    {
        for(int i =index ; i< index+size ;i++)
        {
            if (variableBox[i].variable_value > max) max = variableBox[i].variable_value;
        }
        for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
        {
           if ( ( !( strcmp (variableBox[i].variable_name,var) )  ) )
           {
               variableBox[i].variable_value = max ; 
               var_declared = 1 ;
               break ;
           }
       }
       if(var_declared == 0)
        {
               variableBox[Which_VariableBox_to_be_used_right_now].variable_name = var ;
               variableBox[Which_VariableBox_to_be_used_right_now].variable_value = max;
               variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int" ;
               variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0;
               variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0';
               Which_VariableBox_to_be_used_right_now++ ;
        }

    }
    else printf ("ERROR:THE ARRAY TO FIND MAX IS NOT DECLARED YET\n");
}

void Find_Min(char *var ,char *name)
{
    int declared = 0;
    int var_declared = 0;
    int max = 10000;
    int size;
    int index;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
             size = variableBox[i].variable_value + 1 ; 
             index = i + 1 ;
             declared = 1 ;
             break ;
        }
    }
    if(declared == 1)
    {
        for(int i =index ; i< index+size ;i++)
        {
            if (variableBox[i].variable_value < max) max = variableBox[i].variable_value;
        }
        for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
        {
           if ( ( !( strcmp (variableBox[i].variable_name,var) )  ) )
           {
               variableBox[i].variable_value = max ; 
               var_declared = 1 ;
               break ;
           }
       }
       if(var_declared == 0)
        {
               variableBox[Which_VariableBox_to_be_used_right_now].variable_name = var ;
               variableBox[Which_VariableBox_to_be_used_right_now].variable_value = max;
               variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int" ;
               variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0;
               variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0';
               Which_VariableBox_to_be_used_right_now++ ;
        }

    }
    else printf ("ERROR:THE ARRAY TO FIND MAX IS NOT DECLARED YET\n");
}

void Sort_Asc(char *name)
{
    int size , index , swap ; 
    int declared = 0;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
             size = variableBox[i].variable_value + 1 ; 
             index = i + 1 ;
             declared = 1 ;
             break ;
        }
    }
    if(declared == 1)
    {
        int array[size];
        for(int i=0 ; i < size ; i++)
            array[i] = variableBox[i+index].variable_value;  
        for (int c = 0 ; c < size; c++)
        {
            for (int d = 0 ; d < size-1 ; d++)
            {
                if (array[d] > array[d+1]) 
                {
                   swap       = array[d];
                   array[d]   = array[d+1];
                   array[d+1] = swap;
                }
            }
        }
        for(int i = 0 ; i < size ; i++)
           variableBox[i + index].variable_value = array[i] ;

    }
    else printf ("ERROR:THE ARRAY TO BE SORTED IS NOT DECLARED YET\n");  
}

void Sort_Des(char *name)
{
    int size , index , swap ; 
    int declared = 0;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
             size = variableBox[i].variable_value + 1 ; 
             index = i + 1 ;
             declared = 1 ;
             break ;
        }
    }
    if(declared == 1)
    {
        int array[size];
        for(int i=0 ; i < size ; i++)
            array[i] = variableBox[i+index].variable_value;  
        for (int c = 0 ; c < size; c++)
        {
            for (int d = 0 ; d < size-1 ; d++)
            {
                if (array[d] < array[d+1]) 
                {
                   swap       = array[d];
                   array[d]   = array[d+1];
                   array[d+1] = swap;
                }
            }
        }
        for(int i = 0 ; i < size ; i++)
           variableBox[i + index].variable_value = array[i] ;

    }
    else printf ("ERROR:THE ARRAY TO BE SORTED IS NOT DECLARED YET\n");  
}

void GCD_Calculator(char *name, int val1 , int val2)
{
    int gcd;
    int is_that_var_declared = 0;
    for(int i=1; i <= val1 && i <= val2; ++i)
    {
            if(val1%i==0 && val2%i==0) gcd = i;
    }
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            variableBox[i].variable_value = gcd ; 
            is_that_var_declared = 1;
            break;
        }
    }
    if (is_that_var_declared == 0)
    {
        variableBox[Which_VariableBox_to_be_used_right_now].variable_name = name ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_value = gcd ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int" ;
        variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0 ;
        variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0' ; 
    }   
}

void LCM_Calculator(char *name, int val1 , int val2)
{
    int lcm;
    int is_that_var_declared = 0;
    int max = (val1 > val2) ? val1 : val2;
    while (1) {
        if (max % val1 == 0 && max % val2 == 0) {
            lcm = max;
            break;
        }
        ++max;
    }
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            variableBox[i].variable_value = lcm ; 
            is_that_var_declared = 1;
            break;
        }
    }
    if (is_that_var_declared == 0)
    {
        variableBox[Which_VariableBox_to_be_used_right_now].variable_name = name ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_value = lcm ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_type = "int" ;
        variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0 ;
        variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0' ; 
    }   
}

void AddIntValue(variableWithValues *pointer,char *name , int value )
{
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            printf("VARIABLE ALREADY DECLARED.RESTORING THE VALUE\n");
            variableBox[i].variable_value  = value;
            is_that_variable_already_there = 1;
            break;   
        }
    }
    if (is_that_variable_already_there == 0)
    {
        pointer->variable_type   = "int" ;
        pointer->variable_name   = name  ;
        pointer->variable_value  = value ;
        pointer->fVariable_value = 0.0   ;
        pointer->cVariable_value = '\0'  ;
        Which_VariableBox_to_be_used_right_now ++ ;
    }
}

void AddIntValueAsMathematicalOperation (char *name , int value)
{
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) )
            {
                variableBox[i].variable_value = value;
                is_that_variable_already_there = 1;
                break;
            }  
        }
    }
    if (is_that_variable_already_there == 0)
    {
        
        variableBox[Which_VariableBox_to_be_used_right_now].variable_type   = "int" ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_name   = name  ;
        variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = 0.0   ;
        variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0'  ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_value = value;
        Which_VariableBox_to_be_used_right_now ++ ;
    }

}

void AddIntValue_Checkwhetherfirstvariabledeclared( char *name, char *firstVariable , char *operator , int second_value )
{
    int first_value;
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,firstVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) )
            {
               first_value = variableBox[i].variable_value;
               is_that_variable_already_there = 1;
               break;
            }
        }
    }
    if(is_that_variable_already_there)
    {
        //AddIntValueAsMathematicalOperation(name,first_value,operator,second_value,&variableBox[Which_VariableBox_to_be_used_right_now]);
    }
    else printf("ERROR: THE VARIABLE IN THE RIGHT SIDE OF EQUAL(=) IS NOT DECLARED OR DID NOT MATCH WITH THE TYPE(INT)\n");   
}

void AddIntValue_Checkwhethersecondvariabledeclared ( char *name, int first_value , char *operator , char *secondVariable )
{
    int second_value;
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,secondVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) )
            {
               second_value = variableBox[i].variable_value;
               is_that_variable_already_there = 1;
               break;
            }
            
        }
    }
    if(is_that_variable_already_there)
    {
        //AddIntValueAsMathematicalOperation(name,first_value,operator,second_value,&variableBox[Which_VariableBox_to_be_used_right_now]);
    }
    else printf("ERROR: THE VARIABLE IN THE RIGHT SIDE OF EQUAL(=) IS NOT DECLARED OR DID NOT MATCH WITH THE TYPE(INT)\n"); 
}

void AddIntValue_Checkwhetherfirstsecondvariabledeclared ( char *name, char *firstVariable , char *operator , char *secondVariable )
{
    int first_value;
    float first_value_f;
    char *type1;
    int is_first_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,firstVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) ) { first_value = variableBox[i].variable_value; type1 = "int";}
            else if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) ) { first_value_f = variableBox[i].fVariable_value; type1 = "float";}
            is_first_variable_already_there = 1;
            break;
        }
    }
    int second_value;
    float second_value_f;
    char *type2;
    int is_second_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,secondVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"int") )  ) ) { second_value = variableBox[i].variable_value; type2 = "int";}
            else if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) ) { second_value_f = variableBox[i].fVariable_value; type2 = "float";}
            is_second_variable_already_there = 1;
            break;
        }
    }
    if ( is_first_variable_already_there  && is_second_variable_already_there   )
    {
        if ( ((!strcmp(type1,type2))) && ((!strcmp(type1,"int"))) ) {}// AddIntValueAsMathematicalOperation(name,first_value,operator,second_value,&variableBox[Which_VariableBox_to_be_used_right_now]);
        else if ( ((!strcmp(type1,type2))) && ((!strcmp(type1,"float"))) ) {}//AddFloatValueAsMathematicalOperation(name,first_value_f,operator,second_value_f,&variableBox[Which_VariableBox_to_be_used_right_now]);
        else printf("ERROR: TYPE ERROR \n");
    }
    else printf("ERROR: ONE OF THE VARIABLES OR BOTH IN THE RIGHT SIDE OF EQUAL(=) ARE NOT DECLARED\n"); 
}

void AddFloatValue(variableWithValues *pointer,char *name , float value )
{
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            printf("VARIABLE ALREADY DECLARED.RESTORING THE VALUE\n");
            variableBox[i].fVariable_value = value;
            is_that_variable_already_there = 1;
            break;   
        }
    }
    if(is_that_variable_already_there == 0)
    {
        pointer->variable_type   = "float" ;
        pointer->variable_name   = name    ;
        pointer->fVariable_value = value   ;
        pointer->variable_value  = 0       ;
        pointer->cVariable_value = '\0'    ;
        Which_VariableBox_to_be_used_right_now ++ ;
    }
}

void AddFloatValueAsMathematicalOperation (char *name , float value )
{
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) )
            {
                variableBox[i].fVariable_value = value;
                is_that_variable_already_there = 1;
                break;
            }    
        }
    }
    if (is_that_variable_already_there == 0)
    {
        
        variableBox[Which_VariableBox_to_be_used_right_now].variable_type   = "float" ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_name   = name  ;
        variableBox[Which_VariableBox_to_be_used_right_now].fVariable_value = value   ;
        variableBox[Which_VariableBox_to_be_used_right_now].cVariable_value = '\0'  ;
        variableBox[Which_VariableBox_to_be_used_right_now].variable_value = 0;
        Which_VariableBox_to_be_used_right_now ++ ;
    }

}

void AddFloatValue_Checkwhetherfirstvariabledeclared( char *name, char *firstVariable , char *operator , float second_value )
{
    float first_value;
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,firstVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) )
            {
               first_value = variableBox[i].fVariable_value;
               is_that_variable_already_there = 1;
               break;
            }
        }
    }
    if(is_that_variable_already_there)
    {
        //AddFloatValueAsMathematicalOperation(name,first_value,operator,second_value,&variableBox[Which_VariableBox_to_be_used_right_now]);
    }
    else printf("ERROR: THE VARIABLE IN THE RIGHT SIDE OF EQUAL(=) IS NOT DECLARED OR DID NOT MATCH WITH THE TYPE(FLOAT)\n");   
}

void AddFloatValue_Checkwhethersecondvariabledeclared ( char *name, float first_value , char *operator , char *secondVariable )
{
    float second_value;
    int is_that_variable_already_there = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,secondVariable) )  ) )
        {
            if ( ( !( strcmp (variableBox[i].variable_type,"float") )  ) )
            {
               second_value = variableBox[i].fVariable_value;
               is_that_variable_already_there = 1;
               break;
            }
        }
    }
    if(is_that_variable_already_there)
    {
        //AddFloatValueAsMathematicalOperation(name,first_value,operator,second_value,&variableBox[Which_VariableBox_to_be_used_right_now]);
    }
    else printf("ERROR: THE VARIABLE IN THE RIGHT SIDE OF EQUAL(=) IS NOT DECLARED OR DID NOT MATCH WITH THE TYPE(FLOAT)\n"); 
}

void AddCharValue(variableWithValues *pointer,char *name ,  char *value )
{
    int is_that_variable_already_there = 0;
    for (int i = 100 ; i < Which_VariableBox_to_be_used_right_now_for_array ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            variableBox[i].variable_value = strlen(value) ; 
            for (int j=i+1;j<(i + strlen(value) - 2);j++)
            {
                variableBox[j].cVariable_value = value[j-i] ;
            }
            is_that_variable_already_there = 1;
            break;   
        }
    }
    if(is_that_variable_already_there == 0)
    {
        pointer->variable_type   = "char"   ;
        pointer->variable_name   = name     ;
        pointer->variable_value  = strlen(value)        ;
        pointer++ ; 
        Which_VariableBox_to_be_used_right_now_for_array ++ ;
        for(int i=1; i < (strlen(value)-1) ; i++)
        {
            pointer->variable_type   = "char"   ;
            pointer->variable_name   = name     ;
            pointer->cVariable_value = value[i] ;
            pointer->fVariable_value = 0.0      ;
            pointer->variable_value = 0;
            pointer ++ ;
            Which_VariableBox_to_be_used_right_now_for_array ++ ;
        }
    }
}

void MakeAnArrayOfIntegers(char *name , int size)
{
    variableBox[Which_VariableBox_to_be_used_right_now_for_array].variable_name = name;
    variableBox[Which_VariableBox_to_be_used_right_now_for_array].variable_value = size-1;
    variableBox[Which_VariableBox_to_be_used_right_now_for_array].variable_type = "notchar" ;
    Which_VariableBox_to_be_used_right_now_for_array ++;
    for(int i = Which_VariableBox_to_be_used_right_now_for_array ; i < Which_VariableBox_to_be_used_right_now_for_array + size ; i++)
    {
        variableBox[ i].variable_name   = name; 
        variableBox[ i].variable_value  = 0;
        variableBox[ i].fVariable_value = 0.0;
        variableBox[ i].cVariable_value = '\0';    
    }
    Which_VariableBox_to_be_used_right_now_for_array += size;
}

void StoreIntegersInAnArray( char *name,int index,int value)
{
    int is_the_value_storable = 0;
    int expected_index;
    int size;
    for ( int i = 100 ; i<Which_VariableBox_to_be_used_right_now_for_array ; i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value;
            if( index <= size) is_the_value_storable = 1;
            expected_index = i + index + 1;
            break;
        }
    }
    
    if (is_the_value_storable == 0 ) 
    { 
        printf("THE ARRAY IS NOT DECLARED YET OR THE INDEX VALUE IS OUT OF ARRAY SIZE.\n");
        
        
    }    
    else
    {
        variableBox[expected_index].variable_value = value;
        variableBox[expected_index].variable_type = "int" ;
        
    }
    
}

void StoreFloatInAnArray( char *name,int index,float value)
{
    int is_the_value_storable = 0;
    int expected_index;
    int size;
    for ( int i = 100 ; i<Which_VariableBox_to_be_used_right_now_for_array ; i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value;
            if( index <= size) is_the_value_storable = 1;
            expected_index = i + index + 1;
            break;
        }
    }
    
    if (is_the_value_storable == 0 ) 
    { 
        printf("THE ARRAY IS NOT DECLARED YET OR THE INDEX VALUE IS OUT OF ARRAY SIZE.\n");
        
        
    }    
    else
    {
        variableBox[expected_index].fVariable_value = value;
        variableBox[expected_index].variable_type = "float" ;
        
    }
    
}

void StoreCharInAnArray( char *name,int index,char *value)
{
    int is_the_value_storable = 0;
    int expected_index;
    int size;
    for ( int i = 100 ; i<Which_VariableBox_to_be_used_right_now_for_array ; i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value;
            if( index <= size) is_the_value_storable = 1;
            expected_index = i + index + 1;
            break;
        }
    }
    
    if (is_the_value_storable == 0 ) 
    { 
        printf("THE ARRAY IS NOT DECLARED YET OR THE INDEX VALUE IS OUT OF ARRAY SIZE.\n");
        
        
    }    
    else
    {
        variableBox[expected_index].cVariable_value = value[1];
        variableBox[expected_index].variable_type = "char" ;
        
    }
    
}

void StoreArrayByLoop ( char *name)
{
    int size ;
    int starting_index; 
    int found_the_array = 0;
    int temp;
    int cont;
    for ( int i = 100 ; i<Which_VariableBox_to_be_used_right_now_for_array ; i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value ;
            found_the_array = 1;
            starting_index = i+1 ;
            break;
        }
    }
    if (found_the_array == 1)
    {
        for(int i = 0 ; i<= size ; i++ )
        {
            printf("Enter the value = ");
            scanf("%d",&temp);
            variableBox[starting_index].variable_value = temp;
            starting_index ++ ;
            //printf("Wish to continue?In case not,the remaining index of the array will be skipped(0/1):");
            //scanf("%d",&cont);
            //if(cont == 0) break;
        }
    }
    else printf("ERROR:THE ARRAY IS NOT DECLARED YET\n");   
}

void What_Values_Are_In_VariableBox() // has to be editted
{
    printf("%d\n",Which_VariableBox_to_be_used_right_now);
    for(int i=0;i<Which_VariableBox_to_be_used_right_now;i++) 
       printf("%s = %d\n",variableBox[i].variable_name,variableBox[i].variable_value);
}

void Display_Function(char *name)
{
    int found = 0;
    int index;
    char *type;
    for(int i=0;i<Which_VariableBox_to_be_used_right_now;i++)
    {
        if ( ! ( strcmp(variableBox[i].variable_name,name) ) )
        {
            index = i;
            type = variableBox[i].variable_type;
            found = 1;
            break;
        }
    }
    if (found == 1)
    {
        if( ! ( strcmp(type,"int") )  )   printf("%d\n",variableBox[index].variable_value);
        if( ! ( strcmp(type,"float") )  ) printf("%f\n",variableBox[index].fVariable_value);
        if( ! ( strcmp(type,"char") )  )  printf("%c\n",variableBox[index].cVariable_value);
    }
    else printf("ERROR: VARIABLE NOT FOUND\n");
}

void Display_Function_Array(char *name)
{
    int size;
    int index;
    int is_printable = 0;
    for (int i=100 ; i<Which_VariableBox_to_be_used_right_now_for_array;i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value;
            index = i+1;
            is_printable = 1;
            break;
        }
    }
    if ( is_printable)
    {
        for(int i=index;i<=(index + size);i++)
        {
            printf("%s %s %d %f %c\n",variableBox[i].variable_name,variableBox[i].variable_type,variableBox[i].variable_value,variableBox[i].fVariable_value,variableBox[i].cVariable_value);
        }
    }
    else
    {
        printf("ERROR: NO ARRAY IS FOUND WITH THIS NAME\n");
    }
    
}

void Display_Function_Array_loop(char *name,int loopIndex)
{
    int size;
    int indexToPrint;
    int is_printable = 0;
    for (int i=100 ; i<Which_VariableBox_to_be_used_right_now_for_array;i++)
    {
        if ( ! ( strcmp ( variableBox[i].variable_name , name  ) ) ) 
        {
            size = variableBox[i].variable_value;
            indexToPrint = (i+1)+loopIndex;
            is_printable = 1;
            if ( ! ( strcmp ( variableBox[indexToPrint].variable_type , "int"  ) ) ) printf("%d\n",variableBox[indexToPrint].variable_value);
            else if ( ! ( strcmp ( variableBox[indexToPrint].variable_type , "float"  ) ) ) printf("%f\n",variableBox[indexToPrint].fVariable_value);
            else if ( ! ( strcmp ( variableBox[indexToPrint].variable_type , "char"  ) ) ) printf("%c\n",variableBox[indexToPrint].cVariable_value);
            break;
        }
    }
    if(is_printable == 0) printf("ERROR: ARRAY INDEX EXCEEDS\n");
}   

void inc_dec_function(char *name , char * operator , int unit)
{
    int done = 0;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,name) )  ) )
        {
            if ( ( !( strcmp (operator,"inc+") )  ) ) 
            { 
                variableBox[i].variable_value += unit ;
                done = 1;
                break ;  
            } 
            else if ( ( !( strcmp (operator,"inc*") )  ) ) 
            { 
                variableBox[i].variable_value *= unit ;
                done = 1;
                break ;  
            }  
            else if ( ( !( strcmp (operator,"dec-") )  ) ) 
            { 
                variableBox[i].variable_value -= unit ;
                done = 1;
                break ;  
            }  
            else if ( ( !( strcmp (operator,"dec/") )  ) ) 
            { 
                if (unit != 0) variableBox[i].variable_value /= unit ;
                else printf("ERROR: DIVISION BY ZERO\n");
                done = 1;
                break ;  
            } 
        }
    }
    if (done == 0) {printf ("ERROR: VARIABLE NO DECLARED\n");}   
        
}

void inc_dec_function_variableUnit(char *name , char * operator , char *unit)
{
    int is_unit_declared = 0;
    int index;
    for (int i = 0 ; i < Which_VariableBox_to_be_used_right_now ; i ++)
    {
        if ( ( !( strcmp (variableBox[i].variable_name,unit) )  ) ) { is_unit_declared = 1 ; index = i; break ; }
    }
    if( is_unit_declared == 0 ) printf ("ERROR: THE UNIT VARIABLE IS NOT DECLARED\n");    
    else inc_dec_function(name , operator , variableBox[index].variable_value);
}

int main(void)
{
   
	freopen("input.txt","r",stdin);
	yyparse();
    
}

int yywrap(void)
{
	return 1;
    /*INT INT INT BLOCKSTART  BLOCKEND { for (int i = $2 ;  i < $3 ; i = i + $4) 
                                                              {
                                                                  printf ("Step %d : value of expression is .\n",i);
                                                              } }*/
}

int yyerror(char *s)
{
	fprintf(stderr, "error: %s\n", s);
   // |  VARIABLE EQUAL INT MATHEMATECAL_OPERATOR INT            { AddIntValueAsMathematicalOperation ( $1 , $3 , $4 , $5 , &variableBox[Which_VariableBox_to_be_used_right_now]); }
   //                  |  VARIABLE EQUAL VARIABLE MATHEMATECAL_OPERATOR INT       { AddIntValue_Checkwhetherfirstvariabledeclared  ($1 , $3 , $4 , $5) ;}
   //                  |  VARIABLE EQUAL INT MATHEMATECAL_OPERATOR VARIABLE       { AddIntValue_Checkwhethersecondvariabledeclared ($1 , $3 , $4 , $5) ;}
   //                  |  VARIABLE EQUAL VARIABLE MATHEMATECAL_OPERATOR VARIABLE  { AddIntValue_Checkwhetherfirstsecondvariabledeclared ($1 , $3 , $4 , $5) ;}
   //               
}