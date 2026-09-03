package psychlua;

#if LUA_ALLOWED

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import states.PlayState;
import psychlua.LuaUtils;
import backend.MusicBeatState;
import backend.ClientPrefs;
import backend.Song;
import backend.Conductor;

class LegacyCompat
{
    public static function implement(funk:FunkinLua)
    {
        var debug = FunkinLua.getBool('luaDebugMode');

        // ---- Алиасы классов ----
        funk.set('ClientPrefs', backend.ClientPrefs);
        funk.set('Conductor', backend.Conductor);
        funk.set('Song', backend.Song);
        funk.set('Paths', Paths);
        funk.set('PlayState', states.PlayState);
        funk.set('GameOverSubstate', substates.GameOverSubstate);
        funk.set('PauseSubState', substates.PauseSubState);
        funk.set('Character', objects.Character);
        funk.set('Note', objects.Note);
        funk.set('Alphabet', objects.Alphabet);
        funk.set('StrumNote', objects.StrumNote);
        funk.set('HealthIcon', objects.HealthIcon);
        funk.set('FlxG', flixel.FlxG);
        funk.set('FlxSprite', flixel.FlxSprite);
        funk.set('FlxText', flixel.text.FlxText);
        funk.set('FlxTimer', flixel.util.FlxTimer);
        funk.set('FlxTween', flixel.tweens.FlxTween);
        funk.set('FlxEase', flixel.tweens.FlxEase);
        funk.set('FlxSound', flixel.sound.FlxSound);
        funk.set('Lib', openfl.Lib);
        funk.set('Type', Type);
        funk.set('Reflect', Reflect);
        funk.set('Math', Math);
        funk.set('Std', Std);
        funk.set('Json', haxe.Json);
        funk.set('StringTools', StringTools);

        // ---- Старые функции ----
        Lua_helper.add_callback(funk.lua, "getScore", function() {
            if (debug) FunkinLua.luaTrace('getScore() is deprecated! Use getProperty("songScore")', false, true, FlxColor.YELLOW);
            return PlayState.instance?.songScore ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "getMisses", function() {
            if (debug) FunkinLua.luaTrace('getMisses() is deprecated! Use getProperty("songMisses")', false, true, FlxColor.YELLOW);
            return PlayState.instance?.songMisses ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "getHits", function() {
            if (debug) FunkinLua.luaTrace('getHits() is deprecated! Use getProperty("songHits")', false, true, FlxColor.YELLOW);
            return PlayState.instance?.songHits ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "doTweenX", function(tag, vars, val, dur, ease) {
            if (debug) FunkinLua.luaTrace('doTweenX() is deprecated! Use startTween()', false, true, FlxColor.YELLOW);
            return oldTween(funk, tag, vars, {x: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "doTweenY", function(tag, vars, val, dur, ease) {
            if (debug) FunkinLua.luaTrace('doTweenY() is deprecated! Use startTween()', false, true, FlxColor.YELLOW);
            return oldTween(funk, tag, vars, {y: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "doTweenZoom", function(tag, vars, val, dur, ease) {
            if (debug) FunkinLua.luaTrace('doTweenZoom() is deprecated! Use startTween()', false, true, FlxColor.YELLOW);
            return oldTween(funk, tag, vars, {zoom: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "getPropertyFromClass", function(classVar:String, variable:String) {
            var myClass = Type.resolveClass(classVar);
            if (myClass == null) myClass = Type.resolveClass('backend.' + classVar);
            if (myClass == null && debug) FunkinLua.luaTrace('Class "' + classVar + '" not found', false, true, FlxColor.RED);
            return myClass != null ? Reflect.getProperty(myClass, variable) : null;
        });

        Lua_helper.add_callback(funk.lua, "setPropertyFromClass", function(classVar:String, variable:String, value:Dynamic) {
            var myClass = Type.resolveClass(classVar);
            if (myClass == null) myClass = Type.resolveClass('backend.' + classVar);
            if (myClass != null) Reflect.setProperty(myClass, variable, value);
            return value;
        });

        if (debug) FunkinLua.luaTrace('LegacyCompat loaded (debug ON)', false, false, FlxColor.GREEN);
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