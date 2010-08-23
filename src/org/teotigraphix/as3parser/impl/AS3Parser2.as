package org.teotigraphix.as3parser.impl
{

import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.api.IScanner;
import org.teotigraphix.as3parser.api.KeyWords;
import org.teotigraphix.as3parser.api.Operators;
import org.teotigraphix.as3parser.core.LinkedListTreeAdaptor;
import org.teotigraphix.as3parser.core.TokenNode;

public class AS3Parser2 extends ParserBase
{
	//--------------------------------------------------------------------------
	//
	//  Private :: Constants
	//
	//--------------------------------------------------------------------------
	
	public static const MULTIPLE_LINES_COMMENT:String = "/*";
	
	public static const SINGLE_LINE_COMMENT:String = "//";
	
	public static const NEW_LINE:String = "\n";
	
	private static const VECTOR:String = "Vector";
	
	//--------------------------------------------------------------------------
	//
	//  Private :: Variables
	//
	//--------------------------------------------------------------------------
	
	private var currentAsDoc:TokenNode;
	
	private var braceCount:int;
	
	private var isInFor:Boolean = false;
	
	private var qualifiedNameEnd:int = -1;
	
	private var adapter:LinkedListTreeAdaptor = new LinkedListTreeAdaptor();
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function AS3Parser2()
	{
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Protected :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override protected function createScanner():IScanner
	{
		return new AS3Scanner();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden Public :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function parseCompilationUnit():IParserNode
	{
		var result:TokenNode = adapter.create(AS3NodeKind.COMPILATION_UNIT);
		
		nextTokenIgnoringAsDoc(result);
		if (tokIs(KeyWords.PACKAGE))
		{
			result.addChild(parsePackage());
		}
		//		result.addChild(parsePackageContent());
		return result;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Internal :: Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * token is package
	 * 
	 * @throws UnExpectedTokenException
	 */
	internal function parsePackage():TokenNode
	{
		var end:int = -1;
		
		var result:TokenNode = adapter.create(
			AS3NodeKind.PACKAGE,
			KeyWords.PACKAGE, 
			token.line, 
			token.column);
		
		result.start = scanner.offset;
		
		consume(KeyWords.PACKAGE);
		
		consumeComment();// added 
		
		var line:int = token.line;
		var column:int = token.column;
		
		var start:int = scanner.offset - token.text.length;
		
		qualifiedNameEnd = scanner.offset;
		var qualifiedName:String = "";
		
		if (!tokIs(Operators.LEFT_CURLY_BRACKET))
		{
			qualifiedName = parseQualifiedName();
		}
		
		var name:TokenNode = adapter.create(
			AS3NodeKind.NAME,
			qualifiedName, 
			line, 
			column);
		name.start = start;
		name.end = qualifiedNameEnd;
		
		result.addChild(name);
		
		consume(Operators.LEFT_CURLY_BRACKET);
		//		result.addChild(parsePackageContent());
		consume(Operators.RIGHT_CURLY_BRACKET);
		
		result.end = scanner.offset;
		
		return result;
	}
	
	private function parseQualifiedName():String
	{
		var buffer:String = "";
		
		buffer += token.text;
		nextToken();
		while (tokIs(Operators.DOT) || tokIs(Operators.DOUBLE_COLUMN))
		{
			buffer += token.text;
			nextToken();
			buffer += token.text;
			qualifiedNameEnd = scanner.offset;
			nextToken(); // name
		}
		return buffer;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	override public function nextToken():void
	{
		super.nextToken();
		
		if (tokIs(" ") || tokIs("\t") || tokIs("{") || tokIs("}"))
		{
			
		}
	}
	
	private function nextTokenIgnoringAsDoc(node:TokenNode):void
	{
		do
		{
			nextToken();
		}
		while (tokenStartsWith(MULTIPLE_LINES_COMMENT));
	}
	
	private function consumeComment():void
	{
		while (tokenStartsWith(MULTIPLE_LINES_COMMENT))
		{
			nextToken();
		}
	}
}
}