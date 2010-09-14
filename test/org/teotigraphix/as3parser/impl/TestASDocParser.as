package org.teotigraphix.as3parser.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3parser.api.IParserNode;
import org.teotigraphix.as3parser.core.SourceCode;
import org.teotigraphix.asblocks.impl.ASTPrinter;
import org.teotigraphix.asblocks.utils.ASTUtil;

public class TestASDocParser
{
	private var parser:ASDocParser;
	
	private var scanner:ASDocScanner;
	
	[Before]
	public function setUp():void
	{
		parser = new ASDocParser();
		scanner = parser.scanner as ASDocScanner;
	}
	
	[Test]
	public function test_shortNoSpace():void
	{
		var input:Array =
			[
				"/**A short comment.*/"
			];
		
		//assertPrint(input);
		assertComment("1", 
			input,
			"<compilation-unit line=\"-1\" column=\"-1\"><content line=\"1\" " +
			"column=\"4\"><short-list line=\"1\" column=\"4\"><text line=\"1\" " +
			"column=\"4\">A short comment.</text></short-list></content>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function test_short2Lines():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment ",
				" * on another line.",
				" */"
			];
		
		//assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit line=\"-1\" column=\"-1\"><content line=\"2\" " +
			"column=\"4\"><short-list line=\"2\" column=\"4\">" +
			"<text line=\"2\" column=\"4\">A short comment  on another line.</text>" +
			"</short-list></content></compilation-unit>");
	}
	
	/**
	 * compilation-unit
	 *   - content
	 *     - short-list
	 *       - text
	 *       - code-text
	 *     - long-list
	 *       - text
	 *       - code-text
	 *     - doctag-list
	 *       - doctag
	 *         - name
	 *         - body
	 *           - text
	 *           - code-text
	 */
	[Test]
	public function test_parseCompilationUnit():void
	{
		var lines:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" * ",
				" * <p>Long <code>document()</code> description.</p>", 
				" * ",
				" * <p>Long <code>create()</code> description two.</p>", 
				" * ",
				" * @author The <code>document()</code> Author", 
				" * @private",
				" */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">"
			+ "<content line=\"2\" column=\"4\"><short-list line=\"2\" "
			+ "column=\"4\"><text line=\"2\" column=\"4\">A short "
			+ "</text><code-text line=\"2\" column=\"12\">document()"
			+ "</code-text><text line=\"2\" column=\"35\"> comment span 2."
			+ "</text></short-list><long-list line=\"5\" column=\"4\">"
			+ "<text line=\"5\" column=\"4\">&lt;p&gt;Long </text><code-text "
			+ "line=\"5\" column=\"12\">document()</code-text><text line=\"5\" "
			+ "column=\"35\"> description.&lt;/p&gt;  &lt;p&gt;Long </text>"
			+ "<code-text line=\"7\" column=\"12\">create()</code-text>"
			+ "<text line=\"7\" column=\"33\"> description two.&lt;/p&gt;  "
			+ "</text></long-list><doctag-list line=\"9\" column=\"4\">"
			+ "<doctag line=\"9\" column=\"4\"><name line=\"9\" column=\"5\">"
			+ "author</name><body line=\"9\" column=\"11\"><text line=\"9\" "
			+ "column=\"11\"> The </text><code-text line=\"9\" column=\"16\">"
			+ "document()</code-text><text line=\"9\" column=\"39\"> Author "
			+ "</text></body></doctag><doctag line=\"10\" column=\"4\">"
			+ "<name line=\"10\" column=\"5\">private</name></doctag>"
			+ "</doctag-list></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function test_parseContentShortLongMultiple():void
	{
		var lines:Array =
			[
				"/**",
				" * A short document comment",
				" * that spans two.",
				" * ",
				" * <p>Long description 1.</p>",
				" * <p>Long description 2.</p>", 
				" */"
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<content line=\"2\" column=\"4\"><short-list line=\"2\" column=\"4\">" +
			"<text line=\"2\" column=\"4\">A short document comment that spans two.</text>" +
			"</short-list><long-list line=\"5\" column=\"4\"><text line=\"5\" column=\"4\">" +
			"&lt;p&gt;Long description 1.&lt;/p&gt; &lt;p&gt;Long description 2.&lt;/p&gt;" +
			"</text></long-list></content></compilation-unit>",
			result);
	}
	
	[Test]
	public function test_parseCompilationUnit_bug1():void
	{
		var lines:Array =
			[
				"/** Class comment. */",
			];
		
		scanner.setLines(Vector.<String>(lines));
		
		var result:String = ASTUtil.convert(parser.parseCompilationUnit());
		
		Assert.assertEquals("<compilation-unit line=\"-1\" column=\"-1\">" +
			"<content line=\"1\" column=\"5\"><short-list line=\"1\" column=\"5\">" +
			"<text line=\"1\" column=\"5\">Class comment. </text></short-list>" +
			"</content></compilation-unit>",
			result);
	}
	
	protected function assertPrint(input:Array):void
	{
		var printer:ASTPrinter = createPrinter();
		printer.print(parse(input));
		Assert.assertEquals(input.join("\n"), printer.flush());
	}
	
	protected function assertComment(message:String, 
									 input:Array, 
									 expected:String):void
	{
		var result:String = ASTUtil.convert(parse(input));
		Assert.assertEquals(message, expected, result);
	}
	
	protected function parse(input:Array):IParserNode
	{
		parser.scanner.setLines(Vector.<String>(input));
		return parser.parseCompilationUnit();
	}
	
	protected function createPrinter():ASTPrinter
	{
		return new ASTPrinter(new SourceCode());
	}
}
}