package org.as3commons.asblocks.parser.impl
{

import org.as3commons.asblocks.impl.TokenBuilder;
import org.as3commons.asblocks.parser.api.ASDocNodeKind;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.api.IScanner;
import org.as3commons.asblocks.parser.core.LinkedListToken;
import org.as3commons.asblocks.parser.core.LinkedListTreeAdaptor;
import org.as3commons.asblocks.parser.core.TokenNode;
import org.as3commons.asblocks.utils.ASTUtil;

public class ASDocParser2 extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	// Public :: Constants
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public static const NL:String = "\n";
	
	/**
	 * @private
	 */
	public static const TAB:String = "\t";
	
	/**
	 * @private
	 */
	public static const SPACE:String = " ";
	
	/**
	 * @private
	 */
	public static const ML_START:String = "/**";
	
	/**
	 * @private
	 */
	public static const ML_END:String = "*/";
	
	/**
	 * @private
	 */
	public static const ASTRIX:String = "*";
	
	/**
	 * @private
	 */
	public static const AT:String = "@";
	
	/**
	 * @private
	 */
	public static const EOF:String = "__END__";
	
	//--------------------------------------------------------------------------
	//
	// Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _bodyFound:Boolean = false;
	
	//--------------------------------------------------------------------------
	//
	// Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function ASDocParser2()
	{
		super();
		
		adapter = new LinkedListTreeAdaptor();
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function parseCompilationUnit():IParserNode
	{
		var result:TokenNode = adapter.create(ASDocNodeKind.COMPILATION_UNIT);
		
		nextToken();
		
		result.addChild(parseDescription());
		
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	// Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createScanner():IScanner
	{
		return new ASDocScanner2();
	}
	
	/**
	 * @private
	 */
	override protected function initialize():void
	{
	}
	
	//--------------------------------------------------------------------------
	//
	// Internal Parse :: Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	// description
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDescription():IParserNode
	{
		var result:TokenNode = ASTUtil.newParentheticAST(
			ASDocNodeKind.DESCRIPTION,
			ASDocNodeKind.ML_START, "/**", 
			ASDocNodeKind.ML_END, "*/") as TokenNode;
		
		consumeParenthetic(ML_START); // /**
		
		while (!tokIs(EOF) && !tokIs(ML_END))
		{
			if (tokIs(AT))
			{
				result.addChild(parseDocTagList());
			}
			else
			{
				result.addChild(parseBody());
			}
		}
		
		consumeParenthetic(ML_END); // */
		
		return result;
	}
	
	//----------------------------------
	// body
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseBody():IParserNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		consumeWhitespace(result);
		
		while (!tokIs(EOF) && !tokIs(ML_END) && !tokIs(AT))
		{
			if (tokIsValid())
			{
				if (tokenStartsWith("<") && isBlock(token.text))
				{
					result.addChild(parseTag(token.text.substring(1)));
				}
				else if (tokIs(NL))
				{
					result.addChild(parseNewline());
				}
				else
				{
					result.addChild(parseTextBlock());
				}
			}
			else
			{
				consumeWhitespace(result);
			}
		}
		
		return result;
	}
	
	//----------------------------------
	// text-block
	//----------------------------------
	
	private function isBlock(name:String):Boolean
	{
		if (!tokenStartsWith("<"))
		{
			return false;
		}
		
		var blocks:Object =
			{
				p:true,
				code:true,
				pre:true
			};
		
		return blocks[name.substring(1)];
	}
	
	/**
	 * @private
	 */
	private function parseTextBlock():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.TEXT_BLOCK, token);
		
		while (!tokIs(EOF) && !tokIs(ML_END) && !tokIs(AT)
			&& !isBlock(token.text) && !tokIs("</"))
		{
			if (tokIs(NL))
			{
				result.addChild(parseNewline());
			}
			else
			{
				parseTextStream(result);
			}
		}
		
		return result;
	}
	
	private function parseNewline():TokenNode
	{
		var result:TokenNode = adapter.create(ASDocNodeKind.NL);
		result.appendToken(TokenBuilder.newToken(ASDocNodeKind.NL, token.text));
		nextToken();
		return result;
	}
	
	private function parseTextStream(node:TokenNode):void
	{
		var text:String = "";
		
		while (!tokIs(EOF) && !tokIs(ML_END) 
			&& !tokIs(AT) && !tokIs(NL)
			&& !isBlock(token.text) && !tokIs("</"))
		{
			if (tokIsValid())
			{
				text += token.text;
				nextToken();
			}
			else
			{
				if (text != "")
				{
					node.addChild(adapter.create(ASDocNodeKind.TEXT, text));
					text = "";
				}
				consumeWhitespace(node);
			}
		}
		if (text != "")
		{
			node.addChild(adapter.create(ASDocNodeKind.TEXT, text));
		}
	}
	
	
	//----------------------------------
	// doctag-list
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTagList():IParserNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG_LIST, token);
		
		while (!tokIs(EOF) && !tokIs(ML_END))
		{
			result.addChild(parseDocTag());
		}
		
		return result;
	}
	
	//----------------------------------
	// doctag
	//----------------------------------
	
	/**
	 * @private
	 */
	internal function parseDocTag():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.DOCTAG, token);
		
		consume(AT, result);
		
		while (!tokIs(EOF) && !tokIs(ML_END) && !tokIs(AT))
		{
			result.addChild(parseDocTagName());
			result.addChild(parseDocTagBody());
		}
		
		return result;
	}
	
	//----------------------------------
	// doctag-name
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTagName():TokenNode
	{
		var result:TokenNode = adapter.copy(ASDocNodeKind.NAME, token);
		nextToken(); // name
		return result;
	}
	
	/**
	 * @private
	 */
	private function appendToken(node:TokenNode, 
								 kind:String, 
								 text:String):LinkedListToken
	{
		var token:LinkedListToken = adapter.createToken(
			kind, text,	token.line, token.column);
		
		node.appendToken(token);
		
		return token;
	}
	
	//----------------------------------
	// doctag-body
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseDocTagBody():TokenNode
	{
		var result:TokenNode = adapter.empty(ASDocNodeKind.BODY, token);
		
		while (!tokIs(AT) && !tokIs(ML_END))
		{
			if (tokIsValid())
			{
				result.addChild(parseTextBlock());
			}
			else
			{
				consumeWhitespace(result);
			}
		}
		
		return result;
	}
	
	private function nextTokenAppend(node:TokenNode, kind:String, text:String):void
	{
		node.appendToken(TokenBuilder.newToken(kind, text));
		nextToken();
	}
	
	//----------------------------------
	// *-tag
	//----------------------------------
	
	/**
	 * @private
	 */
	private function parseTag(name:String):TokenNode
	{
		var result:TokenNode = adapter.empty(name + "-block", token);
		
		var skip:Boolean = false;
		
		nextTokenAppend(result, "tag", "<" + name);
		
		// eat attributes
		if (!tokIs(">"))
		{
			while (!tokIs(">"))
			{
				nextTokenAppend(result, "tag", token.text);
			}
		}
		
		nextTokenAppend(result, "tag", ">");
			
		while (!tokIs(EOF) && !tokIs(ML_END))
		{
			if (tokIs("</"))
			{
				nextToken(); // </"
				if (tokIs(name))
				{
					skip = true;
					break;
				}
				else
				{
					//text += "</";
				}
			}
			else
			{
				result.addChild(parseTextBlock());
			}
		}
		
		if (!skip)
		{
			nextTokenAppend(result, "tag", "</");
		}
		else
		{
			// the while kicked out at '</', must record
			result.appendToken(TokenBuilder.newToken("tag", "</"));
		}
		
		nextTokenAppend(result, "tag", name);
		nextTokenAppend(result, "tag", ">");
		
		return result;
	}
	
	/**
	 * @private
	 */
	override protected function consumeWhitespace(node:TokenNode):Boolean
	{
		if (!node || !token)
		{
			return false;
		}
		
		var advanced:Boolean = false;
		
		while (token.text == " "
			|| token.text == "\t"
			|| token.text == "*")
		{
			if (token.text == " ")
			{
				appendSpace(node);
			}
			else if (token.text == "\t")
			{
				appendTab(node);
			}
			else if (token.text == "*")
			{
				appendAstrix(node);
			}
			
			advanced = true;
		}
		
		return advanced;
	}
	
	/**
	 * @private
	 */
	private function tokIsValid():Boolean
	{
		return token.kind != "ws" && token.kind != "astrix";
	}
	
	/**
	 * @private
	 */
	protected function appendAstrix(node:TokenNode):void
	{
		if (!node || !scanner.allowWhiteSpace)
			return;
		
		if (node)
		{
			node.appendToken(
				adapter.createToken("astrix", "*",
					token.line, token.column));
		}
		
		nextToken();
	}
}
}