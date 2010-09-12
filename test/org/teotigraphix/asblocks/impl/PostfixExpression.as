package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.api.IPostfixExpression;
import org.teotigraphix.asblocks.api.IScriptNode;

/*
* newPostDecExpression()
* newPostIncExpression()
*/

public class PostfixExpression
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
	public function testPostfixExpressionNode():void
	{
		var expression:IPostfixExpression;
		
		expression = factory.newPostDecExpression(factory.newSimpleNameExpression("i"));
		assertPrint("i--", expression);
		
		expression.expression = factory.newSimpleNameExpression("count");
		assertPrint("count--", expression);
		
		// FIXME
		//expression.operator = PostfixOperator.POSTINC;
		//assertPrint("count++", expression);
		
		expression = factory.newPostIncExpression(factory.newSimpleNameExpression("i"));
		assertPrint("i++", expression);
		
		expression.expression = factory.newSimpleNameExpression("count");
		assertPrint("count++", expression);
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
}
}