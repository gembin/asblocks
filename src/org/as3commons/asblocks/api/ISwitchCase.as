package org.as3commons.asblocks.api
{

public interface ISwitchCase extends ISwitchLabel
{
	
	//----------------------------------
	//  label
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get label():IExpression;
	
	/**
	 * @private
	 */
	function set label(value:IExpression):void;
}
}