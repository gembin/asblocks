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
		var lines:Array =
			[
				"package my.domain { } ",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		var ast:IParserNode = parser.parseCompilationUnit();
		var result:String = ASTUtil.convert(ast);
		
		var sourceCode:SourceCode = new SourceCode();
		sourceCode.code = "";
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		printer.print(ast);
		
		//Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\"><package line=\"1\" " +
		//	"column=\"1\"><name line=\"1\" column=\"9\"></name><content line=\"1\" " +
		//	"column=\"11\"><class line=\"1\" column=\"17\"><name line=\"1\" column=\"17\">" +
		////	"A</name><content line=\"1\" column=\"20\"></content></class></content>" +
		//	"</package><content line=\"2\" column=\"1\"></content></compilation-unit>",
		//	result);
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