package testSuites
{

import org.teotigraphix.asblocks.TestASFactory;
import org.teotigraphix.asblocks.impl.TestASProject;
import org.teotigraphix.asblocks.impl.TestArrayAccessExpression;
import org.teotigraphix.asblocks.impl.TestArrayLiteral;
import org.teotigraphix.asblocks.impl.TestAssignmentNodes;
import org.teotigraphix.asblocks.impl.TestBinaryExpression;
import org.teotigraphix.asblocks.impl.TestBooleanLiteralNode;
import org.teotigraphix.asblocks.impl.TestBreakStatement;
import org.teotigraphix.asblocks.impl.TestClassTypeNode;
import org.teotigraphix.asblocks.impl.TestCompilationUnitNode;
import org.teotigraphix.asblocks.impl.TestConditionalExpressionNode;
import org.teotigraphix.asblocks.impl.TestExpressionNodes;
import org.teotigraphix.asblocks.impl.TestFieldNode;
import org.teotigraphix.asblocks.impl.TestInterfaceTypeNode;
import org.teotigraphix.asblocks.impl.TestLiteralNodes;
import org.teotigraphix.asblocks.impl.TestMethodNode;
import org.teotigraphix.asblocks.impl.TestPackageNode;
import org.teotigraphix.asblocks.impl.TestPrefixExpression;
import org.teotigraphix.asblocks.impl.TestStatementList;
import org.teotigraphix.asblocks.impl.TestTokenBoundaries;
import org.teotigraphix.asblocks.impl.TestTryStatementNode;
import org.teotigraphix.asblocks.impl.TestTypeNode;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3BlocksTestSuite
{
	public var testASFactory:TestASFactory;
	public var testASProject:TestASProject;
	public var testCompilationUnitNode:TestCompilationUnitNode;
	public var testPackageNode:TestPackageNode;
	public var testTypeNode:TestTypeNode;
	public var testClassTypeNode:TestClassTypeNode;
	public var testInterfaceNodeType:TestInterfaceTypeNode;
	
	public var testExpressionNodes:TestExpressionNodes;
	public var testLiteralNodes:TestLiteralNodes;
	
	// 
	public var testArrayAccessExpression:TestArrayAccessExpression;
	public var testArrayLiteral:TestArrayLiteral;
	public var testAssignmentNodes:TestAssignmentNodes;
	public var testBinaryExpression:TestBinaryExpression;
	public var testBooleanLiteralNode:TestBooleanLiteralNode;
	public var testBreakStatement:TestBreakStatement;
	public var testConditionalExpressionNode:TestConditionalExpressionNode;
	
	public var testTryStatementNode:TestTryStatementNode;
	
	public var testTokenBoundaries:TestTokenBoundaries;
	public var testFieldNode:TestFieldNode;
	public var testMethodNode:TestMethodNode;
	public var testPrefixExpression:TestPrefixExpression;
	public var testStatementList:TestStatementList;
	
	
}
}