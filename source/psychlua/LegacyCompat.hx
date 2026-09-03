package psychlua;

#if LUA_ALLOWED
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import states.PlayState;
import psychlua.LuaUtils;

class LegacyCompat
{
    public static function implement(funk:FunkinLua)
    {
        var debug = FunkinLua.getBool('luaDebugMode');

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
