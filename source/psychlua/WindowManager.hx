package psychlua;

import backend.Paths;
import lime.app.Application;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.util.FlxDestroyUtil;

#if LUA_ALLOWED
import psychlua.FunkinLua;
#end

class WindowManager
{
    public static var windows:Map<String, WindowData> = new Map<String, WindowData>();
    public static var nextId:Int = 0;
    private static var _isShuttingDown:Bool = false;

    public static function createWindow(title:String, width:Int, height:Int, ?x:Int = -1, ?y:Int = -1):String
    {
        if (width <= 0 || height <= 0) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Invalid size $width x $height', false, false, FlxColor.RED);
            #end
            return null;
        }

        var attrs:WindowAttributes = {
            title: title != null ? title : "Window",
            width: width,
            height: height,
            resizable: true,
            borderless: false,
            alwaysOnTop: false,
            fullscreen: false,
            x: (x >= 0 && y >= 0) ? x : Math.round((FlxG.stage.stageWidth - width) / 2),
            y: (x >= 0 && y >= 0) ? y : Math.round((FlxG.stage.stageHeight - height) / 2)
        };

        var window:Window = null;
        try {
            window = Application.current.createWindow(attrs);
        } catch (e:Dynamic) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Failed to create window: $e', false, false, FlxColor.RED);
            #end
            return null;
        }

        if (window == null) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Window creation returned null', false, false, FlxColor.RED);
            #end
            return null;
        }

        var id = "window_" + nextId++;

        var data = new WindowData();
        data.window = window;
        data.id = id;
        data.title = title != null ? title : "Window";
        data.width = width;
        data.height = height;
        data.x = attrs.x;
        data.y = attrs.y;
        data.opacity = 1.0;
        data.visible = true;
        data.objects = new Map<String, Dynamic>();
        data.isClosed = false;

        // В P-Slice Lime нет startState(), просто храним окно
        windows.set(id, data);

        // События через onX
        try {
            window.onResize = function(w:Int, h:Int) {
                if (data.isClosed) return;
                data.width = w;
                data.height = h;
                triggerEvent(id, 'onResize', [w, h]);
            };

            window.onClose = function() {
                if (data.isClosed) return;
                closeWindowInternal(id, true);
            };
        } catch (e:Dynamic) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Failed to set event handlers: $e', false, false, FlxColor.RED);
            #end
        }

        triggerEvent(id, 'onWindowCreate', []);
        return id;
    }

    public static function closeWindow(id:String):Bool
    {
        return closeWindowInternal(id, false);
    }

    private static function closeWindowInternal(id:String, fromEvent:Bool):Bool
    {
        if (!windows.exists(id)) return false;

        var data = windows.get(id);
        if (data.isClosed) return false;

        data.isClosed = true;
        clearObjectsInternal(data);

        try {
            if (data.window != null) {
                data.window.close();
            }
        } catch (e:Dynamic) {}

        data.window = null;
        windows.remove(id);

        if (!fromEvent) {
            triggerEvent(id, 'onWindowClose', []);
        }

        return true;
    }

    private static function getData(id:String):WindowData
    {
        if (!windows.exists(id)) return null;
        var data = windows.get(id);
        if (data == null || data.isClosed || data.window == null) {
            if (data != null && data.isClosed == false) {
                data.isClosed = true;
                clearObjectsInternal(data);
                windows.remove(id);
            }
            return null;
        }
        return data;
    }

    public static function setWindowTitle(id:String, title:String):Bool
    {
        var data = getData(id);
        if (data == null || title == null) return false;

        try {
            data.title = title;
            data.window.title = title;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowSize(id:String, width:Int, height:Int):Bool
    {
        if (width <= 0 || height <= 0) return false;

        var data = getData(id);
        if (data == null) return false;

        try {
            data.width = width;
            data.height = height;
            data.window.resize(width, height);
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowPosition(id:String, x:Int, y:Int):Bool
    {
        var data = getData(id);
        if (data == null) return false;

        try {
            data.x = x;
            data.y = y;
            data.window.x = x;
            data.window.y = y;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowOpacity(id:String, opacity:Float):Bool
    {
        var data = getData(id);
        if (data == null) return false;

        opacity = Math.max(0, Math.min(1, opacity));

        try {
            data.opacity = opacity;
            data.window.opacity = opacity;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowVisible(id:String, visible:Bool):Bool
    {
        var data = getData(id);
        if (data == null) return false;

        try {
            data.visible = visible;
            data.window.visible = visible;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowFullscreen(id:String, fullscreen:Bool):Bool
    {
        var data = getData(id);
        if (data == null) return false;

        try {
            data.window.fullscreen = fullscreen;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function addObject(id:String, name:String, obj:Dynamic):Bool
    {
        if (name == null || obj == null) return false;

        var data = getData(id);
        if (data == null) return false;

        try {
            if (data.objects.exists(name)) {
                removeObject(id, name);
            }

            data.objects.set(name, obj);
            triggerEvent(id, 'onObjectAdded', [name]);
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function removeObject(id:String, name:String):Bool
    {
        if (name == null) return false;

        var data = getData(id);
        if (data == null) return false;

        if (!data.objects.exists(name)) return false;

        try {
            var obj = data.objects.get(name);

            if (Std.isOfType(obj, FlxSprite)) {
                var sprite:FlxSprite = cast obj;
                if (sprite != null) {
                    sprite.destroy();
                }
            }

            data.objects.remove(name);
            triggerEvent(id, 'onObjectRemoved', [name]);
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function getObject(id:String, name:String):Dynamic
    {
        if (name == null) return null;

        var data = getData(id);
        if (data == null) return null;

        if (!data.objects.exists(name)) return null;
        return data.objects.get(name);
    }

    public static function clearObjects(id:String):Bool
    {
        var data = getData(id);
        if (data == null) return false;

        clearObjectsInternal(data);
        return true;
    }

    private static function clearObjectsInternal(data:WindowData):Void
    {
        if (data == null) return;

        try {
            for (name in data.objects.keys()) {
                var obj = data.objects.get(name);
                if (Std.isOfType(obj, FlxSprite)) {
                    var sprite:FlxSprite = cast obj;
                    if (sprite != null) {
                        sprite.destroy();
                    }
                }
            }

            data.objects.clear();
        } catch (e:Dynamic) {}
    }

    public static function createSprite(id:String, name:String, ?x:Float = 0, ?y:Float = 0):Bool
    {
        if (name == null) return false;

        var data = getData(id);
        if (data == null) return false;

        try {
            var sprite = new FlxSprite(x, y);
            return addObject(id, name, sprite);
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function loadSpriteGraphic(id:String, name:String, image:String):Bool
    {
        if (name == null || image == null) return false;

        var sprite:FlxSprite = getObject(id, name);
        if (sprite == null) return false;

        try {
            sprite.loadGraphic(Paths.image(image));
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function createText(id:String, name:String, text:String, ?x:Float = 0, ?y:Float = 0, ?size:Int = 16):Bool
    {
        if (name == null || text == null) return false;

        var data = getData(id);
        if (data == null) return false;

        try {
            var flxText = new FlxText(x, y, 0, text, size);
            return addObject(id, name, flxText);
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setObjectProperty(id:String, name:String, property:String, value:Dynamic):Bool
    {
        if (name == null || property == null) return false;

        var obj = getObject(id, name);
        if (obj == null) return false;

        try {
            Reflect.setProperty(obj, property, value);
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function getObjectProperty(id:String, name:String, property:String):Dynamic
    {
        if (name == null || property == null) return null;

        var obj = getObject(id, name);
        if (obj == null) return null;

        try {
            return Reflect.getProperty(obj, property);
        } catch (e:Dynamic) {
            return null;
        }
    }

    public static function getWindowData(id:String):Dynamic
    {
        var data = getData(id);
        if (data == null) return null;

        return {
            id: data.id,
            title: data.title,
            width: data.width,
            height: data.height,
            x: data.x,
            y: data.y,
            opacity: data.opacity,
            visible: data.visible,
            isClosed: data.isClosed
        };
    }

    public static function getWindowIds():Array<String>
    {
        var ids:Array<String> = [];

        for (key in windows.keys()) {
            var data = windows.get(key);
            if (data == null || data.isClosed || data.window == null) {
                if (data != null && !data.isClosed) {
                    data.isClosed = true;
                    clearObjectsInternal(data);
                }
                windows.remove(key);
            } else {
                ids.push(key);
            }
        }

        return ids;
    }

    public static function exists(id:String):Bool
    {
        if (id == null) return false;
        return getData(id) != null;
    }

    public static function shutdown():Void
    {
        _isShuttingDown = true;

        for (key in windows.keys()) {
            var data = windows.get(key);
            if (data != null) {
                data.isClosed = true;
                clearObjectsInternal(data);
                try {
                    if (data.window != null) {
                        data.window.close();
                    }
                } catch (e:Dynamic) {}
            }
        }

        windows.clear();
        _isShuttingDown = false;
    }

    private static function triggerEvent(id:String, eventName:String, ?args:Array<Dynamic>):Void
    {
        #if LUA_ALLOWED
        try {
            if (FunkinLua.lastCalledScript != null && !FunkinLua.lastCalledScript.closed) {
                var fullArgs:Array<Dynamic> = [id];
                if (args != null) {
                    for (arg in args) {
                        fullArgs.push(arg);
                    }
                }
                FunkinLua.lastCalledScript.call(eventName, fullArgs);
            }
        } catch (e:Dynamic) {}
        #end
    }
}

class WindowData
{
    public var window:Window = null;
    public var id:String = "";
    public var title:String = "";
    public var width:Int = 0;
    public var height:Int = 0;
    public var x:Int = 0;
    public var y:Int = 0;
    public var opacity:Float = 1.0;
    public var visible:Bool = true;
    public var isClosed:Bool = false;
    public var objects:Map<String, Dynamic> = new Map<String, Dynamic>();

    public function new() {}
}
