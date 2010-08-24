package org.teotigraphix.as3parser.core
{

import org.flexunit.Assert;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3Parser2;
import org.teotigraphix.as3parser.impl.AS3Tokenizer;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestLinkedListToken
{
	private var parser:AS3Parser2 = new AS3Parser2();
	
	[Test]
	public function testDefaultPackage():void
	{
		//package my.domain \n{\n\t\n}\n
		var lines:Array =
			[
				"package my.domain \n{\n\t\n}"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		var ast:IParserNode = parser.parseCompilationUnit();
		var result:String = ASTUtil.convert(ast);
		
		var sourceCode:SourceCode = new SourceCode();
		sourceCode.code = "";
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		printer.print(ast);
		
		Assert.assertEquals("package my.domain \n{\n\t\n}\n", printer.toString());
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
				"\t\t * A const document comment.",
				"\t\t */",
				"\t\tpublic static const MY_CONSTANT:String = ;",
				"\t}",
				"}"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		var ast:IParserNode = parser.parseCompilationUnit();
		var result:String = ASTUtil.convert(ast);
		
		var sourceCode:SourceCode = new SourceCode();
		sourceCode.code = "";
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		printer.print(ast);
		
		Assert.assertEquals("package my.domain {\n\t\n\timport my.domain.Class;" +
			"\n\timport my.domain.IClass;\n\t\n\tuse namespace " +
			"flash_proxy;\n\t\n\t[Style( name = \"myStyle\" , " +
			"type = \"Number\" )]\n\t\n\tpublic final class HelloWorld " +
			"extends NewWorld\n\t\timplements IInterface1 " +
			"IInterface2\n\t{\n\t}\n}\n", 
			printer.toString());
	}
	

	
	[Test]
	public function testIt():void
	{
		/*
		public static AS3ASTCompilationUnit synthesizeClass(String qualifiedName) {
		LinkedListTree unit = ASTUtils.newImaginaryAST(AS3Parser.COMPILATION_UNIT);
		LinkedListTree pkg = ASTUtils.newAST(AS3Parser.PACKAGE, "package");
		pkg.appendToken(TokenBuilder.newSpace());
		unit.addChildWithTokens(pkg);
		pkg.appendToken(TokenBuilder.newSpace());
		String packageName = packageNameFrom(qualifiedName);
		if (packageName != null) {
		pkg.addChildWithTokens(AS3FragmentParser.parseIdent(packageName));
		}
		LinkedListTree packageBlock = newBlock();
		pkg.addChildWithTokens(packageBlock);
		String className = typeNameFrom(qualifiedName);
		
		LinkedListTree clazz = synthesizeAS3Class(className);
		ASTUtils.addChildWithIndentation(packageBlock, clazz);
		return new AS3ASTCompilationUnit(unit);
		}

		*/
		
		//var unit:IParserNode = ASTNodeUtil.newAST(AS3NodeKind.COMPILATION_UNIT, "");
		//var pkg:IParserNode = ASTNodeUtil.newAST("package", "pacakge");
		//pkg.appendToken(new TokenNode(new LinkedListToken("space", " ")));
		///unit.addChild(pkg);
		//pkg.appendToken(new TokenNode(new LinkedListToken("space", " ")));
		
		
		var sourceCode:SourceCode = new SourceCode("package my.domain { } ");
		var tokens:Tokens = new Tokens();
		var tokenizer:AS3Tokenizer = new AS3Tokenizer();
		tokenizer.tokenize(sourceCode, tokens);
		
		
		
		
	}
}
}