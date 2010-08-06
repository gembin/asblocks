package testSuites
{

import org.teotigraphix.as3nodes.impl.TestIdentiferNode;
import org.teotigraphix.as3nodes.impl.TestInterfaceNode;
import org.teotigraphix.as3nodes.impl.TestPackageNode;
import org.teotigraphix.as3nodes.impl.TestSourceFile;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3NodeTestSuite
{
	public var testSourceFile:TestSourceFile;
	public var testPackageNode:TestPackageNode;
	public var testInterfaceNode:TestInterfaceNode;
	public var testIdentiferNode:TestIdentiferNode;
}
}