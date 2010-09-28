package org.as3commons.mxmlblocks.parser.impl
{

import flexunit.framework.Assert;

import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.utils.ASTUtil;

public class AbstractMXMLTest
{
	protected var parser:MXMLParser;
	
	[Before]
	public function setUp():void
	{
		parser = new MXMLParser();
	}
	
	protected function assertUnitPrint(input:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseUnit(input));
		Assert.assertEquals(input, printer.flush());
	}
	
	protected function assertUnit(message:String, 
								  input:String, 
								  expected:String):void
	{
		var result:String = ASTUtil.convert(parseUnit(input));
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		return parser.parseCompilationUnit();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}