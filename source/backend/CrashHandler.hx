package backend;

import mikolka.vslice.components.crash.CrashServer;
import mikolka.vslice.components.crash.UserErrorSubstate;
import mikolka.vslice.components.crash.CrashState;
import haxe.CallStack;
import openfl.events.UncaughtErrorEvent;
#if sys
import sys.io.File;
#end


using flixel.util.FlxArrayUtil;

/**
 * Crash Handler.
 * @author YoshiCrafter29, Ne_Eo, MAJigsaw77 and Lily Ross (mcagabe19)
 */
class CrashHandler
{
	public static function init():Void
	{
		trace("hooking openfl crash handler");
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		#if cpp 
		trace("hooking hxcpp crash handler");
		untyped __global__.__hxcpp_set_critical_error_handler(onError);
		#elseif hl
		trace("hooking hashlink crash handler");
		hl.Api.setErrorHandler(onError);
		#end
		trace("done with crash handler");
	}

	private static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		var errorStack = CallStack.exceptionStack(true);
		var crash = UserErrorSubstate.collectErrorData(e.error,errorStack);
		var crashState = new CrashState(crash);
		e.preventDefault();
		FlxG.switchState(crashState);
	}

	#if (cpp || hl)
	private static function onError(message:Dynamic):Void
	{
		final log:Array<String> = [];

		if (message != null && message.length > 0)
			log.push(message);

		log.push(haxe.CallStack.toString(haxe.CallStack.exceptionStack(true)));
		var logMsg = log.join('\n');
		#if sys
		var path = './crash/' + 'PSlice_' + Date.now().toString() + '.txt';
        File.saveContent(path, logMsg + '\n');
		#end
		trace(logMsg);

		CoolUtil.showPopUp(logMsg, "Critical Error!");
		#if DISCORD_ALLOWED DiscordClient.shutdown(); #end
		lime.system.System.exit(1);
	}
	#end
}
