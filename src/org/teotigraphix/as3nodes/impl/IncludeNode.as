package org.teotigraphix.as3nodes.impl
{
import org.teotigraphix.as3nodes.api.IIncludeNode;
import org.teotigraphix.as3nodes.api.INode;
import org.teotigraphix.as3parser.api.IParserNode;

public class IncludeNode extends NodeBase implements IIncludeNode
{
	//----------------------------------
	//  filePath
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _filePath:String;
	
	/**
	 * doc
	 */
	public function get filePath():String
	{
		return _filePath;
	}
	
	/**
	 * @private
	 */	
	public function set filePath(value:String):void
	{
		_filePath = value;
	}
	
	public function IncludeNode(node:IParserNode, parent:INode)
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
		_filePath = node.stringValue;
	}
}
}