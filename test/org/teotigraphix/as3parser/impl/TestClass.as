package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.utils.ASTUtil;

public class TestClass
{
	private var parser:AS3ParserOLD;
	
	[Before]
	public function setUp():void
	{
		parser = new AS3ParserOLD();
	}
	
	[Test]
	public function testExtends():void
	{
		assertPackageContent("1", 
			"public /*foo comment*/class A { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"29\">" +
			"<name line=\"2\" column=\"29\">A</name><mod-list line=\"2\" column=\"1\">" +
			"<mod line=\"2\" column=\"1\">public</mod></mod-list><content line=\"2\" " +
			"column=\"33\"></content></class></content>");
		
		assertPackageContent("1", 
			"public class A extends B { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" " +
			"column=\"14\"><name line=\"2\" column=\"14\">A</name>" +
			"<mod-list line=\"2\" column=\"1\"><mod line=\"2\" column=\"1\">" +
			"public</mod></mod-list><extends line=\"2\" column=\"24\">B</extends>" +
			"<content line=\"2\" column=\"28\"></content></class></content>");
		
		assertPackageContent("1",
			"public class A extends com.adobe::B { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\"><name line=\"2\" "
			+ "column=\"14\">A</name><mod-list line=\"2\" column=\"1\"><mod line=\"2\" "
			+ "column=\"1\">public</mod></mod-list><extends line=\"2\" column=\"24\""
			+ ">com.adobe::B</extends><content line=\"2\" column=\"39\"></content>"
			+ "</class></content>" );
	}
	
	[Test]
	public function testFinalClass():void
	{
		assertPackageContent( "",
			"public final class Title{ }",
			"<content line=\"2\" column=\"1\">"
			+ "<class line=\"2\" column=\"20\">"
			+ "<name line=\"2\" column=\"20\">Title</name>"
			+ "<mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "<mod line=\"2\" column=\"8\">final</mod></mod-list>"
			+ "<content line=\"2\" " + "column=\"27\"></content>" + "</class>"
			+ "</content>" );
	}
	
	[Test]
	public function testFullFeatured():void
	{
		assertPackageContent( "1",
			"public class A extends B implements C,D { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\">"
			+ "<name line=\"2\" column=\"14\">A</name><mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod></mod-list><extends line=\"2\" "
			+ "column=\"24\">B</extends><implements-list line=\"2\" column=\"37\">"
			+ "<implements line=\"2\" column=\"37\">C</implements><implements line=\"2\" "
			+ "column=\"39\">D</implements></implements-list><content line=\"2\" column=\"43\">"
			+ "</content></class></content>" );
	}
	
	[Test]
	public function testImplementsList():void
	{
		assertPackageContent( "1",
			"public class A implements B,C { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\">"
			+ "<name line=\"2\" column=\"14\">A</name><mod-list line=\"2\" "
			+ "column=\"1\"><mod line=\"2\" column=\"1\">public</mod></mod-list>"
			+ "<implements-list line=\"2\" column=\"27\"><implements line=\"2\" "
			+ "column=\"27\">B</implements><implements line=\"2\" column=\"29\">"
			+ "C</implements></implements-list><content line=\"2\" column=\"33\">"
			+ "</content></class></content>" );
	}

	[Test]
	public function testImplementsSingle():void
	{
		assertPackageContent( "1",
			"public class A implements B { } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\">"
			+ "<name line=\"2\" column=\"14\">A</name><mod-list line=\"2\" "
			+ "column=\"1\"><mod line=\"2\" column=\"1\">public</mod></mod-list>"
			+ "<implements-list line=\"2\" column=\"27\"><implements line=\"2\" "
			+ "column=\"27\">B</implements></implements-list><content line=\"2\" "
			+ "column=\"31\"></content></class></content>" );
	}
	
	[Test]
	public function testImportInsideClass():void
	{
		assertPackageContent( "",
			"public final class Title{ import lala.lala; }",
			"<content line=\"2\" column=\"1\">"
			+ "<class line=\"2\" column=\"20\">"
			+ "<name line=\"2\" column=\"20\">Title</name>"
			+ "<mod-list line=\"2\" column=\"1\">"
			+ "<mod line=\"2\" column=\"1\">public</mod>"
			+ "<mod line=\"2\" column=\"8\">final</mod>" + "</mod-list>"
			+ "<content line=\"2\" column=\"27\"><import line=\"2\" "
			+ "column=\"34\">lala.lala</import></content></class></content>" );
	}
	
	[Test]
	public function testInclude():void
	{
		assertPackageContent( "1",
			"public class A extends B { include \"ITextFieldInterface.asz\" } ",
			"<content line=\"2\" column=\"1\"><class line=\"2\" column=\"14\">" +
			"<name line=\"2\" column=\"14\">A</name><mod-list line=\"2\" " +
			"column=\"1\"><mod line=\"2\" column=\"1\">public</mod>" +
			"</mod-list><extends line=\"2\" column=\"24\">B</extends>" +
			"<content line=\"2\" column=\"28\"><include line=\"2\" column=\"28\">" +
			"<primary line=\"2\" column=\"36\">\"ITextFieldInterface.asz\"" +
			"</primary></include></content></class></content>" );
	}

	private function assertPackageContent(message:String, 
										  input:String, 
										  expected:String):void
	{
		var lines:Array =
			[
				"{",
				input,
				"}"
			];
		
		parser.scanner.setLines(ASTUtil.toVector(lines));
		
		parser.nextToken(); // first call
		parser.nextToken(); // skip {
		
		Assert.assertEquals(expected, ASTUtil.convert(parser.parsePackageContent()));
	}
}
}