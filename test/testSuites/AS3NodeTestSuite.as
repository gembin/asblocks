package testSuites
{

import org.teotigraphix.as3node.impl.TestInterfaceNode;
import org.teotigraphix.as3node.impl.TestPackageNode;
import org.teotigraphix.as3node.impl.TestSourceFile;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3NodeTestSuite
{
	public var testSourceFile:TestSourceFile;
	public var testPackageNode:TestPackageNode;
	public var testInterfaceNode:TestInterfaceNode;
}
}