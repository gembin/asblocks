package org.teotigraphix.as3dom.api
{

public interface ICompilationUnit
{
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get packageName():String;
	
	/**
	 * @private
	 */
	function set packageName(value:String):void;
	
	
	//----------------------------------
	//  type
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get type():ICompilationUnit;
	
	/**
	 * @private
	 */
	function set type(value:ICompilationUnit):void;
	
	
	//----------------------------------
	//  packageElement
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	//function get packageElement():IPackageElement;
	
	/**
	 * @private
	 */
	//function set packageElement(value:IPackageElement):void;
}
}