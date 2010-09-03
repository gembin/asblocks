package org.teotigraphix.asblocks.impl
{

import org.teotigraphix.asblocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.asblocks.api.IArrayLiteralNode;
import org.teotigraphix.asblocks.api.IAssignmentExpressionNode;
import org.teotigraphix.asblocks.api.IBinaryExpressionNode;
import org.teotigraphix.asblocks.api.IBlockNode;
import org.teotigraphix.asblocks.api.IBooleanLiteralNode;
import org.teotigraphix.asblocks.api.ICompilationUnitNode;
import org.teotigraphix.asblocks.api.IConditionalExpressionNode;
import org.teotigraphix.asblocks.api.IExpressionNode;
import org.teotigraphix.asblocks.api.IFieldAccessExpression;
import org.teotigraphix.asblocks.api.IFunctionLiteralNode;
import org.teotigraphix.asblocks.api.IINvocationExpressionNode;
import org.teotigraphix.asblocks.api.IIfStatementNode;
import org.teotigraphix.asblocks.api.INewExpressionNode;
import org.teotigraphix.asblocks.api.INullLiteralNode;
import org.teotigraphix.asblocks.api.INumberLiteralNode;
import org.teotigraphix.asblocks.api.IObjectLiteralNode;
import org.teotigraphix.asblocks.api.IPostfixExpressionNode;
import org.teotigraphix.asblocks.api.IPrefixExpressionNode;
import org.teotigraphix.asblocks.api.ISimpleNameExpressionNode;
import org.teotigraphix.asblocks.api.IStringLiteralNode;
import org.teotigraphix.asblocks.api.IUndefinedLiteralNode;
import org.teotigraphix.asblocks.utils.ASTUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;

public class ASFactory
{
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASFactory()
	{
		super();
	}
	
	public function newClass(qualifiedName:String):ICompilationUnitNode
	{
		return ASTBuilder.synthesizeClass(qualifiedName);
	}
	
	public function newInterface(qualifiedName:String):ICompilationUnitNode
	{
		return ASTBuilder.synthesizeInterface(qualifiedName);
	}
	
	public function newNumberLiteral(number:Number):INumberLiteralNode
	{
		return new NumberLiteralNode(ASTUtil.newAST(AS3NodeKind.NUMBER, number.toString()));
	}
	
	public function newNullLiteral():INullLiteralNode
	{
		return new NullLiteralNode(ASTUtil.newAST(AS3NodeKind.NULL, KeyWords.NULL));
	}
	
	public function newUndefinedLiteral():IUndefinedLiteralNode
	{
		return new UndefinedLiteralNode(ASTUtil.newAST(AS3NodeKind.UNDEFINED, KeyWords.UNDEFINED));
	}
	
	public function newBooleanLiteral(boolean:Boolean):IBooleanLiteralNode
	{
		var kind:String = (boolean) ? AS3NodeKind.TRUE : AS3NodeKind.FALSE;
		var text:String = (boolean) ? KeyWords.TRUE : KeyWords.FALSE;
		return new BooleanLiteralNode(ASTUtil.newAST(kind, text));
	}
	
	public function newStringLiteral(string:String):IStringLiteralNode
	{
		return new StringLiteralNode(ASTUtil.newAST(AS3NodeKind.STRING, ASTBuilder.escapeString(string)));
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
	
	//----------------------------------
	// IInvocation
	//----------------------------------
	
	public function newFieldAccessExpression(target:IExpressionNode, 
											 name:String):IFieldAccessExpression
	{
		var ast:IParserNode = ASTBuilder.newFieldAccessExpression(
			target.node, ASTUtil.newAST(AS3NodeKind.NAME, name));
		return new FieldAccessExpression(ast);
	}
	
	public function newInvocationExpression(target:IExpressionNode, 
											args:Vector.<IExpressionNode>):IINvocationExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newInvocationExpression(target.node);
		var result:IINvocationExpressionNode = new InvocationExpressionNode(ast);
		result.arguments = args;
		return result;
	}
	
	public function newNewExpression(target:IExpressionNode, 
									 args:Vector.<IExpressionNode>):INewExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newNewExpression(target.node);
		var result:INewExpressionNode = new NewExpressionNode(ast);
		result.arguments = args;
		return result;
	}
	
	//----------------------------------
	// IPostfixExpressionNode, IPrefixExpressionNode
	//----------------------------------
	
	public function newPostDecExpression(sub:IExpressionNode):IPostfixExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newPostfixExpression(
			TokenBuilder.newPostDec(), sub.node);
		return new PostfixExpressionNode(ast);
	}
	
	public function newPostIncExpression(sub:IExpressionNode):IPostfixExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newPostfixExpression(
			TokenBuilder.newPostInc(), sub.node);
		return new PostfixExpressionNode(ast);
	}
	
	public function newPreDecExpression(sub:IExpressionNode):IPrefixExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newPrefixExpression(
			TokenBuilder.newPreDec(), sub.node);
		return new PrefixExpressionNode(ast);
	}
	
	public function newPreIncExpression(sub:IExpressionNode):IPrefixExpressionNode
	{
		var ast:IParserNode = ASTBuilder.newPrefixExpression(
			TokenBuilder.newPreInc(), sub.node);
		return new PrefixExpressionNode(ast);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IAS3Factory#newArrayAccessExpression()
	 */
	public function newArrayAccessExpression(target:IExpressionNode, 
											 subscript:IExpressionNode):IArrayAccessExpressionNode
	{
		var ast:IParserNode = ASTUtil.newAST(AS3NodeKind.ARRAY_ACCESSOR);
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
	
	public function newBlock():IBlockNode
	{
		var ast:IParserNode = ASTBuilder.newBlock();
		return new StatementList(ast);
	}
	
	public function newIf(condition:IExpressionNode):IIfStatementNode
	{
		var ast:IParserNode = ASTBuilder.newIf(condition.node);
		return new IfStatementNode(ast);
	}
	
	
}
}