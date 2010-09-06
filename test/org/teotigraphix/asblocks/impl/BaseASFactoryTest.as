package org.teotigraphix.asblocks.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.impl.AS3Scanner;
import org.teotigraphix.asblocks.ASFactory;
import org.teotigraphix.asblocks.IASParser;
import org.teotigraphix.asblocks.api.IScriptNode;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class BaseASFactoryTest
{
	protected var printer:ASTPrinter;
	
	protected var factory:ASFactory;
	
	protected var project:ASProject;
	
	protected var asparser:IASParser;
	
	protected var parser:AS3Parser;
	
	protected var scanner:AS3Scanner;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
		scanner = parser.scanner as AS3Scanner;
		printer = new ASTPrinter(new SourceCode());
		factory = new ASFactory();
		project = new ASProject(factory);
		asparser = factory.newParser();
	}
	
	[After]
	public function tearDown():void
	{
		
	}
	
	protected function assertPrint(expected:String, 
								   expression:IScriptNode):void
	{
		printer.print(expression.node);
		Assert.assertEquals(expected, printer.flush());
	}
	
	protected function assertCompilationUnit(message:String, 
											 input:String, 
											 expected:String):void
	{
		var result:String = ASTUtil.convert(parseCompilationUnit(input), false);
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parseCompilationUnit(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		return parser.parseCompilationUnit();
	}
	
	protected function toElementString(element:Object):String
	{
		var node:IParserNode = (element is IScriptNode) 
			? IScriptNode(element).node 
			: element as IParserNode;
		return ASTUtil.convert(node, false);
	}
}
}