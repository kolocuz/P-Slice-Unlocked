package psychlua;

#if LUA_ALLOWED
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
                    return; // Уже существует - пропускаем
                }
            }
            funk.set(name, value);
        }

        // ===== BACKEND (используем полные имена) =====
        safeSet('Achievements', backend.Achievements);
        safeSet('BaseStage', backend.BaseStage);
        safeSet('CacheSystem', backend.CacheSystem);
        safeSet('ClientPrefs', backend.ClientPrefs);
        safeSet('Conductor', backend.Conductor);
        safeSet('Controls', backend.Controls);
        safeSet('CoolUtil', backend.CoolUtil);
        safeSet('CrashHandler', backend.CrashHandler);
        safeSet('CustomFadeTransition', backend.CustomFadeTransition);
        safeSet('Difficulty', backend.Difficulty);
        safeSet('Highscore', backend.Highscore);
        safeSet('InputFormatter', backend.InputFormatter);
        safeSet('Language', backend.Language);
        safeSet('Mods', backend.Mods);
        safeSet('MusicBeatState', backend.MusicBeatState);
        safeSet('MusicBeatSubstate', backend.MusicBeatSubstate);
        safeSet('NoteTypesConfig', backend.NoteTypesConfig);
        safeSet('Paths', backend.Paths);
        safeSet('PsychCamera', backend.PsychCamera);
        safeSet('Rating', backend.Rating);
        safeSet('Song', backend.Song);
        safeSet('StageData', backend.StageData);
        safeSet('WeekData', backend.WeekData);

        // ===== BACKEND.UI =====
        safeSet('PsychUIBox', backend.ui.PsychUIBox);
        safeSet('PsychUIButton', backend.ui.PsychUIButton);
        safeSet('PsychUICheckBox', backend.ui.PsychUICheckBox);
        safeSet('PsychUIDropDownMenu', backend.ui.PsychUIDropDownMenu);
        safeSet('PsychUIEventHandler', backend.ui.PsychUIEventHandler);
        safeSet('PsychUIInputText', backend.ui.PsychUIInputText);
        safeSet('PsychUINumericStepper', backend.ui.PsychUINumericStepper);
        safeSet('PsychUIRadioGroup', backend.ui.PsychUIRadioGroup);
        safeSet('PsychUISlider', backend.ui.PsychUISlider);
        safeSet('PsychUITab', backend.ui.PsychUITab);

        // ===== OBJECTS =====
        safeSet('AchievementPopup', objects.AchievementPopup);
        safeSet('Alphabet', objects.Alphabet);
        safeSet('AlphabetMenu', objects.AlphabetMenu);
        safeSet('AttachedSprite', objects.AttachedSprite);
        safeSet('AttachedText', objects.AttachedText);
        safeSet('Bar', objects.Bar);
        safeSet('BGSprite', objects.BGSprite);
        safeSet('Character', objects.Character);
        safeSet('CheckboxThingie', objects.CheckboxThingie);
        safeSet('HealthIcon', objects.HealthIcon);
        safeSet('MenuCharacter', objects.MenuCharacter);
        safeSet('MenuItem', objects.MenuItem);
        safeSet('Note', objects.Note);
        safeSet('NoteSplash', objects.NoteSplash);
        safeSet('StrumNote', objects.StrumNote);
        safeSet('SustainSplash', objects.SustainSplash);
        safeSet('TypedAlphabet', objects.TypedAlphabet);
        safeSet('VideoSprite', objects.VideoSprite);

        // ===== STATES =====
        safeSet('PlayState', states.PlayState);
        safeSet('InitState', states.InitState);
        safeSet('LoadingState', states.LoadingState);
        safeSet('FreeplayState', states.FreeplayState);
        safeSet('CreditsState', states.CreditsState);
        safeSet('ModsMenuState', states.ModsMenuState);
        safeSet('AchievementsMenuState', states.AchievementsMenuState);

        // ===== SUBSTATES =====
        safeSet('GameOverSubstate', substates.GameOverSubstate);
        safeSet('PauseSubState', substates.PauseSubState);
        safeSet('ResetScoreSubState', substates.ResetScoreSubState);

        // ===== OPTIONS =====
        safeSet('OptionsState', options.OptionsState);
        safeSet('Option', options.Option);
        safeSet('BaseOptionsMenu', options.BaseOptionsMenu);
        safeSet('ControlsSubState', options.ControlsSubState);
        safeSet('GameplayChangersSubstate', options.GameplayChangersSubstate);
        safeSet('GameplaySettingsSubState', options.GameplaySettingsSubState);
        safeSet('GraphicsSettingsSubState', options.GraphicsSettingsSubState);
        safeSet('LanguageSubState', options.LanguageSubState);
        safeSet('ModSettingsSubState', options.ModSettingsSubState);
        safeSet('NoteOffsetState', options.NoteOffsetState);
        safeSet('NotesColorSubState', options.NotesColorSubState);
        safeSet('NotesSubState', options.NotesSubState);
        safeSet('VisualsSettingsSubState', options.VisualsSettingsSubState);

        // ===== SHADERS =====
        safeSet('ColorSwap', shaders.ColorSwap);
        safeSet('Grayscale', shaders.Grayscale);
        safeSet('HSVShader', shaders.HSVShader);
        safeSet('WiggleEffect', shaders.WiggleEffect);
        safeSet('AdjustColorShader', shaders.AdjustColorShader);
        safeSet('RainShader', shaders.RainShader);
        safeSet('RGBPalette', shaders.RGBPalette);
        safeSet('GaussianBlurShader', shaders.GaussianBlurShader);

        // ===== FLIXEL =====
        safeSet('FlxG', flixel.FlxG);
        safeSet('FlxSprite', flixel.FlxSprite);
        safeSet('FlxText', flixel.text.FlxText);
        safeSet('FlxTimer', flixel.util.FlxTimer);
        safeSet('FlxTween', flixel.tweens.FlxTween);
        safeSet('FlxEase', flixel.tweens.FlxEase);
        safeSet('FlxSound', flixel.sound.FlxSound);
        safeSet('FlxCamera', flixel.FlxCamera);
        safeSet('FlxMath', flixel.math.FlxMath);
        safeSet('FlxObject', flixel.FlxObject);
        safeSet('FlxBasic', flixel.FlxBasic);
        safeSet('FlxState', flixel.FlxState);
        safeSet('FlxSubState', flixel.FlxSubState);
        safeSet('FlxGame', flixel.FlxGame);
        safeSet('FlxSave', flixel.util.FlxSave);
        safeSet('FlxDestroyUtil', flixel.util.FlxDestroyUtil);
        safeSet('FlxStringUtil', flixel.util.FlxStringUtil);
        safeSet('FlxPoint', flixel.math.FlxPoint);
        safeSet('FlxRect', flixel.math.FlxRect);
        safeSet('FlxAngle', flixel.math.FlxAngle);
        safeSet('FlxVelocity', flixel.math.FlxVelocity);
        safeSet('FlxRandom', flixel.math.FlxRandom);
        safeSet('FlxGroup', flixel.group.FlxGroup);
        safeSet('FlxSpriteGroup', flixel.group.FlxSpriteGroup);
        safeSet('FlxBar', flixel.ui.FlxBar);
        safeSet('FlxAnimationController', flixel.animation.FlxAnimationController);

        // ===== OPENFL =====
        safeSet('Lib', openfl.Lib);
        safeSet('Assets', openfl.utils.Assets);
        safeSet('Application', openfl.display.Application);

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
        safeSet('CutsceneHandler', cutscenes.CutsceneHandler);

        // ===== DEBUG =====
        safeSet('FPSCounter', debug.FPSCounter);

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
