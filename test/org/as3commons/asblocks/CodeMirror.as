package org.as3commons.asblocks
{

import org.flexunit.Assert;
import org.flexunit.asserts.assertEquals;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.parser.impl.ASTIterator;
import org.as3commons.asblocks.api.ICompilationUnit;

public class CodeMirror
{
	public static function assertReflection(factory:ASFactory, 
											unit:ICompilationUnit):ICompilationUnit
	{
		var ast:IParserNode = unit.node;
		saintyCheckTokenStream(ast);
		saintyCheckStartStopTokens(ast);
		// FIXME
		//assertTokenStreamNotDisjoint(ast);
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
				throw new Error("assertReflection(2) - writer.write() error \n" + e.message);
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
			assertEquals("[sv] At " + path, ast1.stringValue, ast2.stringValue);
			//assertEquals("[kind] At " + path, ast1.kind, ast2.kind);
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
	
	public static function assertTokenStreamNotDisjoint(ast:IParserNode):Vector.<LinkedListToken>
	{
		var tokensFromStartToStop:Vector.<LinkedListToken> = tokenStreamToSet(ast);
		for (var i:int=0; i<ast.numChildren; i++)
		{
			var child:IParserNode = ast.getChild(i);
			var childTokens:Vector.<LinkedListToken> = assertTokenStreamNotDisjoint(child);
			Assert.assertTrue("'"+child+"' (child "+i+" of '"+ast+
				"') had a token stream disjoint with its parent",
				containsAll(tokensFromStartToStop, childTokens));
		}
		
		return tokensFromStartToStop;
	}
	
	private static function containsAll(one:Vector.<LinkedListToken>, 
										two:Vector.<LinkedListToken>):Boolean
	{
		var test:Array = [];
		var len:int = one.length;
		for (var i:int = 0; i < len; i++)
		{
			var node:IParserNode = one[i] as IParserNode;
			var lenj:int = two.length;
			for (var j:int = 0; j < lenj; j++)
			{
				if (node === two[j])
				{
					test.push(two[j]);
					break;
				}
			}
		}
		
		return two.length == test.length;
	}
	
	private static function tokenStreamToSet(ast:IParserNode):Vector.<LinkedListToken>
	{
		var tokens:Vector.<LinkedListToken> = new Vector.<LinkedListToken>();
		
		var tok:LinkedListToken = ast.startToken;
		while (tok != null)
		{
			tokens.push(tok);
			if (tok == ast.stopToken)
			{
				break;
			}
			tok = tok.next;
		}
		return tokens;
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
	
	private static function saintyCheckTokenStream(ast:IParserNode):void
	{
		var last:LinkedListToken = null;
		for (var tok:LinkedListToken=ast.startToken; tok!=null; tok=tok.next)
		{
			if (last != null && last != tok.previous)
			{
				Assert.fail("last["+last+"].next=>["+tok+"] but next.prev=>["+tok.previous+"]");
			}
			last = tok;
		}
	}
	private static function saintyCheckStartStopTokens(ast:IParserNode):void
	{
		assertStopNotBeforeStart(ast);
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			saintyCheckStartStopTokens(i.next());
		}
	}
	
	private static function assertStopNotBeforeStart(ast:IParserNode):void
	{
		var start:LinkedListToken = ast.startToken;
		var stop:LinkedListToken = ast.stopToken;
		if (stop == start) return;
		for (var tok:LinkedListToken=stop; tok!=null; tok=tok.next)
		{
			Assert.assertFalse("Found stopToken preceeding startToken: "+ast+"("+start+" - "+stop+")",
				tok==start);
		}
	}
}
}