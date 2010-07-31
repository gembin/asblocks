package org.teotigraphix.as3nodes.impl
{

import mx.utils.StringUtil;

import org.teotigraphix.as3nodes.api.ICommentNode;
import org.teotigraphix.as3nodes.api.IDocTag;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.utils.AsDocUtil;
import org.teotigraphix.as3parser.api.ASDocNodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.impl.ASDocParser;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class CommentNode extends NodeBase implements ICommentNode
{
	protected var asdocNode:IParserNode;
	
	//----------------------------------
	//  shortDescription
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _shortDescription:String;
	
	/**
	 * doc
	 */
	public function get shortDescription():String
	{
		return _shortDescription;
	}
	
	/**
	 * @private
	 */	
	public function set shortDescription(value:String):void
	{
		_shortDescription = value;
	}
	
	//----------------------------------
	//  longDescription
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _longDescription:String;
	
	/**
	 * doc
	 */
	public function get longDescription():String
	{
		return _longDescription;
	}
	
	/**
	 * @private
	 */	
	public function set longDescription(value:String):void
	{
		_longDescription = value;
	}
	
	//----------------------------------
	//  docTags
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _docTags:Vector.<IDocTag>;
	
	/**
	 * doc
	 */
	public function get docTags():Vector.<IDocTag>
	{
		return _docTags;
	}
	
	/**
	 * @private
	 */	
	public function set docTags(value:Vector.<IDocTag>):void
	{
		_docTags = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function CommentNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	public function getDocTagAt(index:int):IDocTag
	{
		if (!docTags || index > docTags.length)
			return null;
		
		return docTags[index];
	}
	
	public function getDocTag(name:String):IDocTag
	{
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				return docTags[i];	
		}
		return null;
	}
	
	public function hasDocTag(name:String):Boolean
	{
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				return true;	
		}
		return false;
	}
	
	public function getDocTags(name:String):Vector.<IDocTag>
	{
		var result:Vector.<IDocTag> = new Vector.<IDocTag>();
		var len:int = docTags.length;
		for (var i:int = 0; i < len; i++)
		{
			if (docTags[i].name == name)
				result.push(docTags[i]);	
		}
		return result;
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
		var parser:ASDocParser = new ASDocParser();
		var lines:Array = toString().split("\n");
		
		asdocNode = parser.buildAst(ASTUtil.toVector(lines), "asdoc");
		
		// compilation-unit/content
		var contentNode:IParserNode = asdocNode.getLastChild();
		shortDescription = parseShortDescription(contentNode); 
		longDescription = parseLongDescription(contentNode);
		docTags = parseDocTagList(contentNode);
	}
	
	protected function parseShortDescription(child:IParserNode):String
	{
		var result:String = "";
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.SHORT_LIST, child);
		if (!list)
			return null;
		
		for each (var element:IParserNode in list.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		return result;
	}
	
	protected function parseLongDescription(child:IParserNode):String
	{
		var result:String = "";
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.LONG_LIST, child);
		if (!list)
			return null;
		
		for each (var element:IParserNode in list.children)
		{
			result += AsDocUtil.returnString(element);
		}
		
		result = StringUtil.trim(result);
		
		return result;
	}
	
	protected function parseDocTagList(child:IParserNode):Vector.<IDocTag>
	{
		var list:IParserNode = ASTUtil.getNode(ASDocNodeKind.DOCTAG_LIST, child);
		if (!list)
			return null;
		
		var result:Vector.<IDocTag> = new Vector.<IDocTag>();
		
		for each (var element:IParserNode in list.children)
		{
			result.push(new DocTagNode(element, this));
		}
		
		return result;
	}
	
	public function toString():String
	{
		return node.stringValue;
	}
}
}