package org.teotigraphix.as3parser.core
{

import org.flexunit.Assert;
import org.teotigraphix.as3blocks.api.IArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.api.IExpressionNode;
import org.teotigraphix.as3blocks.impl.ArrayAccessExpressionNode;
import org.teotigraphix.as3blocks.impl.ExpressionBuilder;
import org.teotigraphix.as3blocks.impl.TokenBuilder;
import org.teotigraphix.as3nodes.utils.ASTNodeUtil;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.AS3FragmentParser2;
import org.teotigraphix.as3parser.impl.AS3Parser2;
import org.teotigraphix.as3parser.impl.AS3Tokenizer;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestLinkedListToken
{
	private var parser:AS3Parser2 = new AS3Parser2();

	
	
	
	
	
	
	
	
	//[Test]
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
	
	//[Test]
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
				"\t\t{",
				"\t\t/**",
				"\t\t * A const document comment 2.",
				"\t\t */",
				"\t\tpublic static const MY_CONSTANT_2:String = {",
				"\t\t\t a:42  ,b:true, c:\"Mike\"",
				"\t\t};",
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
		
		var res:String = ASTUtil.convert(ast);
		
		//Assert.assertEquals("package my.domain {\n\t\n\timport my.domain.Class;" +
		//	"\n\timport my.domain.IClass;\n\t\n\tuse namespace " +
		//	"flash_proxy;\n\t\n\t[Style( name = \"myStyle\" , " +
		//	"type = \"Number\" )]\n\t\n\tpublic final class HelloWorld " +
		//	"extends NewWorld\n\t\timplements IInterface1 " +
		//	"IInterface2\n\t{\n\t}\n}\n", 
		//	printer.toString());
	}
	

	
	//[Test]
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
		
		var qualifiedName:String = "my.domain";
		
		// create a COMPILATION_UNIT
		var unit:IParserNode = newAST(AS3NodeKind.COMPILATION_UNIT);
		// create a PACKAGE child
		var pckg:IParserNode = newAST(AS3NodeKind.PACKAGE, "package");
		// append a space
		pckg.appendToken(TokenBuilder.newSpace());
		// add PACKAGE to COMPILATION_UNIT
		unit.addChild(pckg);
		// append space
		pckg.appendToken(TokenBuilder.newSpace());
		// add NAME to PACKAGE
		if (qualifiedName)
		{
			var name:IParserNode = newName(qualifiedName);
			pckg.addChild(name);
		}
		
		
		var result:String = ASTUtil.convert(unit);
		
		var printer:ASTPrinter = new ASTPrinter(new SourceCode());
		printer.print(unit);
		
		// myObject[42][0]
		var target:IExpressionNode = newExpression("myObject[42]");
		var subscript:IExpressionNode = newExpression("0");
		
		var arrAcc:IArrayAccessExpressionNode = 
			newArrayAccessExpression(target, subscript);
		
		printer = new ASTPrinter(new SourceCode());
		printer.print(arrAcc.node);
	}
	
	public function newExpression(expression:String):IExpressionNode
	{
		var ast:IParserNode = AS3FragmentParser2.parseExpression(expression);
		ast.parent = null;
		return ExpressionBuilder.build(ast);
	}

	
	
	public function newArrayAccessExpression(target:IExpressionNode, 
											 subscript:IExpressionNode):IArrayAccessExpressionNode
	{
		var ast:IParserNode = newImaginaryAST(AS3NodeKind.ARRAY_ACCESSOR);
		var targetAST:IParserNode = target.node;
		ast.addChild(targetAST);
		ast.appendToken(TokenBuilder.newLeftBracket());
		var subAST:IParserNode = subscript.node;
		ast.addChild(subAST);
		ast.appendToken(TokenBuilder.newRightBracket());
		
		var result:ArrayAccessExpressionNode = new ArrayAccessExpressionNode(ast);
		
		return result;
	}

	//return (LinkedListTree)TREE_ADAPTOR.create(type, tokenName(type));

	public static function newImaginaryAST(kind:String, text:String = null):IParserNode
	{
		return adapter.create(kind, text);
	}
	
	public static function newAST(kind:String, text:String = null):IParserNode
	{
		var tok:LinkedListToken = TokenBuilder.newToken(kind, text);
		var ast:IParserNode = adapter.createNode(tok);
		//if (text)
		//{
		//	ast.appendToken(adapter.createToken(kind, text));
		//}
		return ast;
	}
	
	public static function newName(text:String):IParserNode
	{
		return adapter.create(AS3NodeKind.NAME, text);
	}
	
	protected static var adapter:LinkedListTreeAdaptor = new LinkedListTreeAdaptor();
	
}
}