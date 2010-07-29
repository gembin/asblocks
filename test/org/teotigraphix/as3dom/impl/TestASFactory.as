package org.teotigraphix.as3dom.impl
{
import flexunit.framework.Assert;

import org.teotigraphix.as3dom.api.IASProject;

public class TestASFactory
{
	private var factory:ASFactory;
	
	[Before]
	public function setUp():void
	{
		factory = new ASFactory();
	}
	
	[Test]
	public function testAssignments():void
	{
		var path:String = "src";
		
		var project:IASProject = factory.newEmptyASProject(path);
		
		Assert.assertNotNull(project);
		Assert.assertEquals(path, project.output);
		
		
		//
		//ASCompilationUnit unit = proj.newClass("Test");
		//ASClassType clazz = (ASClassType)unit.getType();
		//ASMethod meth = clazz.newMethod("test", Visibility.PUBLIC, "void");
		//meth.addStmt("trace('Hello world')");
		//proj.writeAll();
		
		/*
		package {
		public class Test {
		public function test():void {
		trace('Hello World');
		}
		}
		}
		*/
	}
}
}