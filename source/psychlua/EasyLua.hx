package psychlua;

#if LUA_ALLOWED

class EasyLua
{
    public static function implement(funk:FunkinLua)
    {
        // ---- backend ----
        funk.set('ClientPrefs', backend.ClientPrefs);
        funk.set('Conductor', backend.Conductor);
        funk.set('Song', backend.Song);
        funk.set('Paths', Paths);
        funk.set('CoolUtil', backend.CoolUtil);
        funk.set('Difficulty', backend.Difficulty);
        funk.set('Highscore', backend.Highscore);
        funk.set('WeekData', backend.WeekData);
        funk.set('Mods', backend.Mods);
        funk.set('CacheSystem', backend.CacheSystem);
        funk.set('Controls', backend.Controls);
        funk.set('MusicBeatState', backend.MusicBeatState);
        funk.set('MusicBeatSubstate', backend.MusicBeatSubstate);
        funk.set('PsychCamera', backend.PsychCamera);

        // ---- states ----
        funk.set('PlayState', states.PlayState);
        funk.set('MainMenuState', mikolka.vslice.ui.MainMenuState);
        funk.set('StoryMenuState', mikolka.vslice.ui.StoryMenuState);
        funk.set('FreeplayState', mikolka.vslice.freeplay.FreeplayState);
        funk.set('CreditsState', states.CreditsState);
        funk.set('LoadingState', states.LoadingState);

        // ---- substates ----
        funk.set('GameOverSubstate', substates.GameOverSubstate);
        funk.set('PauseSubState', substates.PauseSubState);

        // ---- objects ----
        funk.set('Character', objects.Character);
        funk.set('Note', objects.Note);
        funk.set('Alphabet', objects.Alphabet);
        funk.set('StrumNote', objects.StrumNote);
        funk.set('HealthIcon', objects.HealthIcon);
        funk.set('NoteSplash', objects.NoteSplash);

        // ---- flixel ----
        funk.set('FlxG', flixel.FlxG);
        funk.set('FlxMath', flixel.math.FlxMath);
        funk.set('FlxSprite', flixel.FlxSprite);
        funk.set('FlxText', flixel.text.FlxText);
        funk.set('FlxCamera', flixel.FlxCamera);
        funk.set('FlxTimer', flixel.util.FlxTimer);
        funk.set('FlxTween', flixel.tweens.FlxTween);
        funk.set('FlxEase', flixel.tweens.FlxEase);
        funk.set('FlxSound', flixel.sound.FlxSound);

        // ---- openfl ----
        funk.set('Lib', openfl.Lib);
        funk.set('Assets', openfl.utils.Assets);

        // ---- haxe ----
        funk.set('Type', Type);
        funk.set('Reflect', Reflect);
        funk.set('Math', Math);
        funk.set('Std', Std);
        funk.set('Json', haxe.Json);
        funk.set('StringTools', StringTools);

        // ---- misc ----
        funk.set('FlxTransitionableState', flixel.addons.transition.FlxTransitionableState);
    }
}
#end
