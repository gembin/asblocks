package testSuites
{

import org.as3commons.asblocks.parser.core.TestLinkedListToken;
import org.as3commons.asblocks.parser.core.TestSourceCode;
import org.as3commons.asblocks.parser.impl.TestAS3FragmentParser;
import org.as3commons.asblocks.parser.impl.TestAS3Scanner;
import org.as3commons.asblocks.parser.impl.TestAS3Tokenizer;
import org.as3commons.asblocks.parser.impl.TestClass;
import org.as3commons.asblocks.parser.impl.TestClassContent;
import org.as3commons.asblocks.parser.impl.TestCompilationUnit;
import org.as3commons.asblocks.parser.impl.TestConstStatement;
import org.as3commons.asblocks.parser.impl.TestDoStatement;
import org.as3commons.asblocks.parser.impl.TestEmptyStatement;
import org.as3commons.asblocks.parser.impl.TestExpression;
import org.as3commons.asblocks.parser.impl.TestForStatement;
import org.as3commons.asblocks.parser.impl.TestIfStatement;
import org.as3commons.asblocks.parser.impl.TestInterface;
import org.as3commons.asblocks.parser.impl.TestInterfaceContent;
import org.as3commons.asblocks.parser.impl.TestPackageContent;
import org.as3commons.asblocks.parser.impl.TestPrimaryExpression;
import org.as3commons.asblocks.parser.impl.TestReturnStatement;
import org.as3commons.asblocks.parser.impl.TestSwitchStatement;
import org.as3commons.asblocks.parser.impl.TestTryCatchFinallyStatement;
import org.as3commons.asblocks.parser.impl.TestUnaryExpression;
import org.as3commons.asblocks.parser.impl.TestVarStatement;
import org.as3commons.asblocks.parser.impl.TestWhileStatement;
import org.as3commons.asblocks.parser.impl.TestWithStatement;

[Suite]
[RunWith("org.flexunit.runners.Suite")]
public class AS3ParserTestSuite
{
	public var testLinkedListToken:TestLinkedListToken;
	
	public var testSourceCode:TestSourceCode;
	
	// TestAS3Parser
	public var testAS3FragmentParser:TestAS3FragmentParser;
	public var testAS3Scanner:TestAS3Scanner;
	public var testClass:TestClass;
	public var testClassContent:TestClassContent;
	public var testCompilationUnit:TestCompilationUnit;
	public var testConstStatement:TestConstStatement;
	public var testDoStatement:TestDoStatement;
	// TestE4xExpression
	public var testEmptyStatement:TestEmptyStatement;
	public var testExpression:TestExpression;
	public var testForStatement:TestForStatement;
	public var testIfStatement:TestIfStatement;
	public var testInterface:TestInterface;
	public var testInterfaceContent:TestInterfaceContent;
//	public var testMetaData:TestMetaData;
	public var testPackageContent:TestPackageContent;
	public var testPrimaryExpression:TestPrimaryExpression;
	public var testReturnStatement:TestReturnStatement;
	public var testSwitchStatement:TestSwitchStatement;
	public var testTryCatchFinallyStatement:TestTryCatchFinallyStatement;
	public var testUnaryExpression:TestUnaryExpression;
	public var testVarStatement:TestVarStatement;
	public var testWhileStatement:TestWhileStatement;
	public var testWithStatement:TestWithStatement;
	
	public var testAS3Tokenizer:TestAS3Tokenizer;
	
	// util
//	public var testASTUtil:TestASTUtil;
}
}