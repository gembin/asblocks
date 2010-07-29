package testSuites
{

import org.teotigraphix.as3parser.impl.TestASDocParser;
import org.teotigraphix.as3parser.impl.TestASDocScanner;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class ASDocParserTestSuite
{
	public var testASDocScanner:TestASDocScanner;
	public var testASDocParser:TestASDocParser;
}
}