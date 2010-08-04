package org.teotigraphix.as3parser.impl
{

public class TestVarStatement extends AbstractStatementTest
{
	[Test]
	public function testFullFeaturedVar():void
	{
		assertStatement( "1",
			"var a : int = 4",
			"<var-list line=\"1\" column=\"5\">"
			+ "<name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">a</name><type line=\"1\" column=\"9\">int</type>"
			+ "<init line=\"1\" column=\"15\"><primary line=\"1\" column=\"15\">4</primary>"
			+ "</init></name-type-init></var-list>" );
		
		assertStatement( "1",
			"var a : int = 4, b : int = 2;",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">a</name><type line=\"1\" column=\"9\">int</type>"
			+ "<init line=\"1\" column=\"15\"><primary line=\"1\" column=\"15\">4</primary></init>"
			+ "</name-type-init><name-type-init line=\"1\" column=\"18\">"
			+ "<name line=\"1\" column=\"18\">b</name><type line=\"1\" column=\"22\">int</type>"
			+ "<init line=\"1\" column=\"28\"><primary line=\"1\" column=\"28\">2</primary></init>"
			+ "</name-type-init></var-list>" );
		
		assertStatement( "with array",
			"var colors:Array = [0x2bc9f6, 0x0086ad];",
			"<var-list line=\"1\" column=\"5\">"
			+ "<name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">colors</name><type line=\"1\" column=\"12\">Array</type>"
			+ "<init line=\"1\" column=\"20\">"
			+ "<primary line=\"1\" column=\"20\"><array line=\"1\" column=\"20\">"
			+ "<primary line=\"1\" column=\"21\">0x2bc9f6</primary>"
			+ "<primary line=\"1\" column=\"31\">0x0086ad</primary>"
			+ "</array></primary></init></name-type-init></var-list>" );
	}
	
	[Test]
	public function testInitializedVar():void
	{
		assertStatement( "1",
			"var a = 4",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">a</name><type line=\"1\" column=\"7\">"
			+ "</type><init line=\"1\" column=\"9\"><primary line=\"1\" column=\"9\">4</primary>"
			+ "</init></name-type-init></var-list>" );
	}
	
	[Test]
	public function testSimpleVar():void
	{
		assertStatement( "1",
			"var a",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">a</name><type line=\"2\" column=\"1\">"
			+ "</type></name-type-init></var-list>" );
	}
	
	[Test]
	public function testTypedVar():void
	{
		assertStatement( "1",
			"var a : Object",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">a</name><type line=\"1\" column=\"9\">Object</type>"
			+ "</name-type-init></var-list>" );
	}
	
	[Test]
	public function testVector():void
	{
		assertStatement( "vector",
			"var v:Vector.<DisplayObject> = new Vector.<Sprite>();",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" " +
			"column=\"5\"><name line=\"1\" column=\"5\">v</name><vector " +
			"line=\"1\" column=\"7\"><type line=\"1\" column=\"15\">" +
			"DisplayObject</type></vector><init line=\"1\" column=\"32\">" +
			"<new line=\"1\" column=\"36\"><primary line=\"1\" column=\"36\">" +
			"Vector</primary><arguments line=\"1\" column=\"52\"></arguments>" +
			"</new></init></name-type-init></var-list>" );
		
		assertStatement( "vector",
			"var v:Vector.< Vector.< String > >",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">"
			+ "v</name><vector line=\"1\" column=\"7\"><vector line=\"1\" "
			+ "column=\"16\"><type line=\"1\" "
			+ "column=\"25\">String</type></vector></vector></name-type-init></var-list>" );
		
		assertStatement( "vector",
			"var v:Vector.<Vector.<String>>;",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" column=\"5\">"
			+ "<name line=\"1\" column=\"5\">"
			+ "v</name><vector line=\"1\" column=\"7\"><vector line=\"1\" column=\"15\"><type line=\"1\" "
			+ "column=\"23\">String</type></vector></vector></name-type-init></var-list>" );
		
		assertStatement( "",
			"var HT:Vector.<BitString> = new Vector.<BitString>(251, true);",
			"<var-list line=\"1\" column=\"5\"><name-type-init line=\"1\" " +
			"column=\"5\"><name line=\"1\" column=\"5\">HT</name><vector " +
			"line=\"1\" column=\"8\"><type line=\"1\" column=\"16\">BitString" +
			"</type></vector><init line=\"1\" column=\"29\"><new line=\"1\" " +
			"column=\"33\"><primary line=\"1\" column=\"33\">Vector</primary>" +
			"<arguments line=\"1\" column=\"52\"><primary line=\"1\" column=\"52\">" +
			"251</primary><primary line=\"1\" column=\"57\">true</primary>" +
			"</arguments></new></init></name-type-init></var-list>" );
	}
}
}