package org.teotigraphix.as3parser.impl
{
public class TestExpression extends AbstractStatementTest
{
	[Test]
	public function testAddExpression():void
	{
		assertStatement( "1",
			"5+6",
			"<add line=\"1\" column=\"1\"><primary line=\"1\" "
			+ "column=\"1\">5</primary><op line=\"1\" "
			+ "column=\"2\">+</op><primary line=\"1\" column=\"3\">6</primary></add>" );
	}
	
	[Test]
	public function testAndExpression():void
	{
		assertStatement( "1",
			"5&&6",
			"<and line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5</primary>"
			+ "<op line=\"1\" column=\"2\">&&</op>"
			+ "<primary line=\"1\" column=\"4\">6</primary></and>" );
	}
	
	[Test]
	public function testAssignmentExpression():void
	{
		assertStatement( "1",
			"x+=6",
			"<assign line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">x"
			+ "</primary><op line=\"1\" column=\"2\">+=</op><primary line=\"1\" "
			+ "column=\"4\">6</primary></assign>" );
	}
	
	[Test]
	public function testBitwiseAndExpression():void
	{
		assertStatement( "1",
			"5&6",
			"<b-and line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">&</op><primary line=\"1\" "
			+ "column=\"3\">6</primary></b-and>" );
	}
	
	[Test]
	public function testBitwiseOrExpression():void
	{
		assertStatement( "1",
			"5|6",
			"<b-or line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">|</op><primary line=\"1\" "
			+ "column=\"3\">6</primary></b-or>" );
	}
	
	[Test]
	public function testBitwiseXorExpression():void
	{
		assertStatement( "1",
			"5^6",
			"<b-xor line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">^</op><primary line=\"1\" "
			+ "column=\"3\">6</primary></b-xor>" );
	}
	
	[Test]
	public function testConditionalExpression():void
	{
		assertStatement( "1",
			"true?5:6",
			"<conditional line=\"1\" column=\"5\"><primary line=\"1\" column=\"1\">"
			+ "true</primary><primary line=\"1\" column=\"6\">5"
			+ "</primary><primary line=\"1\" column=\"8\">6" + "</primary></conditional>" );
	}
	
	[Test]
	public function testEncapsulated():void
	{
		assertStatement( "",
			"(dataProvider as ArrayCollection) = null",
			"<assign line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">"
			+ "<encapsulated line=\"1\" column=\"2\"><relation line=\"1\" column=\"2\">"
			+ "<primary line=\"1\" column=\"2\">dataProvider</primary>"
			+ "<op line=\"1\" column=\"15\">as</op><primary line=\"1\" column=\"18\">"
			+ "ArrayCollection</primary></relation></encapsulated></primary>"
			+ "<op line=\"1\" column=\"35\">=</op><primary line=\"1\" column=\"37\">"
			+ "null</primary></assign>" );
	}
	
	[Test]
	public function testEqualityExpression():void
	{
		assertStatement( "1",
			"5&&6,5&&9",
			"<expr-list line=\"1\" column=\"1\"><and line=\"1\" column=\"1\">"
			+ "<primary line=\"1\" column=\"1\">5</primary><op line=\"1\" column=\"2\">"
			+ "&&</op><primary line=\"1\" column=\"4\">6</primary></and><and line=\"1\" "
			+ "column=\"6\"><primary line=\"1\" column=\"6\">5</primary><op line=\"1\" "
			+ "column=\"7\">&&</op><primary line=\"1\" column=\"9\">9</primary></and></expr-list>" );
	}
	
	[Test]
	public function testMulExpression():void
	{
		assertStatement( "1",
			"5/6",
			"<mul line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">/</op><primary line=\"1\" "
			+ "column=\"3\">6</primary></mul>" );
	}
	
	[Test]
	public function testNewExpression():void
	{
		assertStatement( "",
			"new Event()",
			"<new line=\"1\" column=\"5\"><call line=\"1\" column=\"10\">"
			+ "<primary line=\"1\" column=\"5\">Event</primary>"
			+ "<arguments line=\"1\" column=\"11\"></arguments></call></new>" );
		
		assertStatement( "",
			"new Event(\"lala\")",
			"<new line=\"1\" column=\"5\"><call line=\"1\" column=\"10\">"
			+ "<primary line=\"1\" column=\"5\">Event</primary>"
			+ "<arguments line=\"1\" column=\"11\"><primary line=\"1\" column=\"11\">"
			+ "\"lala\"</primary></arguments></call></new>" );
	}
	
	[Test]
	public function testOrExpression():void
	{
		assertStatement( "1",
			"5||6",
			"<or line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">||</op><primary line=\"1\" "
			+ "column=\"4\">6</primary></or>" );
	}
	
	[Test]
	public function testRelationalExpression():void
	{
		assertStatement( "1",
			"5<=6",
			"<relation line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">&lt;=</op><primary line=\"1\" "
			+ "column=\"4\">6</primary></relation>" );
	}
	
	[Test]
	public function testShiftExpression():void
	{
		assertStatement( "1",
			"5<<6",
			"<shift line=\"1\" column=\"1\"><primary line=\"1\" column=\"1\">5"
			+ "</primary><op line=\"1\" column=\"2\">&lt;&lt;</op><primary line=\"1\" "
			+ "column=\"4\">6</primary></shift>" );
	}
}
}