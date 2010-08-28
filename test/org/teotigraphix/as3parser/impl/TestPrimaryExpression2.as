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
	public function testArrayLiteral():void
	{
		var input:String = "[1,2,3]";
		
		assertPrimaryPrint(input, "[1,2,3]" );
		
		assertPrimary(input,
			"<array line=\"1\" column=\"1\">" +
			"<number line=\"1\" column=\"2\">1</number><number line=\"1\" " +
			"column=\"4\">2</number><number line=\"1\" column=\"6\">3</number>" +
			"</array>");
	}
	
	[Test]
	public function testObjectLiteral():void
	{
		var input:String = "{a:1,b:2}";
		
		assertPrimaryPrint(input, "{a:1,b:2}" );
		
		assertPrimary( input,
			"<primary line=\"1\" column=\"1\"><object line=\"1\" column=\"1\">" +
			"<prop line=\"1\" column=\"2\"><name line=\"1\" column=\"2\">a" +
			"</name><value line=\"1\" column=\"4\"><number line=\"1\" " +
			"column=\"4\">1</number></value></prop><prop line=\"1\" " +
			"column=\"6\"><name line=\"1\" column=\"6\">b</name><value " +
			"line=\"1\" column=\"8\"><number line=\"1\" column=\"8\">2" +
			"</number></value></prop></object></primary>" );
	}
	
	[Test]
	public function testFunctionLiteral():void
	{
		assertPrimary( "function ( a : Object ) : * { trace('test'); }",
			"<lambda line=\"1\" column=\"1\">" +
			"<parameter-list line=\"1\" column=\"10\"><parameter line=\"1\" " +
			"column=\"12\"><name-type-init line=\"1\" column=\"12\"><name line=\"1\" " +
			"column=\"12\">a</name><type line=\"1\" column=\"16\">Object</type>" +
			"</name-type-init></parameter></parameter-list><name-type-init line=\"1\" " +
			"column=\"25\"><type line=\"1\" column=\"27\">*</type></name-type-init>" +
			"<block line=\"1\" column=\"29\"><call line=\"1\" column=\"36\">" +
			"<primary line=\"1\" column=\"31\">trace</primary><arguments line=\"1\" " +
			"column=\"36\"><string line=\"1\" column=\"37\">'test'</string>" +
			"</arguments></call></block></lambda>" );
	}
	
	[Test]
	public function testNumbers():void
	{
		assertNumber("1", "1");
		assertPrimaryPrint("1", "1");
		
		assertNumber("0xff", "0xff");
		assertPrimaryPrint("0xff", "0xff");
		
		assertNumber("0420", "0420");
		assertPrimaryPrint("0420", "0420");
		
		assertNumber(".42E2", ".42E2");
		assertPrimaryPrint(".42E2", ".42E2");
	}
	
	[Test]
	public function testInfinity():void
	{
		assertNumber("Infinity", "Infinity");
		assertPrimaryPrint( "Infinity", "Infinity" );
		
		assertNumber("-Infinity", "-Infinity");
		assertPrimaryPrint( "-Infinity", "-Infinity" );
	}
	
	[Test]
	public function testStrings():void
	{
		// "string"
		parser.scanner.setLines(Vector.<String>(["\"string\""]));
		parser.nextToken(); // first call
		
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<string line=\"1\" column=\"1\">" +
			"\"string\"</string>", result);
		
		assertPrimaryPrint("\"string\"", "\"string\"");
		
		// 'string'
		parser.scanner.setLines(Vector.<String>(["'string'"]));
		parser.nextToken(); // first call
		
		result = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<string line=\"1\" column=\"1\">" +
			"'string'</string>", result);
		
		assertPrimaryPrint("'string'", "'string'");
	}
	
	[Test]
	public function testNull():void
	{
		parser.scanner.setLines(Vector.<String>(["null"]));
		parser.nextToken(); // first call
		
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<null line=\"1\" column=\"1\">" +
			"null</null>", result);
		
		assertPrimaryPrint("null", "null");
	}
	
	[Test]
	public function testUndefined():void
	{
		parser.scanner.setLines(Vector.<String>(["undefined"]));
		parser.nextToken(); // first call
		
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<undefined line=\"1\" column=\"1\">" +
			"undefined</undefined>", result);
		
		assertPrimaryPrint("undefined", "undefined");
	}
	
	[Test]
	public function testBooleans():void
	{
		parser.scanner.setLines(Vector.<String>(["true"]));
		parser.nextToken(); // first call
		
		var result:String = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<true line=\"1\" column=\"1\">" +
			"true</true>", result);
		
		assertPrimaryPrint("true", "true");
		
		parser.scanner.setLines(Vector.<String>(["false"]));
		parser.nextToken(); // first call
		
		result = ASTUtil.convert(parser.parsePrimaryExpression());
		Assert.assertEquals("<false line=\"1\" column=\"1\">" +
			"false</false>", result);
		
		assertPrimaryPrint("false", "false");
	}
	
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