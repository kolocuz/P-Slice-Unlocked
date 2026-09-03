package psychlua;

#if LUA_ALLOWED
import backend.*;
import states.*;
import objects.*;
import substates.*;
import flixel.*;
import flixel.math.*;
import flixel.text.*;
import flixel.group.*;
import flixel.util.*;
import flixel.tweens.*;
import flixel.addons.transition.FlxTransitionableState;
import openfl.Lib;
import openfl.utils.Assets;
import openfl.display.BitmapData;
import openfl.filters.ShaderFilter;
import openfl.events.KeyboardEvent;

class EasyLua
{
    public static function implement(funk:FunkinLua)
    {
        // ---- backend ----
        funk.set('ClientPrefs', ClientPrefs);
        funk.set('Conductor', Conductor);
        funk.set('Song', Song);
        funk.set('Highscore', Highscore);
        funk.set('WeekData', WeekData);
        funk.set('StageData', StageData);
        funk.set('Mods', Mods);
        funk.set('Paths', Paths);
        funk.set('CoolUtil', CoolUtil);
        funk.set('Difficulty', Difficulty);
        funk.set('Rating', Rating);
        funk.set('NoteTypesConfig', NoteTypesConfig);
        funk.set('CacheSystem', CacheSystem);
        funk.set('Controls', Controls);
        funk.set('CustomFadeTransition', CustomFadeTransition);
        funk.set('MusicBeatState', MusicBeatState);
        funk.set('MusicBeatSubstate', MusicBeatSubstate);
        funk.set('PsychCamera', PsychCamera);
        funk.set('BaseStage', BaseStage);

        // ---- states ----
        funk.set('PlayState', PlayState);
        funk.set('MainMenuState', mikolka.vslice.ui.MainMenuState);
        funk.set('StoryMenuState', mikolka.vslice.ui.StoryMenuState);
        funk.set('FreeplayState', mikolka.vslice.freeplay.FreeplayState);
        funk.set('CreditsState', states.CreditsState);
        funk.set('LoadingState', states.LoadingState);
        funk.set('InitState', states.InitState);
        funk.set('ModsMenuState', states.ModsMenuState);
        funk.set('AchievementsMenuState', states.AchievementsMenuState);

        // ---- substates ----
        funk.set('GameOverSubstate', substates.GameOverSubstate);
        funk.set('PauseSubState', substates.PauseSubState);
        funk.set('ResetScoreSubState', substates.ResetScoreSubState);

        // ---- objects ----
        funk.set('Character', Character);
        funk.set('Note', Note);
        funk.set('Alphabet', Alphabet);
        funk.set('StrumNote', StrumNote);
        funk.set('HealthIcon', HealthIcon);
        funk.set('NoteSplash', NoteSplash);
        funk.set('SustainSplash', SustainSplash);
        funk.set('Bar', Bar);
        funk.set('BGSprite', BGSprite);
        funk.set('AttachedSprite', AttachedSprite);
        funk.set('MenuItem', MenuItem);
        funk.set('MenuCharacter', MenuCharacter);
        funk.set('VideoSprite', VideoSprite);
        funk.set('CheckboxThingie', CheckboxThingie);
        funk.set('AlphabetMenu', AlphabetMenu);
        funk.set('TypedAlphabet', TypedAlphabet);

        // ---- psychlua ----
        funk.set('FunkinLua', psychlua.FunkinLua);
        funk.set('HScript', psychlua.HScript);
        funk.set('LuaUtils', psychlua.LuaUtils);
        funk.set('ModchartSprite', ModchartSprite);
        funk.set('ModchartAnimateSprite', ModchartAnimateSprite);
        funk.set('DebugLuaText', DebugLuaText);
        funk.set('CustomSubstate', CustomSubstate);
        funk.set('ReflectionFunctions', ReflectionFunctions);
        funk.set('ExtraFunctions', ExtraFunctions);
        funk.set('TextFunctions', TextFunctions);
        funk.set('ShaderFunctions', ShaderFunctions);
        funk.set('DeprecatedFunctions', DeprecatedFunctions);

        // ---- flixel ----
        funk.set('FlxG', FlxG);
        funk.set('FlxMath', FlxMath);
        funk.set('FlxSprite', FlxSprite);
        funk.set('FlxText', FlxText);
        funk.set('FlxCamera', FlxCamera);
        funk.set('FlxTimer', FlxTimer);
        funk.set('FlxTween', FlxTween);
        funk.set('FlxEase', FlxEase);
        funk.set('FlxColor', FlxColor);
        funk.set('FlxSound', FlxSound);
        funk.set('FlxSpriteGroup', FlxSpriteGroup);
        funk.set('FlxTypedGroup', FlxTypedGroup);
        funk.set('FlxState', FlxState);
        funk.set('FlxSubState', FlxSubState);
        funk.set('FlxObject', FlxObject);
        funk.set('FlxBasic', FlxBasic);
        funk.set('FlxPoint', FlxPoint);
        funk.set('FlxRect', FlxRect);
        funk.set('FlxAxes', FlxAxes);
        funk.set('FlxDestroyUtil', FlxDestroyUtil);
        funk.set('FlxStringUtil', FlxStringUtil);
        funk.set('FlxSave', FlxSave);
        funk.set('FlxTransitionableState', FlxTransitionableState);

        // ---- openfl ----
        funk.set('Lib', Lib);
        funk.set('Assets', Assets);
        funk.set('BitmapData', BitmapData);
        funk.set('ShaderFilter', ShaderFilter);
        funk.set('KeyboardEvent', KeyboardEvent);

        // ---- haxe ----
        funk.set('Type', Type);
        funk.set('Reflect', Reflect);
        funk.set('Math', Math);
        funk.set('Std', Std);
        funk.set('Json', haxe.Json);
        funk.set('StringTools', StringTools);
        funk.set('Lambda', Lambda);
        funk.set('EReg', EReg);
        funk.set('Date', Date);
        funk.set('Array', Array);
        funk.set('Map', Map);
        funk.set('StringMap', haxe.ds.StringMap);
        funk.set('IntMap', haxe.ds.IntMap);
        funk.set('ObjectMap', haxe.ds.ObjectMap);

        // ---- shaders ----
        funk.set('WiggleEffect', shaders.WiggleEffect);
        funk.set('ColorSwap', shaders.ColorSwap);
        funk.set('HSVShader', shaders.HSVShader);
        funk.set('GaussianBlurShader', shaders.GaussianBlurShader);
        funk.set('Grayscale', shaders.Grayscale);
        funk.set('MosaicEffect', shaders.MosaicEffect);
        funk.set('OverlayBlend', shaders.OverlayBlend);
        funk.set('RainShader', shaders.RainShader);
        funk.set('StrokeShader', shaders.StrokeShader);
        funk.set('VFDOverlay', shaders.VFDOverlay);
        funk.set('AngleMask', shaders.AngleMask);
        funk.set('BlueFade', shaders.BlueFade);
        funk.set('DropShadowShader', shaders.DropShadowShader);
        funk.set('PureColor', shaders.PureColor);
        funk.set('AdjustColorShader', shaders.AdjustColorShader);
        funk.set('BlendModeEffect', shaders.BlendModeEffect);
        funk.set('RGBPalette', shaders.RGBPalette);

        // ---- editors ----
        funk.set('ChartingState', states.editors.ChartingState);
        funk.set('CharacterEditorState', states.editors.CharacterEditorState);
        funk.set('MasterEditorMenu', states.editors.MasterEditorMenu);
        funk.set('StageEditorState', states.editors.StageEditorState);
        funk.set('WeekEditorState', states.editors.WeekEditorState);
        funk.set('NoteSplashEditorState', states.editors.NoteSplashEditorState);

        // ---- options ----
        funk.set('OptionsState', options.OptionsState);
        funk.set('BaseOptionsMenu', options.BaseOptionsMenu);
        funk.set('GameplayChangersSubstate', options.GameplayChangersSubstate);
        funk.set('ControlsSubState', options.ControlsSubState);
        funk.set('NotesColorSubState', options.NotesColorSubState);
        funk.set('NoteOffsetState', options.NoteOffsetState);
        funk.set('LanguageSubState', options.LanguageSubState);
        funk.set('ModSettingsSubState', options.ModSettingsSubState);
        funk.set('GraphicsSettingsSubState', options.GraphicsSettingsSubState);
        funk.set('VisualsSettingsSubState', options.VisualsSettingsSubState);
        funk.set('GameplaySettingsSubState', options.GameplaySettingsSubState);

        // ---- mikolka (только то, что точно есть) ----
        funk.set('DesktopMenuState', mikolka.vslice.ui.mainmenu.DesktopMenuState);
        funk.set('TitleState', mikolka.vslice.ui.title.TitleState);
        funk.set('StickerSubState', mikolka.vslice.StickerSubState);
        funk.set('ResultState', mikolka.vslice.results.ResultState);
        funk.set('Tallies', mikolka.vslice.results.Tallies);
        funk.set('VsliceOptions', mikolka.compatibility.VsliceOptions);
        funk.set('ModsHelper', mikolka.compatibility.ModsHelper);
        funk.set('GameBorder', mikolka.GameBorder);
        funk.set('FunkinPreloader', mikolka.vslice.FunkinPreloader);
        funk.set('FunkinSound', mikolka.funkin.FunkinSound);
        funk.set('FunkinSprite', mikolka.funkin.FunkinSprite);
        funk.set('FunkinTools', mikolka.funkin.utils.custom.FunkinTools);
        funk.set('PsychUITools', mikolka.funkin.utils.custom.PsychUITools);
        funk.set('Scoring', mikolka.funkin.Scoring);
        funk.set('EventLoader', mikolka.stages.EventLoader);
        funk.set('DialogueBoxPsych', mikolka.stages.cutscenes.dialogueBox.DialogueBoxPsych);
        funk.set('DialogueCharacter', mikolka.stages.cutscenes.dialogueBox.DialogueCharacter);
        funk.set('DialogueStyle', mikolka.stages.cutscenes.dialogueBox.styles.DialogueStyle);
        funk.set('PsychDialogueStyle', mikolka.stages.cutscenes.dialogueBox.styles.PsychDialogueStyle);
        funk.set('PixelDialogueStyle', mikolka.stages.cutscenes.dialogueBox.styles.PixelDialogueStyle);
        funk.set('DecayDialogueStyle', mikolka.stages.cutscenes.dialogueBox.styles.DecayDialogueStyle);

        // ---- mobile ----
        #if TOUCH_CONTROLS_ALLOWED
        funk.set('TouchPad', mobile.objects.TouchPad);
        funk.set('Hitbox', mobile.objects.Hitbox);
        funk.set('TouchButton', mobile.objects.TouchButton);
        funk.set('TouchZone', mobile.objects.TouchZone);
        funk.set('GridButtons', mobile.objects.GridButtons);
        funk.set('MobileData', mobile.backend.MobileData);
        funk.set('MobileScaleMode', mobile.backend.MobileScaleMode);
        funk.set('StorageUtil', mobile.backend.StorageUtil);
        funk.set('SwipeUtil', mobile.backend.SwipeUtil);
        funk.set('TouchUtil', mobile.backend.TouchUtil);
        funk.set('MobileInputID', mobile.input.MobileInputID);
        funk.set('MobileInputManager', mobile.input.MobileInputManager);
        #end

        // ---- misc ----
        funk.set('AchievementPopup', objects.AchievementPopup);
        funk.set('NativeFileSystem', mikolka.funkin.custom.NativeFileSystem);
        funk.set('Native', Native);
        funk.set('CrashHandler', CrashHandler);
        funk.set('InputFormatter', InputFormatter);
        funk.set('Language', Language);
        #if DISCORD_ALLOWED
        funk.set('DiscordClient', Discord.DiscordClient);
        #end
    }
}
#end
