package org.teotigraphix.as3parser.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestAS3FragmentParser
{
	[Before]
	public function setUp():void
	{
	}
	
	[Test]
	public function test_parseCompilationUnit():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseCompilationUnit("package my.domain{public class " +
			"Test { } } class InternalClass { }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<compilation-unit><package><name>my.domain</name>" +
			"<content><class><mod-list><mod>public</mod></mod-list><name>Test</name><content></content>" +
			"</class></content></package><content><class><name>InternalClass</name>" +
			"<content></content></class></content></compilation-unit>", result);
	}
	
	[Test]
	public function test_parsePackage():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parsePackage("package my.domain{public class Test " +
			"{ } } class InternalClass { }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<package><name>my.domain</name><content><class>" +
			"<mod-list><mod>public</mod></mod-list><name>Test</name><content></content></class>" +
			"</content></package>", result);
	}
	
	[Test]
	public function test_parsePackageContent():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parsePackageContent("public class Test { }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><class><mod-list><mod>public</mod></mod-list><name>Test</name>" +
			"<content></content></class></content>", result);
		
		ast = AS3FragmentParser.parsePackageContent("public interface ITest { }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><interface><mod-list><mod>public</mod></mod-list><name>ITest</name>" +
			"<content></content></interface></content>", result);
		
		ast = AS3FragmentParser.parsePackageContent("public function myGlobalFunction():int { return -1; }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><function><mod-list><mod>public</mod></mod-list>" +
			"<accessor-role></accessor-role><name>myGlobalFunction</name>" +
			"<parameter-list></parameter-list><type>int</type><block><return>" +
			"<minus><number>1</number></minus></return></block></function>" +
			"</content>", result);
	}
	
	[Test]
	public function test_parseClassContent():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseClassContent("private var hello:World = null; " +
			"flash_proxy function getProperty():Object{return null;}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><field-list><mod-list><mod>private</mod>" +
			"</mod-list><field-role><var></var></field-role><name-type-init>" +
			"<name>hello</name><type>World</type><init><null>null</null>" +
			"</init></name-type-init></field-list><function><mod-list>" +
			"<mod>flash_proxy</mod></mod-list><accessor-role></accessor-role>" +
			"<name>getProperty</name><parameter-list></parameter-list>" +
			"<type>Object</type></function></content>", result);
	}
	
	[Test]
	public function test_parseInterfaceContent():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseInterfaceContent("function get hello():World; " +
			"function recycleWorld():void;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><function><accessor-role><get></get>" +
			"</accessor-role><name>hello</name><parameter-list></parameter-list>" +
			"<type>World</type></function><function><accessor-role></accessor-role>" +
			"<name>recycleWorld</name><parameter-list></parameter-list><type>void" +
			"</type></function></content>", result);
	}
	
	//[Test]
	public function test_parseConstants():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseConstants("[MetaData]/** My asdoc. */" +
			"public static const MY_CONSTANT:String = \"me\";");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><const-list><meta><name>MetaData</name>" +
			"</meta><as-doc>/** My asdoc. */</as-doc><mod-list><mod>public</mod><mod>" +
			"static</mod></mod-list><name-type-init><name>MY_CONSTANT</name><type>String" +
			"</type><init><string>\"me\"</string></init></name-type-init>" +
			"</const-list></content>", result);
		
		ast = AS3FragmentParser.parseConstants(
			"public static const MY_CONSTANT:String = \"me\";" +
			"public static const YOU_CONSTANT:String = \"you\";");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><const-list><mod-list><mod>public</mod><mod>" +
			"static</mod></mod-list><name-type-init><name>MY_CONSTANT</name>" +
			"<type>String</type><init><string>\"me\"</string></init>" +
			"</name-type-init></const-list><const-list><mod-list><mod>public</mod>" +
			"<mod>static</mod><mod-list><name-type-init><name>YOU_CONSTANT</name>" +
			"<type>String</type><init><string>\"you\"</string></init>" +
			"</name-type-init></const-list></content>", result);
	}
	
//	[Test]
	public function test_parseVariables():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseVariables("[MetaData]/** My asdoc. */" +
			"public var myVariable:Object = {};");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><var-list><meta-list><meta><name>MetaData" +
			"</name></meta></meta-list><mod-list><mod>public</mod></mod-list>" +
			"<name-type-init><name>myVariable</name><type>Object</type><init>" +
			"<primary><object></object></primary></init></name-type-init>" +
			"<as-doc>/** My asdoc. */</as-doc></var-list></content>", result);
	}
	
//	[Test]
	public function test_parseMethods():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseMethods("[MetaData]/** My asdoc. */" +
			"public function myMethod(arg0:int = -1):Object {return null;}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><function><as-doc>/** My asdoc. */" +
			"</as-doc><meta-list><meta><name>MetaData</name></meta>" +
			"</meta-list><mod-list><mod>public</mod></mod-list><name>" +
			"myMethod</name><parameter-list><parameter><name-type-init>" +
			"<name>arg0</name><type>int</type><init><minus><primary>1</primary>" +
			"</minus></init></name-type-init></parameter></parameter-list>" +
			"<type>Object</type><block><return><primary>null</primary></return>" +
			"</block></function></content>", result);
	}
	
//	[Test]
	public function test_getSet():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseMethods("[MetaData]/** My asdoc. */" +
			"public function get myProperty():int {return -1;}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<content><get><as-doc>/** My asdoc. */</as-doc>" +
			"<meta-list><meta><name>MetaData</name></meta></meta-list>" +
			"<mod-list><mod>public</mod></mod-list><name>myProperty</name>" +
			"<parameter-list></parameter-list><type>int</type><block>" +
			"<return><minus><primary>1</primary></minus></return></block>" +
			"</get></content>", result);
	}
	
	[Test]
	public function test_parseStatement():void
	{
		var ast:IParserNode;
		var result:String;
		
		//------------------------------
		// for()
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("for(;;){}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<for><block></block></for>", result);
		
		ast = AS3FragmentParser.parseStatement("for(a in obj){}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<forin><init><primary>a</primary></init><in>" +
			"<primary>obj</primary></in><block></block></forin>", result);
		
		ast = AS3FragmentParser.parseStatement("for(i=0;i<len;i--){}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<for><init><assign><primary>i</primary><op>=</op>" +
			"<number>0</number></assign></init><cond><relation><primary>i" +
			"</primary><op>&lt;</op><primary>len</primary></relation></cond>" +
			"<iter><post-dec><primary>i</primary></post-dec></iter><block>" +
			"</block></for>", result);
		
		ast = AS3FragmentParser.parseStatement("for each(a in obj){}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<foreach><name>a</name><in><primary>obj</primary>" +
			"</in><block></block></foreach>", result);
		
		//------------------------------
		// if()
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("if(a){}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<if><condition><primary>a</primary></condition>" +
			"<block></block></if>", result);
		
		ast = AS3FragmentParser.parseStatement("if(a) trace('') else trace('')");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<if><condition><primary>a</primary></condition><call>" +
			"<primary>trace</primary><arguments><string>''</string></arguments>" +
			"</call><call><primary>trace</primary><arguments><string>''</string>" +
			"</arguments></call></if>", result);
		
		ast = AS3FragmentParser.parseStatement("if(a) trace('') else if(b) trace('') else trace('')");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<if><condition><primary>a</primary></condition><call>" +
			"<primary>trace</primary><arguments><string>''</string></arguments>" +
			"</call><if><condition><primary>b</primary></condition><call><primary>" +
			"trace</primary><arguments><string>''</string></arguments></call><call>" +
			"<primary>trace</primary><arguments><string>''</string></arguments>" +
			"</call></if></if>", result);
		
		//------------------------------
		// switch()
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("switch( x ){ case 1 : { trace('one'); " +
			"break; } default : trace('unknown'); }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<switch><condition><primary>x</primary></condition>" +
			"<cases><case><number>1</number><switch-block><block><call><primary>" +
			"trace</primary><arguments><string>'one'</string></arguments></call>" +
			"<break></break></block></switch-block></case><case><default></default>" +
			"<switch-block><call><primary>trace</primary><arguments><string>" +
			"'unknown'</string></arguments></call></switch-block></case>" +
			"</cases></switch>", result);
		
		ast = AS3FragmentParser.parseStatement("switch( x ){ case 1 : break; default:}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<switch><condition><primary>x</primary></condition>" +
			"<cases><case><number>1</number><switch-block><break></break>" +
			"</switch-block></case><case><default></default><switch-block>" +
			"</switch-block></case></cases></switch>", result);
		
		//------------------------------
		// do
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("do ; while( i++ );");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<do><stmt-empty>;</stmt-empty><condition>" +
			"<post-inc><primary>i</primary></post-inc></condition></do>", result);
		
		ast = AS3FragmentParser.parseStatement("do trace( i ); while( i++ );");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<do><call><primary>trace</primary><arguments>" +
			"<primary>i</primary></arguments></call><condition><post-inc>" +
			"<primary>i</primary></post-inc></condition></do>", result);
		
		ast = AS3FragmentParser.parseStatement("do{ trace( i ); } while( i++ );");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<do><block><call><primary>trace</primary>" +
			"<arguments><primary>i</primary></arguments></call></block>" +
			"<condition><post-inc><primary>i</primary></post-inc>" +
			"</condition></do>", result);
		
		//------------------------------
		// while()
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("while( i++ );");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<while><condition><post-inc><primary>i</primary>" +
			"</post-inc></condition><stmt-empty>;</stmt-empty></while>", result);
		
		ast = AS3FragmentParser.parseStatement("while( i++ ) trace( i );");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<while><condition><post-inc><primary>i</primary>" +
			"</post-inc></condition><call><primary>trace</primary>" +
			"<arguments><primary>i</primary></arguments></call></while>", result);
		
		ast = AS3FragmentParser.parseStatement("while( i++ ){ trace( i ); }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<while><condition><post-inc><primary>i</primary>" +
			"</post-inc></condition><block><call><primary>trace</primary>" +
			"<arguments><primary>i</primary></arguments></call>" +
			"</block></while>", result);
		
		//------------------------------
		// try
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("try{ trace( true ); }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<try><block><call><primary>trace</primary><arguments>" +
			"<true>true</true></arguments></call></block></try>", result);
		
		//------------------------------
		// catch
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("catch( e : Error ) {trace( true ); }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<catch><name>e</name><type>Error</type><block>" +
			"<call><primary>trace</primary><arguments><true>true</true>" +
			"</arguments></call></block></catch>", result);
		
		//------------------------------
		// finally
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("finally {trace( true ); }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<finally><block><call><primary>trace</primary>" +
			"<arguments><true>true</true></arguments></call>" +
			"</block></finally>", result);
		
		//------------------------------
		// block
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("{ method(); {} }");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<block><call><primary>method</primary><arguments>" +
			"</arguments></call><block></block><primary> </primary></block>", result);
		
		//------------------------------
		// var
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("var i;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>i</name></name-type-init></dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("var i:World = new World();");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>i</name><type>World</type><init><primary>" +
			"<new><call><primary>World</primary><arguments></arguments></call>" +
			"</new></primary></init></name-type-init></dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("var a:World, b:World, c:World;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>a</name><type>World</type></name-type-init>" +
			"<name-type-init><name>b</name><type>World</type></name-type-init>" +
			"<name-type-init><name>c</name><type>World</type></name-type-init>" +
			"</dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("var a:Array = [0,1,2];");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>a</name><type>Array</type><init><primary>" +
			"<array><number>0</number><number>1</number><number>2</number>" +
			"</array></primary></init></name-type-init></dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("var a:Object = {a:1,b:1};");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>a</name><type>Object</type><init><primary>" +
			"<object><prop><name>a</name><value><number>1</number></value>" +
			"</prop><prop><name>b</name><value><number>1</number></value>" +
			"</prop></object></primary></init></name-type-init></dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("var a:Vector.<World> = new World.<World>(255, true);");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><var></var></dec-role>" +
			"<name-type-init><name>a</name><vector><type>World</type></vector>" +
			"<init><primary><new><primary>World</primary><arguments><number>" +
			"255</number><true>true</true></arguments></new></primary></init>" +
			"</name-type-init></dec-list>", result);
		
		//------------------------------
		// const
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("const i;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><const></const></dec-role>" +
			"<name-type-init><name>i</name></name-type-init></dec-list>", result);
		
		ast = AS3FragmentParser.parseStatement("const i:int = 42;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dec-list><dec-role><const></const></dec-role>" +
			"<name-type-init><name>i</name><type>int</type><init><number>42" +
			"</number></init></name-type-init></dec-list>", result);
		
		//------------------------------
		// return
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement("return;");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<return></return>", result);
		
		ast = AS3FragmentParser.parseStatement("return [a,b,c];");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<return><primary><array><primary>a</primary>" +
			"<primary>b</primary><primary>c</primary></array>" +
			"</primary></return>", result);
		
		
		//------------------------------
		// empty statement ;
		//------------------------------
		
		ast = AS3FragmentParser.parseStatement(";");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<stmt-empty>;</stmt-empty>", result);
	}
	
	[Test]
	public function test_parseExpression():void
	{
		var ast:IParserNode;
		var result:String;
		
		//------------------------------
		// . identifier
		//------------------------------
		
		ast = AS3FragmentParser.parseExpression("myXML.attributeName");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dot><primary>myXML</primary>" +
			"<primary>attributeName</primary></dot>", result);
		
		//------------------------------
		// @ attribute identifier
		//------------------------------
		
		ast = AS3FragmentParser.parseExpression("myXML.@attributeName");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dot><primary>myXML</primary><e4x-attr>" +
			"<name>attributeName</name></e4x-attr></dot>", result);
		
		//------------------------------
		// .* identifier
		//------------------------------
		
		ast = AS3FragmentParser.parseExpression("myXML.@*");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<dot><primary>myXML</primary><e4x-attr><star>*" +
			"</star></e4x-attr></dot>", result);
		
	}
	
	[Test]
	public function test_parsePrimaryExpression():void
	{
		var ast:IParserNode;
		var result:String;
		
		//------------------------------
		// Boolean
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("true");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<true>true</true>", result);
		
		ast = AS3FragmentParser.parsePrimaryExpression("false");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<false>false</false>", result);
		
		//------------------------------
		// null
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("null");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<null>null</null>", result);
		
		//------------------------------
		// undefined
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("undefined");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<undefined>undefined</undefined>", result);
		
		//------------------------------
		// Infinity
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("Infinity");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>Infinity</number>", result);
		
		//------------------------------
		// -Infinity
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("-Infinity");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>-Infinity</number>", result);
		
		//------------------------------
		// NaN
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("NaN");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>NaN</number>", result);
		
		//------------------------------
		// Numbers
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("42");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>42</number>", result);
		
		ast = AS3FragmentParser.parsePrimaryExpression("0x242424");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>0x242424</number>", result);
		
		ast = AS3FragmentParser.parsePrimaryExpression(".42E2");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<number>.42E2</number>", result);
		
		//------------------------------
		// Strings
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("'string'");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<string>'string'</string>", result);
		
		ast = AS3FragmentParser.parsePrimaryExpression("\"string\"");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<string>\"string\"</string>", result);
		
		//------------------------------
		// Array literal
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("[a,b,c]");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<primary><array><primary>a</primary><primary>b" +
			"</primary><primary>c</primary></array></primary>", result);
		
		//------------------------------
		// Object literal
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("{a:1,b:1}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<primary><object><prop><name>a</name><value>" +
			"<number>1</number></value></prop><prop><name>b</name><value>" +
			"<number>1</number></value></prop></object></primary>", result);
		
		//------------------------------
		// Function literal
		//------------------------------
		
		ast = AS3FragmentParser.parsePrimaryExpression("function(a:Object):void{}");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<primary><lambda><parameter-list><parameter>" +
			"<name-type-init><name>a</name><type>Object</type></name-type-init>" +
			"</parameter></parameter-list><block></block></lambda></primary>", result);
	}
	
	[Test]
	public function test_parseCondition():void
	{
		var ast:IParserNode;
		var result:String;
		
		ast = AS3FragmentParser.parseCondition("a!=42");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<condition><equality><primary>a</primary><op>!=" +
			"</op><number>42</number></equality></condition>", result);
		
		ast = AS3FragmentParser.parseCondition("a<11&&b>11");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<condition><and><relation><primary>a</primary>" +
			"<op>&lt;</op><number>11</number></relation><op>&&</op><relation>" +
			"<primary>b</primary><op>&gt;</op><number>11</number></relation>" +
			"</and></condition>", result);
		
		ast = AS3FragmentParser.parseCondition("value & uint(1 << posval)");
		result = ASTUtil.convert(ast, false);
		Assert.assertEquals("<condition><b-and><primary>value</primary><op>&</op>" +
			"<call><primary>uint</primary><arguments><shift><number>1</number>" +
			"<op>&lt;&lt;</op><primary>posval</primary></shift></arguments>" +
			"</call></b-and></condition>", result);
		
	}
}
}