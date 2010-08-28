package org.teotigraphix.as3parser.impl
{


import org.flexunit.Assert;
import org.teotigraphix.as3blocks.utils.ASTUtil2;
import org.teotigraphix.as3parser.api.AS3NodeKind;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.ASTPrinter;
import org.teotigraphix.as3parser.core.LinkedListToken;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.as3parser.utils.ASTUtil;

/**
 * Tests, token stream, print stream and ast model of the PRIMARY node.
 */
public class TestPrimaryExpression2
{
	private var parser:AS3Parser2 = new AS3Parser2();
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser2();
	}
	
	//----------------------------------
	// try{} catch(){} finally{}
	//----------------------------------
	
	[Test]
	public function testCatch():void
	{
		var input:String;
		
		input = "catch( e : Error ) {trace( true ); }";
		assertStatementPrint(input, 
			"catch( e : Error ) {trace( true ); }" );
		
		assertStatement( "1",
			input,
			"<catch line=\"1\" column=\"1\"><name line=\"1\" column=\"8\">e" +
			"</name><type line=\"1\" column=\"12\">Error</type>" +
			"<block line=\"1\" column=\"20\"><call line=\"1\" " +
			"column=\"26\"><primary line=\"1\" column=\"21\">trace" +
			"</primary><arguments line=\"1\" column=\"26\"><true line=\"1\" " +
			"column=\"28\">true</true></arguments></call></block></catch>" );
	}
	
	/*
	
	NUMBER
	- IntegerLiteralNode [1,0.2,0xff,Infinity,-Infinity]
	STRING
	- StringLiteralNode ["string", 'string']
	NULL
	- NullLiteralNode [null]
	UNDEFINED
	- UndefinedLiteralNode [undefined]
	TRUE
	FALSE
	- BooleanLiteralNode [true,false]
	ASSIGN
	- AssignmentExpressionNode [=]
	OP
	- BinaryExpressionNode
	POST_DEC
	POST_INC
	- PostfixExpressionNode
	PRE_DEC
	PRE_INC
	PLUS
	MINUS
	NOT
	- PrefixExpressionNode
	DOT
	- FieldAccessExpressionNode
	CALL
	- InvocationExpressionNode
	ENCAPSULATED
	- return build(ast.getFirstChild());
	ARRAY_ACCESSOR
	- ArrayAccessExpressionNode
	NEW
	- NewExpressionNode
	CONDITIONAL
	- ConditionalExpressionNode
	FUNCTION
	- FunctionExpressionNode
	ARRAY
	- ArrayLiteralNode
	OBJECT
	- ObjectExpressionNode
	XML
	- XMLExpressionNode
	
	*/
	
	



	[Test]
	public function testAssignment():void
	{
		assertStatement("1", "myObject[42] = \"universal\"",
			"<assign line=\"1\" column=\"1\"><arr-acc line=\"1\" column=\"9\">" +
			"<primary line=\"1\" column=\"1\">myObject</primary><number line=\"1\" " +
			"column=\"10\">42</number></arr-acc><op line=\"1\" column=\"14\">=</op>" +
			"<string line=\"1\" column=\"16\">\"universal\"</string></assign>" );
	}
	
	[Test]
	public function testXML():void
	{
		//assertStatement("1", "var xml:XML = <xml><tml/><tml id=\"me\"/></xml>",
		//	"<assign line=\"1\" column=\"1\"><arr-acc line=\"1\" column=\"9\">" +
		//	"<primary line=\"1\" column=\"1\">myObject</primary><number line=\"1\" " +
		//	"column=\"10\">42</number></arr-acc><op line=\"1\" column=\"14\">=</op>" +
		//	"<string line=\"1\" column=\"16\">\"universal\"</string></assign>" );
	}
	
	[Test]
	public function testAssignmentComplex():void
	{
		//assertStatement("1", "myObject[42] = {a:1,b:{a:1,b:2},c:'me'}",
		//	"<assign line=\"1\" column=\"1\"><arr-acc line=\"1\" column=\"9\">" +
		//	"<primary line=\"1\" column=\"1\">myObject</primary><number line=\"1\" " +
		//	"column=\"10\">42</number></arr-acc><op line=\"1\" column=\"14\">=</op>" +
		//	"<string line=\"1\" column=\"16\">\"universal\"</string></assign>" );
	}

	

	

	
	
	
	
	
	
	

	
	
	
	
	
	
	
	
	private function assertStatementPrint(input:String, 
										  expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parseStatement(input));
		
		Assert.assertEquals(expected, printer.toString());
	}
	
	protected function assertStatement(message:String, input:String, expected:String):void
	{
		var lines:Array = [input];
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		var result:String = ASTUtil.convert(parser.parseStatement());
		Assert.assertEquals(message, expected, result);
	}
	
	private function assertNumber(input:String, 
								  expected:String):void
	{
		var lines:Array = [input];
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<number line=\"1\" column=\"1\">" + 
			expected + "</number>", result);
	}
	
	private function assertPrimary(input:String, 
								   expected:String):void
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<primary line=\"1\" column=\"1\">" + 
			expected + "</primary>", result);
	}
	
	private function assertPrimaryPrint(input:String, 
										expected:String):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parsePrimary(input));
		Assert.assertEquals(expected, printer.flush());
	}
	
	private function parseStatement(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		return parser.parseStatement();
	}
	
	private function parsePrimary(input:String):IParserNode
	{
		parser.scanner.setLines(Vector.<String>([input]));
		parser.nextToken(); // first call
		return parser.parsePrimaryExpression();
	}
	
	private function createPrinter():ASTPrinter
	{
		var sourceCode:SourceCode = new SourceCode();
		var printer:ASTPrinter = new ASTPrinter(sourceCode);
		return printer;
	}
}
}