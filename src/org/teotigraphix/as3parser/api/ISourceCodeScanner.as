package org.teotigraphix.as3parser.api
{

public interface ISourceCodeScanner
{
	
	//----------------------------------
	//  asdocOffset
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get asdocOffset():int;
	
	/**
	 * @private
	 */
	function set asdocOffset(value:int):void;
	
	//----------------------------------
	//  commentLine
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get commentLine():int;
	
	/**
	 * @private
	 */
	function set commentLine(value:int):void;
	
	//----------------------------------
	//  commentColumn
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get commentColumn():int;
	
	/**
	 * @private
	 */
	function set commentColumn(value:int):void;
	
	function setInBlock(value:Boolean):void;
}
}