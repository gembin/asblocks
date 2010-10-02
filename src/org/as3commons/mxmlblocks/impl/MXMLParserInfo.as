package org.as3commons.mxmlblocks.impl
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;

import org.as3commons.asblocks.IASParser;
import org.as3commons.asblocks.api.IClassPathEntry;
import org.as3commons.asblocks.api.ICompilationUnit;
import org.as3commons.asblocks.impl.ParserInfo;
import org.as3commons.asblocks.parser.api.ISourceCode;
import org.as3commons.mxmlblocks.IMXMLParser;

public class MXMLParserInfo extends ParserInfo
{
	public function MXMLParserInfo(parser:Object, 
								   sourceCode:ISourceCode, 
								   entry:IClassPathEntry)
	{
		super(parser, sourceCode, entry, false);
	}
	
	override public function parse():ICompilationUnit
	{
		var mxmlparser:IMXMLParser = IMXMLParser(parser);
		_unit = mxmlparser.parse(sourceCode, entry);
		return _unit;
	}
}
}