package org.as3commons.asblocks.impl
{

import flash.events.IEventDispatcher;

import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.parser.api.ISourceCode;

public interface IParserInfo extends IEventDispatcher
{
	
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get sourceCode():ISourceCode;
	
	//----------------------------------
	//  entry
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get entry():IClassPathEntry;
	
	//----------------------------------
	//  unit
	//----------------------------------
	
	/**
	 * TODO Docme
	 */
	function get unit():ICompilationUnit;
}
}