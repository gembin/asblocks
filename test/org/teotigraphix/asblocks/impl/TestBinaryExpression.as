package org.teotigraphix.asblocks.impl
{

import org.flexunit.asserts.assertEquals;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.api.BinaryOperator;
import org.teotigraphix.asblocks.api.IBinaryExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestBinaryExpression
{
	private var factory:ASFactory = new ASFactory();
	
	private var expression:IBinaryExpression;
	
	private var left:IExpression;
	
	private var right:IExpression;
	
	[Before]
	public function setUp():void
	{
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
		}
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
}
}