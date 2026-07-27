package backend;

import openfl.display.BitmapData;
import flixel.FlxState;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import flixel.addons.transition.FlxTransitionableState;
import backend.PsychCamera;
import backend.Paths;
import backend.Mods;
import backend.Controls;
import backend.Conductor;
import backend.ClientPrefs;
import backend.CoolUtil;
import backend.CustomFadeTransition;
import backend.BaseStage;
import mikolka.funkin.custom.NativeFileSystem;
#if LUA_ALLOWED
import psychlua.FunkinLua;
import psychlua.LuaUtils;
#end
#if HSCRIPT_ALLOWED
import psychlua.HScript;
#end
#if TOUCH_CONTROLS_ALLOWED
import mobile.objects.TouchPad;
import mobile.objects.Hitbox;
import mobile.backend.MobileData;
#end

@:bitmap("assets/embed/images/ui/cursor.png")
private class FunkinCursor extends BitmapData {}

class MusicBeatState extends FlxState
{
	private static var currentState:MusicBeatState;

	private var curSection:Int = 0;
	private var stepsToDo:Int = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	private var curDecStep:Float = 0;
	private var curDecBeat:Float = 0;
	public var controls(get, never):Controls;
	private function get_controls()
	{
		return Controls.instance;
	}

	#if LUA_ALLOWED
	public static var globalLuaScripts:Array<FunkinLua> = [];
	#end
	#if HSCRIPT_ALLOWED
	public static var globalHScripts:Array<HScript> = [];
	#end

	#if TOUCH_CONTROLS_ALLOWED
	public var touchPad:TouchPad;
	public var hitbox:Hitbox;
	public var camControls:FlxCamera;
	public var tpadCam:FlxCamera;

	public function addTouchPad(DPad:String, Action:String)
	{
		touchPad = new TouchPad(DPad, Action);
		add(touchPad);
	}

	public function removeTouchPad()
	{
		if (touchPad != null)
		{
			remove(touchPad);
			touchPad = FlxDestroyUtil.destroy(touchPad);
		}

		if(tpadCam != null)
		{
			FlxG.cameras.remove(tpadCam);
			tpadCam = FlxDestroyUtil.destroy(tpadCam);
		}
	}

	public function addHitbox(defaultDrawTarget:Bool = false):Void
	{
		var extraMode = MobileData.extraActions.get(ClientPrefs.data.extraHints);

		hitbox = new Hitbox(extraMode,MobileData.getButtonsColors());

		camControls = new FlxCamera();
		camControls.bgColor.alpha = 0;
		FlxG.cameras.add(camControls, defaultDrawTarget);

		hitbox.cameras = [camControls];
		hitbox.visible = false;
		add(hitbox);
	}

	public function removeHitbox()
	{
		if (hitbox != null)
		{
			remove(hitbox);
			hitbox = FlxDestroyUtil.destroy(hitbox);
			hitbox = null;
		}

		if(camControls != null)
		{
			FlxG.cameras.remove(camControls);
			camControls = FlxDestroyUtil.destroy(camControls);
		}
	}

	public function addTouchPadCamera(defaultDrawTarget:Bool = false):Void
	{
		if (touchPad != null)
		{
			tpadCam = new FlxCamera();
			tpadCam.bgColor.alpha = 0;
			FlxG.cameras.add(tpadCam, defaultDrawTarget);
			touchPad.cameras = [tpadCam];
		}
	}
	#end

	var _psychCameraInitialized:Bool = false;

	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public static function getVariables()
		return getState().variables;

	#if LUA_ALLOWED
	function loadGlobalScripts()
	{
		if (globalLuaScripts.length > 0) return;

		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'global_scripts/'))
		{
			#if linux
			for (file in CoolUtil.sortAlphabetically(NativeFileSystem.readDirectory(folder)))
			#else
			for (file in NativeFileSystem.readDirectory(folder))
			#end
			{
				if (file.toLowerCase().endsWith('.lua'))
				{
					try
					{
						var script = new FunkinLua(folder + file);
						globalLuaScripts.push(script);
						script.set('stateName', Type.getClassName(Type.getClass(this)));
						trace('Global Lua loaded: $folder$file');
					}
					catch (e:Dynamic)
					{
						trace('Error loading global script $file: $e');
					}
				}
				
				#if HSCRIPT_ALLOWED
				if (file.toLowerCase().endsWith('.hx'))
				{
					try
					{
						var script = new HScript(null, folder + file);
						globalHScripts.push(script);
						if (script.exists('onCreate'))
							script.call('onCreate');
						trace('Global HScript loaded: $folder$file');
					}
					catch (e:Dynamic)
					{
						trace('Error loading global HScript $file: $e');
					}
				}
				#end
			}
		}
	}

	function callGlobalScripts(func:String, args:Array<Dynamic> = null):Dynamic
	{
		var result:Dynamic = LuaUtils.Function_Continue;
		for (script in globalLuaScripts)
		{
			if (script.closed) continue;
			var ret = script.call(func, args ?? []);
			if (ret != null && ret != LuaUtils.Function_Continue)
				result = ret;
		}
		#if HSCRIPT_ALLOWED
		for (script in globalHScripts)
		{
			try {
				if (script.exists(func)) {
					var ret = script.call(func, args ?? []);
					if (ret != null && ret.returnValue != LuaUtils.Function_Continue)
						result = ret.returnValue;
				}
			} catch (e:Dynamic) {}
		}
		#end
		return result;
	}
	#end

	override function create() {
		currentState = this;
		var skip:Bool = FlxTransitionableState.skipNextTransOut;
		if(!(FlxG.mouse.cursor?.bitmapData is FunkinCursor)) FlxG.mouse.load(new FunkinCursor(0,0));

		#if MODS_ALLOWED
		Mods.updatedOnState = false;
		#end

		#if LUA_ALLOWED
		loadGlobalScripts();
		for (script in globalLuaScripts)
		{
			script.set('stateName', Type.getClassName(Type.getClass(this)));
		}
		callGlobalScripts('onStateChange', [Type.getClassName(Type.getClass(this))]);
		callGlobalScripts('onCreate', []);
		#end

		if(!_psychCameraInitialized) initPsychCamera();

		super.create();

		if(!skip) {
			openSubState(new CustomFadeTransition(0.5, true));
		}
		FlxTransitionableState.skipNextTransOut = false;
		timePassedOnState = 0;

		#if LUA_ALLOWED
		callGlobalScripts('onCreatePost', []);
		#end
	}

	public function initPsychCamera():PsychCamera
	{
		var camera = new PsychCamera();
		FlxG.cameras.reset(camera);
		FlxG.cameras.setDefaultDrawTarget(camera, true);
		_psychCameraInitialized = true;
		return camera;
	}

	public static var timePassedOnState:Float = 0;
	override function update(elapsed:Float)
	{
		var oldStep:Int = curStep;
		timePassedOnState += elapsed;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
		{
			if(curStep > 0)
				stepHit();

			if(PlayState.SONG != null)
			{
				if (oldStep < curStep)
					updateSection();
				else
					rollbackSection();
			}
		}

		if(FlxG.save.data != null) FlxG.save.data.fullscreen = FlxG.fullscreen;
		
		stagesFunc(function(stage:BaseStage) {
			stage.update(elapsed);
		});

		#if LUA_ALLOWED
		callGlobalScripts('onUpdate', [elapsed]);
		#end

		super.update(elapsed);

		#if LUA_ALLOWED
		callGlobalScripts('onUpdatePost', [elapsed]);
		#end
	}

	private function updateSection():Void
	{
		if(stepsToDo < 1) stepsToDo = Math.round(getBeatsOnSection() * 4);
		while(curStep >= stepsToDo)
		{
			curSection++;
			var beats:Float = getBeatsOnSection();
			stepsToDo += Math.round(beats * 4);
			sectionHit();
		}
	}

	private function rollbackSection():Void
	{
		if(curStep < 0) return;

		var lastSection:Int = curSection;
		curSection = 0;
		stepsToDo = 0;
		for (i in 0...PlayState.SONG.notes.length)
		{
			if (PlayState.SONG.notes[i] != null)
			{
				stepsToDo += Math.round(getBeatsOnSection() * 4);
				if(stepsToDo > curStep) break;
				
				curSection++;
			}
		}

		if(curSection > lastSection) sectionHit();
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
		curDecBeat = curDecStep/4;
	}

	private function updateCurStep():Void
	{
		var lastChange = Conductor.getBPMFromSeconds(Conductor.songPosition);

		var shit = ((Conductor.songPosition - ClientPrefs.data.noteOffset) - lastChange.songTime) / lastChange.stepCrochet;
		curDecStep = lastChange.stepTime + shit;
		curStep = lastChange.stepTime + Math.floor(shit);
	}

	public static function switchState(nextState:FlxState = null) {
		if(nextState == null) nextState = FlxG.state;
		if(nextState == FlxG.state)
		{
			resetState();
			return;
		}

		if(FlxTransitionableState.skipNextTransIn) FlxG.switchState(nextState);
		else startTransition(nextState);
		FlxTransitionableState.skipNextTransIn = false;
	}

	public static function resetState() {
		if(FlxTransitionableState.skipNextTransIn) FlxG.resetState();
		else startTransition();
		FlxTransitionableState.skipNextTransIn = false;
	}

	public static function startTransition(nextState:FlxState = null)
	{
		if(nextState == null)
			nextState = FlxG.state;

		FlxG.state.openSubState(new CustomFadeTransition(0.5, false));
		if(nextState == FlxG.state)
			CustomFadeTransition.finishCallback = function() FlxG.resetState();
		else
			CustomFadeTransition.finishCallback = function() FlxG.switchState(nextState);
	}

	public static function getState():MusicBeatState {
		if (Std.is(FlxG.state, MusicBeatState))
			return cast(FlxG.state, MusicBeatState);
		else
			return currentState;
	}

	public function stepHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curStep = curStep;
			stage.curDecStep = curDecStep;
			stage.stepHit();
		});

		#if LUA_ALLOWED
		callGlobalScripts('onStepHit', []);
		#end

		if (curStep % 4 == 0)
			beatHit();
	}

	public var stages:Array<BaseStage> = [];
	public function beatHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curBeat = curBeat;
			stage.curDecBeat = curDecBeat;
			stage.beatHit();
		});

		#if LUA_ALLOWED
		callGlobalScripts('onBeatHit', []);
		#end
	}

	public function sectionHit():Void
	{
		stagesFunc(function(stage:BaseStage) {
			stage.curSection = curSection;
			stage.sectionHit();
		});

		#if LUA_ALLOWED
		callGlobalScripts('onSectionHit', []);
		#end
	}

	public function stagesFunc(func:BaseStage->Void)
	{
		for (stage in stages)
			if(stage != null && stage.exists && stage.active)
				func(stage);
	}

	override function destroy()
	{
		#if TOUCH_CONTROLS_ALLOWED
		removeTouchPad();
		removeHitbox();
		#end

		#if LUA_ALLOWED
		callGlobalScripts('onStateDestroy', [Type.getClassName(Type.getClass(this))]);
		callGlobalScripts('onDestroy', []);
		#end
		
		super.destroy();
	}

	function getBeatsOnSection()
	{
		var val:Null<Float> = 4;
		if(PlayState.SONG != null && PlayState.SONG.notes[curSection] != null) val = PlayState.SONG.notes[curSection].sectionBeats;
		return val == null ? 4 : val;
	}
}
