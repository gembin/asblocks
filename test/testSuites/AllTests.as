package testSuites
{

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AllTests
{
	public var aS3BlockTestSuite:AS3BlockTestSuite;
	public var aS3ParserTestSuite:AS3ParserTestSuite;
	public var mXMLParserTestSuite:MXMLParserTestSuite;
	public var aSDocParserTestSuite:ASDocParserTestSuite;
//	public var aS3BookTestSuite:AS3BookTestSuite;
	
	public var wikiExamples:WikiExamples;
}
}