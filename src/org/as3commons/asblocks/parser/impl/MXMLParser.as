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

import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.IScanner;
import org.as3commons.asblocks.parser.api.ISourceCodeScanner;
import org.as3commons.asblocks.parser.api.MXMLNodeKind;
import org.as3commons.asblocks.parser.api.Operators;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.LinkedListTreeAdaptor;
import org.as3commons.asblocks.parser.core.Node;
import org.as3commons.asblocks.parser.core.Token;
import org.as3commons.asblocks.parser.core.TokenNode;
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
		
		adapter = new LinkedListTreeAdaptor();
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
		var s:IScanner = new MXMLScanner();
		s.allowWhiteSpace = true;
		return s;
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
		var result:TokenNode = adapter.create(MXMLNodeKind.COMPILATION_UNIT);
		
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
		
		nextNonWhiteSpaceToken(result); // chomp all whitespace
		
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
	internal function parseProcInst():TokenNode
	{
		var result:TokenNode = adapter.copy(MXMLNodeKind.PROC_INST, token);
		// current token "<?"
		var text:String = "";
		
		var line:int = token.line;
		var column:int = token.column;
		
		while (!tokIs("?>"))
		{
			text += token.text;
			nextToken();
		}
		
		text += "?>";
		result.stringValue = text;
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
	internal function parseASDoc():TokenNode
	{
		// current token "<!--- doc. -->"
		asdocLine = ISourceCodeScanner(scanner).commentLine;
		asdocColumn = ISourceCodeScanner(scanner).commentColumn;
		
		var result:TokenNode =
			adapter.create(MXMLNodeKind.AS_DOC,
				token.text,
				asdocLine,
				asdocColumn);
		
		nextNonWhiteSpaceToken(result);
		
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
	
	internal function parseTagList():TokenNode
	{
		// current token "<"
		var result:TokenNode = adapter.empty(MXMLNodeKind.TAG_LIST, token);
		
		var cdata:String = "";
		
		if (pendingASDoc != null)
		{
			result.addChild(pendingASDoc);
			pendingASDoc = null;
		}
		
		// <, s, :, Application
		
		consume("<", result);
		
		var bindingFound:Boolean = false;
		
		var localNameToken:Token = token;
		var firstNode:TokenNode = adapter.empty(MXMLNodeKind.LOCAL_NAME, localNameToken);
		var tagName:String = localNameToken.text;
		
		nextNonWhiteSpaceToken(firstNode); // (:|TAG_NAME)
		
		if (tokIs(Operators.COLON))
		{
			bindingFound = true;
			
			firstNode.kind = MXMLNodeKind.BINDING;
			firstNode.stringValue = localNameToken.text;
			result.addChild(firstNode);
			
			consume(Operators.COLON, result);
			localNameToken = token;
			tagName = localNameToken.text;
			
			result.addChild(adapter.create(
				MXMLNodeKind.LOCAL_NAME, tagName, 
				localNameToken.line, localNameToken.column));
		}
		else
		{
			bindingFound = false;
			
			firstNode.kind = MXMLNodeKind.LOCAL_NAME;
			tagName = localNameToken.text;
			firstNode.stringValue = tagName;
			result.addChild(firstNode);
		}
		
		// only call next if there was a binding, if not we are already there
		if (bindingFound)
		{
			nextNonWhiteSpaceToken(result); // maybe xmlns or att or <
		}
		
		// added to solve . error in tag name (state)
		// TODO edit ast to include tag state
		if (tokIs("."))
		{
			nextNonWhiteSpaceToken(result);
			tagName = tagName + "." + token.text;
			nextNonWhiteSpaceToken(result); // maybe xmlns or att or <
		}
		
		var closing:Boolean = false;
		var inAttList:Boolean = true;
		
		while (!tokIs("/>") && !tokIs("</"))
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
				append(result);
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
					//cdata += token.text;
					result.appendToken(new LinkedListToken("cdata-start", "<![CDATA["));
					var cxd:TokenNode = adapter.copy(
						MXMLNodeKind.CDATA, token);
					result.addChild(cxd);
					result.appendToken(new LinkedListToken("cdata-end", "]]>"));
					
				}
				nextNonWhiteSpaceToken(result);
			}
		}
		
		// these tokens are required to leave this method
		// to types of end tag tokens
		if (tokIs("/>") || tokIs("</"))
		{
			var end:Boolean = tokIs("/>");
			consume(token.text, result);
			
			if (!end)
			{
				// binding : LocalName
				if (!bindingFound)
				{
					consume(tagName, result);
					consume(">", result);
				}
				else
				{
					consume(firstNode.stringValue, result);
					consume(":", result);
					consume(tagName, result);
					consume(">", result);
				}	
			}
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
	internal function parseXmlNs():TokenNode
	{
		// current token "xmlns"
		var result:TokenNode = adapter.empty(MXMLNodeKind.XML_NS, token);
		
		consume("xmlns", result);
		consume(":", result);
		
		result.addChild(adapter.copy(MXMLNodeKind.LOCAL_NAME, token));
		
		nextNonWhiteSpaceToken(result); // s binding
		consume("=", result);
		
		result.appendToken(new LinkedListToken(Operators.QUOTE, "\""));
		result.addChild(adapter.create(
			MXMLNodeKind.URI,
			trimQuotes(token.text),
			token.line,
			token.column));// should +1 since quotes are trimmed;
		result.appendToken(new LinkedListToken(Operators.QUOTE, "\""));
		
		nextNonWhiteSpaceToken(result); // "library://ns.adobe.com/flex/spark"
		
		return result;
	}
	
	//----------------------------------
	//  cdata
	//----------------------------------
	
	/*
	* - CDATA
	*/
	internal function parseCData():TokenNode
	{
		// current token "all string data in between CDATA tags"
		var result:TokenNode = adapter.copy(MXMLNodeKind.CDATA, token);
		
		nextNonWhiteSpaceToken(result);
		
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
	internal function parseAtt():TokenNode
	{
		// current token "attributName"
		var result:TokenNode = adapter.empty(MXMLNodeKind.ATT, token);
		
		result.addChild(adapter.copy(MXMLNodeKind.NAME, token));
		
		nextNonWhiteSpaceToken(result);
		if (tokIs("."))
		{
			skip(".", result);
			result.addChild(adapter.copy(MXMLNodeKind.STATE, token));
			nextNonWhiteSpaceToken(result);
		}
		
		if (!tokIs("="))
		{
			return null;
		}
		
		consume("=", result);
		
		result.appendToken(new LinkedListToken(Operators.QUOTE, "\""));
		result.addChild(adapter.create(MXMLNodeKind.VALUE,
			trimQuotes(token.text),
			token.line,
			token.column));
		result.appendToken(new LinkedListToken(Operators.QUOTE, "\""));
		
		nextNonWhiteSpaceToken(result); // pass the value
		
		return result;
	}
	
	override protected function nextNonWhiteSpaceToken(node:TokenNode):void
	{
		if (!consumeWhitespace(node))
		{
			nextToken();
			
			if (tokIs(" ") || tokIs("\t") || tokIs("\n")
				|| (tokenStartsWith("<!--") && !tokenStartsWith("<!---")))
			{
				nextNonWhiteSpaceToken(node);
			}
		}
	}
	
	override protected function tokIsWhitespace():Boolean
	{
		return token.text == "\n" || token.text == "\t" || 
			token.text == " " || tokenStartsWith("<!--");
	}
	
	override protected function consumeWhitespace(node:TokenNode):Boolean
	{
		if (!node || !token)
		{
			return false;
		}
		
		var advanced:Boolean = false;
		
		while (tokIs(" ") || tokIs("\t") || tokIs("\n")
			|| (tokenStartsWith("<!--") && ! tokenStartsWith("<!---")))
		{
			if (tokIs(" "))
			{
				appendSpace(node);
			}
			else if (tokIs("\t"))
			{
				appendTab(node);
			}
			else if (tokIs("\n"))
			{
				appendNewline(node);
			}
			else if (tokenStartsWith("<!--") && !tokenStartsWith("<!---"))
			{
				appendComment(node);
			}
			
			advanced = true;
		}
		
		return advanced;
	}
}
}