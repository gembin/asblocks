package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.impl.ASTPrinter;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class AbstractStatementTest
{
	protected var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	protected function assertStatementPrint(input:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseStatement(input));
		Assert.assertEquals(input, printer.flush());
	}
	
	protected function assertStatement(message:String, 
									   input:String, 
									   expected:String):void
	{
		var result:String = ASTUtil.convert(parseStatement(input));
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseStatement(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		return parser.parseStatement();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}