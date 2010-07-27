package org.teotigraphix.as3parser.impl
{

public class TestConstStatement extends AbstractStatementTest
{

	[Test]
	public function testFullFeaturedConst():void
	{
		assertStatement( "1",
			"const a : int = 4",
			"<const-list line=\"1\" column=\"7\">"
			+ "<name-type-init line=\"1\" column=\"7\">"
			+ "<name line=\"1\" column=\"7\">a</name><type line=\"1\" column=\"11\">int</type>"
			+ "<init line=\"1\" column=\"17\"><primary line=\"1\" column=\"17\">4</primary>"
			+ "</init></name-type-init></const-list>" );
	}
	
	[Test]
	public function testInitializedConst():void
	{
		assertStatement( "1",
			"const a = 4",
			"<const-list line=\"1\" column=\"7\"><name-type-init line=\"1\" column=\"7\">"
			+ "<name line=\"1\" column=\"7\">a</name><type line=\"1\" column=\"9\">"
			+ "</type><init line=\"1\" column=\"11\"><primary line=\"1\" column=\"11\">4"
			+ "</primary></init></name-type-init></const-list>" );
	}
	
	[Test]
	public function testSimpleConst():void
	{
		assertStatement( "1",
			"const a",
			"<const-list line=\"1\" column=\"7\"><name-type-init line=\"1\" column=\"7\">"
			+ "<name line=\"1\" column=\"7\">a</name><type line=\"2\" column=\"1\">"
			+ "</type></name-type-init></const-list>" );
	}
	
	[Test]
	public function testTypedConst():void
	{
		assertStatement( "1",
			"const a : Object",
			"<const-list line=\"1\" column=\"7\"><name-type-init line=\"1\" column=\"7\">"
			+ "<name line=\"1\" column=\"7\">a</name><type line=\"1\" column=\"11\">Object</type>"
			+ "</name-type-init></const-list>" );
	}
}
}