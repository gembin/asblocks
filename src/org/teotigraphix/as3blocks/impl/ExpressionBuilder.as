package org.teotigraphix.as3blocks.impl
{

import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

public class ExpressionBuilder
{
	public static function build(ast:IParserNode):IExpressionNode
	{
		switch (ast.kind)
		{
			case AS3NodeKind.PRIMARY:
				return new SimpleNameExpressionNode(ast);
			
			case AS3NodeKind.ARRAY_ACCESSOR:
				return new ArrayAccessExpressionNode(ast);
				
			default:
				throw new Error("");
		}
	}
}
}