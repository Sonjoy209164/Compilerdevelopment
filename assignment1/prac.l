%{
#include <bits/stdc++.h>
using namespace std;

string x;
int count_of_identifiers = 0;
int count_of_keywords = 0;
int count_of_statements = 0;
int inc = 0;
int inf = 0;

void print(string comment, string message) {
    cout << "input : " << message << "\n";
    cout << "token : " << comment << "\n\n";
}
%}

iff_condition        ("if"|"else if"|"else")
Preprocessor        (#include|#define|#undef|#if|#ifdef|#ifndef|#elif|#else|#endif|#line|#error|#pragma|#import)
singleline          (>>)[^\n]*
multiline           (>>>)(.|\n)*(<<<)

identifier          [a-zA-Z_][a-zA-Z_0-9]{0,31}
datatype            ("int"|"real"|"char"|"string"|"bin")
string              [\"].*[\"]
int                 [\+\-]?[0-9]+
real                ({int}([\.]{int})?(e[\+\-]?{int})|{int}([\.]{int}))
bin                 ("false"|"true")
char                ("'\\n'"|[\'][^\n][\'])
eof                 ([\n]|";")
algebric_op         (\+|\-|\*|\/|%|\**)
ass_op              =
ass_init            (\+=|\-=|\*=|\/=|%=|&=|\|=|\^=|<<=|>>=)
com_op              ("==="|"!!!"|<|>|<=|>=)
logical_op          ("or"|"and"|"xor")
bitwise_op          (&|\|\^|>>|<<)
inc                 (inc)[ ]
dec                 (dec)[ ]
comma               ,
skip                ("continue")
back                ("return")
stop                ("break")
for 				("for")[ ]{identifier}[ ]("in")[ ]{identifier}
while_loop          ("while")[ ]
returntype          ({datatype}|"void")
routine             ("function"[ ]{identifier}[ ]*[\(].*[\)][ ]*:[ ]*{returntype}[ ]*[\{].*[\}])

%%

[ ]                 {}
{singleline}        {x = yytext; print("singleline comment", x);}
{multiline}         {x = yytext; print("multiline comment", x);}
{bin}               {x = yytext; print("bin",  x);}
{skip}|{back}|{stop} {x = yytext; print("keyword", x); count_of_keywords++;}
{eof}               {count_of_statements++;}
{logical_op}        {x = yytext; print("logical_operator",  x);}
{com_op}            {x = yytext; print("comparison operator",  x);}
{datatype}          {x = yytext; print("datatype",  x); count_of_keywords++;}
{iff_condition}     {x = yytext;  print("if condition", x); inf++;}
{identifier}        {x = yytext; print("identifier",  x); count_of_identifiers++;}
{string}            {x = yytext; print("string",  x);}
{int}               {x = yytext; print("int",  x);}
{real}              {x = yytext; print("real",  x);}
{char}              {x = yytext; print("char",  x);}
{algebric_op}       {x = yytext; print("algebric_op",  x);}
{ass_op}            {x = yytext; print("assignment operator",  x);}
{ass_init}          {x = yytext; print("operation with assignment",  x);}
{bitwise_op}        {x = yytext; print("bitwise operator",  x);}
{inc}               {x = yytext; print("indec_operator",  x); inc++;}
{dec}               {x = yytext; print("indec_operator",  x); inc++;}
{comma}             {x = yytext; print("comma operator",  x);}
{for}               {x = yytext; print("for loop", x);}
{while_loop}        {x = yytext; print("while loop", x); }
{routine}           {x = yytext; print("subroutine", x);}
.                   {}
%%

int yywrap() {
    return 1;
}

void replaceNewlinesWithWhitespace(const std::string filename) {
    std::ifstream inputFile(filename);
    if (!inputFile) {
        std::cerr << "Error: Unable to open input file." << std::endl;
        return;
    }
    std::string content;
    std::string line;
    while (std::getline(inputFile, line)) {
        content += line + " ";
    }
    inputFile.close();
    std::ofstream outputFile("temp");
    if (!outputFile) {
        std::cerr << "Error: Unable to open output file." << std::endl;
        return;
    }
    outputFile << content;
    outputFile.close();
}

int main() {
    yyin = freopen("input.txt", "r", stdin);
    cout << "Evaluation is running...\n";
    yylex();
    cout << "Total identifiers found: " << count_of_identifiers << "\n";
    cout << "Total keywords found   : " << count_of_keywords << "\n";
    cout << "Total statements found : " << count_of_statements << "\n";
    cout << "Total if-else statements found : " << inf << "\n";
    return 0;
}
