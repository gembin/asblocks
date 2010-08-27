package org.teotigraphix.as3parser.core
{
import org.teotigraphix.as3nodes.api.IParameterNode;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.ITokenListUpdateDelegate;

public class ParentheticListUpdateDelegate implements ITokenListUpdateDelegate
{
	// TODO: many methods simply duplicate those in
	//       BasicListUpdateDelegate, maybe just subclass it?
	
	private var tokenTypeOpen:String;
	private var tokenTypeClose:String;
	
	public function ParentheticListUpdateDelegate(tokenTypeOpen:String, 
												  tokenTypeClose:String)
	{
		this.tokenTypeOpen = tokenTypeOpen;
		this.tokenTypeClose = tokenTypeClose;
	}
	
	public function addedChild(parent:IParserNode, 
							   child:IParserNode):void
	{
		var insert:LinkedListToken = findClose(parent).previous;
		
		insertAfter(insert, insert.next, child.startToken, child.stopToken);
	}
	
	private function findOpen(parent:IParserNode):LinkedListToken
	{
		for (var tok:LinkedListToken = parent.startToken; tok != null; tok = tok.next)
		{
			if (tok.kind == tokenTypeOpen)
			{
				return tok;
			}
		}
		return null;
	}
	
	private function findClose(parent:IParserNode):LinkedListToken
	{
		for (var tok:LinkedListToken = parent.stopToken; tok != null; tok = tok.previous)
		{
			if (tok.kind == tokenTypeClose)
			{
				return maybeSkiptoLinePreceeding(tok);
			}
		}
		return null;
	}
	
	private function maybeSkiptoLinePreceeding(target:LinkedListToken):LinkedListToken
	{
		for (var tok:LinkedListToken = target.previous; tok != null; tok = tok.previous)
		{
			switch (tok.kind) 
			{
				case AS3NodeKind.SPACE:
					continue;
				case AS3NodeKind.NL:
					return tok;
				default:
					return target;
			}
		}
		return target;
	}
	
	protected static function insertAfter(target:LinkedListToken, 
										  targetNext:LinkedListToken,
										  start:LinkedListToken, 
										  stop:LinkedListToken):void
	{
		if (target == null && targetNext == null) 
		{
			// IllegalArgumentException
			throw new Error("At least one of target and targetNext must be non-null");
		}
		if (start != null) 
		{
			// i.e. we're not adding an imaginary node that currently
			//      has no real children
			if (target != null) {
				target.next = start;
			}
			stop.next = targetNext;
			if (targetNext != null) 
			{
				targetNext.previous = stop;
			}
		}
	}
	
	public function addedChildAt(tree:IParserNode, index:int, child:IParserNode):void
	{
		var target:LinkedListToken;
		var targetNext:LinkedListToken;
		
		if (index == 0) 
		{
			target = findOpen(tree);
			targetNext = target.next;
		} 
		else 
		{
			var prev:IParserNode = tree.getChild(index - 1);
			target = prev.stopToken;
			targetNext = target.next;
		}
		insertAfter(target, targetNext, child.startToken, child.stopToken);
	}
	
	public function appendToken(parent:IParserNode, append:LinkedListToken):void
	{
		var insert:LinkedListToken = findClose(parent).previous;
		insertAfter(insert, insert.next, append, append);
	}
	
	public function addToken(parent:IParserNode, index:int, append:LinkedListToken):void
	{
		var target:LinkedListToken;
		var targetNext:LinkedListToken;
		
		if (index == 0)
		{
			target = findOpen(parent);
			// added
			if (!target)
			{
				target = parent.startToken;
			}
			targetNext = target.next;
		} 
		else 
		{
			var beforeChild:IParserNode = parent.getChild(index);
			// added
			if (!beforeChild)
			{
				//targetNext = parent.startToken.next;
				target = parent.startToken.next;
			}
			else
			{
				targetNext = beforeChild.startToken;
				target = targetNext.previous;
			}
			
			//target = targetNext.previous;
		}
		insertAfter(target, targetNext,	append, append);
	}
	
	public function deletedChild(parent:IParserNode, index:int, child:IParserNode):void
	{
		var start:LinkedListToken = child.startToken;
		var stop:LinkedListToken = child.stopToken;
		var startPrev:LinkedListToken = start.previous;
		var stopNext:LinkedListToken = stop.next;
		if (startPrev != null) 
		{
			startPrev.next = stopNext;
		} 
		else if (stopNext != null)
		{
			stopNext.previous = startPrev;
		}
		// just to save possible confusion, break links out from the
		// removed token list too,
		start.previous = null;
		stop.next = null;
	}
	
	public function replacedChild(tree:IParserNode, index:int, child:IParserNode, oldChild:IParserNode):void
	{
		// link the new child's tokens in place of the old,
		oldChild.startToken.previous.next = child.startToken;
		oldChild.stopToken.next.previous = child.stopToken;
		// just to save possible confusion, break links out from the
		// removed token list too,
		oldChild.startToken.previous = null;
		oldChild.stopToken.next = null;
	}
	
}
}