package org.teotigraphix.as3nodes.impl
{

import org.teotigraphix.as3nodes.api.IMetaDataNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

public class MetaDataNode extends NodeBase implements IMetaDataNode
{
	//--------------------------------------------------------------------------
	//
	//  INameAware API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  name
	//----------------------------------
	
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
	//  IMetaDataNode API :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  parameter
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _parameter:String;
	
	/**
	 * doc
	 */
	public function get parameter():String
	{
		return _parameter;
	}
	
	/**
	 * @private
	 */	
	public function set parameter(value:String):void
	{
		_parameter = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MetaDataNode(node:IParserNode, parent:INode)
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
		var data:String = node.stringValue;
		
		_name = data.indexOf(" ( ") > -1 ? 
			data.substring( 0, data.indexOf(" ( "))	: 
			data;
		
		_parameter = data.indexOf("( ") > -1 ? 
			data.substring(data.indexOf("( ") + 2, data.lastIndexOf(" )")) : 
			"";
	}
}
}