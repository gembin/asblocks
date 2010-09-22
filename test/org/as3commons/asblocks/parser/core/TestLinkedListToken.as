package org.as3commons.asblocks.parser.core
{

import org.flexunit.Assert;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.impl.AS3Parser;
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.utils.ASTUtil;

public class TestLinkedListToken
{
	private var parser:AS3Parser = new AS3Parser();
	
	[Test]
	public function testDefaultPackage():void
	{
		//package my.domain \n{\n\t\n}
		var lines:Array =
			[
				"package my.domain ",
				"{",
				"	",
				"}"
			];
		
		parser.scanner.setLines(Vector.<String>(lines));
		
		var ast:IParserNode = parser.parseCompilationUnit();
		var result:String = ASTUtil.convert(ast);
		
		var sourceCode:SourceCode = new SourceCode();
		sourceCode.code = "";
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		printer.print(ast);
		
		Assert.assertEquals("package my.domain \n{\n\t\n}", printer.toString());
	}
	
	[Test]
	public function testPackageClass():void
	{
		var lines:Array =
			[
				"package my.domain {",
				"\t",
				"\timport my.domain.Class;",
				"\timport my.domain.IClass;",
				"\t",
				"\tuse namespace flash_proxy;",
				"\t",
				"\t/**",
				"\t * A meta style document comment.",
				"\t */",
				"\t[Style( name = \"myStyle\" , type = \"Number\" )]",
				"\t",
				"\t/**",
				"\t * A class document comment.",
				"\t */",
				"\tpublic final class HelloWorld extends NewWorld",
				"\t\timplements IInterface1, IInterface2",
				"\t{",
				"\t\t/**",
				"\t\t * A const document comment 1.",
				"\t\t */",
				"\t\tpublic static const MY_CONSTANT_1:String = [1,2,3 , 42];",
				"\t\t",
				"\t\t/**",
				"\t\t * A const document comment 2.",
				"\t\t */",
				"\t\tpublic static const MY_CONSTANT_2:String = {",
				"\t\t\t a:42  ,b:true, c:\"Mike\"",
				"\t\t};",
				"\t}",
				"}"
			];
		
		parser.scanner.setLines(Vector.<String>(lines));
		
		var ast:IParserNode = parser.parseCompilationUnit();
		var result:String = ASTUtil.convert(ast);
		
		var printer:ASTPrinter = new ASTPrinter(new SourceCode());
		printer.print(ast);
		
		Assert.assertEquals("package my.domain {\n\t\n\timport my.domain.Class;" +
			"\n\timport my.domain.IClass;\n\t\n\t" +
			"use namespace flash_proxy;\n\t\n\t/**\n\t * A meta style document " +
			"comment.\n\t */\n\t[Style( name = \"myStyle\" , type = \"Number\" )]" +
			"\n\t\n\t/**\n\t * A class document comment.\n\t */\n\tpublic final " +
			"class HelloWorld extends NewWorld\n\t\timplements IInterface1, " +
			"IInterface2\n\t{\n\t\t/**\n\t\t * A const document comment 1.\n\t\t " +
			"*/\n\t\tpublic static const MY_CONSTANT_1:String = [1,2,3 , 42];" +
			"\n\t\t\n\t\t/**\n\t\t * A const document comment 2.\n\t\t */\n\t\t" +
			"public static const MY_CONSTANT_2:String = {\n\t\t\t a:42  ,b:true, " +
			"c:\"Mike\"\n\t\t};\n\t}\n}", 
			printer.toString());
	}
}
}