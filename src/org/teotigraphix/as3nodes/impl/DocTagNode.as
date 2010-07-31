package org.teotigraphix.as3nodes.impl
{

import mx.utils.StringUtil;

import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;

public class DocTagNode extends NodeBase implements IDocTag
{
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#name
	 */
	public function get name():String
	{
		return _name;
	}
	
	/**
	 * @private
	 */	
	public function set name(value:String):void
	{
		_name = value;
	}
	
	//----------------------------------
	//  body
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _body:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#body
	 */
	public function get body():String
	{
		return _body;
	}
	
	/**
	 * @private
	 */	
	public function set body(value:String):void
	{
		_body = value;
	}
	//----------------------------------
	//  preformated
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _preformated:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IDocTag#preformated
	 */
	public function get preformated():String
	{
		return _preformated;
	}
	
	/**
	 * @private
	 */	
	public function set preformated(value:String):void
	{
		_preformated = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function DocTagNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	override protected function compute():void
	{
		var nameNode:IParserNode = node.getChild(0);
		name = StringUtil.trim(nameNode.stringValue);
		
		if (node.numChildren == 1)
			return;
		
		var bodyNode:IParserNode = node.getChild(1);
		
		if (bodyNode && bodyNode.numChildren > 0)
		{
			var bodyString:String = "";
			
			for each (var element:IParserNode in bodyNode.children)
			{
				if (element.isKind(ASDocNodeKind.TEXT))
				{
					bodyString += AsDocUtil.returnString(element);
				}
				else if (element.isKind(ASDocNodeKind.PRE_TEXT))
				{
					
				}
			}
			
			body = StringUtil.trim(bodyString);
		}
	}
	
	public function toString():String
	{
		return "@" + name + "[" + body + "]";
	}
}
}