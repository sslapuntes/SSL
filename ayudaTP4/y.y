%{
	#include <stdio.h>
    int yylex(void);
	int yyerror(const char *s);
	extern FILE* yyin;
    extern int yylineno;
	int analisisCorrecto = 1;

%}
%union
{
  char* idval;
  int ival;  
}

%token <ival> OCTAL
%token <idval> ID
%token VOID 
%token INT 
%token DEFINE IF WHILE
%token RETURN 
%token  ELSE INCLUDE  FOR
%nonassoc IFX
%nonassoc ELSE
%start unidad_de_programa
%%
unidad_de_programa: INCLUDE  unidad_de_programa  {printf("unidad_de_programa:   include<stdio.h>     unidad_de_programa\n");}                      
                  | DEFINE  expresion_primaria   unidad_de_programa    {printf("unidad_de_programa:   DEFINE expresion_primaria    unidad_de_programa\n");}              	
                  | unidad_de_traduccion 	{printf("unidad_de_programa:   unidad_de_traduccion\n");}								
                  ;

unidad_de_traduccion: declaracion_externa  {printf("unidad_de_traduccion:  declaracion_externa\n");}
                   |  unidad_de_traduccion declaracion_externa   {printf("unidad_de_traduccion: declaracion_externa\n");}
                   ;

declaracion_externa: definicion_de_funcion  {printf("declaracion_externa: definicion_de_funcion\n");}
                   | declaracion {printf("declaracion_externa: declaracion\n");}
                   ;

definicion_de_funcion: especificadores_de_declaracion declarador lista_de_declaracion sentencia_compuesta {printf("definicion_de_funcion: especificadores_de_declaracion    declarador    lista_de_declaracion     sentencia_compuesta\n");}
                     |  declarador lista_de_declaracion sentencia_compuesta {printf("definicion_de_funcion:   declarador      lista_de_declaracion    sentencia_compuesta\n");}
                     |  especificadores_de_declaracion declarador  sentencia_compuesta   {printf("definicion_de_funcion:  especificadores_de_declaracion   declarador    sentencia_compuesta \n");}
                     |  declarador  sentencia_compuesta {printf("definicion_de_funcion:   declarador  sentencia_compuesta \n");}
                     ;

declaracion: especificadores_de_declaracion lista_declaradores_init ';'  {printf("declaracion:   especificadores_de_declaracion     lista_declaradores_init     ;\n");}
           | especificadores_de_declaracion ';'{printf("declaracion:  especificadores_de_declaracion      ;\n");}
           ;

lista_de_declaracion: declaracion {printf("lista_de_declaracion:   declaracion\n");}
                      | lista_de_declaracion declaracion {printf("lista_de_declaracion: lista_de_declaracion     declaracion\n");}
                      ;

especificadores_de_declaracion: especificador_de_tipo especificadores_de_declaracion {printf("especificadores_de_declaracion:   especificador_de_tipo     especificadores_de_declaracion\n");}
                              | especificador_de_tipo {printf("especificadores_de_declaracion:   especificador_de_tipo\n");}
 ;
especificador_de_tipo: VOID {printf("especificador_de_tipo:   void\n");}
                      | INT {printf("especificador_de_tipo:   int\n");}
                      ;

lista_declaradores_init: declarador_init {printf("lista_declaradores_init: declarador_init\n");}
                       | lista_declaradores_init ',' declarador_init {printf("lista_declaradores_init: lista_declaradores_init        ','    declarador_init\n");}
                       ;

declarador_init: declarador {printf("declarador_init:  declarador\n");}
               | declarador '=' inicializador {printf("declarador_init:  declarador '=' inicializador\n");}
               ;

lista_calificador_especificador: especificador_de_tipo lista_calificador_especificador {printf("lista_calificador_especificador: especificador_de_tipo lista_calificador_especificador\n");}
                               | especificador_de_tipo {printf("lista_calificador_especificador: especificador_de_tipo\n");}
;

declarador: apuntador declarador_directo {printf("declarador: apuntador declarador_directo\n");}
          | declarador_directo {printf("declarador:    declarador_directo\n");}
          ;

declarador_directo: ID {printf("declarador_directo:     %s\n",$<idval>1);}
                  | declarador_directo '(' ')'  {printf("declarador_directo:  declarador_directo   (      )\n");}
                  ;

apuntador:'*' apuntador {printf("apuntador: '*' apuntador\n");}
         | '*' {printf("apuntador: '*'\n");}
         ;

inicializador: expresion_de_asignacion {printf("inicializador: expresion_de_asignacion\n");}
             | '{' lista_de_inicializadores '}' {printf("inicializador: '{' lista_de_inicializadores '}'\n");}
             | '{' lista_de_inicializadores ',' '}' {printf("inicializador: '{' lista_de_inicializadores ',' '}'\n");}
             ;

lista_de_inicializadores: inicializador {printf("lista_de_inicializadores: inicializador\n");}
                        | lista_de_inicializadores ',' inicializador {printf("lista_de_inicializadores ',' inicializador\n");}
                        ;

nombre_de_tipo: lista_calificador_especificador declarador_abstracto inicializador {printf("nombre_de_tipo: lista_calificador_especificador declarador_abstracto inicializador\n");}
              | lista_calificador_especificador {printf("nombre_de_tipo: lista_calificador_especificador\n");}
              ;

declarador_abstracto: apuntador {printf("declarador_abstracto: apuntador\n");}
                    | apuntador declarador_abstracto_directo {printf("declarador_abstracto: apuntador declarador_abstracto_directo\n");}
                    | declarador_abstracto_directo {printf("declarador_abstracto: declarador_abstracto_directo\n");}
                    ;

declarador_abstracto_directo: '(' declarador_abstracto ')' {printf("declarador_abstracto_directo: '(' declarador_abstracto ')'\n");}
                            | declarador_abstracto_directo '(' ')' {printf("declarador_abstracto_directo: declarador_abstracto_directo '(' ')'\n");}
                            | '(' ')' {printf("declarador_abstracto_directo: '(' ')'\n");}
                            ;

sentencia: sentencia_expresion {printf("sentencia: sentencia_expresion\n");}
         | sentencia_compuesta {printf("sentencia: sentencia_compuesta\n");}
         | sentencia_de_seleccion {printf("sentencia: sentencia_de_seleccion\n");}
         | sentencia_de_salto {printf("sentencia: sentencia_de_salto\n");}
         ;

sentencia_expresion: expresion ';' {printf("sentencia_expresion: expresion ';'\n");}
                   | ';' {printf("sentencia_expresion: ';'\n");}
                   ;

sentencia_compuesta: '{' lista_de_declaracion lista_de_sentencias '}' {printf("'{' lista_de_declaracion lista_de_sentencias '}'\n");}
                   | '{' lista_de_sentencias '}' {printf("sentencia_compuesta:   {     lista_de_sentencias      }\n");}
                   | '{' lista_de_declaracion '}' {printf("sentencia_compuesta:  '{' lista_de_declaracion '}'\n");}
                   | '{' '}' {printf("sentencia_compuesta:  '{' '}'\n");}
                   ;

lista_de_sentencias: sentencia {printf("lista_de_sentencias:             sentencia\n");}
                   | lista_de_sentencias sentencia {printf("lista_de_sentencias: lista_de_sentencias sentencia\n");}
                   ;

sentencia_de_seleccion: IF '(' expresion ')' sentencia %prec IFX
                      | IF '(' expresion ')' sentencia ELSE sentencia
                      ;

sentencia_de_salto: RETURN expresion ';' {printf("sentencia_de_salto:   return      expresion       ;\n")}
                  | RETURN ';' {printf("sentencia_de_salto:   RETURN ;\n")}
                  ;

expresion: expresion_de_asignacion {printf("expresion:  expresion_de_asignacion\n")}
         | expresion ',' expresion_de_asignacion {printf("expresion:  expresion ',' expresion_de_asignacion \n")}
         ;

expresion_de_asignacion: expresion_condicional {printf("expresion_de_asignacion:  expresion_condicional\n")}
                       | expresion_unaria operador_de_asignacion expresion_de_asignacion {printf("expresion_de_asignacion:  expresion_unaria operador_de_asignacion expresion_de_asignacion\n")}
                       ;

operador_de_asignacion: '=' {printf("operador_de_asignacion: '='\n")}
                      ;

expresion_condicional: expresion_logica_OR {printf("expresion_condicional:                  expresion_logica_OR\n")}
;

expresion_logica_OR: expresion_logica_AND {printf("expresion_logica_OR:            expresion_logica_AND\n")}
                   ;

expresion_logica_AND: expresion_OR_inclusivo {printf("expresion_logica_AND:              expresion_OR_inclusivo\n")}
                    ;

expresion_OR_inclusivo: expresion_OR_exclusivo {printf("expresion_OR_inclusivo:                  expresion_OR_exclusivo\n")}
                      ;

expresion_OR_exclusivo: expresion_AND {printf("expresion_OR_exclusivo:                 expresion_AND\n")}
                      ;

expresion_AND: expresion_de_igualdad {printf("expresion_AND:                 expresion_de_igualdad\n")}
             ;

expresion_de_igualdad: expresion_relacional {printf("expresion_de_igualdad:              expresion_relacional\n")}
                     ;

expresion_relacional: expresion_de_corrimiento {printf("expresion_relacional:                expresion_de_corrimiento\n")}
                    ;

expresion_de_corrimiento: expresion_aditiva {printf("expresion_de_corrimiento:                expresion_aditiva\n")}
                        ;

expresion_aditiva: expresion_multiplicativa {printf("expresion_aditiva:                expresion_multiplicativa\n")}
                 ;

expresion_multiplicativa: expresion_cast {printf("expresion_multiplicativa:               expresion_cast\n")}
                        ;

expresion_cast: expresion_unaria {printf("expresion_cast:            expresion_unaria\n")}
              | '(' nombre_de_tipo ')' expresion_cast 
              ;

expresion_unaria: expresion_postfija  {printf("expresion_unaria:        expresion_postfija\n")}
                | operador_unario expresion_cast
                ;

operador_unario: '*' {printf("operador_unario:   *\n");}
               ;

expresion_postfija: expresion_primaria {printf("expresion_postfija: expresion_primaria\n");}
                  | expresion_postfija '(' lista_expresiones_argumento ')'   {printf("expresion_postfija: expresion_postfija   (    lista_expresiones_argumento    )\n");}
                  | expresion_postfija '(' ')'  {printf("expresion_postfija: expresion_postfija    (      )\n");}
                  ;

expresion_primaria: ID {printf("expresion_primaria: %s\n",$<idval>1);}
            | constante {printf("expresion_primaria:    constante\n");}
            ;

lista_expresiones_argumento: expresion_de_asignacion  {printf("lista_expresiones_argumento:  expresion_de_asignacion\n");}
                           | lista_expresiones_argumento ',' expresion_de_asignacion {printf("lista_expresiones_argumento: lista_expresiones_argumento    ,     expresion_de_asigancion\n");}
                           ;

constante: OCTAL {printf("constante: %d\n",$<ival>1);}
         ;
%%

int main(int argc, char *argv[]) {

	yyin=fopen(argv[1],"r");
   	yyparse();
	fclose(yyin);

	if(analisisCorrecto)
    printf("\nAnalisis finalizado correctamente\n\n\n");


    return 0; }

int yyerror(const char *msg) {
	printf("\nFallo el analisis en la linea: %d %s\n\n\n",yylineno,msg);
	analisisCorrecto = 0;
	return 0; }