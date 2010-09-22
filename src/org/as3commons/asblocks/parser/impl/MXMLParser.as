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

package org.as3commons.asblocks.parser.impl
{

import mx.utils.StringUtil;

import org.as3commons.asblocks.parser.api.IParser;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.IScanner;
import org.as3commons.asblocks.parser.api.ISourceCodeScanner;
import org.as3commons.asblocks.parser.api.MXMLNodeKind;
import org.as3commons.asblocks.parser.core.Node;
import org.as3commons.asblocks.parser.core.Token;
import org.as3commons.asblocks.parser.errors.NullTokenError;
import org.as3commons.asblocks.parser.errors.Position;
import org.as3commons.asblocks.parser.errors.UnExpectedTokenError;

/**
 * The default implementation of an .mxml parser.
 * 
 * @author Michael Schmalle
 * @copyright Teoti Graphix, LLC
 * @productversion 1.0
 */
public class MXMLParser extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var pendingASDoc:IParserNode = null;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function MXMLParser()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createScanner():IScanner
	{
		return new MXMLScanner();
	}
	
	/**
	 * @private
	 */
	override protected function initialize():void
	{
		pendingASDoc = null;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal Parser :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  compilation-unit
	//----------------------------------
	
	/**
	 * @private
	 */
	override public function parseCompilationUnit():IParserNode
	{
		var result:Node =
			Node.create(MXMLNodeKind.COMPILATION_UNIT, -1, -1);
		
		nextToken(); // start the parse
		
		if (!tokIs("<?"))
		{
			throw new UnExpectedTokenError(
				"<?", 
				token.text, 
				new Position(token.line, token.column, -1), 
				fileName);
		}
		
		result.addChild(parseProcInst());
		
		nextToken(); // chomp all whitespace
		
		if (tokenStartsWith("<!---")) // this will be the class asdoc
		{
			pendingASDoc = parseASDoc();
		}
		
		if (tokIs("<")) // first tag is application/component
		{
			result.addChild(parseTagList());
		}
		
		return result;
	}
	
	//----------------------------------
	//  proc-inst
	//----------------------------------
	
	/*
	* - PROC_INST
	*/
	internal function parseProcInst():Node
	{
		// current token "<?"
		var text:String = "";
		
		var line:int = token.line;
		var column:int = token.column;
		
		while (!tokIs("?>"))
		{
			text += token.text;
			nextTokenAllowWhiteSpace();
		}
		
		text += "?>";
		
		var result:Node =
			Node.create(MXMLNodeKind.PROC_INST,
				line,
				column,
				text);
		
		return result;
	}
	
	//----------------------------------
	//  as-doc
	//----------------------------------
	
	/**
	 * @private
	 */
	private var asdocColumn:int;
	
	/**
	 * @private
	 */
	private var asdocLine:int;
	
	/*
	* - AS_DOC
	*/
	internal function parseASDoc():Node
	{
		// current token "<!--- doc. -->"
		asdocLine = ISourceCodeScanner(scanner).commentLine;
		asdocColumn = ISourceCodeScanner(scanner).commentColumn;
		
		var result:Node =
			Node.create(MXMLNodeKind.AS_DOC,
				asdocLine,
				asdocColumn,
				token.text);
		
		nextToken();
		
		return result;
	}
	
	//----------------------------------
	//  tag-list
	//----------------------------------
	
	/*
	* TAG_LIST
	*   - AS_DOC (optional)
	*   - BINDING (optional)
	*   - LOCAL_NAME (required)
	*   - ATT
	*     - NAME
	*     - VALUE
	*   - TAG_LIST (optional)
	*/
	
	internal function parseTagList():Node
	{
		// current token "<"
		var line:int = token.line;
		var column:int = token.column;
		
		var result:Node =
			Node.create(MXMLNodeKind.TAG_LIST, line, column);
		
		var cdata:String = "";
		
		if (pendingASDoc != null)
		{
			result.addChild(pendingASDoc);
			pendingASDoc = null;
		}
		
		// <, s, :, Application
		
		nextToken(); // <
		
		var bindingFound:Boolean = false;
		
		var bindingOrLocalName:Token = token;
		var tagName:String = bindingOrLocalName.text;
		
		nextToken(); // (:|TAG_NAME)
		
		if (token.text == ":")
		{
			result.addChild(Node.create(MXMLNodeKind.BINDING,
				bindingOrLocalName.line,
				bindingOrLocalName.column,
				bindingOrLocalName.text));
			
			nextToken();
			bindingOrLocalName = token;
			tagName = bindingOrLocalName.text;
			bindingFound = true;
		}
		else
		{
			bindingFound = false;
		}
		
		// only call next if there was a binding, if not we are already there
		if (bindingFound)
		{
			nextToken(); // maybe xmlns or att or <
		}
		
		// added to solve . error in tag name (state)
		// TODO edit ast to include tag state
		if (tokIs("."))
		{
			nextToken();
			tagName = tagName + "." + token.text;
			nextToken(); // maybe xmlns or att or <
		}
		
		result.addChild(Node.create(MXMLNodeKind.LOCAL_NAME,
			bindingOrLocalName.line,
			bindingOrLocalName.column,
			tagName));
		
		var closing:Boolean = false;
		var inAttList:Boolean = true;
		
		while (!tokIs("/>"))
		{
			// if we have passed the closing tag's </, binding(optional) and local name
			if (closing && tokIs(">"))
			{
				break;
			}
			// if we are not closing but have reached tag end, atts cannot be collected
			if (!closing && tokIs(">"))
			{
				inAttList = false;
			}
			// mark as closing, need to digest binding(optional) and local name
			if (token.text == "</")
			{
				closing = true;
			}
			
			//-----------------------------
			// descent parsing
			//-----------------------------
			
			// parse an asdoc comment
			if (tokenStartsWith("<!---"))
			{
				pendingASDoc = parseASDoc();
			}
				// parse the name space declaration
			else if (token.text == "xmlns")
			{
				result.addChild(parseXmlNs());
			}
			else if (token.text == "<![CDATA[")
			{
				result.addChild(parseCData());
			}
				// parse a new nested tag list
			else if (token.text == "<")
			{
				result.addChild(parseTagList());
			}
				// if we are still in the tag and are not closing it, do an attribute
			else if (inAttList)
			{
				var aresult:Node = parseAtt();
				if (aresult != null)
				{
					result.addChild(aresult);
				}
				else
				{
					//nextToken();
				}
			}
				// other wise, pass all junk IE (binding ends, :, etc)
			else
			{
				// we must be in a text node
				if (!closing && !inAttList && !tokIs(">"))
				{
					// System.out.println("{" + tok.getText() + "}");
					cdata += token.text;
				}
				nextTokenAllowWhiteSpace();
			}
		}
		
		if (StringUtil.trim(cdata).length > 0)
		{
			// text node
			result.addChild(Node.create(MXMLNodeKind.CDATA,
				token.line,
				token.column,
				cdata));
		}
		
		// these tokens are required to leave this method
		// to types of end tag tokens
		if (tokIs("/>") || tokIs("</"))
		{
			consume(token.text);
		}
		
		return result;
	}
	
	//----------------------------------
	//  xmlns
	//----------------------------------
	
	/*
	* - XMLNS
	*   - LOCAL_NAME
	*   - URI
	*/
	internal function parseXmlNs():Node
	{
		// current token "xmlns"
		var result:Node =
			Node.create(MXMLNodeKind.XML_NS, token.line, token.column);
		
		consume("xmlns");
		consume(":");
		
		result.addChild(Node.create(MXMLNodeKind.LOCAL_NAME,
			token.line,
			token.column,
			token.text));
		
		nextToken(); // s binding
		consume("=");
		
		result.addChild(Node.create(MXMLNodeKind.URI,
			token.line,
			token.column,// should +1 since quotes are trimmed
			trimQuotes(token.text)));
		
		nextToken(); // "library://ns.adobe.com/flex/spark"
		
		return result;
	}
	
	//----------------------------------
	//  cdata
	//----------------------------------
	
	/*
	* - CDATA
	*/
	internal function parseCData():Node
	{
		// FIXME Cdata line and column is not correct
		
		// current token "all string data in between CDATA tags"
		var line:int = token.line;
		var column:int = token.column;
		
		var result:Node =
			Node.create(MXMLNodeKind.CDATA, line, column, token.text);
		
		nextToken();
		
		return result;
	}
	
	//----------------------------------
	//  att
	//----------------------------------
	
	/*
	* - ATT
	*   - NAME
	*   - STATE
	*   - VALUE
	*/
	internal function parseAtt():Node
	{
		// current token "attributName"
		var result:Node =
			Node.create(MXMLNodeKind.ATT, token.line, token.column);
		
		result.addChild(Node.create(MXMLNodeKind.NAME,
			token.line,
			token.column,
			token.text));
		
		var state:Node = null;
		
		nextToken();
		if (token.text == ".")
		{
			skip(".");
			state =
				Node.create(MXMLNodeKind.STATE,
					token.line,
					token.column,
					token.text);
			nextToken();
		}
		
		if (!tokIs("="))
		{
			return null;
		}
		
		consume("=");
		
		result.addChild(Node.create(MXMLNodeKind.VALUE,
			token.line,
			token.column,
			trimQuotes(token.text)));
		
		if (state != null)
		{
			result.addChild(state);
		}
		
		nextToken(); // pass the value
		
		return result;
	}
	
	/**
	 * @private
	 */
	override protected function moveToNextToken():void
	{
		do
		{
			token = scanner.nextToken();
			
			if (token == null)
			{
				throw new NullTokenError(fileName);
				
			}
			if (token.text == null)
			{
				throw new NullTokenError(fileName);
			}
		}
		while (tokenStartsWith("<!--")
			&& !tokenStartsWith("<!---"));
	}
}
}