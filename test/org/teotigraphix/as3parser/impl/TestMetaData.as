package org.teotigraphix.as3parser.impl
{

import org.flexunit.Assert;
import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestMetaData
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	//[Test]
	public function testBasic():void
	{
		assertMetaData("[MetaData]",
			"<meta-list line=\"1\" column=\"1\"><meta line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"2\">MetaData</name>" +
			"</meta></meta-list>");
	}
	
	//[Test]
	public function testEmptyParenthesis():void
	{
		assertMetaData("[MetaData()]",
			"<meta-list line=\"1\" column=\"1\"><meta line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"2\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"10\"></parameter-list>" +
			"</meta></meta-list>");
	}
	
	//[Test]
	public function testUnNamedParameter():void
	{
		assertMetaData("[MetaData(true)]",
			"<meta-list line=\"1\" column=\"1\"><meta line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"2\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"10\"><parameter line=\"1\" " +
			"column=\"11\"><name line=\"1\" column=\"11\">true</name></parameter>" +
			"</parameter-list></meta></meta-list>");
	}
	
	//[Test]
	public function testNamedParameter():void
	{
		assertMetaData("[MetaData(name=\"true\")]",
			"<meta-list line=\"1\" column=\"1\"><meta line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"2\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"10\"><parameter line=\"1\" " +
			"column=\"11\"><name line=\"1\" column=\"11\">name</name><value " +
			"line=\"1\" column=\"16\">\"true\"</value></parameter></parameter-list>" +
			"</meta></meta-list>");
	}
	
	//[Test]
	public function testNamedAndUnNamedParameter():void
	{
		assertMetaData("[MetaData(name=\"true\", false)]",
			"<meta-list line=\"1\" column=\"1\"><meta line=\"1\" " +
			"column=\"1\"><name line=\"1\" column=\"2\">MetaData</name>" +
			"<parameter-list line=\"1\" column=\"10\"><parameter line=\"1\" " +
			"column=\"11\"><name line=\"1\" column=\"11\">name</name><value " +
			"line=\"1\" column=\"16\">\"true\"</value></parameter><parameter " +
			"line=\"1\" column=\"24\"><name line=\"1\" column=\"24\">false</name>" +
			"</parameter></parameter-list></meta></meta-list>");
	}
	
	//[Test]
	public function testASDocComment():void
	{
		assertMetaData("/** ASDoc comment. */[MetaData]",
			"<meta-list line=\"1\" column=\"21\"><meta line=\"1\" " +
			"column=\"22\"><as-doc line=\"1\" column=\"1\">/** ASDoc comment. " +
			"*/</as-doc><name line=\"1\" column=\"23\">MetaData</name>" +
			"</meta></meta-list>");
	}
	
	//[Test]
	private function assertMetaData(source:String, expected:String):void
	{
		var lines:Array =
			[
				source,
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		parser.nextToken();
		//var result:String = ASTUtil.convert(parser.parseMetaDatas());
		//Assert.assertEquals(expected, result);
	}
}
}