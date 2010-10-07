package org.as3commons.asblocks.utils
{

import org.as3commons.asblocks.ASBlocksSyntaxError;
import org.as3commons.asblocks.api.AccessorRole;
import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.IMethod;
import org.as3commons.asblocks.api.IScriptNode;
import org.as3commons.asblocks.api.IType;
import org.as3commons.asblocks.impl.ASTBuilder;
import org.as3commons.asblocks.impl.ClassTypeNode;
import org.as3commons.asblocks.impl.InterfaceTypeNode;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.LinkedListToken;
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
		i.replace(ASTBuilder.newAST(AS3NodeKind.NAME, name));
	}
	
	public static function getType(ast:IParserNode):String
	{
		var i:ASTIterator = new ASTIterator(ast);
		var result:IParserNode = i.search(AS3NodeKind.TYPE);
		if (!result)
		{
			i.reset();
			result = i.search(AS3NodeKind.VECTOR);
		}
		
		if (!result)
			return null;
		
		return stringifyType(result);
	}
	
	public static function setType(ast:IParserNode, type:String):void
	{
		var i:ASTIterator = new ASTIterator(ast);
		i.find(AS3NodeKind.TYPE);
		i.replace(ASTBuilder.newAST(AS3NodeKind.TYPE, type));
	}
	
	public static function hasType(ast:IParserNode):Boolean
	{
		var i:ASTIterator = new ASTIterator(ast);
		var result:IParserNode = i.search(AS3NodeKind.TYPE);
		if (!result)
		{
			i.reset();
			result = i.search(AS3NodeKind.VECTOR);
		}
		
		return result != null;
	}
	
	public static function stringifyType(ast:IParserNode):String
	{
		var result:String = "";
		for (var tok:LinkedListToken =  ast.startToken; tok != null && tok.kind != null; tok = tok.next)
		{
			if (tok.text != null && tok.text != ":"
				&&  tok.kind != "ws")
			{
				result += tok.text;
			}
			
			if (tok == ast.stopToken)
			{
				break;
			}
		}
		return result;
	}
	
	
	
	public static function getQualfiedName(element:IScriptNode):String
	{
		var qname:String;
		var parent:IParserNode;
		var type:IType;
		var role:String;
		if (element is IField)
		{
			var field:IField = IField(element);
			parent = field.node.parent.parent;
			type = new ClassTypeNode(parent);
			role = field.isConstant ? "constant" : "field";
			qname = type.qualifiedName + "#" + role + ":" + field.name;
			return qname;
		}
		else if (element is IMethod)
		{
			var method:IMethod = IMethod(element);
			role = "function";
			if (!method.accessorRole.equals(AccessorRole.NORMAL))
			{
				role = method.accessorRole.name;
			}
			parent = method.node.parent.parent;
			if (parent.isKind(AS3NodeKind.CLASS))
			{
				type = new ClassTypeNode(parent);
			}
			else
			{
				type = new InterfaceTypeNode(parent);
			}
			
			qname = type.qualifiedName + "#" + role + ":" + method.name;
			return qname;
		}
		//trace(ast.kind);
		return null;
	}
	
	
	
}
}