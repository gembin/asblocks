package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IIdentifierNode;
import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.IModifierAware;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IVariableNode;
import org.teotigraphix.as3nodes.api.MetaData;
import org.teotigraphix.as3nodes.api.Modifier;
import org.teotigraphix.as3nodes.utils.MetaDataUtils;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class VariableNode extends NodeBase implements IVariableNode, IModifierAware
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
	protected var identifier:IdentifierNode;
	
	/**
	 * @private
	 */
	private var _name:String;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.INameAware#name
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
	
	//--------------------------------------------------------------------------
	//
	//  IVariableNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _type:IIdentifierNode;
	
	/**
	 * doc
	 */
	public function get type():IIdentifierNode
	{
		return _type;
	}
	
	/**
	 * @private
	 */	
	public function set type(value:IIdentifierNode):void
	{
		_type = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  IMetaDataAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  numMetaData
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var metaData:Vector.<IMetaDataNode>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#numMetaData
	 */
	public function get numMetaData():int
	{
		return metaData.length;
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#addMetaData()
	 */
	public function addMetaData(node:IMetaDataNode):void
	{
		metaData.push(node);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IMetaDataAware#getMetaData()
	 */
	public function getMetaData(name:String):Vector.<IMetaDataNode>
	{
		var result:Vector.<IMetaDataNode> = new Vector.<IMetaDataNode>();
		
		var len:int = metaData.length;
		for (var i:int = 0; i < len; i++)
		{
			var element:IMetaDataNode = metaData[i] as IMetaDataNode;
			if (element.name == name)
				result.push(element);
		}
		
		return result;
	}
	
	public function hasMetaData(meta:MetaData):Boolean
	{
		for each (var element:IMetaDataNode in metaData)
		{
			if (element.name == meta.name)
				return true;
		}
		return false;
	}
	
	public function get isBindable():Boolean
	{
		return hasMetaData(MetaData.BINDABLE);
	}
	
	//--------------------------------------------------------------------------
	//
	//  IModifierAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	protected var modifiers:Vector.<Modifier>;
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#addModifier()
	 */
	public function addModifier(modifier:Modifier):void
	{
		modifiers.push(modifier);
	}
	
	/**
	 * @copy org.teotigraphix.as3nodes.api.IModifierAware#hasModifier()
	 */
	public function hasModifier(modifier:Modifier):Boolean
	{
		for each (var element:Modifier in modifiers)
		{
			if (element.equals(modifier))
				return true;
		}
		return false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function VariableNode(node:IParserNode, parent:INode)
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
		metaData = new Vector.<IMetaDataNode>();
		
		var nti:IParserNode = ASTUtil.getNameTypeInit(node);
		if (!nti)
			return;
		
		identifier = IdentifierNode.create(nti.getChild(0), this);
		name = identifier.toString();
		type = IdentifierNode.create(nti.getChild(1), this);
		
		// nameTypeInit
		// metaList
		for each (var element:IParserNode in node.children)
		{
			if (element.isKind(AS3NodeKind.META_LIST))
			{
				MetaDataUtils.computeMetaDataList(this, element);
			}
		}
	}
}
}