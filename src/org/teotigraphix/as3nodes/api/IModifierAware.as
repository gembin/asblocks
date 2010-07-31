package org.teotigraphix.as3nodes.api
{

public interface IModifierAware
{
	function addModifier(modifier:Modifier):void
	
	function hasModifier(modifier:Modifier):Boolean;
}
}