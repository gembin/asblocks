package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3parser.api.ASDocNodeKind;

public class ASDocLinkedListTreeAdaptor extends LinkedListTreeAdaptor
{
	public function ASDocLinkedListTreeAdaptor()
	{
		super();
	}
	
	override public function createNode(payload:LinkedListToken):TokenNode 
	{
		var result:TokenNode = new TokenNode(
			payload.kind, 
			payload.text, 
			payload.line, 
			payload.column);
		
		TokenNode(result).token = payload;
		
		TokenNode(result).tokenListUpdater = delegate;
		
		if (payload.kind == ASDocNodeKind.CONTENT)
		{
			TokenNode(result).tokenListUpdater = 
				new ParentheticListUpdateDelegate("ml-start", "ml-end");
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