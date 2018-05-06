#ifndef DEC_H
#define DEC_H

#include <string>
#include <vector>
#include <map>


enum TYPEKIND{INTEGERt, REALt, CHARt, BOOLEANt, 
            RECORDt, 
            ARRAYt, 
            FUNCTIONt, 
            PROCEDUREt, 
            PROGRAMt
};

typedef struct terminalSAttri{
    bool    leafMark;	        // 叶子阶段标记
    int     nodeSym;            // 产生式序号
    std::string m_type;         // 记录单词类型
	std::string id_name;        // id的名名字
    double val;                 // num的属性值
    terminalSAttri* father;     // 父亲节点
    terminalSAttri* child;      // 孩子节点

    terminalSAttri(){
        id_name = "";
        val = 0;
    }
}terminalSAttri,*terminalSAttriP;

typedef struct idlistAttri{
    std::vector<std::string> ids;
}idlistAttri,*idlistAttriP;

typedef struct typeAttri {
	TYPEKIND kind;
    std::map<std::string, struct typeAttri *> records;	    //存名字和类型
	std::vector<double> periods;				            //数组的范围
    struct typeAttri * arraytp;                             //数组类型信息
}typeAttri,*typeAttrip;

typedef std::map<std::string, typeAttrip> type_declarationAttri,*type_declarationAttrip;
typedef std::map<std::string, typeAttrip> var_declarationAttri,*var_declarationAttrip;
typedef std::map<std::string, typeAttrip> record_bodyAttri,*record_bodyAttrip;
typedef std::map<std::string, TYPEKIND> paraInfo,*paraInfop;
typedef std::vector<double> periodAttri,*periodAttrip;
typedef std::vector<double> periodsAttri,*periodsAttrip;

typedef struct id_varpartAttri{
    std::string s;
    unsigned int dimension;
} id_varpartAttri,*id_varpartAttrip;

typedef struct id_varpartsAttri{
    std::vector<std::string> ss;
    unsigned int dimension;
} id_varpartsAttri,*id_varpartsAttrip;

typedef struct expression_listAttri{
    unsigned int dimension;
} expression_listAttri,*expression_listAttrip;


typedef struct funInfo{
    paraInfo parainfo;
    TYPEKIND returntype;
}funInfo,*funInfop;


//符号表每一行都有些啥
typedef struct symtabele{
    std::string name;				    // 标识符名
    TYPEKIND kind;					    // 标识符种类
    bool constornot;				    // 是否为const变量
    unsigned int dimension;			    // 维数，函数就存参数个数，数组存维数，record存变量个数，简单变量就存0就行
    typeAttri *tinfop;				    // 类型信息，用于类型检查
	paraInfop    parainfop;             // 用于存储过程或者是函数参数的信息
    TYPEKIND rekind;                    // 存储函数返回值信息
    //unsigned int decline;			    // 声明行
	//unsigned int referline;			// 引用行
	//symtabele* link;				    // 链域

}symtabele,*symtabeleP;

#endif // !DEC_H

