package org.as3commons.asblocks.utils
{

import org.as3commons.asblocks.api.IField;
import org.as3commons.asblocks.api.Visibility;
import org.as3commons.asblocks.impl.ASTBuilder;
import org.as3commons.asblocks.impl.ASTTypeBuilder;
import org.as3commons.asblocks.impl.FieldNode;
import org.as3commons.asblocks.parser.api.AS3NodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.impl.ASTIterator;

public class FieldUtil
{
	public static function getFields(ast:IParserNode):Vector.<IField>
	{
		var result:Vector.<IField> = new Vector.<IField>();
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			var member:IParserNode = i.search(AS3NodeKind.FIELD_LIST);
			if (member)
			{
				result.push(new FieldNode(member));
			}
		}
		return result;
	}
	
	/**
	 * @copy org.as3commons.asblocks.api.IClassType#newField()
	 */
	public static function newField(ast:IParserNode,
									name:String, 
									visibility:Visibility, 
									type:String):IField
	{
		var fieldAST:IParserNode = ASTTypeBuilder.newFieldAST(name, visibility, type);
		var field:IField = new FieldNode(fieldAST);
		addField(ast, field);
		return field;
	}
	
	/**
	 * @private
	 */
	public static function addField(ast:IParserNode, field:IField):void
	{
		ASTUtil.addChildWithIndentation(ast, field.node);
	}
	
	public static function getField(ast:IParserNode, name:String):IField
	{
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FIELD_LIST))
			{
				var field:IField = new FieldNode(member);
				if (field.name == name)
				{
					return field;
				}
			}
		}
		return null;
	}
	
	public static function removeField(ast:IParserNode, name:String):IField
	{
		var i:ASTIterator = new ASTIterator(ast);
		while (i.hasNext())
		{
			var member:IParserNode = i.next();
			if (member.isKind(AS3NodeKind.FIELD_LIST))
			{
				var field:IField = new FieldNode(member);
				if (field.name == name)
				{
					i.remove();
					return field;
				}
			}
		}
		return null;
	}
}
}