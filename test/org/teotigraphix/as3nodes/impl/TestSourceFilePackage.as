package org.teotigraphix.as3nodes.impl
{

import flexunit.framework.Assert;

import org.teotigraphix.as3nodes.api.ISourceFilePackage;
import org.teotigraphix.as3nodes.impl.SourceFilePackage;

public class TestSourceFilePackage
{
	[Test]
	public function testBasic():void
	{
		var collection:SourceFilePackage = 
			new SourceFilePackage("/home/teoti/src", "my.domain.core");
		
		Assert.assertNull(collection.node);
		Assert.assertNull(collection.parent);
		
		Assert.assertEquals("/home/teoti/src", collection.classPath);
		Assert.assertEquals("my.domain.core", collection.name);
		Assert.assertEquals("/home/teoti/src/my/domain/core", collection.toString());
		Assert.assertEquals("/home/teoti/src/my/domain/core", collection.toLink());
	}
	
	[Test]
	public function testWindowsMount():void
	{
		var collection:SourceFilePackage = 
			new SourceFilePackage("C:\\\\home\\teoti\\src", "my.domain.core");
		
		Assert.assertNull(collection.node);
		Assert.assertNull(collection.parent);
		
		Assert.assertEquals("C://home/teoti/src", collection.classPath);
		Assert.assertEquals("my.domain.core", collection.name);
		Assert.assertEquals("C://home/teoti/src/my/domain/core", collection.toString());
		Assert.assertEquals("C://home/teoti/src/my/domain/core", collection.toLink());
	}
}
}