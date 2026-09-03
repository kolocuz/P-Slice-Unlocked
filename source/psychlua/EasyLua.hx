package psychlua;

#if LUA_ALLOWED
class EasyLua
{
    public static function implement(funk:FunkinLua)
    {
        var lua = funk.lua;

        // ---- backend ----
        funk.set('ClientPrefs', backend.ClientPrefs);
        funk.set('Conductor', backend.Conductor);
        funk.set('Song', backend.Song);
        funk.set('Highscore', backend.Highscore);
        funk.set('WeekData', backend.WeekData);
        funk.set('StageData', backend.StageData);
        funk.set('Mods', backend.Mods);
        funk.set('Paths', Paths);
        funk.set('CoolUtil', backend.CoolUtil);
        funk.set('Difficulty', backend.Difficulty);
        funk.set('Rating', backend.Rating);
        funk.set('NoteTypesConfig', backend.NoteTypesConfig);
        funk.set('CacheSystem', backend.CacheSystem);
        funk.set('Controls', backend.Controls);
        funk.set('CustomFadeTransition', backend.CustomFadeTransition);
        funk.set('MusicBeatState', backend.MusicBeatState);
        funk.set('MusicBeatSubstate', backend.MusicBeatSubstate);
        funk.set('PsychCamera', backend.PsychCamera);

        // ---- states ----
        funk.set('PlayState', states.PlayState);
        funk.set('MainMenuState', states.MainMenuState);
        funk.set('StoryMenuState', states.StoryMenuState);
        funk.set('FreeplayState', states.FreeplayState);
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
        funk.set('Character', objects.Character);
        funk.set('Note', objects.Note);
        funk.set('Alphabet', objects.Alphabet);
        funk.set('StrumNote', objects.StrumNote);
        funk.set('HealthIcon', objects.HealthIcon);
        funk.set('NoteSplash', objects.NoteSplash);
        funk.set('SustainSplash', objects.SustainSplash);
        funk.set('Bar', objects.Bar);
        funk.set('BGSprite', objects.BGSprite);
        funk.set('AttachedSprite', objects.AttachedSprite);
        funk.set('MenuItem', objects.MenuItem);
        funk.set('MenuCharacter', objects.MenuCharacter);
        funk.set('VideoSprite', objects.VideoSprite);
        funk.set('CheckboxThingie', objects.CheckboxThingie);
        funk.set('AlphabetMenu', objects.AlphabetMenu);
        funk.set('TypedAlphabet', objects.TypedAlphabet);

        // ---- psychlua ----
        funk.set('FunkinLua', psychlua.FunkinLua);
        funk.set('HScript', psychlua.HScript);
        funk.set('LuaUtils', psychlua.LuaUtils);
        funk.set('ModchartSprite', psychlua.ModchartSprite);
        funk.set('ModchartAnimateSprite', psychlua.ModchartAnimateSprite);
        funk.set('DebugLuaText', psychlua.DebugLuaText);
        funk.set('CustomSubstate', psychlua.CustomSubstate);

        // ---- mikolka ----
        funk.set('DesktopMenuState', mikolka.vslice.ui.mainmenu.DesktopMenuState);
        funk.set('FreeplayState', mikolka.vslice.freeplay.FreeplayState);
        funk.set('TitleState', mikolka.vslice.ui.title.TitleState);
        funk.set('StoryMenuState', mikolka.vslice.ui.StoryMenuState);
        funk.set('StickerSubState', mikolka.vslice.StickerSubState);
        funk.set('ResultState', mikolka.vslice.results.ResultState);
        funk.set('Tallies', mikolka.vslice.results.Tallies);
        funk.set('VsliceOptions', mikolka.compatibility.VsliceOptions);
        funk.set('ModsHelper', mikolka.compatibility.ModsHelper);
        funk.set('GameBorder', mikolka.GameBorder);
        funk.set('FunkinPreloader', mikolka.vslice.FunkinPreloader);
        funk.set('FunkinSound', mikolka.funkin.FunkinSound);
        funk.set('FunkinSprite', mikolka.funkin.FunkinSprite);
        funk.set('FunkinText', mikolka.funkin.FunkinText);
        funk.set('FunkinCamera', mikolka.funkin.FunkinCamera);
        funk.set('FunkinControls', mikolka.funkin.FunkinControls);
        funk.set('FunkinTools', mikolka.funkin.utils.custom.FunkinTools);
        funk.set('PsychUITools', mikolka.funkin.utils.custom.PsychUITools);
        funk.set('Scoring', mikolka.funkin.Scoring);
        funk.set('PlayerData', mikolka.funkin.players.PlayerData);
        funk.set('PlayerStats', mikolka.funkin.players.PlayerStats);
        funk.set('PlayableCharacter', mikolka.funkin.players.PlayableCharacter);
        funk.set('CharacterData', mikolka.funkin.players.CharacterData);
        funk.set('CharacterLoader', mikolka.funkin.players.CharacterLoader);
        funk.set('Album', mikolka.funkin.freeplay.album.Album);
        funk.set('AlbumData', mikolka.funkin.freeplay.album.AlbumData);
        funk.set('AlbumRegistry', mikolka.funkin.freeplay.album.AlbumRegistry);
        funk.set('FreeplayStyle', mikolka.funkin.freeplay.FreeplayStyle);
        funk.set('FreeplayStyleData', mikolka.funkin.freeplay.FreeplayStyleData);
        funk.set('FreeplayStyleRegistry', mikolka.funkin.freeplay.FreeplayStyleRegistry);
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

        // ---- flixel ----
        funk.set('FlxG', flixel.FlxG);
        funk.set('FlxMath', flixel.math.FlxMath);
        funk.set('FlxSprite', flixel.FlxSprite);
        funk.set('FlxText', flixel.text.FlxText);
        funk.set('FlxCamera', flixel.FlxCamera);
        funk.set('FlxTimer', flixel.util.FlxTimer);
        funk.set('FlxTween', flixel.tweens.FlxTween);
        funk.set('FlxEase', flixel.tweens.FlxEase);
        funk.set('FlxColor', flixel.util.FlxColor);
        funk.set('FlxSound', flixel.sound.FlxSound);
        funk.set('FlxSpriteGroup', flixel.group.FlxSpriteGroup);
        funk.set('FlxTypedGroup', flixel.group.FlxTypedGroup);
        funk.set('FlxState', flixel.FlxState);
        funk.set('FlxSubState', flixel.FlxSubState);
        funk.set('FlxObject', flixel.FlxObject);
        funk.set('FlxBasic', flixel.FlxBasic);
        funk.set('FlxPoint', flixel.math.FlxPoint);
        funk.set('FlxRect', flixel.math.FlxRect);
        funk.set('FlxAxes', flixel.util.FlxAxes);
        funk.set('FlxDestroyUtil', flixel.util.FlxDestroyUtil);
        funk.set('FlxStringUtil', flixel.util.FlxStringUtil);
        funk.set('FlxSave', flixel.util.FlxSave);

        // ---- openfl ----
        funk.set('Lib', openfl.Lib);
        funk.set('Assets', openfl.utils.Assets);
        funk.set('BitmapData', openfl.display.BitmapData);
        funk.set('ShaderFilter', openfl.filters.ShaderFilter);
        funk.set('KeyboardEvent', openfl.events.KeyboardEvent);

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
        funk.set('RGBPalette', shaders.RGBPalette);
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

        // ---- editors ----
        funk.set('ChartingState', states.editors.ChartingState);
        funk.set('CharacterEditorState', states.editors.CharacterEditorState);
        funk.set('MasterEditorMenu', states.editors.MasterEditorMenu);
        funk.set('StageEditorState', states.editors.StageEditorState);
        funk.set('WeekEditorState', states.editors.WeekEditorState);
        funk.set('NoteSplashEditorState', states.editors.NoteSplashEditorState);
        funk.set('DialogueEditorState', states.editors.DialogueEditorState);
        funk.set('DialogueCharacterEditorState', states.editors.DialogueCharacterEditorState);
        funk.set('MenuCharacterEditorState', states.editors.MenuCharacterEditorState);
        funk.set('ResultPreviewMenu', states.editors.ResultPreviewMenu);

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
        funk.set('PSliceSubState', options.PSliceSubState);
        funk.set('VSliceSubState', options.VSliceSubState);

        // ---- misc ----
        funk.set('FlxTransitionableState', flixel.addons.transition.FlxTransitionableState);
        funk.set('LoadingState', states.LoadingState);
        funk.set('AchievementPopup', objects.AchievementPopup);
        funk.set('NativeFileSystem', mikolka.funkin.custom.NativeFileSystem);
        funk.set('Native', backend.Native);
        funk.set('CrashHandler', backend.CrashHandler);
        funk.set('InputFormatter', backend.InputFormatter);
        funk.set('Language', backend.Language);
        funk.set('DiscordClient', backend.Discord.DiscordClient);
    }
}
#end
