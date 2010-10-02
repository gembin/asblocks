package org.as3commons.asblocks.impl
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.as3commons.asblocks.IASParser;
import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.parser.api.ISourceCode;

public class ParserInfo extends EventDispatcher implements IParserInfo
{
	//----------------------------------
	//  sourceCode
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _sourceCode:ISourceCode;
	
	/**
	 * doc
	 */
	public function get sourceCode():ISourceCode
	{
		return _sourceCode;
	}
	
	//----------------------------------
	//  entry
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _entry:IClassPathEntry;
	
	/**
	 * doc
	 */
	public function get entry():IClassPathEntry
	{
		return _entry;
	}
	
	//----------------------------------
	//  unit
	//----------------------------------
	
	/**
	 * @private
	 */
	protected var _unit:ICompilationUnit;
	
	/**
	 * doc
	 */
	public function get unit():ICompilationUnit
	{
		return _unit;
	}
	
	public var parser:Object;
	
	public var parseBlocks:Boolean;
	
	
	public function ParserInfo(parser:Object, 
							   sourceCode:ISourceCode, 
							   entry:IClassPathEntry, 
							   parseBlocks:Boolean)
	{
		super();
		
		this.parser = parser;
		_sourceCode = sourceCode;
		_entry = entry;
		this.parseBlocks = parseBlocks;
	}
	
	public function parse():ICompilationUnit
	{
		var asparser:IASParser = IASParser(parser);
		_unit = asparser.parse(sourceCode, parseBlocks);
		return _unit;
	}
}
}