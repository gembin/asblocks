package testSuites
{

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AllTests
{
	public var aS3ParserTestSuite:AS3ParserTestSuite;
	public var aS3NodeTestSuite:AS3NodeTestSuite;
	public var mXMLParserTestSuite:MXMLParserTestSuite;
	public var aSDocParserTestSuite:ASDocParserTestSuite;
	public var aS3BookTestSuite:AS3BookTestSuite;
}
}