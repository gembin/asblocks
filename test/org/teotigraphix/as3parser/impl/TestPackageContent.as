package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestPackageContent
{
	private var parser:AS3Parser;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3Parser();
	}
	
	[Test]
	public function testClass():void
	{
		assertPackageContent( "1",
			"public class A { }",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\">"
			+ "<name line=\"2\" column=\"14\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><content line=\"2\" column=\"18\">"
			+ "</content></class></content>" );
	}
	
	[Test]
	public function testClassWithAsDoc():void
	{
		assertPackageContent( "1",
			"/** AsDoc */ public class A { }",
			"<content line=\"2\" column=\"12\"><class line=\"2\" column=\"27\">"
			+ "<as-doc line=\"2\" column=\"1\">/** AsDoc */</as-doc><name line=\"2\" "
			+ "column=\"27\">A</name><mod-list line=\"2\" column=\"14\"><mod line=\"2\" "
			+ "column=\"14\">public</mod></mod-list><content line=\"2\" column=\"31\">"
			+ "</content></class></content>" );
	}
	
	[Test]
	public function testClassWithAsDocComplex():void
	{
		assertPackageContent( "1",
			"/** AsDoc */ public class A { "+ 
			"/** Member */ " + 
			"public var tmp : Number; " + 
			"private var tmp2 : int; " + 
			"/** Function */ " + 
			"protected function foo() : void { } }",
			"<content line=\"2\" column=\"12\"><class line=\"2\" column=\"27\">" +
			"<as-doc line=\"2\" column=\"1\">/** AsDoc */</as-doc><name line=\"2\" " +
			"column=\"27\">A</name><mod-list line=\"2\" column=\"14\"><mod line=\"2\" " +
			"column=\"14\">public</mod></mod-list><content line=\"2\" column=\"43\">" +
			"<var-list line=\"2\" column=\"56\"><mod-list line=\"2\" column=\"45\">" +
			"<mod line=\"2\" column=\"45\">public</mod></mod-list><name-type-init line=\"2\" " +
			"column=\"56\"><name line=\"2\" column=\"56\">tmp</name><type line=\"2\" " +
			"column=\"62\">Number</type></name-type-init><as-doc line=\"2\" column=\"31\">" +
			"/** Member */</as-doc></var-list><var-list line=\"2\" column=\"82\">" +
			"<mod-list line=\"2\" column=\"70\"><mod line=\"2\" column=\"70\">" +
			"private</mod></mod-list><name-type-init line=\"2\" column=\"82\">" +
			"<name line=\"2\" column=\"82\">tmp2</name><type line=\"2\" column=\"89\">" +
			"int</type></name-type-init></var-list><function line=\"2\" column=\"142\">" +
			"<as-doc line=\"2\" column=\"94\">/** Function */</as-doc><mod-list line=\"2\" " +
			"column=\"110\"><mod line=\"2\" column=\"110\">protected</mod></mod-list>" +
			"<name line=\"2\" column=\"129\">foo</name><parameter-list line=\"2\" " +
			"column=\"133\"></parameter-list><type line=\"2\" column=\"137\">void</type>" +
			"<block line=\"2\" column=\"144\"></block></function></content>" +
			"</class></content>" );
	}
	
	[Test]
	public function testClassWithMetadata():void
	{
		assertPackageContent( "1",
			"[Bindable(name=\"abc\", value=\"123\")] public class A { }",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"50\">" +
			"<name line=\"2\" column=\"50\">A</name><meta-list line=\"2\" " +
			"column=\"1\"><meta line=\"2\" column=\"1\">Bindable ( name = \"abc\" ," +
			" value = \"123\" )</meta></meta-list><mod-list line=\"2\" column=\"37\">" +
			"<mod line=\"2\" column=\"37\">public</mod></mod-list><content line=\"2\" " +
			"column=\"54\"></content></class></content>" );
	}
	
	[Test]
	public function testClassWithMetadataComment():void
	{
		assertPackageContent( "1",
			"/** Comment */ [Bindable] public class A { }",
			"<content line=\"2\" column=\"14\"><class line=\"2\" column=\"40\">" +
			"<name line=\"2\" column=\"40\">A</name><meta-list line=\"2\" column=\"16\">" +
			"<meta line=\"2\" column=\"16\"><as-doc line=\"2\" column=\"1\">/** Comment */" +
			"</as-doc></meta></meta-list><mod-list line=\"2\" column=\"27\"><mod line=\"2\" " +
			"column=\"27\">public</mod></mod-list><content line=\"2\" column=\"44\">" +
			"</content></class></content>" );
	}
	
	[Test]
	public function testClassWithSimpleMetadata():void
	{
		assertPackageContent( "1",
			"[Bindable] public class A { }",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"25\">" +
			"<name line=\"2\" column=\"25\">A</name><meta-list line=\"2\" " +
			"column=\"1\"><meta line=\"2\" column=\"1\">Bindable</meta></meta-list>" +
			"<mod-list line=\"2\" column=\"12\"><mod line=\"2\" column=\"12\">" +
			"public</mod></mod-list><content line=\"2\" column=\"29\"></content>" +
			"</class></content>" );
	}
	
	[Test]
	public function testImports():void
	{
		assertPackageContent( "1",
			"import a.b.c;",
			"<content line=\"2\" column=\"1\"><import line=\"2\" "
			+ "column=\"8\">a.b.c</import></content>" );
		
		assertPackageContent( "2",
			"import a.b.c import x.y.z",
			"<content line=\"2\" column=\"1\"><import line=\"2\" column=\"8\">a.b.c"
			+ "</import><import line=\"2\" column=\"21\">x.y.z</import></content>" );
	}
	
	[Test]
	public function testInterface():void
	{
		assertPackageContent( "1",
			"public interface A { }",
			"<content line=\"2\" column=\"1\"><interface line=\"2\" column=\"18\">"
			+ "<name line=\"2\" column=\"18\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><content line=\"2\" column=\"22\">"
			+ "</content></interface></content>" );
	}
	
	[Test]
	public function testMethodPackages():void
	{
		assertPackageContent( "1",
			"public function a() : void { }",
			"<content line=\"2\" column=\"1\"><function line=\"2\" column=\"28\">"
			+ "<mod-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">public</mod>"
			+ "</mod-list><name line=\"2\" column=\"17\">a</name><parameter-list line=\"2\" "
			+ "column=\"19\"></parameter-list><type line=\"2\" column=\"23\">void</type>"
			+ "<block line=\"2\" column=\"30\"></block></function></content>" );
	}
	
	[Test]
	public function testUse():void
	{
		assertPackageContent( "1",
			"use namespace myNamespace",
			"<content line=\"2\" column=\"1\"><use line=\"2\" column=\"15\""
			+ ">myNamespace</use></content>" );
	}
	
	[Test]
	public function testUseNameSpace():void
	{
		assertPackageContent( "1",
			"use namespace mx_internal;",
			"<content line=\"2\" column=\"1\"><use line=\"2\" column=\"15\">" +
			"mx_internal</use></content>" );
	}
	
	private function assertPackageContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array =
			[
				"{",
				input,
				"}",
				"__END__"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		var result:String = ASTUtil.convert(parser.parsePackageContent());
		
		Assert.assertEquals(expected, result);
	}
}
}