package org.as3commons.asblocks.utils
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.impl.ASTIterator;

public class NameTypeUtil
{
	public static function getName(ast:IParserNode):String
	{
		var i:ASTIterator = new ASTIterator(ast);
		return ASTUtil.nameText(i.find(AS3NodeKind.NAME));
	}
	
	public static function setName(ast:IParserNode, name:String):void
	{
		if (name == "")
		{
			throw new ASBlocksSyntaxError("Cannot set name to an empty string");
		}
		else if (name == null)
		{
			throw new ASBlocksSyntaxError("Cannot set name to null");
		}
		var i:ASTIterator = new ASTIterator(ast);
		i.find(AS3NodeKind.NAME);
		i.replace(ASTUtil.newAST(AS3NodeKind.NAME, name));
	}
	
	public static function getType(ast:IParserNode):String
	{
		var i:ASTIterator = new ASTIterator(ast);
		var result:IParserNode = i.search(AS3NodeKind.TYPE);
		if (!result)
			return null;
		return result.stringValue;
	}
	
	public static function setType(ast:IParserNode, type:String):void
	{
		var i:ASTIterator = new ASTIterator(ast);
		i.find(AS3NodeKind.TYPE);
		i.replace(ASTUtil.newAST(AS3NodeKind.TYPE, type));
	}
}
}