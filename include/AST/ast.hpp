#ifndef __AST_H__
#define __AST_H__

#include "loc.h"
#include <stdint.h>
#include <memory>
#include <string>
#include <vector>

#define NODE_DELETE(NODE)				
		if((NODE) != nullptr){			\
			delete((NODE));				\
			(NODE) = nullptr;			\
		}
#define NODELIST_PTR_DELETE(NODELIST_PTR)						
		if((NODELIST_PTR) != nullptr){							\
			for(uint i = 0; i < (NODELIST_PTR)->size; i++){		\
				delete(*(NODELIST_PTR)[i]);						\
				*(NODELIST_PTR)[i] = nullptr;					\
			}													\
			delete((NODELIST_PTR));								\
			(NODELIST_PTR) = nullptr;							\	
		}														\

using namespace std;
/* It's just for reference,
 * you can design your own
 * struct or class to impl inheritance in c/cpp */
typedef vector<class ASTNodeBase *> NodeList;
typedef class ASTNodeBase Node;

enum EnumOperator{
	OP_ASSIGN,	// :=
	OP_OR,		// or
	OP_AND,		// and
	OP_NOT,		// not
	OP_ADD,		// +
	OP_SUB,		// -
	OP_MUL,		// *
	OP_DIV,		// /
	OP_GT,		// >
	OP_LT,		// <
	OP_EQ,		// =
	OP_GET,		// >=
	OP_LET,		// <=
	OP_NEQ,		// !=
	UNKNOWN_OP
}

enum EnumTypeSet{
	SET_SCALAR = 100,
	SET_ACCUMLATED,
	SET_CONSTANT_LITERAL,
	UNKNOWN_SET
}

enum EnumType{
	TYPE_INTEGER = 200,
	TYPE_REAL,
	TYPE_STRING,
	TYPE_VOID,
	UNKNOWN_TYPE
}

struct IntPair{
	int start;
	int end;
}

struct IdentifierInfo{
	string name;
	uint32_t line_no;
	uint32_t col_no;
};

struct VariableInfo{
	EnumTypeSet type_set;
	EnumType type;
	vector<IntPair> array_range;
	int int_literal;
	double real_literal;
	string string_literal;

	VariableInfo(){
		this->type_set = UNKNOWN_SET;
		this->type = UNKNOWN_SET;
	}
	VariableInfo(EnumTypeSet _type_set, EnumType _type){
		this->type_set = _type_set;
		this->type = _type;
	}
	VariableInfo(EnumTypeSet _type_set, EnumType _type, int _int_literal){
		this->type_set = _type_set;
		this->type = _type;
		this->int_literal = _int_literal;
	}
	VariableInfo(EnumTypeSet _type_set, EnumType _type, double _real_literal){
		this->type_set = _type_set;
		this->type = _type;
		this->real_literal = _real_literal;
	}
	VariableInfo(EnumTypeSet _type_set, EnumType _type, string _string_literal){
		this->type_set = _type_set;
		this->type = _type;
		this->string_literal = _string_literal;
	}
};

struct NodeWithType{
	Node node;
	VariableInfo *type;
	uint counter;
};

class ASTNodeBase{
	public:
		int line_no;
		int col_no;
		string name;

	public:
		virtual void accept(class &ASTVisitorBase &v) = 0;
		virtual ~ASTNodeBase(){};
};

#endif
