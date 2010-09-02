package org.teotigraphix.as3blocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3blocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.api.IAssignmentExpressionNode;
import org.teotigraphix.as3blocks.api.IBinaryExpressionNode;
import org.teotigraphix.as3blocks.api.IConditionalExpressionNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.api.IFunctionLiteralNode;
import org.teotigraphix.as3blocks.api.ISimpleNameExpressionNode;
import org.teotigraphix.as3nodes.impl.AS3Factory2;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.SourceCode;

public class TestExpressionNodes
{
	private var printer:ASTPrinter;
	
	private var factory:AS3Factory2;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		factory = new AS3Factory2();
	}
	
	[Test]
	public function testArrayAccessExpressionNode():void
	{
		var target:IExpressionNode = factory.newExpression("myObject[42]");
		var subscript:IExpressionNode = factory.newExpression("0");
		
		var expression:IArrayAccessExpressionNode = 
			factory.newArrayAccessExpression(target, subscript);
		
		assertPrintExpression("myObject[42][0]", expression);
		
		// test changing the 'target'
		target = factory.newExpression("myObject");
		expression.target = target;
		
		assertPrintExpression("myObject[0]", expression);
		
		// test changing the 'subscript'
		subscript = factory.newExpression("42");
		expression.subscript = subscript;
		
		assertPrintExpression("myObject[42]", expression);
		
		// test changing the 'subscript' to a string literal
		subscript = factory.newExpression("'myProp'");
		// or you could use
		// subscript = factory.newStringLiteral("'myProp'");
		expression.subscript = subscript;
		
		assertPrintExpression("myObject['myProp']", expression);
	}
	
	[Test]
	public function testAssignmentExpressionNode():void
	{
		var left:IExpressionNode = factory.newExpression("myAnswer");
		var right:IExpressionNode = factory.newExpression("4");
		
		var expression:IAssignmentExpressionNode = 
			factory.newAssignmentExpression(left, right);
		
		assertPrintExpression("myAnswer = 4", expression);
		
		// change right expression
		expression.rightExpression = factory.newExpression("otherAnswer = 4");
		
		assertPrintExpression("myAnswer = otherAnswer = 4", expression);
		
		// change left expression to an array access
		var target:IExpressionNode = factory.newExpression("myObject[42]");
		var subscript:IExpressionNode = factory.newExpression("2");
		
		var arrayAccessExpression:IArrayAccessExpressionNode = 
			factory.newArrayAccessExpression(target, subscript);
		
		expression.leftExpression = arrayAccessExpression;
		
		assertPrintExpression("myObject[42][2] = otherAnswer = 4", expression);
	}
	
	[Test]
	public function testBinaryExpressionNode():void
	{
		var left:IExpressionNode;
		var right:IExpressionNode;
		
		var expression:IBinaryExpressionNode;
		
		// ADD
		expression = factory.newAddExpression(
			factory.newNumberLiteral(4),
			factory.newNumberLiteral(2));
		
		assertPrintExpression("4 + 2", expression);
		
		// AND
		expression = factory.newAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a && b", expression);
		
		// BITAND
		expression = factory.newBitAndExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a & b", expression);
		
		// BITOR
		expression = factory.newBitOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a | b", expression);
		
		// BITXOR
		expression = factory.newBitXorExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a ^ b", expression);
		
		// DIV
		expression = factory.newDivisionExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a / b", expression);
		
		// EQ
		expression = factory.newEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a == b", expression);
		
		// GE
		expression = factory.newGreaterEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a >= b", expression);
		
		// GT
		expression = factory.newGreaterThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a > b", expression);
		
		// LE
		expression = factory.newLessEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a <= b", expression);
		
		// LT
		expression = factory.newLessThanExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a < b", expression);
		
		// MOD
		expression = factory.newModuloExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a % b", expression);
		
		// MUL
		expression = factory.newMultiplyExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a * b", expression);
		
		// NE
		expression = factory.newNotEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a != b", expression);
		
		// OR
		expression = factory.newOrExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a || b", expression);
		
		// SL
		expression = factory.newShiftLeftExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a << b", expression);
		
		// SR
		expression = factory.newShiftRightExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a >> b", expression);
		
		// SRU
		expression = factory.newShiftRightUnsignedExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a >>> b", expression);
		
		// SUB
		expression = factory.newSubtractExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a - b", expression);
	}
	
	[Test]
	public function testConditionalExpressionNode():void
	{
		var conditionExpression:IExpressionNode = factory.newNotEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		var thenExpression:IExpressionNode = factory.newBooleanLiteral(false);
		var elseExpression:IExpressionNode = factory.newBooleanLiteral(true);
		
		var expression:IConditionalExpressionNode = 
			factory.newConditionalExpression(
				conditionExpression, thenExpression, elseExpression);
		
		assertPrintExpression("a != b ? false : true", expression);
		
		// test changing the condition
		expression.conditionExpression = factory.newEqualsExpression(
			factory.newSimpleNameExpression("a"), 
			factory.newSimpleNameExpression("b"));
		
		assertPrintExpression("a == b ? false : true", expression);
		
		// test changing the then
		expression.thenExpression = factory.newNumberLiteral(4);
		
		assertPrintExpression("a == b ? 4 : true", expression);
		
		// test changing the else
		expression.elseExpression = factory.newNumberLiteral(2);
		
		assertPrintExpression("a == b ? 4 : 2", expression);
	}
	
	[Test]
	public function testDescendentExpressionNode():void
	{
		
	}
	
	[Test]
	public function testExpressionAttrbuteNode():void
	{
		
	}
	
	[Test]
	public function testFieldAccessExpressionNode():void
	{
		
	}
	
	[Test]
	public function testFilterExpressionNode():void
	{
		
	}
	
	[Test]
	public function testFunctionExpressionNode():void
	{
		
	}
	
	[Test]
	public function testInvocationExpressionNode():void
	{
		
	}
	
	[Test]
	public function testNewExpressionNode():void
	{
		
	}
	
	[Test]
	public function testPostfixExpressionNode():void
	{
		
	}
	
	[Test]
	public function testPrefixExpressionNode():void
	{
		
	}
	
	[Test]
	public function testPropertyAttributeNode():void
	{
		
	}
	
	[Test]
	public function testSimpleNameExpressionNode():void
	{
		var expression:ISimpleNameExpressionNode = 
			factory.newSimpleNameExpression("myObject");
		
		Assert.assertEquals("myObject", expression.name);
		assertPrintExpression("myObject", expression);
		
		// test changing the 'name'
		
		expression.name = "myOtherObject";
		
		Assert.assertEquals("myOtherObject", expression.name);
		assertPrintExpression("myOtherObject", expression);
	}
	
	[Test]
	public function testStarAttributeNode():void
	{
		
	}
	
	[Test]
	public function testAttributeExpressionNode():void
	{
		
	}
	
	
	protected function assertPrintExpression(expected:String, 
											 expression:IExpressionNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}