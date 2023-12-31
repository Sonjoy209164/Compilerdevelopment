%{
    #include <stdio.h>
    #include <string.h>
    #include "bison.tab.h"

    int variable_count = 0;
    int line_count = 0;
    char previous_code[1000];
%}

%option noyywrap

%}
header             "import"[ ]["tuli"]+[^\n]+[.h][ ]
digit              [0-9]
keywords           "IF"|"ELSE"|"WHILE"|"FOR"|"RETURN"|"CONTINUE"|"BREAK"
identifier         [a-zA-Z_][a-zA-Z_0-9]*
datatype           "INTEGER"|"DOUBLE"|"FLOAT"|"CHARACTER"|"STRING"|"BINARY"
integer            [+-]?{digit}{1,5}
number             ([+-]?[digit]+([\.][digit]+)?(e[+-]?[digit]+))
main               "INT"[\t ]+"MAIN"[\t ]+"START"
singlelinecomment  ("/")[^\n]*  
math_op            "PLUS"|"MINUS"|"MULT"|"DIV"
logical_op			"or"|"and"|"xor"     
%%

"import"[ ]+{IDENTIFIER}[.][h][ ]* {
    return HEADER;
}

";" {
    return EOL;
}

"/>"[ ]* {
    char comment[1000];
    int i = 0;
    while(1) {
        char c = input();
        if(c == '\n' || c == EOF) {
            comment[i] = '\0';
            break;
        }
        comment[i++] = c;
    }
    printf("SINGLELINE COMMENT DETECTED! The Comment is: \n");
    printf("%s\n", comment);
    return SCOMMENT;
}


"number"[ ]+ {
    return NUMBER_TYPE;
}



"--" {
    return DEC;
}
"===" {
    return EQL;
}                                       
"!!!" {
    return NEQL;
}
"<" {
    return LT;
}
">" {
    return GT;
}
"<=" {
    return LEQL;
}
">=" {
    return GEQL;
}
"&&" {
    return AND;
}
"||" {
    return OR;
}
"^^" {
    return XOR;
}
"~~" {
    return NOT;
}
"**" {
    return POW;
}
"sin" {
    return SIN;
}
"cos" {
    return COS;
}
"tan" {
    return TAN;
}
"log10" {
    return LOG10;
}
"log2" {
    return LOG2;
}
"ln" {
    return LN;
}
"sqrt" {
    return SQRT;
}

{IDENTIFIER} {
    yylval.string = strdup(yytext);

    // Check if it's a variable declaration
    if(strcmp(yytext, "int") == 0 || strcmp(yytext, "double") == 0 || strcmp(yytext, "float") == 0 || strcmp(yytext, "char") == 0) {
        variable_count++;
    }

    return VARIABLE;
 }

{INTEGER} {
    yylval.integer = atoi(yytext);
    return NUMBER_VALUE;
}

{DOUBLE} {
    yylval.real = atof(yytext);
    return DECIMAL_VALUE;
}

{STRING} {
    char* tmp = strdup(yytext);
    int n = strlen(tmp);
    yylval.string = malloc(n * sizeof(char));
    memcpy(yylval.string, &tmp[1], n  - 2);
    yylval.string[n - 2]= '\0';
    return STRING_VALUE;
}

[ \t\n] {
    // Count lines
    if(yytext[0] == '\n') {
        line_count++;
    }
}

[-+/*<>=,();%^{}\[\]] {
    return yytext[0];
}

. {
    printf("Unknown Character. %s\n", yytext);
}

%%

int yywrap() {
    return 1;
}

int yyerror(char *s){
    fprintf(stderr,"error: %s\n", s);
    return 1;
}
