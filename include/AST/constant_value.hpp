#ifndef __CONSTANT_VALUE_H__
#define __CONSTANT_VALUE_H__

#include "ast.hpp"

class ConstantValueNode : public ASTNodeBase {
	public:
		VariableInfo *constant_info;

	public:
		ConstantValueNode(int _line_no, int _col_no,
			VariableInfo *_constant_info);
		~ConstantValueNode();
		void accept(class &ConstantValueNode &v){};
};

#endif