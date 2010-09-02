package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3blocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.api.IArrayLiteralNode;
import org.teotigraphix.as3blocks.api.IAssignmentExpressionNode;
import org.teotigraphix.as3blocks.api.IBinaryExpressionNode;
import org.teotigraphix.as3blocks.api.IBooleanLiteralNode;
import org.teotigraphix.as3blocks.api.IConditionalExpressionNode;
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
import org.teotigraphix.as3blocks.impl.ConditionalExpressionNode;
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
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

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
	
	//----------------------------------
	// IBinaryExpressionNode
	//----------------------------------
	
	public function newAddExpression(left:IExpressionNode, 
									 right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newPlus(), left, right);
	}
	
	public function newAndExpression(left:IExpressionNode, 
									 right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newAnd(), left, right);
	}
	
	public function newBitAndExpression(left:IExpressionNode, 
										right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitAnd(), left, right);
	}
	
	public function newBitOrExpression(left:IExpressionNode, 
									   right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitOr(), left, right);
	}
	
	public function newBitXorExpression(left:IExpressionNode, 
										right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newBitXor(), left, right);
	}
	
	public function newDivisionExpression(left:IExpressionNode, 
										  right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newDiv(), left, right);
	}
	
	public function newEqualsExpression(left:IExpressionNode, 
										right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newEquals(), left, right);
	}
	
	public function newGreaterEqualsExpression(left:IExpressionNode, 
											   right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newGreaterEquals(), left, right);
	}
	
	public function newGreaterThanExpression(left:IExpressionNode, 
											 right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newGreater(), left, right);
	}
	
	public function newLessEqualsExpression(left:IExpressionNode, 
											right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newLessEquals(), left, right);
	}
	
	public function newLessThanExpression(left:IExpressionNode, 
										  right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newLess(), left, right);
	}
	
	public function newModuloExpression(left:IExpressionNode, 
										right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newModulo(), left, right);
	}
	
	public function newMultiplyExpression(left:IExpressionNode, 
										  right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newMult(), left, right);
	}
	
	public function newNotEqualsExpression(left:IExpressionNode, 
										   right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newNotEquals(), left, right);
	}
	
	public function newOrExpression(left:IExpressionNode, 
									right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newOr(), left, right);
	}
	
	public function newShiftLeftExpression(left:IExpressionNode, 
										   right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftLeft(), left, right);
	}
	
	public function newShiftRightExpression(left:IExpressionNode, 
											right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftRight(), left, right);
	}
	
	public function newShiftRightUnsignedExpression(left:IExpressionNode, 
													right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newShiftRightUnsigned(), left, right);
	}
	
	public function newSubtractExpression(left:IExpressionNode, 
										  right:IExpressionNode):IBinaryExpressionNode
	{
		return ASTBuilder.newBinaryExpression(TokenBuilder.newMinus(), left, right);
	}
	
	//----------------------------------
	// IConditionalExpressionNode
	//----------------------------------
	
	public function newConditionalExpression(conditionExpression:IExpressionNode, 
											 thenExpression:IExpressionNode,
											 elseExpression:IExpressionNode):IConditionalExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newConditionalExpression(
			conditionExpression.node, thenExpression.node, elseExpression.node);
		return new ConditionalExpressionNode(ast);
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
		var ast:IParserNode = AS3FragmentParser.parsePrimaryExpression(name);
		var result:ISimpleNameExpressionNode = new SimpleNameExpressionNode(ast);
		return result;
	}
	
	public function newExpression(expression:String):IExpressionNode
	{
		var ast:IParserNode = AS3FragmentParser.parseExpression(expression);
		ast.parent = null;
		return ExpressionBuilder.build(ast);
	}
	
	
	
	
}
}