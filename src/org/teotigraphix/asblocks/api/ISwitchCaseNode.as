package org.teotigraphix.asblocks.api
{

public interface ISwitchCaseNode extends ISwitchLabelNode
{
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get label():IExpressionNode;
	
	/**
	 * @private
	 */
	function set label(value:IExpressionNode):void;
}
}