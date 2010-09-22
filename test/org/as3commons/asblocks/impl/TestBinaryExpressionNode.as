package org.as3commons.asblocks.impl
{

import flexunit.framework.Assert;

import org.flexunit.asserts.assertEquals;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.impl.AS3FragmentParser;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.CodeMirror;
import org.as3commons.asblocks.api.BinaryOperator;
import org.as3commons.asblocks.api.IBinaryExpression;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.utils.ASTUtil;

/*
* newAddExpression()
* newAndExpression()
* newBitAndExpression()
* newBitOrExpression()
* newBitXorExpression()
* newDivisionExpression()
* newEqualsExpression()
* newGreaterEqualsExpression()
* newGreaterThanExpression()
* newLessEqualsExpression()
* newLessThanExpression()
* newModuloExpression()
* newMultiplyExpression()
* newNotEqualsExpression()
* newOrExpression()
* newShiftLeftExpression()
* newShiftRightExpression()
* newShiftRightUnsignedExpression()
* newSubtractExpression()
*/

public class TestBinaryExpressionNode
{
	private var printer:ASTPrinter;
	
	private var factory:ASFactory = new ASFactory();
	
	private var expression:IBinaryExpression;
	
	private var left:IExpression;
	
	private var right:IExpression;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		
		left = factory.newNumberLiteral(1);
		right = factory.newNumberLiteral(2);
		expression = null;
	}
	
	[After]
	public function tearDown():void
	{
		if (expression)
		{
			assertEquals(left.node, expression.leftExpression.node);
			assertEquals(right.node, expression.rightExpression.node);
			
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = expression.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testBinaryExpressionNode():void
	{
		var left:IExpression;
		var right:IExpression;
		
		var expression:IBinaryExpression;
		
		// ADD
		expression = factory.newAddExpression(
			factory.newNumberLiteral(4),
			factory.newNumberLiteral(2));
		
		assertPrint("4 + 2", expression);
		
		// AND
		expression = factory.newAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a && b", expression);
		
		// BITAND
		expression = factory.newBitAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a & b", expression);
		
		// BITOR
		expression = factory.newBitOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a | b", expression);
		
		// BITXOR
		expression = factory.newBitXorExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a ^ b", expression);
		
		// DIV
		expression = factory.newDivisionExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a / b", expression);
		
		// EQ
		expression = factory.newEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a == b", expression);
		
		// GE
		expression = factory.newGreaterEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >= b", expression);
		
		// GT
		expression = factory.newGreaterThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a > b", expression);
		
		// LE
		expression = factory.newLessEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a <= b", expression);
		
		// LT
		expression = factory.newLessThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a < b", expression);
		
		// MOD
		expression = factory.newModuloExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a % b", expression);
		
		// MUL
		expression = factory.newMultiplyExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a * b", expression);
		
		// NE
		expression = factory.newNotEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a != b", expression);
		
		// OR
		expression = factory.newOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a || b", expression);
		
		// SL
		expression = factory.newShiftLeftExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a << b", expression);
		
		// SR
		expression = factory.newShiftRightExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >> b", expression);
		
		// SRU
		expression = factory.newShiftRightUnsignedExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a >>> b", expression);
		
		// SUB
		expression = factory.newSubtractExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrint("a - b", expression);
	}
	
	[Test]
	public function testAdd():void
	{
		expression = factory.newAddExpression(left, right);
		assertOp(BinaryOperator.ADD);
	}
	
	[Test]
	public function testAnd():void
	{
		expression = factory.newAndExpression(left, right);
		assertOp(BinaryOperator.AND);
	}
	
	[Test]
	public function testBitAnd():void
	{
		expression = factory.newBitAndExpression(left, right);
		assertOp(BinaryOperator.BITAND);
	}
	
	[Test]
	public function testBitOr():void
	{
		expression = factory.newBitOrExpression(left, right);
		assertOp(BinaryOperator.BITOR);
	}
	
	[Test]
	public function testBitXor():void
	{
		expression = factory.newBitXorExpression(left, right);
		assertOp(BinaryOperator.BITXOR);
	}
	
	[Test]
	public function testDivision():void
	{
		expression = factory.newDivisionExpression(left, right);
		assertOp(BinaryOperator.DIV);
	}
	
	[Test]
	public function testEquals():void
	{
		expression = factory.newEqualsExpression(left, right);
		assertOp(BinaryOperator.EQ);
	}
	
	[Test]
	public function testGreaterEquals():void
	{
		expression = factory.newGreaterEqualsExpression(left, right);
		assertOp(BinaryOperator.GE);
	}
	
	[Test]
	public function testGreaterThan():void
	{
		expression = factory.newGreaterThanExpression(left, right);
		assertOp(BinaryOperator.GT);
	}
	
	[Test]
	public function testLessEquals():void
	{
		expression = factory.newLessEqualsExpression(left, right);
		assertOp(BinaryOperator.LE);
	}
	
	[Test]
	public function testLessThan():void
	{
		expression = factory.newLessThanExpression(left, right);
		assertOp(BinaryOperator.LT);
	}
	
	[Test]
	public function testModulo():void
	{
		expression = factory.newModuloExpression(left, right);
		assertOp(BinaryOperator.MOD);
	}
	
	[Test]
	public function testMultiply():void
	{
		expression = factory.newMultiplyExpression(left, right);
		assertOp(BinaryOperator.MUL);
	}
	
	[Test]
	public function testNotEquals():void
	{
		expression = factory.newNotEqualsExpression(left, right);
		assertOp(BinaryOperator.NE);
	}
	
	[Test]
	public function testOr():void
	{
		expression = factory.newOrExpression(left, right);
		assertOp(BinaryOperator.OR);
	}
	
	[Test]
	public function testShiftLeft():void
	{
		expression = factory.newShiftLeftExpression(left, right);
		assertOp(BinaryOperator.SL);
	}
	
	[Test]
	public function testShiftRight():void
	{
		expression = factory.newShiftRightExpression(left, right);
		assertOp(BinaryOperator.SR);
	}
	
	[Test]
	public function testShiftRightUnsigned():void
	{
		expression = factory.newShiftRightUnsignedExpression(left, right);
		assertOp(BinaryOperator.SRU);
	}
	
	[Test]
	public function testSubtract():void
	{
		expression = factory.newSubtractExpression(left, right);
		assertOp(BinaryOperator.SUB);
	}
	
	[Test]
	public function testSetOp():void
	{
		expression = factory.newAddExpression(left, right);
		assertOp(BinaryOperator.ADD);
		expression.operator = BinaryOperator.SUB;
		assertOp(BinaryOperator.SUB);
	}
	
	[Test]
	public function testSetLeft():void
	{
		expression = factory.newAddExpression(left, right);
		left = factory.newNumberLiteral(24);
		expression.leftExpression = left;
	}
	
	[Test]
	public function testSetRight():void
	{
		expression = factory.newAddExpression(left, right);
		right = factory.newNumberLiteral(24);
		expression.rightExpression = right;
	}
	
	private function assertOp(expected:BinaryOperator):void
	{
		var ast:IParserNode = expression.node;
		var expr:IExpression = factory.newExpression(ASTUtil.stringifyNode(ast));
		assertEquals(expected, IBinaryExpression(expr).operator);
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}