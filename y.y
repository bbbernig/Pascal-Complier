%{
    #include <cmath>
    #include <string>
    #include <iostream>
    #include <vector>
	#include <stack>
	#include <map>
	#include <unordered_set>
	#include <fstream>
    #include "dec.h"
	extern FILE* yyin;
	extern int yylineno;
    int       yylex(void);
    void      yyerror(char const *);
	std::stack<symtabele> 	symtab;					//主符号表
	std::stack<symtabeleP> 	indextab;				//索引表
	std::map<std::string,typeAttri> customtypetab;	//全局自定义类型表
	std::map<std::string,funInfo> funtab;			//全局函数表
	std::map<std::string,paraInfo> protab;			//全剧过程表
	std::ofstream out;
%}

%union{
	terminalSAttriP 		terattrip;
	idlistAttriP			idlistattrip;
	typeAttrip				typeattrip;
	periodAttrip			periodattrip;
	periodsAttrip			periodsattrip;
	type_declarationAttrip 	type_declarationattrip;
	var_declarationAttrip 	var_declarationattrip;
	record_bodyAttrip		record_bodyattrip;
	id_varpartAttrip		id_varpartattrip;
	id_varpartsAttrip		id_varpartsattrip;
	expression_listAttrip	expression_listattrip;

	paraInfop				parainfop;		
	double					numer_val;
	TYPEKIND				typekind;
    string                  STRING;
}

/*标识符*/
%token  <terattrip> ID       /*-----[a-zA-Z][a-zA-Z0-9]*----*/

/*常数*/
%token  <terattrip> NUM      /*-------{DIGIT}+(\.{DIGIT}+)?(E[+\-]?{DIGIT}*)?-----*/

 /*关系运算*/
%token  <terattrip> RELOP    /*----'<'|'>'|'<>'|'<='|'>='---------*/      	   

/*关键字*/
%token TYPE
%token PROGRAM
%token PROCEDURE
%token FUNCTION
%token IF
%token ELSE
%token THEN
%token CONST
%token INTEGER
%token BEGINpas
%token END
%token VAR
%token WHILE
%token REAL
%token NOT
%token TO
%token UNTIL
%token OF
%token CHAR
%token FOR
%token BOOLEAN
%token CASE
%token DOWNTO
%token ARRAY
%token RECORD
%token REPEAT
%token OR
%token MOD
%token DIV
%token AND
%token DO

/*标点符号*/
%token COMMA              /*逗号----','*/
%token SEMICOLON          /*分号----';'*/
%token DOT                /*点------'.'*/
%token COLON              /*冒号----':'*/
%token LEFTBRACKETS  	RIGHTBRACKETS             	/*左右圆括号*/
%token LEFTSQUBRACKETS 	RIGHTSQUBRACKETS        	/*左右方括号*/
/*运算符号*/
%token ASSIGNOP           /*赋值----':='*/
%token EQUSIGN            /*等于号---'='*/
%token PLUS               /*加号----'+'*/
%token MINUS              /*减号----'-'*/
%token DIVISION           /*除号----'/'*/
%token MULTIPLY           /*乘号----'*'*/



%nonassoc LOWER_THAN_ELSE /*为了解决if-else的else移进规约冲突，这是个伪token，不用词法分析返回*/
%nonassoc ELSE            /*为了解决if-else的else移进规约冲突*/


/*------------以下为非终结符号的属性声明-----------------*/
%type <idlistattrip> 			idlist
%type <numer_val> 				const_value
%type <typekind>				standard_type
%type <typeattrip>				type
%type <periodattrip>			period
%type <periodsattrip>			periods
%type <type_declarationattrip> 	type_declaration
%type <var_declarationattrip>	var_declaration
%type <record_bodyattrip>		record_body
%type <parainfop>				parameter
%type <parainfop>				parameter_list
%type <parainfop>				formal_parameter
%type <id_varpartattrip>		id_varpart
%type <id_varpartsattrip>		id_varparts
%type <expression_listattrip>	expression_list
/*---------代码生成中的非终结符属性定义---------*/
%type <STRING>                  const_declaration


%%
programstruct:                  program_head  program_body DOT
								{ 
									// std::cout << "\n\nThe following output are purely for play -)---------------------------------------------------------\n"; 
									// std::cout << "The whole analysis process is over.\n\n"; 

									// //打印出所有的自定义数据类型的名字
									// std::cout << "The follows are all the custom defined types:\n"; 
									// for( auto & i : customtypetab ){
									// 	std::cout << i.first << std::endl;
									// }

									// std::cout << " The follows are the main symbol table:\n";
									// auto temps = symtab;
									
									// while( !temps.empty() ){
									// 	std::cout << temps.top().name << std::endl;
									// 	temps.pop();	
									// }
									out.close();
								}
;


program_head:                   PROGRAM ID LEFTBRACKETS idlist RIGHTBRACKETS SEMICOLON
                                {
									//注：input和output暂时没有处理
                                	symtabele * tabelep = new symtabele();
                                	tabelep->name = $2->id_name;
                                	tabelep->kind = PROGRAMt;
                                	tabelep->constornot = false;
                                	tabelep->tinfop = NULL;                                  
                                	symtab.push(*tabelep);
                                	delete(tabelep);							//这delete的顺序不能随意改变
                                  	tabelep = &symtab.top();
                                  	indextab.push(tabelep);
									

									/*-----以上为语义分析部分，已完成--------*/

									out << "#include <stdlib.h>\n";
									out << "#include <stdio.h>\n";
                                    out << "\n"
                                    out << "#define bool int\n"
                                    out << "#define true 1\n"
                                    out << "#define false 0\n"
                                    out << "\n";

								
                                    delete($2);
									delete($4);
                                }
;


program_body:                   const_declarations type_declarations var_declarations subprogram_declarations compound_statement
								{
									out << "int main()\n";
									out << "{\n";
									out << "//these are statement which we can get from the compound_statement's property\n";
									out << "//所以，compound_statement的属性应该是一个字符串\n";
									out << "return 0}\n";
								}
;

idlist:                         idlist COMMA ID 
                                { 
									$$ = new(idlistAttri);
                                  	for( auto & i: $1->ids ){
                                	 	$$->ids.push_back(i);
                                  	}
                                    $$->ids.push_back($3->id_name);

									/*-----以上为语义分析部分，已完成--------*/

									delete($1);
									delete($3);
                                }
                               | ID 
                                {
									$$ = new(idlistAttri);
									$$->ids.push_back($1->id_name);

									/*-----以上为语义分析部分，已完成--------*/

									delete($1);
                                }
;
const_declarations:             CONST const_declaration SEMICOLON
                                | empty
{
    out << const_declaration;
}
;
const_declaration:              const_declaration SEMICOLON ID EQUSIGN const_value
                                {
                                  	symtabele * tabelep = new symtabele();
                                	tabelep->name = $3->id_name;
                                	tabelep->kind = REALt;
                                	tabelep->constornot = true;
                                	tabelep->tinfop = NULL;                                  
                                	symtab.push(*tabelep);
									/*-----以上为语义分析部分，已完成--------*/
									const_declaration+="const ";
                                    const_declaration+="double ";
                                    const_declaration+=$3->id_name;
                                    const_declaration+="=";
                                    const_declaration+=$5;
                                    const_declaration+=";";
                                    const_declaration+="\n";
                                    /*------代码生成部分------*/
                                    delete(tabelep);
                                }
                                | ID EQUSIGN const_value
                                {
                                  	symtabele * tabelep = new symtabele();
                                	tabelep->name = $1->id_name;
                                	tabelep->kind = REALt;
                                	tabelep->constornot = true;
                                	tabelep->tinfop = NULL;                                  
                                	symtab.push(*tabelep);
									/*-----以上为语义分析部分，已完成--------*/
                                    const_declaration+="const ";
                                    const_declaration+="double ";
                                    const_declaration+=$1->id_name;
                                    const_declaration+="=";
                                    const_declaration+=$3;
                                    const_declaration+=";";
                                    const_declaration+="\n";
                                    /*------代码生成部分------*/


                                	delete(tabelep);
                                }
;
const_value:                    PLUS ID     
								{
									auto temps = symtab;
									bool flag = 0;
									while( !temps.empty() ){
										if( temps.top().name == $2->id_name){
											flag = 1;
											break;
										}
										else{
											temps.pop();
										}
									}
									if( flag == 0){
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The variable "<< '\'' <<$2->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/
                                    out << "+";
                                    const_value=$2->id_name;
                                    /*------代码生成部分----有错误--*/
								}
                                | MINUS ID
								{
									auto temps = symtab;
									bool flag = 0;
									while( !temps.empty() ){
										if( temps.top().name == $2->id_name){
											flag = 1;
											break;
										}
										else{
											temps.pop();
										}
									}
									if( flag == 0){
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The variable "<< '\'' <<$2->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/
                                    out << "-";
                                    const_value=$2->id_name;
                                    /*------代码生成部分------*/
                                    
								}
                                | ID        
								{
									auto temps = symtab;
									bool flag = 0;
									while( !temps.empty() ){
										if( temps.top().name == $1->id_name){
											flag = 1;
											break;
										}
										else{
											temps.pop();
										}
									}
									if( flag == 0){
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The variable "<< '\'' <<$1->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/
                                    
                                    const_calue=$1->id-name;
                                    /*------代码生成部分------*/
                                    
								}
                                | PLUS NUM	
								{ 
									$$ = $2->val; 	
									/*-----以上为语义分析部分，完成--------*/
                                    out << "+";
                                    const_value=$2->val;
                                    /*------代码生成部分------*/
                                    
								}
                                | MINUS NUM 
								{ 
									$$ = -$2->val; 
									/*-----以上为语义分析部分，完成--------*/
                                    out << "-";
                                    const_value=$2->val;
                                    /*------代码生成部分------*/
                                    
								}
                                | NUM 		
								{ 
									$$ = $1->val; 	
									/*-----以上为语义分析部分，完成--------*/
                                    const_value=$1->val;
                                    /*------代码生成部分------*/
                                    
								}
;



type_declarations:              TYPE type_declaration SEMICOLON
                                | empty
;
type_declaration:               type_declaration SEMICOLON ID EQUSIGN  type
								{
									customtypetab.insert(std::pair<std::string,typeAttri>($3->id_name,*($5)));
									/*-----以上为语义分析部分，已完成--------*/
									
								}
								
                                | ID EQUSIGN type
								{
									customtypetab.insert(std::pair<std::string,typeAttri>($1->id_name,*($3)));
									/*-----以上为语义分析部分，已完成--------*/
									
								}
;

type:                           standard_type
								{
									$$ = new(typeAttri);
									$$->kind = $1;
									/*-----以上为语义分析部分，已完成--------*/
									
								}
                                | RECORD record_body END
								{
									$$ = new(typeAttri);
									$$->kind = RECORDt;
									$$->records = *$2;
									/*-----以上为语义分析部分，已完成--------*/
									
								}
                                | ARRAY LEFTSQUBRACKETS periods RIGHTSQUBRACKETS OF type
								{
									$$ = new(typeAttri);
									$$->kind = ARRAYt;
									$$->periods = *$3;
									$$->arraytp = $6;
									/*-----以上为语义分析部分，已完成--------*/
									
								}
;

standard_type:                  INTEGER 	{ $$ = INTEGERt	}
                                | REAL 		{ $$ = REALt	}
                                | BOOLEAN 	{ $$ = BOOLEANt }
                                | CHAR		{ $$ = CHARt	}
;

record_body:                    var_declaration
								{ 
									$$ = new(record_bodyAttri);
									*($$) = *($1);
									/*-----以上为语义分析部分，已完成--------*/
									
								}
                                | empty
								{
									$$ = new(record_bodyAttri);
									/*-----以上为语义分析部分，已完成--------*/
									
								}
;

periods:                        periods COMMA period
								{
									$$ = new(periodsAttri);
									for( auto &i : *($1) ){
										$$->push_back(i);
									}
									for( auto &i : *($3) ){
										$$->push_back(i);
									}
									/*-----以上为语义分析部分，已完成--------*/
									
								}
                                | period
								{
									$$ = new(periodsAttri);
									for( auto &i : *($1) ){
										$$->push_back(i);
									}
									/*-----以上为语义分析部分，已完成--------*/
									
								}
;

period:                         const_value DOT DOT const_value
								{
									$$ = new(periodAttri);
									$$->push_back($1);
									$$->push_back($4);
									/*-----以上为语义分析部分，已完成--------*/
									
								}
;



var_declarations:               VAR var_declaration SEMICOLON
								{
									for( auto & i : *($2) ){
										symtabele * tabelep = new symtabele();
                                		tabelep->name = i.first;
                                		tabelep->kind = i.second->kind;
                                		tabelep->constornot = false;
                                		tabelep->tinfop = i.second;                                  
                                		symtab.push(*tabelep);
										
                                		delete(tabelep);
									}
									/*-----以上为语义分析部分，已完成--------*/
									
								}
                                | empty
;


var_declaration:                var_declaration SEMICOLON idlist COLON type
								{
									$$ = new(var_declarationAttri);
									for( auto &i : *($1) ){
										$$->insert(i);
									}
									for( auto &i : $3->ids ){
										$$->insert(std::pair<std::string, typeAttrip>(i,$5));
									}
									/*-----以上为语义分析部分，已完成--------*/
									
								}
								|
								var_declaration SEMICOLON idlist COLON ID
								{
									$$ = new(var_declarationAttri);
									for( auto &i : *($1) ){
										$$->insert(i);
									}
									//查全局的自定义类型表，把自定义类型的类型树
									/*-----以上为语义分析部分，完成--------*/
									auto iter = customtypetab.find($5->id_name);
									if( iter != customtypetab.end() ){
										
										for( auto &i : $3->ids ){
											$$->insert(std::pair<std::string, typeAttrip>(i,&((*iter).second)) );
										}
									}else{
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The type "<< '\'' <<$5->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/
									
								}
								| idlist COLON type
								{
									$$ = new(var_declarationAttri);
									for( auto &i : $1->ids ){
										$$->insert(std::pair<std::string, typeAttrip>(i,$3));
									}
									/*-----以上为语义分析部分，已完成--------*/
									
								}
								
								| idlist COLON ID
								{
									$$ = new(var_declarationAttri);
									//查全局的自定义类型表，把自定义类型的类型树
									
									auto iter = customtypetab.find($3->id_name);
									if( iter != customtypetab.end() ){
										
										for( auto &i : $1->ids ){
											$$->insert(std::pair<std::string, typeAttrip>(i,&((*iter).second)) );
										}
									}else{
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The type "<< '\'' <<$3->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/									
								}
                                
;





subprogram_declarations:        subprogram_declarations subprogram SEMICOLON
								{
									//释放块
									auto pointer = indextab.top();
									indextab.pop();
									while( &(symtab.top()) != pointer){
										symtab.pop();
                                        
									}
									symtab.pop();
									/*-----以上为语义分析部分，完成--------*/
								}
                                | empty
;


subprogram:                     subprogram_head  subprogram_body
;
{string subprogram_head;}

subprogram_head:                PROCEDURE ID formal_parameter SEMICOLON
								{
									symtabele * tabelep = new symtabele();
                                	tabelep->name = $2->id_name;
                                	tabelep->kind = PROCEDUREt;
                                	tabelep->constornot = false;
									tabelep->dimension = $3->size();
                                	tabelep->tinfop = NULL;
									tabelep->parainfop  =  $3;                        
                                	symtab.push(*tabelep);
									tabelep = &symtab.top();
                                  	indextab.push(tabelep);
									

									protab.insert(std::pair<std::string,paraInfo>($2->id_name,*$3));
									/*-----以上为语义分析部分，完成--------*/


								}
                                | FUNCTION ID formal_parameter COLON standard_type SEMICOLON
								{
									symtabele * tabelep = new symtabele();
                                	tabelep->name = $2->id_name;
                                	tabelep->kind = FUNCTIONt;
                                	tabelep->constornot = false;
									tabelep->dimension = $3->size();
                                	tabelep->tinfop = NULL;
									tabelep->parainfop  =  $3;
									tabelep->rekind = $5;                        
                                	symtab.push(*tabelep);
									tabelep = &symtab.top();
                                  	indextab.push(tabelep);
									

									funInfop finfop = new(funInfo);
									finfop->returntype = $5;
									finfop->parainfo = *$3;
									funtab.insert(std::pair<std::string,funInfo>($2->id_name,*finfop));
									delete finfop;
									/*-----以上为语义分析部分，完成--------*/
								}
;

formal_parameter:               LEFTBRACKETS parameter_list RIGHTBRACKETS
								{
									$$ = new(paraInfo);
									for( auto &i : *($2) ){
										$$->insert(i);
									}
									/*-----以上为语义分析部分，完成--------*/
								}
                                | empty
								{
									$$ = new(paraInfo);
									/*-----以上为语义分析部分，完成--------*/
								}
;

parameter_list:                 parameter_list SEMICOLON parameter
								{
									$$ = new(paraInfo);
									for( auto &i : *($1) ){
										$$->insert(i);
									}
									for( auto &i : *($3) ){
										$$->insert(i);
									}
									/*-----以上为语义分析部分，完成--------*/
								}
                                | parameter
								{
									$$ = new(paraInfo);
									for( auto &i : *($1) ){
										$$->insert(i);
									}
									/*-----以上为语义分析部分，完成--------*/
								}
;


parameter:                      idlist COLON standard_type
								{
									$$ = new(paraInfo);
									for( auto &i : $1->ids ){
										$$->insert(std::pair<std::string, TYPEKIND>(i,$3));
									}
									/*-----以上为语义分析部分，完成--------*/
								}
;




subprogram_body:                const_declarations var_declarations compound_statement
;

compound_statement:             BEGINpas statement_list END
								
;


statement_list:                 statement_list SEMICOLON statement
                                | statement
;



statement:                      variable ASSIGNOP expression{/*类型检查*/}
                                | procedure_call
                                | compound_statement
                                | IF expression THEN statement %prec LOWER_THAN_ELSE{/*类型检查*/}
                                | IF expression THEN statement ELSE statement{/*类型检查*/}
                                | CASE expression OF case_body END
                                | WHILE expression DO statement{/*类型检查*/}
                                | REPEAT statement_list UNTIL expression
                                | FOR ID ASSIGNOP expression updown expression DO statement
								{/*类型检查*/
								
								
								
								/*作用域检查*/
									auto temps = symtab;
									bool flag = 0;
									while( !temps.empty() ){
										if( temps.top().name == $2->id_name){
											flag = 1;
											break;
										}
										else{
											temps.pop();
										}
									}
									if( flag == 0){
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The variable "<< '\'' <<$2->id_name << '\'' <<" has not been decleared yet.\n";
									}
									/*-----以上为语义分析部分，完成--------*/

								}
                                | empty
;




variable:                       ID id_varparts
								{
									/*作用域检查*/
									auto temps = symtab;
									bool flag = 0;
									while( !temps.empty() ){
										if( temps.top().name == $1->id_name){
											flag = 1;
											break;
										}
										else{
											temps.pop();
										}
									}
									if( flag == 0){
										std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The variable "<< '\'' <<$1->id_name << '\'' <<" has not been decleared yet.\n";
									}else{
										/*在这个地方进行数组维数检查，结构体成员变量检查*/

										//先进行结构体成员变量检查
										if( temps.top().tinfop->kind  == RECORDt ){
										
											auto temppp = temps.top().tinfop;
											for( auto &i : $2->ss){
												auto iter =  temppp->records.find(i);
												if( iter  != temppp->records.end() ){
													temppp = iter->second;
												}else{
													std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The member variables "<< '\'' << i << '\'' <<" has not been decleared yet.\n";
													break;
												}
											}
										}//结构体成员变量检查
										else{
											if( temps.top().tinfop->kind  == ARRAYt ){
												if( temps.top().tinfop->periods.size()/2 != $2->dimension){
													std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The array variable "<< '\'' << $1->id_name << '\'' <<"\'s dimension is not correct.\n";
												}
											}//数组维数检查
										}
										

									}


									/*-----以上为语义分析部分，完成--------*/

								}
;



id_varparts:                    id_varparts id_varpart
								{
									$$ = new(id_varpartsAttri);
									for( auto & i: $1->ss ){
										$$->ss.push_back(i);
									}
									$$->ss.push_back($2->s);
									$$->dimension = $2->dimension;
									/*-----以上为语义分析部分，完成--------*/
								}
                                | empty
								{
									$$ = new(id_varpartsAttri);
									/*-----以上为语义分析部分，完成--------*/
								}
;



id_varpart:                     LEFTSQUBRACKETS expression_list RIGHTSQUBRACKETS
								{
									$$ = new(id_varpartAttri);
									$$->dimension = $2->dimension;
									/*-----以上为语义分析部分，完成--------*/
								}
                                | DOT ID
								{
									$$ = new(id_varpartAttri);
									$$->s = $2->id_name;
									/*-----以上为语义分析部分，完成--------*/
								}
;

case_body:                      branch_list
                                | empty
;

branch_list:                    branch_list SEMICOLON branch
                                | branch
;


branch:                         const_list COLON statement
;

const_list:                     const_list COMMA const_value
                                | const_value   
;


procedure_call:                 ID 
								{
									auto iter1 = funtab.find($1->id_name);
									if( iter1 == funtab.end() ){
										auto iter2 = protab.find($1->id_name);
										if( iter2 == protab.end() ){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure or function "<< '\'' << $1->id_name << '\'' <<"has not been declared.\n";
										}else{
											if( iter2->second.size() != 0){
												std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
											}
										}
									}else{
										if( iter1->second.parainfo.size() != 0){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The function "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
										}
									}
									/*-----以上为语义分析部分，完成--------*/
								}
                                | ID LEFTBRACKETS expression_list RIGHTBRACKETS
								{
									auto iter1 = funtab.find($1->id_name);
									if( iter1 == funtab.end() ){
										auto iter2 = protab.find($1->id_name);
										if( iter2 == protab.end() ){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure or function "<< '\'' << $1->id_name << '\'' <<"has not been declared.\n";
										}else{
											if( iter2->second.size() != $3->dimension){
												std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
											}
										}
									}else{
										if( iter1->second.parainfo.size() != $3->dimension){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The function "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
										}
									}
									/*-----以上为语义分析部分，完成--------*/
								}
;


updown:                         TO 
                                | DOWNTO
;



expression_list:                expression_list COMMA expression 
								{
									$$ = new(expression_listAttri);
									$$->dimension = $1->dimension  + 1;
									/*-----以上为语义分析部分，完成--------*/
								}
                                | expression
								{
									$$ = new(expression_listAttri);
									$$->dimension = 1;
									/*-----以上为语义分析部分，完成--------*/
								}
;



expression:                     simple_expression RELOP simple_expression
                                | simple_expression EQUSIGN simple_expression
                                | simple_expression
;



simple_expression:              term
                                | PLUS term
                                | MINUS term
                                | simple_expression PLUS term
                                | simple_expression MINUS term
                                | simple_expression OR term
;


term:                           factor
                                | term MULTIPLY factor
                                | term DIVISION factor
                                | term DIV factor
                                | term MOD factor
                                | term AND factor
;


factor:                         NUM
                                | variable
                                | ID LEFTBRACKETS expression_list RIGHTBRACKETS
								{
									auto iter1 = funtab.find($1->id_name);
									if( iter1 == funtab.end() ){
										auto iter2 = protab.find($1->id_name);
										if( iter2 == protab.end() ){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure or function "<< '\'' << $1->id_name << '\'' <<"has not been declared.\n";
										}else{
											if( iter2->second.size() != $3->dimension){
												std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The procedure "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
											}
										}
									}else{
										if( iter1->second.parainfo.size() != $3->dimension){
											std::cerr << "ERROR: Line " <<yylineno << "\t"<<"The function "<< '\'' << $1->id_name << '\'' <<"\'sParameter does not match.\n";
										}
									}
									/*-----以上为语义分析部分，完成--------*/
								}
                                | LEFTBRACKETS expression RIGHTBRACKETS
                                | NOT factor
;

empty:

%%

#include <cctype>
#include <cstdio>
#include <vector>
#include <stack>
#include <fstream>
#include <iostream>



int main (int argc, char** argv)
{
	out.open("result.c",std::ios::out);
	if( argc <= 1 ){
		return yyparse ();
	}else{
		FILE * file = fopen (argv[1], "r");
		if( !file ){
			perror(argv[1]);
			return 1;
		}else{
			yyin = file;
			return yyparse();
		}
	}
}


/* Called by yyparse on error.  */
void yyerror (char const *s)
{
	std::cout << "line " << yylineno;
	fprintf (stderr, "%s\n", s);
}


