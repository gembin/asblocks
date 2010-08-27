package org.teotigraphix.as3parser.core
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

public class LinkedListTreeAdaptor
{
	public function LinkedListTreeAdaptor()
	{
	}
	
	private var delegate:TokenListUpdateDelegate = new TokenListUpdateDelegate();
	
	public function createToken(kind:String, 
								text:String = null,
								line:int = -1, 
								column:int = -1):LinkedListToken 
	{
		var token:LinkedListToken = new LinkedListToken(kind, text);
		if (kind == AS3NodeKind.SPACE 
			|| kind == AS3NodeKind.TAB 
			|| kind == AS3NodeKind.NL)
		{
			token.channel = AS3NodeKind.HIDDEN;
		}
		token.line = line;
		token.column = column;
		return token;
	}
	
	public function create(kind:String, 
						   text:String = null,
						   line:int = -1, 
						   column:int = -1,
						   child:IParserNode = null):TokenNode 
	{
		var token:LinkedListToken = new LinkedListToken(kind, text);
		token.line = line;
		token.column = column;
		var node:TokenNode = createNode(token);
		if (child)
		{
			node.addChild(child);
		}
		return node;
	}
	
	public function createNode(payload:LinkedListToken):TokenNode 
	{
		var result:TokenNode = new TokenNode(
			payload.kind, 
			payload.text, 
			payload.line, 
			payload.column);
		
		TokenNode(result).token = payload;
		
		TokenNode(result).tokenListUpdater = delegate;
		
		if (payload.kind == AS3NodeKind.ARRAY
			/*|| payload.kind == AS3NodeKind.ARRAY_ACCESSOR*/)
		{
			TokenNode(result).tokenListUpdater = 
				new ParentheticListUpdateDelegate(AS3NodeKind.LBRACKET, AS3NodeKind.RBRACKET);
		}
		else if (payload.kind == AS3NodeKind.OBJECT
			|| payload.kind == AS3NodeKind.BLOCK)
		{
			TokenNode(result).tokenListUpdater = 
				new ParentheticListUpdateDelegate(AS3NodeKind.LCURLY, AS3NodeKind.RCURLY);
		}
		else if (payload.kind == AS3NodeKind.PARAMETER_LIST
			|| payload.kind == AS3NodeKind.ARGUMENTS)
		{
			TokenNode(result).tokenListUpdater = 
				new ParentheticListUpdateDelegate(AS3NodeKind.LPAREN, AS3NodeKind.RPAREN);
		}
		
		if (payload is LinkedListToken) 
		{
			result.startToken = LinkedListToken(payload);
			result.stopToken = LinkedListToken(payload);
		}
		
		return result;
	}
}
}