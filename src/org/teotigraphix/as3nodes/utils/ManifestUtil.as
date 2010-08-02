package org.teotigraphix.as3nodes.utils
{

import org.teotigraphix.as3nodes.impl.MXMLQName;
import org.teotigraphix.as3nodes.impl.ManifestItem;

// TODO implement ManifestUtil;
public class ManifestUtil
{
	public static function getItem(qname:MXMLQName, id:String):ManifestItem
	{
		initialize();
		/*
		List<ManifestItem> items = map.get(qname.getURI());
		if (items == null)
			return null;
		
		for (ManifestItem item : items)
		{
			if (item.name.equals(id))
				return item;
		}
		*/
		return null;
	}
	
	private static function initialize():void
	{
		
	}
}
}