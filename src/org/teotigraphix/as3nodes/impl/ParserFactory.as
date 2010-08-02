////////////////////////////////////////////////////////////////////////////////
// Copyright 2010 Michael Schmalle - Teoti Graphix, LLC
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software 
// distributed under the License is distributed on an "AS IS" BASIS, 
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and 
// limitations under the License
// 
// Author: Michael Schmalle, Principal Architect
// mschmalle at teotigraphix dot com
////////////////////////////////////////////////////////////////////////////////

package org.teotigraphix.as3nodes.impl
{
import org.teotigraphix.as3parser.api.IParser;
import org.teotigraphix.as3parser.impl.AS3Parser;
import org.teotigraphix.as3parser.impl.MXMLParser;

/**
 * TODO DOCME
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class ParserFactory
{
	public function ParserFactory()
	{
	}
	
	/**
	 * @private
	 */
	private static var _instance:ParserFactory;
	
	/**
	 * Returns the single instance of the ParserFactory.
	 */
	public static function get instance():ParserFactory
	{
		if (!_instance)
			_instance = new ParserFactory();
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public :: Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  as3parser
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _as3parser:IParser;
	
	/**
	 * The factory's actionscript3 parser.
	 * 
	 * <p>This property is for shared parser usages, if using a parser
	 * async such as with batches, a new parser will need to be created.</p>
	 */
	public function get as3parser():IParser
	{
		if (!_as3parser)
			_as3parser = createAS3Parser();
		return _as3parser;
	}
	
	//----------------------------------
	//  mxmlparser
	//----------------------------------
	
	/**
	 * @private
	 */
	private var _mxmlparser:IParser;
	
	/**
	 * The factory's mxml parser.
	 * 
	 * <p>This property is for shared parser usages, if using a parser
	 * async such as with batches, a new parser will need to be created.</p>
	 */
	public function get mxmlparser():IParser
	{
		if (!_mxmlparser)
			_mxmlparser = createMXMLParser();
		return _mxmlparser;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Public Factory :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Creates an actionscript3 IParser.
	 * 
	 * @return A new actionscript3 implementation of IParser.
	 */
	public function createAS3Parser():IParser
	{
		return new AS3Parser();
	}
	
	/**
	 * Creates an mxml IParser.
	 * 
	 * @return A new mxml implementation of IParser.
	 */
	public function createMXMLParser():IParser
	{
		return new MXMLParser();
	}
}
}