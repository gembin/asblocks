package org.teotigraphix.as3nodes.impl
{
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3nodes.api.IUseNode;
import org.teotigraphix.as3parser.api.IParserNode;

public class UseNode extends NodeBase implements IUseNode
{
	//----------------------------------
	//  nameSpace
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _nameSpace:String;
	
	/**
	 * doc
	 */
	public function get nameSpace():String
	{
		return _nameSpace;
	}
	
	/**
	 * @private
	 */	
	public function set nameSpace(value:String):void
	{
		_nameSpace = value;
	}
	
	public function UseNode(node:IParserNode, parent:INode)
	{
		super(node, parent);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function compute():void
	{
		_nameSpace = node.stringValue;
	}
}
}