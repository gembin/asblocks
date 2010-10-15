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
			"<nl></nl><nl></nl><p-block><text>A paragraph 1.</text><nl></nl>" +
			"<text>more on another line.</text></p-block><nl></nl><nl></nl>" +
			"<p-block><text>A paragraph 2.</text></p-block><nl></nl></text-block>" +
			"</body></description></compilation-unit>");
	}
	
	[Test]
	public function test_parseCode():void
	{
		var input:Array =
			[
				"/**", 
				" * A short <code>document()</code> comment",
				" * span 2.", 
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short </text><code-block><text>document()</text></code-block>" +
			"<text> comment</text><nl></nl><text>span 2.</text><nl></nl></text-block>" +
			"</body></description></compilation-unit>");
		
		input =
			[
				"/**", 
				" * comment me.",
				" * ",
				" * <p>A short <code>document()</code> comment",
				" * span 2.</p>", 
				" */"
			];
		
		assertPrint(input);
		assertComment("2",
			input,
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>comment me.</text><nl></nl><nl></nl><p-block><text>A short </text>" +
			"<code-block><text>document()</text></code-block><text> comment</text>" +
			"<nl></nl><text>span 2.</text></p-block><nl></nl></text-block></body>" +
			"</description></compilation-unit>");
	}
	
	[Test]
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
			"<compilation-unit><description><body><nl></nl></body><doctag-list>" +
			"<doctag><name>private</name><body><text-block><nl></nl></text-block>" +
			"</body></doctag></doctag-list></description></compilation-unit>");
	}
	
	[Test]
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
			"<compilation-unit><description><body><nl></nl></body><doctag-list>" +
			"<doctag><name>foo</name><body><text-block><text> bar </text><nl></nl>" +
			"</text-block></body></doctag></doctag-list></description>" +
			"</compilation-unit>");
	}
	
	[Test]
	public function test_fullFeatured():void
	{
		var input:Array =
			[
				"/**",
				" * A short description. ",
				" * ",
				" * <p>Some thext that <code>can</code> be ",
				" * used for a test.</p>",
				" * ",
				" * @see foo bar",
				" * @internal foo <code>bar()</code>",
				" * baz goo",
				" */"
			];
		
		assertPrint(input);
		assertComment("1",
			input,
			"<compilation-unit><description><body><nl></nl><text-block>" +
			"<text>A short description. </text><nl></nl><nl></nl><p-block>" +
			"<text>Some thext that </text><code-block><text>can</text>" +
			"</code-block><text> be </text><nl></nl><text>used for a test.</text>" +
			"</p-block><nl></nl><nl></nl></text-block></body><doctag-list>" +
			"<doctag><name>see</name><body><text-block><text> foo bar</text>" +
			"<nl></nl></text-block></body></doctag><doctag><name>internal</name>" +
			"<body><text-block><text> foo </text><code-block><text>bar()</text>" +
			"</code-block><nl></nl><text>baz goo</text><nl></nl></text-block></body>" +
			"</doctag></doctag-list></description></compilation-unit>");
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