package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.CodeMirror;
import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.api.ISimpleNameExpression;

/*
* newAddAssignExpression()
* newAssignExpression()
* newBitAndAssignExpression()
* newBitOrAssignExpression()
* newBitXorAssignExpression()
* newDivideAssignExpression()
* newModuloAssignExpression()
* newMultiplyAssignExpression()
* newShiftLeftAssignExpression()
* newShiftRightAssignExpression()
* newShiftRightUnsignedAssignExpression()
* newSubtractAssignExpression()
*/

public class TestAssignmentNodes
{
	private var printer:ASTPrinter;
	
	private var factory:ASFactory = new ASFactory();
	
	private var expression:IAssignmentExpression;
	
	[Before]
	public function setUp():void
	{
		expression = null;
	}
	
	[After]
	public function tearDown():void
	{
		if (expression)
		{
			var sourceCode:SourceCode = new SourceCode();
			var ast:IParserNode = expression.node;
			new ASTPrinter(sourceCode).print(ast);
			var parsed:IParserNode = AS3FragmentParser.parseExpression(sourceCode.code);
			CodeMirror.assertASTMatch(ast, parsed);
		}
	}
	
	[Test]
	public function testAssignmentExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newAssignExpression(left, right);
		assertOp(Operators.ASSIGN);
	}
	
	[Test]
	public function testAddAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newAddAssignExpression(left, right);
		assertOp(Operators.PLUS_ASSIGN);
	}
	
	[Test]
	public function testBitAndAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newBitAndAssignExpression(left, right);
		assertOp(Operators.BAND_ASSIGN);
	}
	
	[Test]
	public function testBitOrAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newBitOrAssignExpression(left, right);
		assertOp(Operators.BOR_ASSIGN);
	}
	
	[Test]
	public function testBitXorAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newBitXorAssignExpression(left, right);
		assertOp(Operators.BXOR_ASSIGN);
	}
	
	[Test]
	public function testDivideAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newDivideAssignExpression(left, right);
		assertOp(Operators.DIV_ASSIGN);
	}
	
	[Test]
	public function testModuloAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newModuloAssignExpression(left, right);
		assertOp(Operators.MOD_ASSIGN);
	}
	
	[Test]
	public function testMultiplyAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newMultiplyAssignExpression(left, right);
		assertOp(Operators.STAR_ASSIGN);
	}
	
	[Test]
	public function testShiftLeftAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newShiftLeftAssignExpression(left, right);
		assertOp(Operators.SL_ASSIGN);
	}
	
	[Test]
	public function testShiftRightAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newShiftRightAssignExpression(left, right);
		assertOp(Operators.SR_ASSIGN);
	}
	
	[Test]
	public function testShiftRightUnsignedAssignExpressionNode():void
	{
		//var left:IExpression = factory.newExpression("foo");
		//var right:IExpression = factory.newExpression("bar");
		//expression = factory.newShiftRightUnsignedAssignExpression(left, right);
		//assertOp(Operators.SSL_ASSIGN);
	}
	
	[Test]
	public function testSubtractAssignExpressionNode():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newSubtractAssignExpression(left, right);
		assertOp(Operators.MINUS_ASSIGN);
	}
	
	[Test]
	public function test_leftExpression():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newAssignExpression(left, right);
		
		expression.leftExpression = factory.newExpression("bean");
		assertEquals(ISimpleNameExpression(expression.leftExpression).name, "bean");
		assertOp(Operators.ASSIGN);
		assertEquals(ISimpleNameExpression(expression.rightExpression).name, "bar");
	}
	
	[Test]
	public function test_operator():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newAssignExpression(left, right);
		
		expression.operator = Operators.DIV_ASSIGN;
		assertOp(Operators.DIV_ASSIGN);
	}
	
	[Test]
	public function test_rightExpression():void
	{
		var left:IExpression = factory.newExpression("foo");
		var right:IExpression = factory.newExpression("bar");
		expression = factory.newAssignExpression(left, right);
		
		expression.rightExpression = factory.newExpression("bean");
		assertEquals(ISimpleNameExpression(expression.leftExpression).name, "foo");
		assertOp(Operators.ASSIGN);
		assertEquals(ISimpleNameExpression(expression.rightExpression).name, "bean");
	}
	
	protected function assertOp(expected:String):void
	{
		Assert.assertEquals(expected, expression.operator);
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}