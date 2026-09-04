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
import backend.Discord;
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
        // ===== BACKEND =====
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
        funk.set('PsychUIBox', PsychUIBox);
        funk.set('PsychUIButton', PsychUIButton);
        funk.set('PsychUICheckBox', PsychUICheckBox);
        funk.set('PsychUIDropDownMenu', PsychUIDropDownMenu);
        funk.set('PsychUIEventHandler', PsychUIEventHandler);
        funk.set('PsychUIInputText', PsychUIInputText);
        funk.set('PsychUINumericStepper', PsychUINumericStepper);
        funk.set('PsychUIRadioGroup', PsychUIRadioGroup);
        funk.set('PsychUISlider', PsychUISlider);
        funk.set('PsychUITab', PsychUITab);

        // ===== OBJECTS =====
        funk.set('AchievementPopup', AchievementPopup);
        funk.set('Alphabet', Alphabet);
        funk.set('AlphabetMenu', AlphabetMenu);
        funk.set('AttachedSprite', AttachedSprite);
        funk.set('AttachedText', AttachedText);
        funk.set('Bar', Bar);
        funk.set('BGSprite', BGSprite);
        funk.set('Character', Character);
        funk.set('CheckboxThingie', CheckboxThingie);
        funk.set('HealthIcon', HealthIcon);
        funk.set('MenuCharacter', MenuCharacter);
        funk.set('MenuItem', MenuItem);
        funk.set('Note', Note);
        funk.set('NoteSplash', NoteSplash);
        funk.set('StrumNote', StrumNote);
        funk.set('SustainSplash', SustainSplash);
        funk.set('TypedAlphabet', TypedAlphabet);
        funk.set('VideoSprite', VideoSprite);

        // ===== STATES =====
        funk.set('PlayState', PlayState);
        funk.set('InitState', InitState);
        funk.set('LoadingState', LoadingState);
        funk.set('FreeplayState', FreeplayState);
        funk.set('CreditsState', CreditsState);
        funk.set('ModsMenuState', ModsMenuState);
        funk.set('AchievementsMenuState', AchievementsMenuState);

        // ===== SUBSTATES =====
        funk.set('GameOverSubstate', GameOverSubstate);
        funk.set('PauseSubState', PauseSubState);
        funk.set('ResetScoreSubState', ResetScoreSubState);

        // ===== OPTIONS =====
        funk.set('OptionsState', OptionsState);
        funk.set('Option', Option);
        funk.set('BaseOptionsMenu', BaseOptionsMenu);
        funk.set('ControlsSubState', ControlsSubState);
        funk.set('GameplayChangersSubstate', GameplayChangersSubstate);
        funk.set('GameplaySettingsSubState', GameplaySettingsSubState);
        funk.set('GraphicsSettingsSubState', GraphicsSettingsSubState);
        funk.set('LanguageSubState', LanguageSubState);
        funk.set('ModSettingsSubState', ModSettingsSubState);
        funk.set('NoteOffsetState', NoteOffsetState);
        funk.set('NotesColorSubState', NotesColorSubState);
        funk.set('NotesSubState', NotesSubState);
        funk.set('VisualsSettingsSubState', VisualsSettingsSubState);

        // ===== SHADERS =====
        funk.set('ColorSwap', ColorSwap);
        funk.set('Grayscale', Grayscale);
        funk.set('HSVShader', HSVShader);
        funk.set('WiggleEffect', WiggleEffect);
        funk.set('AdjustColorShader', AdjustColorShader);
        funk.set('RainShader', RainShader);
        funk.set('RGBPalette', RGBPalette);
        funk.set('GaussianBlurShader', GaussianBlurShader);

        // ===== FLIXEL =====
        funk.set('FlxG', FlxG);
        funk.set('FlxSprite', FlxSprite);
        funk.set('FlxText', FlxText);
        funk.set('FlxTimer', FlxTimer);
        funk.set('FlxTween', FlxTween);
        funk.set('FlxEase', FlxEase);
        funk.set('FlxSound', FlxSound);
        funk.set('FlxCamera', FlxCamera);
        funk.set('FlxMath', FlxMath);
        funk.set('FlxObject', FlxObject);
        funk.set('FlxBasic', FlxBasic);
        funk.set('FlxState', FlxState);
        funk.set('FlxSubState', FlxSubState);
        funk.set('FlxGame', FlxGame);
        funk.set('FlxSave', FlxSave);
        funk.set('FlxDestroyUtil', FlxDestroyUtil);
        funk.set('FlxStringUtil', FlxStringUtil);
        funk.set('FlxPoint', FlxPoint);
        funk.set('FlxRect', FlxRect);
        funk.set('FlxAngle', FlxAngle);
        funk.set('FlxVelocity', FlxVelocity);
        funk.set('FlxRandom', FlxRandom);
        funk.set('FlxGroup', FlxGroup);
        funk.set('FlxSpriteGroup', FlxSpriteGroup);
        funk.set('FlxBar', FlxBar);
        funk.set('FlxAnimationController', FlxAnimationController);

        // ===== OPENFL =====
        funk.set('Lib', Lib);
        funk.set('Assets', Assets);
        funk.set('Application', Application);

        // ===== HAXE =====
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
        funk.set('CutsceneHandler', CutsceneHandler);

        // ===== DEBUG =====
        funk.set('FPSCounter', FPSCounter);

        // ===== PSYCHLUA =====
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
