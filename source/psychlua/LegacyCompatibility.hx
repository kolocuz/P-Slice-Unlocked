#if LUA_ALLOWED
package psychlua;

import backend.ClientPrefs;
import states.PlayState;
import backend.Song;
import backend.Conductor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import objects.Character;
import objects.Note;
import objects.Alphabet;
import objects.StrumNote;
import openfl.Lib;

class LegacyCompatibility
{
	public static function implement(funk:FunkinLua)
	{
		var lua = funk.lua;
		var debug = FunkinLua.getBool('luaDebugMode');

		funk.set('ClientPrefs', backend.ClientPrefs);
		funk.set('PlayState', states.PlayState);
		funk.set('Song', backend.Song);
		funk.set('Conductor', backend.Conductor);
		funk.set('Paths', Paths);
		funk.set('FlxG', flixel.FlxG);
		funk.set('FlxMath', flixel.math.FlxMath);
		funk.set('FlxSprite', flixel.FlxSprite);
		funk.set('FlxText', flixel.text.FlxText);
		funk.set('Alphabet', objects.Alphabet);
		funk.set('Character', objects.Character);
		funk.set('Note', objects.Note);
		funk.set('StrumNote', objects.StrumNote);
		funk.set('Lib', openfl.Lib);

		Lua_helper.add_callback(lua, "getScore", function() {
			if (debug) FunkinLua.luaTrace('getScore() is deprecated! Use getProperty("songScore") instead', false, true, FlxColor.YELLOW);
			return PlayState.instance?.songScore ?? 0;
		});

		Lua_helper.add_callback(lua, "getMisses", function() {
			if (debug) FunkinLua.luaTrace('getMisses() is deprecated! Use getProperty("songMisses") instead', false, true, FlxColor.YELLOW);
			return PlayState.instance?.songMisses ?? 0;
		});

		Lua_helper.add_callback(lua, "getHits", function() {
			if (debug) FunkinLua.luaTrace('getHits() is deprecated! Use getProperty("songHits") instead', false, true, FlxColor.YELLOW);
			return PlayState.instance?.songHits ?? 0;
		});

		Lua_helper.add_callback(lua, "getPropertyFromClass", function(cls:String, varName:String) {
			var target = Type.resolveClass(cls);
			if (target == null) target = Type.resolveClass('backend.' + cls);
			if (target == null && debug) FunkinLua.luaTrace('getPropertyFromClass: Class "' + cls + '" not found', false, true, FlxColor.RED);
			return target != null ? Reflect.getProperty(target, varName) : null;
		});

		Lua_helper.add_callback(lua, "setPropertyFromClass", function(cls:String, varName:String, value:Dynamic) {
			var target = Type.resolveClass(cls);
			if (target == null) target = Type.resolveClass('backend.' + cls);
			if (target == null && debug) FunkinLua.luaTrace('setPropertyFromClass: Class "' + cls + '" not found', false, true, FlxColor.RED);
			if (target != null) Reflect.setProperty(target, varName, value);
			return value;
		});

		Lua_helper.add_callback(lua, "doTweenX", function(tag, vars, val, dur, ease) {
			if (debug) FunkinLua.luaTrace('doTweenX() is deprecated! Use startTween() instead', false, true, FlxColor.YELLOW);
			return oldTween(funk, tag, vars, {x: val}, dur, ease);
		});

		Lua_helper.add_callback(lua, "doTweenY", function(tag, vars, val, dur, ease) {
			if (debug) FunkinLua.luaTrace('doTweenY() is deprecated! Use startTween() instead', false, true, FlxColor.YELLOW);
			return oldTween(funk, tag, vars, {y: val}, dur, ease);
		});

		Lua_helper.add_callback(lua, "doTweenZoom", function(tag, vars, val, dur, ease) {
			if (debug) FunkinLua.luaTrace('doTweenZoom() is deprecated! Use startTween() instead', false, true, FlxColor.YELLOW);
			return oldTween(funk, tag, vars, {zoom: val}, dur, ease);
		});

		if (debug) FunkinLua.luaTrace('LegacyCompatibility loaded (debug ON)', false, false, FlxColor.GREEN);
	}

	static function oldTween(funk:FunkinLua, tag:String, vars:String, data:Dynamic, dur:Float, ease:String) {
		var target = LuaUtils.tweenPrepare(tag, vars);
		if (target == null) return null;

		if (tag != null) {
			var orig = tag;
			tag = LuaUtils.formatVariable('tween_' + tag);
			LuaUtils.cancelTween(tag);
			var varsMap = MusicBeatState.getVariables();
			varsMap.set(tag, FlxTween.tween(target, data, dur, {
				ease: LuaUtils.getTweenEaseByString(ease),
				onComplete: function(_) {
					varsMap.remove(tag);
					if (PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [orig, vars]);
				}
			}));
			return tag;
		}

		FlxTween.tween(target, data, dur, {ease: LuaUtils.getTweenEaseByString(ease)});
		return null;
	}
}
#end
