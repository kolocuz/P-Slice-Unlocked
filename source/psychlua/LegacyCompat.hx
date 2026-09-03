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
import backend.Highscore;
import backend.Mods;
import backend.CoolUtil;
import backend.Difficulty;
import backend.WeekData;
import objects.Character;
import objects.Note;
import objects.Alphabet;
import objects.StrumNote;
import objects.HealthIcon;
import openfl.Lib;
import openfl.utils.Assets;

class LegacyCompat
{
    static var warnedFunctions:Map<String, Bool> = new Map<String, Bool>();

    static function warnOnce(funk:FunkinLua, funcName:String, message:String) {
        if (!warnedFunctions.exists(funcName)) {
            warnedFunctions.set(funcName, true);
            FunkinLua.luaTrace(message, false, true, FlxColor.YELLOW);
        }
    }

    public static function implement(funk:FunkinLua)
    {
        var debug = FunkinLua.getBool('luaDebugMode');

        // ---- Алиасы классов ----
        funk.set('ClientPrefs', backend.ClientPrefs);
        funk.set('Conductor', backend.Conductor);
        funk.set('Song', backend.Song);
        funk.set('Paths', Paths);
        funk.set('Highscore', backend.Highscore);
        funk.set('Mods', backend.Mods);
        funk.set('CoolUtil', backend.CoolUtil);
        funk.set('Difficulty', backend.Difficulty);
        funk.set('WeekData', backend.WeekData);
        funk.set('PlayState', states.PlayState);
        funk.set('MainMenuState', mikolka.vslice.ui.MainMenuState);
        funk.set('FreeplayState', mikolka.vslice.freeplay.FreeplayState);
        funk.set('StoryMenuState', mikolka.vslice.ui.StoryMenuState);
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
        funk.set('FunkinLua', psychlua.FunkinLua);
        funk.set('HScript', psychlua.HScript);
        funk.set('LuaUtils', psychlua.LuaUtils);
        funk.set('Lib', openfl.Lib);
        funk.set('Assets', openfl.utils.Assets);
        funk.set('Type', Type);
        funk.set('Reflect', Reflect);
        funk.set('Math', Math);
        funk.set('Std', Std);
        funk.set('Json', haxe.Json);
        funk.set('StringTools', StringTools);

        // ---- Устаревшие функции (warn только 1 раз) ----
        Lua_helper.add_callback(funk.lua, "getScore", function() {
            if (debug) warnOnce(funk, 'getScore', 'getScore() is deprecated! Use getProperty("songScore")');
            return PlayState.instance?.songScore ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "getMisses", function() {
            if (debug) warnOnce(funk, 'getMisses', 'getMisses() is deprecated! Use getProperty("songMisses")');
            return PlayState.instance?.songMisses ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "getHits", function() {
            if (debug) warnOnce(funk, 'getHits', 'getHits() is deprecated! Use getProperty("songHits")');
            return PlayState.instance?.songHits ?? 0;
        });

        Lua_helper.add_callback(funk.lua, "doTweenX", function(tag, vars, val, dur, ease) {
            if (debug) warnOnce(funk, 'doTweenX', 'doTweenX() is deprecated! Use startTween()');
            return oldTween(funk, tag, vars, {x: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "doTweenY", function(tag, vars, val, dur, ease) {
            if (debug) warnOnce(funk, 'doTweenY', 'doTweenY() is deprecated! Use startTween()');
            return oldTween(funk, tag, vars, {y: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "doTweenZoom", function(tag, vars, val, dur, ease) {
            if (debug) warnOnce(funk, 'doTweenZoom', 'doTweenZoom() is deprecated! Use startTween()');
            return oldTween(funk, tag, vars, {zoom: val}, dur, ease);
        });

        Lua_helper.add_callback(funk.lua, "getPropertyFromClass", function(classVar:String, variable:String) {
            var myClass = Type.resolveClass(classVar);
            if (myClass == null) myClass = Type.resolveClass('backend.' + classVar);
            if (myClass == null && debug) warnOnce(funk, 'getPropertyFromClass_' + classVar, 'Class "' + classVar + '" not found, using fallback');
            return myClass != null ? Reflect.getProperty(myClass, variable) : null;
        });

        Lua_helper.add_callback(funk.lua, "setPropertyFromClass", function(classVar:String, variable:String, value:Dynamic) {
            var myClass = Type.resolveClass(classVar);
            if (myClass == null) myClass = Type.resolveClass('backend.' + classVar);
            if (myClass != null) Reflect.setProperty(myClass, variable, value);
            return value;
        });

        #if FLX_PITCH
        Lua_helper.add_callback(funk.lua, "getSoundPitch", function(tag:String) {
            if (tag != null && tag.length > 0 && PlayState.instance.modchartSounds.exists(tag)) {
                return PlayState.instance.modchartSounds.get(tag).pitch;
            }
            return 1;
        });

        Lua_helper.add_callback(funk.lua, "setSoundPitch", function(tag:String, value:Float, doPause:Bool = false) {
            if (tag != null && tag.length > 0 && PlayState.instance.modchartSounds.exists(tag)) {
                var snd = PlayState.instance.modchartSounds.get(tag);
                if (snd != null) {
                    var wasResumed = snd.playing;
                    if (doPause) snd.pause();
                    snd.pitch = value;
                    if (doPause && wasResumed) snd.play();
                }
            }
        });
        #end

        #if (MODS_ALLOWED && !flash && sys)
        Lua_helper.add_callback(funk.lua, "initLuaShader", function(name:String, ?glslVersion:Int = 120) {
            if (!ClientPrefs.data.shaders) return false;
            return funk.initLuaShader(name);
        });
        #end

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
