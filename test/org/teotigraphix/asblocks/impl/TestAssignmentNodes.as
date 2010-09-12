package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.api.IAssignmentExpression;
import org.teotigraphix.asblocks.api.IExpression;
import org.teotigraphix.asblocks.api.IScriptNode;

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
	
	private var factory:ASFactory;
	
	[Before]
	public function setUp():void
	{
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		
	}
	
	[Test]
	public function testAssignmentExpressionNode():void
	{
		var left:IExpression = factory.newExpression("myAnswer");
		var right:IExpression = factory.newExpression("4");
		
		var expression:IAssignmentExpression = 
			factory.newAssignmentExpression(left, right);
		
		assertPrint("myAnswer = 4", expression);
		
		// change right expression
		expression.rightExpression = factory.newExpression("otherAnswer = 4");
		
		assertPrint("myAnswer = otherAnswer = 4", expression);
	}
	
	[Test]
	public function testAddAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testBitOrAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testBitXorAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testDivideAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testModuloAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testMultiplyAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testShiftLeftAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testShiftRightAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testShiftRightUnsignedAssignExpressionNode():void
	{
		
	}
	
	[Test]
	public function testSubtractAssignExpressionNode():void
	{
		
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}