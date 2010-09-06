package org.teotigraphix.asblocks
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.core.TokenNode;
import org.teotigraphix.asblocks.api.ICompilationUnit;

public class CodeMirror
{
	public static function assertReflection(factory:ASFactory, 
											unit:ICompilationUnit):ICompilationUnit
	{
		var ast:IParserNode = unit.node;
		var writer:IASWriter = factory.newWriter();
		var sourceCode1:SourceCode = new SourceCode();
		try
		{
			writer.write(sourceCode1, unit);
		}
		catch (e:Error)
		{
			throw new Error("assertReflection(1) - writer.write() error");
		}
		try
		{
			var sourceCode2:SourceCode;
			try
			{
				var unit2:ICompilationUnit = factory.newParser().parseString(sourceCode1.code);
				var ast2:IParserNode = unit2.node;
				assertASTMatch(ast, ast2);
				sourceCode2 = new SourceCode();
				writer.write(sourceCode2, unit2);
			}
			catch (e:ASBlocksSyntaxError)
			{
				throw new Error("assertReflection(2) - writer.write() error");
			}
			assertEquals(sourceCode1.code, sourceCode2.code);
			return unit2;
		}
		catch (e:ASBlocksSyntaxError)
		{
			Assert.fail(e.message + "\n" + sourceCode1.code);
		}
		return null;
	}
	
	public static function assertASTMatch(ast1:IParserNode, 
										  ast2:IParserNode):void
	{
		var path:String = pathTo(ast1);
		
		if (ast1.isKind(AS3NodeKind.NAME))
		{
			assertEquals("At " + path, ast1.stringValue, ast2.stringValue);
		}
		assertEquals("At " + path + " child count mismatch: " + 
			stringifyFirstLevel(ast1) + " vs. " + stringifyFirstLevel(ast2), 
			ast1.numChildren, 
			ast2.numChildren);
		for (var i:int = 0; i < ast1.numChildren; i++)
		{
			assertASTMatch(ast1.getChild(i), ast2.getChild(i));
		}
	}
	
	private static function pathTo(ast:IParserNode):String
	{
		var buffer:String = "";
		while (ast != null)
		{
			buffer = ast.kind + buffer;
			ast = ast.parent;
			if (ast != null)
			{
				buffer = "/" + buffer;
			}
		}
		return buffer;
	}
	
	private static function stringifyFirstLevel(ast:IParserNode):String
	{
		var buffer:String = "(";
		
		for (var i:int = 0; i < ast.numChildren; i++)
		{
			if (i > 0) 
			{
				buffer += " ";
			}
			var r:String = TokenNode(ast.getChild(i)).token.text;
			if (r == null)
			{
				r = TokenNode(ast.getChild(i)).token.kind;
			}
			else
			{
				r = "'" + r + "'";
			}
			buffer += r;
		}
		
		buffer += ")";
		return buffer;
	}

}
}