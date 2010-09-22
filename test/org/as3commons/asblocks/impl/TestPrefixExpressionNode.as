package org.as3commons.asblocks.impl
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.ASFactory;
import org.as3commons.asblocks.api.IExpression;
import org.as3commons.asblocks.api.IPrefixExpression;
import org.as3commons.asblocks.api.IScriptNode;

/*
* newNegativeExpression()
* newNotExpression()
* newPositiveExpression()
* newPreDecExpression()
* newPreIncExpression()
*/

public class TestPrefixExpressionNode
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
	public function testPrefixExpressionNode():void
	{
		var expression:IPrefixExpression;
		
		expression = factory.newPreDecExpression(factory.newSimpleNameExpression("i"));
		assertPrint("--i", expression);
		
		expression = factory.newPreIncExpression(factory.newSimpleNameExpression("i"));
		assertPrint("++i", expression);
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}