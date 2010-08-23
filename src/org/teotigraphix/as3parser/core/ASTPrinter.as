package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3parser.api.IParserNode;

public class ASTPrinter
{
	private var code:SourceCode;
	
	public function ASTPrinter(code:SourceCode)
	{
		this.code = code;
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
		if (!code.code)
			code.code = "";
		
		if (token.text != null)
			code.code += token.text;
	}
	
	private function viable(token:LinkedListToken):Boolean
	{
		return token != null && token.kind != "__END__";
	}
}
}