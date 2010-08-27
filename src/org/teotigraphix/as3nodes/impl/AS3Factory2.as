package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3blocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.api.IArrayLiteralNode;
import org.teotigraphix.as3blocks.api.IAssignmentExpressionNode;
import org.teotigraphix.as3blocks.api.IBooleanLiteralNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.api.IFunctionLiteralNode;
import org.teotigraphix.as3blocks.api.INullLiteralNode;
import org.teotigraphix.as3blocks.api.INumberLiteralNode;
import org.teotigraphix.as3blocks.api.IObjectLiteralNode;
import org.teotigraphix.as3blocks.api.ISimpleNameExpressionNode;
import org.teotigraphix.as3blocks.api.IStringLiteralNode;
import org.teotigraphix.as3blocks.api.IUndefinedLiteralNode;
import org.teotigraphix.as3blocks.impl.ASTBuilder;
import org.teotigraphix.as3blocks.impl.ArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.impl.ArrayLiteralNode;
import org.teotigraphix.as3blocks.impl.BooleanLiteralNode;
import org.teotigraphix.as3blocks.impl.ExpressionBuilder;
import org.teotigraphix.as3blocks.impl.FunctionLiteralNode;
import org.teotigraphix.as3blocks.impl.NullLiteralNode;
import org.teotigraphix.as3blocks.impl.NumberLiteralNode;
import org.teotigraphix.as3blocks.impl.ObjectLiteralNode;
import org.teotigraphix.as3blocks.impl.SimpleNameExpressionNode;
import org.teotigraphix.as3blocks.impl.StringLiteralNode;
import org.teotigraphix.as3blocks.impl.TokenBuilder;
import org.teotigraphix.as3blocks.impl.UndefinedLiteralNode;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.impl.AS3FragmentParser2;

public class AS3Factory2
{
	protected static var adapter:LinkedListTreeAdaptor = new LinkedListTreeAdaptor();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Factory2()
	{
		super();
	}
	
	public function newNumberLiteral(number:Number):INumberLiteralNode
	{
		return new NumberLiteralNode(ASTUtil2.newAST(AS3NodeKind.NUMBER, number.toString()));
	}
	
	public function newNullLiteral():INullLiteralNode
	{
		return new NullLiteralNode(ASTUtil2.newAST(AS3NodeKind.NULL, KeyWords.NULL));
	}
	
	public function newUndefinedLiteral():IUndefinedLiteralNode
	{
		return new UndefinedLiteralNode(ASTUtil2.newAST(AS3NodeKind.UNDEFINED, KeyWords.UNDEFINED));
	}
	
	public function newBooleanLiteral(boolean:Boolean):IBooleanLiteralNode
	{
		var kind:String = (boolean) ? AS3NodeKind.TRUE : AS3NodeKind.FALSE;
		var text:String = (boolean) ? KeyWords.TRUE : KeyWords.FALSE;
		return new BooleanLiteralNode(ASTUtil2.newAST(kind, text));
	}
	
	public function newStringLiteral(string:String):IStringLiteralNode
	{
		return new StringLiteralNode(ASTUtil2.newAST(AS3NodeKind.STRING, ASTBuilder.escapeString(string)));
	}
	
	public function newArrayLiteral():IArrayLiteralNode
	{
		var ast:IParserNode = ASTBuilder.newArrayLiteral();
		return new ArrayLiteralNode(ast);
	}
	
	public function newObjectLiteral():IObjectLiteralNode
	{
		var ast:IParserNode = ASTBuilder.newObjectLiteral();
		return new ObjectLiteralNode(ast);
	}
	
	public function newFunctionLiteral():IFunctionLiteralNode
	{
		var ast:IParserNode = ASTBuilder.newFunctionLiteral();
		return new FunctionLiteralNode(ast);
	}
	
	public function newAssignmentExpression(left:IExpressionNode,
											right:IExpressionNode):IAssignmentExpressionNode
	{
		return ASTBuilder.newAssignmentExpression(TokenBuilder.newAssign(), left, right);
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	

	

	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	

	
	
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newArrayAccessExpression()
	 */
	public function newArrayAccessExpression(target:IExpressionNode, 
											 subscript:IExpressionNode):IArrayAccessExpressionNode
	{
		var ast:IParserNode = ASTUtil2.newAST(AS3NodeKind.ARRAY_ACCESSOR);
		var targetAST:IParserNode = target.node;
		ast.addChild(targetAST);
		ast.appendToken(TokenBuilder.newLeftBracket());
		var subAST:IParserNode = subscript.node;
		ast.addChild(subAST);
		ast.appendToken(TokenBuilder.newRightBracket());
		
		var result:ArrayAccessExpressionNode = new ArrayAccessExpressionNode(ast);
		
		return result;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newSimpleNameExpressionNode()
	 */
	public function newSimpleNameExpression(name:String):ISimpleNameExpressionNode
	{
		var ast:IParserNode = AS3FragmentParser2.parsePrimaryExpression(name);
		var result:ISimpleNameExpressionNode = new SimpleNameExpressionNode(ast);
		return result;
	}
	
	public function newExpression(expression:String):IExpressionNode
	{
		var ast:IParserNode = AS3FragmentParser2.parseExpression(expression);
		ast.parent = null;
		return ExpressionBuilder.build(ast);
	}
	
	
	
	
}
}