package org.as3commons.asblocks.utils
{

import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.impl.ExpressionBuilder;
import org.as3commons.asblocks.impl.TokenBuilder;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.impl.ASTIterator;

public class ArgumentUtil
{
	public static function getArguments(ast:IParserNode):Vector.<IExpression>
	{
		var result:Vector.<IExpression> = new Vector.<IExpression>();
		if (!ast)
			return result;
		
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			result.push(ExpressionBuilder.build(i.next()));
		}
		
		return result;
	}
	
	public static function setArguments(callAST:IParserNode, arguments:Vector.<IExpression>):void
	{
		var ast:IParserNode = ASTUtil.newParentheticAST(
			AS3NodeKind.ARGUMENTS,
			AS3NodeKind.LPAREN, "(",
			AS3NodeKind.RPAREN, ")");
		
		if (callAST.numChildren == 2)
		{
			callAST.setChildAt(ast, 1);
		}
		else
		{
			callAST.addChild(ast);
		}
		
		if (arguments == null)
			return;
		
		var len:int = arguments.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IExpression = arguments[i] as IExpression;
			ast.addChild(element.node);
			if (i < len - 1)
			{
				ast.appendToken(TokenBuilder.newComma());
				ast.appendToken(TokenBuilder.newSpace());
			}
		}
	}
}
}