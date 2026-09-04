package psychlua;

#if LUA_ALLOWED
import backend.*;
import backend.animation.PsychAnimationController;
import backend.ui.*;
import objects.*;
import states.*;
import substates.*;
import options.*;
import shaders.*;
import cutscenes.CutsceneHandler;
import debug.FPSCounter;
import flixel.*;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Lib;
import openfl.utils.Assets;
import openfl.display.Application;

class GlobalRegistry
{
    public static function implement(funk:FunkinLua)
    {
        // ===== BACKEND =====
        funk.set('backend', backend);
        funk.set('Achievements', Achievements);
        funk.set('BaseStage', BaseStage);
        funk.set('CacheSystem', CacheSystem);
        funk.set('ClientPrefs', ClientPrefs);
        funk.set('Conductor', Conductor);
        funk.set('Controls', Controls);
        funk.set('CoolUtil', CoolUtil);
        funk.set('CrashHandler', CrashHandler);
        funk.set('CustomFadeTransition', CustomFadeTransition);
        funk.set('Difficulty', Difficulty);
        funk.set('Discord', Discord);
        funk.set('Highscore', Highscore);
        funk.set('InputFormatter', InputFormatter);
        funk.set('Language', Language);
        funk.set('Mods', Mods);
        funk.set('MusicBeatState', MusicBeatState);
        funk.set('MusicBeatSubstate', MusicBeatSubstate);
        funk.set('NoteTypesConfig', NoteTypesConfig);
        funk.set('Paths', Paths);
        funk.set('PsychCamera', PsychCamera);
        funk.set('Rating', Rating);
        funk.set('Song', Song);
        funk.set('StageData', StageData);
        funk.set('WeekData', WeekData);

        // ===== BACKEND.UI =====
        funk.set('ui', backend.ui);
        funk.set('PsychUIBox', backend.ui.PsychUIBox);
        funk.set('PsychUIButton', backend.ui.PsychUIButton);
        funk.set('PsychUICheckBox', backend.ui.PsychUICheckBox);
        funk.set('PsychUIDropDownMenu', backend.ui.PsychUIDropDownMenu);
        funk.set('PsychUIEventHandler', backend.ui.PsychUIEventHandler);
        funk.set('PsychUIInputText', backend.ui.PsychUIInputText);
        funk.set('PsychUINumericStepper', backend.ui.PsychUINumericStepper);
        funk.set('PsychUIRadioGroup', backend.ui.PsychUIRadioGroup);
        funk.set('PsychUISlider', backend.ui.PsychUISlider);
        funk.set('PsychUITab', backend.ui.PsychUITab);

        // ===== OBJECTS =====
        funk.set('objects', objects);
        funk.set('AchievementPopup', objects.AchievementPopup);
        funk.set('Alphabet', objects.Alphabet);
        funk.set('AlphabetMenu', objects.AlphabetMenu);
        funk.set('AttachedSprite', objects.AttachedSprite);
        funk.set('AttachedText', objects.AttachedText);
        funk.set('Bar', objects.Bar);
        funk.set('BGSprite', objects.BGSprite);
        funk.set('Character', objects.Character);
        funk.set('CheckboxThingie', objects.CheckboxThingie);
        funk.set('HealthIcon', objects.HealthIcon);
        funk.set('MenuCharacter', objects.MenuCharacter);
        funk.set('MenuItem', objects.MenuItem);
        funk.set('Note', objects.Note);
        funk.set('NoteSplash', objects.NoteSplash);
        funk.set('StrumNote', objects.StrumNote);
        funk.set('SustainSplash', objects.SustainSplash);
        funk.set('TypedAlphabet', objects.TypedAlphabet);
        funk.set('VideoSprite', objects.VideoSprite);

        // ===== STATES =====
        funk.set('states', states);
        funk.set('PlayState', states.PlayState);
        funk.set('InitState', states.InitState);
        funk.set('LoadingState', states.LoadingState);
        funk.set('FreeplayState', states.FreeplayState);
        funk.set('CreditsState', states.CreditsState);
        funk.set('ModsMenuState', states.ModsMenuState);
        funk.set('AchievementsMenuState', states.AchievementsMenuState);

        // ===== SUBSTATES =====
        funk.set('substates', substates);
        funk.set('GameOverSubstate', substates.GameOverSubstate);
        funk.set('PauseSubState', substates.PauseSubState);
        funk.set('ResetScoreSubState', substates.ResetScoreSubState);

        // ===== OPTIONS =====
        funk.set('options', options);
        funk.set('OptionsState', options.OptionsState);
        funk.set('Option', options.Option);
        funk.set('BaseOptionsMenu', options.BaseOptionsMenu);
        funk.set('ControlsSubState', options.ControlsSubState);
        funk.set('GameplayChangersSubstate', options.GameplayChangersSubstate);
        funk.set('GameplaySettingsSubState', options.GameplaySettingsSubState);
        funk.set('GraphicsSettingsSubState', options.GraphicsSettingsSubState);
        funk.set('LanguageSubState', options.LanguageSubState);
        funk.set('ModSettingsSubState', options.ModSettingsSubState);
        funk.set('NoteOffsetState', options.NoteOffsetState);
        funk.set('NotesColorSubState', options.NotesColorSubState);
        funk.set('NotesSubState', options.NotesSubState);
        funk.set('VisualsSettingsSubState', options.VisualsSettingsSubState);

        // ===== SHADERS =====
        funk.set('shaders', shaders);
        funk.set('ColorSwap', shaders.ColorSwap);
        funk.set('Grayscale', shaders.Grayscale);
        funk.set('HSVShader', shaders.HSVShader);
        funk.set('WiggleEffect', shaders.WiggleEffect);
        funk.set('WiggleEffectRuntime', shaders.WiggleEffectRuntime);
        funk.set('AdjustColorShader', shaders.AdjustColorShader);
        funk.set('RainShader', shaders.RainShader);
        funk.set('RGBPalette', shaders.RGBPalette);
        funk.set('GaussianBlurShader', shaders.GaussianBlurShader);

        // ===== FLIXEL =====
        funk.set('flixel', flixel);
        funk.set('FlxG', flixel.FlxG);
        funk.set('FlxSprite', flixel.FlxSprite);
        funk.set('FlxText', flixel.text.FlxText);
        funk.set('FlxTimer', flixel.util.FlxTimer);
        funk.set('FlxTween', flixel.tweens.FlxTween);
        funk.set('FlxEase', flixel.tweens.FlxEase);
        funk.set('FlxSound', flixel.sound.FlxSound);
        funk.set('FlxCamera', flixel.FlxCamera);
        funk.set('FlxMath', flixel.math.FlxMath);
        funk.set('FlxObject', flixel.FlxObject);
        funk.set('FlxBasic', flixel.FlxBasic);
        funk.set('FlxState', flixel.FlxState);
        funk.set('FlxSubState', flixel.FlxSubState);
        funk.set('FlxGame', flixel.FlxGame);
        funk.set('FlxSave', flixel.util.FlxSave);
        funk.set('FlxDestroyUtil', flixel.util.FlxDestroyUtil);
        funk.set('FlxStringUtil', flixel.util.FlxStringUtil);
        funk.set('FlxPoint', flixel.math.FlxPoint);
        funk.set('FlxRect', flixel.math.FlxRect);
        funk.set('FlxAngle', flixel.math.FlxAngle);
        funk.set('FlxVelocity', flixel.math.FlxVelocity);
        funk.set('FlxRandom', flixel.math.FlxRandom);
        funk.set('FlxGroup', flixel.group.FlxGroup);
        funk.set('FlxSpriteGroup', flixel.group.FlxSpriteGroup);
        funk.set('FlxBar', flixel.ui.FlxBar);
        funk.set('FlxAnimationController', flixel.animation.FlxAnimationController);

        // ===== OPENFL =====
        funk.set('openfl', openfl);
        funk.set('Lib', openfl.Lib);
        funk.set('Assets', openfl.utils.Assets);
        funk.set('Application', openfl.display.Application);

        // ===== HAXE =====
        funk.set('haxe', haxe);
        funk.set('Type', Type);
        funk.set('Reflect', Reflect);
        funk.set('Math', Math);
        funk.set('Std', Std);
        funk.set('Json', haxe.Json);
        funk.set('StringTools', StringTools);
        funk.set('EReg', EReg);
        funk.set('Lambda', Lambda);
        funk.set('StringBuf', StringBuf);

        // ===== CUTSCENES =====
        funk.set('cutscenes', cutscenes);
        funk.set('CutsceneHandler', cutscenes.CutsceneHandler);

        // ===== DEBUG =====
        funk.set('debug', debug);
        funk.set('FPSCounter', debug.FPSCounter);

        // ===== PSYCHLUA =====
        funk.set('psychlua', psychlua);
        funk.set('FunkinLua', FunkinLua);
        funk.set('HScript', HScript);
        funk.set('LuaUtils', LuaUtils);
        funk.set('CustomSubstate', CustomSubstate);
        funk.set('ModchartSprite', ModchartSprite);
        funk.set('ModchartAnimateSprite', ModchartAnimateSprite);
        funk.set('DebugLuaText', DebugLuaText);
    }
}
#end
