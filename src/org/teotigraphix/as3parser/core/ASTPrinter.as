package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3parser.api.IParserNode;

public class ASTPrinter
{
	private var sourceCode:SourceCode;
	
	public function ASTPrinter(sourceCode:SourceCode)
	{
		this.sourceCode = sourceCode;
	}
	
	public function print(ast:IParserNode):void
	{
		for (var tok:LinkedListToken = findStart(ast); tok != null; tok = tok.next)
		{
			printLn(tok);
		}
	}
	
	private function findStart(ast:IParserNode):LinkedListToken
	{
		var result:LinkedListToken = null;
		
		for (var tok:LinkedListToken = ast.startToken; viable(tok); tok = tok.previous)
		{
			result = tok;
		}
		return result;
	}
	
	private function printLn(token:LinkedListToken):void
	{
		if (!sourceCode.code)
			sourceCode.code = "";
		
		if (token.text != null)
			sourceCode.code += token.text;
	}
	
	private function viable(token:LinkedListToken):Boolean
	{
		return token != null && token.kind != "__END__";
	}
	
	public function flush():String
	{
		var result:String = toString();
		sourceCode.code = null;
		return result;
	}
	
	public function toString():String
	{
		return sourceCode.code;
	}
}
}