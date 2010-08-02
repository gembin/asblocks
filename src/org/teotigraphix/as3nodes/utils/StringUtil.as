package org.teotigraphix.as3nodes.utils
{
import mx.utils.StringUtil;

public class StringUtil
{
	public static function trim(data:String):String
	{
		return mx.utils.StringUtil.trim(data);
	}
	
	public static function startsWith(data:String, delimeter:String):Boolean
	{
		return data.indexOf(delimeter) == 0;
	}
	
	public static function endsWith(data:String, delimeter:String):Boolean
	{
		return data.substr(data.length - delimeter.length, delimeter.length) == delimeter;
	}
}
}