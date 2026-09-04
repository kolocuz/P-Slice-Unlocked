package psychlua;

#if LUA_ALLOWED
import backend.Achievements;
import backend.BaseStage;
import backend.CacheSystem;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Controls;
import backend.CoolUtil;
import backend.CrashHandler;
import backend.CustomFadeTransition;
import backend.Difficulty;
import backend.Highscore;
import backend.InputFormatter;
import backend.Language;
import backend.Mods;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.NoteTypesConfig;
import backend.Paths;
import backend.PsychCamera;
import backend.Rating;
import backend.Song;
import backend.StageData;
import backend.WeekData;

import backend.ui.PsychUIBox;
import backend.ui.PsychUIButton;
import backend.ui.PsychUICheckBox;
import backend.ui.PsychUIDropDownMenu;
import backend.ui.PsychUIEventHandler;
import backend.ui.PsychUIInputText;
import backend.ui.PsychUINumericStepper;
import backend.ui.PsychUIRadioGroup;
import backend.ui.PsychUISlider;
import backend.ui.PsychUITab;

import objects.AchievementPopup;
import objects.Alphabet;
import objects.AlphabetMenu;
import objects.AttachedSprite;
import objects.AttachedText;
import objects.Bar;
import objects.BGSprite;
import objects.Character;
import objects.CheckboxThingie;
import objects.HealthIcon;
import objects.MenuCharacter;
import objects.MenuItem;
import objects.Note;
import objects.NoteSplash;
import objects.StrumNote;
import objects.SustainSplash;
import objects.TypedAlphabet;
import objects.VideoSprite;

import states.PlayState;
import states.InitState;
import states.LoadingState;
import states.FreeplayState;
import states.CreditsState;
import states.ModsMenuState;
import states.AchievementsMenuState;

import substates.GameOverSubstate;
import substates.PauseSubState;
import substates.ResetScoreSubState;

import options.OptionsState;
import options.Option;
import options.BaseOptionsMenu;
import options.ControlsSubState;
import options.GameplayChangersSubstate;
import options.GameplaySettingsSubState;
import options.GraphicsSettingsSubState;
import options.LanguageSubState;
import options.ModSettingsSubState;
import options.NoteOffsetState;
import options.NotesColorSubState;
import options.NotesSubState;
import options.VisualsSettingsSubState;

import shaders.ColorSwap;
import shaders.Grayscale;
import shaders.HSVShader;
import shaders.WiggleEffect;
import shaders.AdjustColorShader;
import shaders.RainShader;
import shaders.RGBPalette;
import shaders.GaussianBlurShader;

import cutscenes.CutsceneHandler;
import debug.FPSCounter;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxBasic;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxGame;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxAngle;
import flixel.math.FlxVelocity;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.ui.FlxBar;
import flixel.animation.FlxAnimationController;

import openfl.Lib;
import openfl.utils.Assets;
import openfl.display.Application;

class GlobalRegistry
{
    public static function implement(funk:FunkinLua)
    {
        // Функция для безопасной регистрации (не перезаписывает существующие)
        function safeSet(name:String, value:Dynamic) {
            if (funk.lua != null) {
                Lua.getglobal(funk.lua, name);
                var type = Lua.type(funk.lua, -1);
                Lua.pop(funk.lua, 1);
                
                if (type != Lua.LUA_TNIL) {
                    // Уже существует - пропускаем
                    return;
                }
            }
            funk.set(name, value);
        }

        // ===== BACKEND (только те, что не зарегистрированы) =====
        safeSet('Achievements', Achievements);
        safeSet('BaseStage', BaseStage);
        safeSet('CacheSystem', CacheSystem);
        safeSet('ClientPrefs', ClientPrefs);
        safeSet('Conductor', Conductor);
        safeSet('Controls', Controls);
        safeSet('CoolUtil', CoolUtil);
        safeSet('CrashHandler', CrashHandler);
        safeSet('CustomFadeTransition', CustomFadeTransition);
        safeSet('Difficulty', Difficulty);
        safeSet('Highscore', Highscore);
        safeSet('InputFormatter', InputFormatter);
        safeSet('Language', Language);
        safeSet('Mods', Mods);
        safeSet('MusicBeatState', MusicBeatState);
        safeSet('MusicBeatSubstate', MusicBeatSubstate);
        safeSet('NoteTypesConfig', NoteTypesConfig);
        safeSet('Paths', Paths);
        safeSet('PsychCamera', PsychCamera);
        safeSet('Rating', Rating);
        safeSet('Song', Song);
        safeSet('StageData', StageData);
        safeSet('WeekData', WeekData);

        // ===== BACKEND.UI =====
        safeSet('PsychUIBox', PsychUIBox);
        safeSet('PsychUIButton', PsychUIButton);
        safeSet('PsychUICheckBox', PsychUICheckBox);
        safeSet('PsychUIDropDownMenu', PsychUIDropDownMenu);
        safeSet('PsychUIEventHandler', PsychUIEventHandler);
        safeSet('PsychUIInputText', PsychUIInputText);
        safeSet('PsychUINumericStepper', PsychUINumericStepper);
        safeSet('PsychUIRadioGroup', PsychUIRadioGroup);
        safeSet('PsychUISlider', PsychUISlider);
        safeSet('PsychUITab', PsychUITab);

        // ===== OBJECTS =====
        safeSet('AchievementPopup', AchievementPopup);
        safeSet('Alphabet', Alphabet);
        safeSet('AlphabetMenu', AlphabetMenu);
        safeSet('AttachedSprite', AttachedSprite);
        safeSet('AttachedText', AttachedText);
        safeSet('Bar', Bar);
        safeSet('BGSprite', BGSprite);
        safeSet('Character', Character);
        safeSet('CheckboxThingie', CheckboxThingie);
        safeSet('HealthIcon', HealthIcon);
        safeSet('MenuCharacter', MenuCharacter);
        safeSet('MenuItem', MenuItem);
        safeSet('Note', Note);
        safeSet('NoteSplash', NoteSplash);
        safeSet('StrumNote', StrumNote);
        safeSet('SustainSplash', SustainSplash);
        safeSet('TypedAlphabet', TypedAlphabet);
        safeSet('VideoSprite', VideoSprite);

        // ===== STATES =====
        safeSet('PlayState', PlayState);
        safeSet('InitState', InitState);
        safeSet('LoadingState', LoadingState);
        safeSet('FreeplayState', FreeplayState);
        safeSet('CreditsState', CreditsState);
        safeSet('ModsMenuState', ModsMenuState);
        safeSet('AchievementsMenuState', AchievementsMenuState);

        // ===== SUBSTATES =====
        safeSet('GameOverSubstate', GameOverSubstate);
        safeSet('PauseSubState', PauseSubState);
        safeSet('ResetScoreSubState', ResetScoreSubState);

        // ===== OPTIONS =====
        safeSet('OptionsState', OptionsState);
        safeSet('Option', Option);
        safeSet('BaseOptionsMenu', BaseOptionsMenu);
        safeSet('ControlsSubState', ControlsSubState);
        safeSet('GameplayChangersSubstate', GameplayChangersSubstate);
        safeSet('GameplaySettingsSubState', GameplaySettingsSubState);
        safeSet('GraphicsSettingsSubState', GraphicsSettingsSubState);
        safeSet('LanguageSubState', LanguageSubState);
        safeSet('ModSettingsSubState', ModSettingsSubState);
        safeSet('NoteOffsetState', NoteOffsetState);
        safeSet('NotesColorSubState', NotesColorSubState);
        safeSet('NotesSubState', NotesSubState);
        safeSet('VisualsSettingsSubState', VisualsSettingsSubState);

        // ===== SHADERS =====
        safeSet('ColorSwap', ColorSwap);
        safeSet('Grayscale', Grayscale);
        safeSet('HSVShader', HSVShader);
        safeSet('WiggleEffect', WiggleEffect);
        safeSet('AdjustColorShader', AdjustColorShader);
        safeSet('RainShader', RainShader);
        safeSet('RGBPalette', RGBPalette);
        safeSet('GaussianBlurShader', GaussianBlurShader);

        // ===== FLIXEL =====
        safeSet('FlxG', FlxG);
        safeSet('FlxSprite', FlxSprite);
        safeSet('FlxText', FlxText);
        safeSet('FlxTimer', FlxTimer);
        safeSet('FlxTween', FlxTween);
        safeSet('FlxEase', FlxEase);
        safeSet('FlxSound', FlxSound);
        safeSet('FlxCamera', FlxCamera);
        safeSet('FlxMath', FlxMath);
        safeSet('FlxObject', FlxObject);
        safeSet('FlxBasic', FlxBasic);
        safeSet('FlxState', FlxState);
        safeSet('FlxSubState', FlxSubState);
        safeSet('FlxGame', FlxGame);
        safeSet('FlxSave', FlxSave);
        safeSet('FlxDestroyUtil', FlxDestroyUtil);
        safeSet('FlxStringUtil', FlxStringUtil);
        safeSet('FlxPoint', FlxPoint);
        safeSet('FlxRect', FlxRect);
        safeSet('FlxAngle', FlxAngle);
        safeSet('FlxVelocity', FlxVelocity);
        safeSet('FlxRandom', FlxRandom);
        safeSet('FlxGroup', FlxGroup);
        safeSet('FlxSpriteGroup', FlxSpriteGroup);
        safeSet('FlxBar', FlxBar);
        safeSet('FlxAnimationController', FlxAnimationController);

        // ===== OPENFL =====
        safeSet('Lib', Lib);
        safeSet('Assets', Assets);
        safeSet('Application', Application);

        // ===== HAXE =====
        safeSet('Type', Type);
        safeSet('Reflect', Reflect);
        safeSet('Math', Math);
        safeSet('Std', Std);
        safeSet('Json', haxe.Json);
        safeSet('StringTools', StringTools);
        safeSet('EReg', EReg);
        safeSet('Lambda', Lambda);
        safeSet('StringBuf', StringBuf);

        // ===== CUTSCENES =====
        safeSet('CutsceneHandler', CutsceneHandler);

        // ===== DEBUG =====
        safeSet('FPSCounter', FPSCounter);

        // ===== PSYCHLUA =====
        safeSet('FunkinLua', FunkinLua);
        safeSet('HScript', HScript);
        safeSet('LuaUtils', LuaUtils);
        safeSet('CustomSubstate', CustomSubstate);
        safeSet('ModchartSprite', ModchartSprite);
        safeSet('ModchartAnimateSprite', ModchartAnimateSprite);
        safeSet('DebugLuaText', DebugLuaText);
    }
}
#end
