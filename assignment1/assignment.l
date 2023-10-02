

%{   
    // flex assignment.l
    // g++ lex.yy.c -o app
#include<bits/stdc++.h>
using namespace std;


string x; // here x is for storing yytext
	int count_of_identifiers = 0;
	int count_of_keywords = 0;
	int count_of_statements = 0;
    int count_of_integers = 0;
    int count_of_preprocessors = 0;

void print(string comment, string message) {
		// cout << message << " is a " << comment << "\n";
		cout << "input : " << message << "\n";
		cout << "token : " << comment << "\n\n";
	}



%}

identifier   		[a-zA-Z_][a-zA-Z_0-9]{0,31}
integer             [0-9]+
Preprocessor        (#include|#define|#undef|#if|#ifdef|#ifndef|#elif|#else|#endif|#line|#error|#pragma|#import)


%%
{identifier}    	{x = yytext; print("identifier",  x); count_of_identifiers++;}
{integer}           {x = yytext; print("integer", x); count_of_integers++;}
{Preprocessor}      {x=yytext; print("Preprocessor",x); count_of_preprocessors++;}


%%

int yywrap()
{
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

int main()
{
	// replaceNewlinesWithWhitespace("input.txt");
	//yyin = freopen("temp", "r", stdin);
	yyin = freopen("input.txt", "r", stdin);
	//yyout = freopen("output.txt", "r", stdout);
	cout << "Evaluation is running...\n";
	yylex();

	cout << "Total identifiers found: " << count_of_identifiers << "\n";
	cout << "Total keywords found   : " << count_of_keywords << "\n";
	cout << "Total statements fountd: " << count_of_statements << "\n";
    cout << "Total integer fountd: " << count_of_integers << "\n";
    cout << "Total Preprocessors fountd: " << count_of_preprocessors << "\n";
	return 0;
}