package org.as3commons.asblocks.parser.impl
{
import org.as3commons.asblocks.impl.ASTPrinter;
import org.as3commons.asblocks.parser.api.IParserNode;
import org.as3commons.asblocks.parser.core.SourceCode;
import org.as3commons.asblocks.utils.ASTUtil;
import org.flexunit.Assert;

public class TestASDocParser2
{
	private var parser:ASDocParser2;
	
	private var scanner:ASDocScanner2;
	
	[Before]
	public function setUp():void
	{
		parser = new ASDocParser2();
		scanner = parser.scanner as ASDocScanner2;
	}
	
	[Test]
	public function test_singleLine():void
	{
		var input:Array =
			[
				"/**A short comment.*/"
			];
		
		assertPrint(input);
		assertComment("1", 
			input,
			"<compilation-unit><description><body><text-block>" +
			"<text>A short comment.</text></text-block></body>" +
			"</description></compilation-unit>");
	}
	
	[Test]
	public function test_singleLineWithSpaces():void
	{
		var input:Array =
			[
				"/**  A short comment.  */"
			];
		
		assertPrint(input);
		assertComment("1", input, 
			"<compilation-unit><description><body><text-block><text>A short comment.  </text>" +
			"</text-block></body></description></compilation-unit>");
	}
	
	[Test]
	public function test_multiLineNoAstrix():void
	{
		var input:Array =
			[
				"/**",
				" A short comment.",
				" */"
			];
		
		assertPrint(input);
		assertComment("1", input, 
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short comment.</text><nl></nl></text-block></body>" +
			"</description></compilation-unit>");
	}
	
	[Test]
	public function test_multiLine():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment.",
				" */"
			];
		
		assertPrint(input);
		assertComment("1", input, 
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short comment.</text><nl></nl></text-block></body>" +
			"</description></compilation-unit>");
	}
	
	[Test]
	public function test_multiPara():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment.",
				" * second line.",
				" */"
			];
		
		assertPrint(input);
		assertComment("1", input, 
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short comment.</text><nl></nl><text>second line.</text>" +
			"<nl></nl></text-block></body></description></compilation-unit>");
	}
	
	[Test]
	public function test_MultipleLinesAndPara():void
	{
		var input:Array =
			[
				"/**",
				" * A short comment",
				" * on another line.",
				" * ",
				" * <p>A paragraph 1.",
				" * more on another line.</p>",
				" * ",
				" * <p>A paragraph 2.</p>",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short comment</text><nl></nl><text>on another line.</text>" +
			"<nl></nl><nl></nl></text-block><p-block><text-block><text>A paragraph 1.</text>" +
			"<nl></nl><text>more on another line.</text></text-block></p-block>" +
			"<nl></nl><nl></nl><p-block><text-block><text>A paragraph 2.</text></text-block>" +
			"</p-block><nl></nl></body></description></compilation-unit>");
	}
	
	//[Test]
	public function test_docTagName():void
	{
		var input:Array =
			[
				"/**",
				" * @private",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> </text>" +
			"</text-block></body><doctag-list><doctag><name>private</name></doctag>" +
			"</doctag-list></description></compilation-unit>");
	}
	
	//[Test]
	public function test_docTagNameAndBody():void
	{
		var input:Array =
			[
				"/**",
				" * @foo bar ",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><text-block><text> </text>" +
			"</text-block></body><doctag-list><doctag><name>foo</name><body>" +
			"<text-block><text> bar </text><nl></nl></text-block></body></doctag>" +
			"</doctag-list></description></compilation-unit>");
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
		var result:String = ASTUtil.convert(parse(input), false);
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