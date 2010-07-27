package testSuites
{

import org.teotigraphix.as3parser.impl.TestAS3Scanner;
import org.teotigraphix.as3parser.impl.TestClass;
import org.teotigraphix.as3parser.impl.TestClassContent;
import org.teotigraphix.as3parser.impl.TestCompilationUnit;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AllTests
{
	public var testAS3Scanner:TestAS3Scanner;
	public var testCompilationUnit:TestCompilationUnit;
	public var testClass:TestClass;
	public var testClassContent:TestClassContent;
}
}