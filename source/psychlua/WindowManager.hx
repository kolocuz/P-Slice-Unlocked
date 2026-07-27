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
import openfl.events.Event;

#if LUA_ALLOWED
import psychlua.FunkinLua;
#end

class WindowManager
{
    public static var windows:Map<String, WindowData> = new Map<String, WindowData>();
    public static var nextId:Int = 0;
    private static var _isShuttingDown:Bool = false;

    // ============ СОЗДАНИЕ ============
    
    public static function createWindow(title:String, width:Int, height:Int, ?x:Int = -1, ?y:Int = -1):String
    {
        if (width <= 0 || height <= 0) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Invalid size $width x $height', false, false, FlxColor.RED);
            #end
            return null;
        }

        var attrs:WindowAttributes = new WindowAttributes();
        attrs.title = title != null ? title : "Window";
        attrs.width = width;
        attrs.height = height;
        attrs.resizable = true;
        attrs.borderless = false;
        attrs.alwaysOnTop = false;
        attrs.fullscreen = false;
        
        if (x >= 0 && y >= 0) {
            attrs.x = x;
            attrs.y = y;
        } else {
            attrs.x = Math.round((FlxG.stage.stageWidth - width) / 2);
            attrs.y = Math.round((FlxG.stage.stageHeight - height) / 2);
        }

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
        
        // Создаём FlxState
        var state = new FlxState();
        try {
            window.startState(state);
        } catch (e:Dynamic) {
            window.close();
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Failed to start state: $e', false, false, FlxColor.RED);
            #end
            return null;
        }
        
        var data = new WindowData();
        data.window = window;
        data.state = state;
        data.id = id;
        data.title = title != null ? title : "Window";
        data.width = width;
        data.height = height;
        data.x = attrs.x;
        data.y = attrs.y;
        data.opacity = 1.0;
        data.visible = true;
        data.objects = new Map<String, Dynamic>();
        data.objectGroup = new FlxGroup();
        data.isClosed = false;
        
        try {
            state.add(data.objectGroup);
        } catch (e:Dynamic) {
            data.isClosed = true;
            window.close();
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Failed to add group: $e', false, false, FlxColor.RED);
            #end
            return null;
        }
        
        windows.set(id, data);
        
        // Обработчики событий с защитой
        try {
            window.addEventListener(Event.RESIZE, function(e) {
                if (data.isClosed) return;
                data.width = window.width;
                data.height = window.height;
                triggerEvent(id, 'onResize', [window.width, window.height]);
            });
            
            window.addEventListener(Event.CLOSE, function(e) {
                if (data.isClosed) return;
                closeWindowInternal(id, true);
            });
        } catch (e:Dynamic) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('createWindow: Failed to add event listeners: $e', false, false, FlxColor.RED);
            #end
        }
        
        triggerEvent(id, 'onWindowCreate', []);
        return id;
    }

    // ============ ЗАКРЫТИЕ ============
    
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
        
        // Удаляем все объекты
        clearObjectsInternal(data);
        
        // Закрываем окно
        try {
            if (data.window != null && !data.window.closed) {
                data.window.close();
            }
        } catch (e:Dynamic) {
            // Игнорируем ошибки при закрытии
        }
        
        // Очищаем ссылки
        data.window = null;
        data.state = null;
        data.objectGroup = null;
        
        // Удаляем из мапы
        windows.remove(id);
        
        if (!fromEvent) {
            triggerEvent(id, 'onWindowClose', []);
        }
        
        return true;
    }

    // ============ ГЕТТЕРЫ С ЗАЩИТОЙ ============
    
    private static function getData(id:String):WindowData
    {
        if (!windows.exists(id)) return null;
        var data = windows.get(id);
        if (data == null || data.isClosed || data.window == null || data.window.closed) {
            // Очищаем мёртвые окна
            if (data != null && data.isClosed == false) {
                data.isClosed = true;
                clearObjectsInternal(data);
                windows.remove(id);
            }
            return null;
        }
        return data;
    }

    // ============ УПРАВЛЕНИЕ ОКНОМ ============
    
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
        
        opacity = Math.max(0, Math.min(1, opacity)); // clamp 0-1
        
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

    public static function setWindowAlwaysOnTop(id:String, alwaysOnTop:Bool):Bool
    {
        var data = getData(id);
        if (data == null) return false;
        
        try {
            data.window.alwaysOnTop = alwaysOnTop;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowResizable(id:String, resizable:Bool):Bool
    {
        var data = getData(id);
        if (data == null) return false;
        
        try {
            data.window.resizable = resizable;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    public static function setWindowBorderless(id:String, borderless:Bool):Bool
    {
        var data = getData(id);
        if (data == null) return false;
        
        try {
            data.window.borderless = borderless;
            return true;
        } catch (e:Dynamic) {
            return false;
        }
    }

    // ============ ОБЪЕКТЫ ============
    
    public static function addObject(id:String, name:String, obj:Dynamic):Bool
    {
        if (name == null || obj == null) return false;
        
        var data = getData(id);
        if (data == null) return false;
        
        try {
            // Удаляем старый объект с таким именем
            if (data.objects.exists(name)) {
                removeObject(id, name);
            }
            
            data.objects.set(name, obj);
            
            // Если это FlxBasic, добавляем в группу
            if (Std.isOfType(obj, flixel.FlxBasic)) {
                data.objectGroup.add(obj);
            }
            
            triggerEvent(id, 'onObjectAdded', [name]);
            return true;
        } catch (e:Dynamic) {
            #if LUA_ALLOWED
            FunkinLua.luaTrace('addObject: Failed to add object: $e', false, false, FlxColor.RED);
            #end
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
            
            // Удаляем из группы
            if (Std.isOfType(obj, flixel.FlxBasic)) {
                data.objectGroup.remove(obj);
            }
            
            // Уничтожаем если это FlxSprite
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
            // Уничтожаем все объекты
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
            
            if (data.objectGroup != null) {
                data.objectGroup.clear();
                data.objectGroup.destroy();
                data.objectGroup = null;
            }
        } catch (e:Dynamic) {
            // Игнорируем ошибки при очистке
        }
    }

    // ============ СПРАЙТЫ И ТЕКСТ ============
    
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

    // ============ РАБОТА СО СВОЙСТВАМИ ============
    
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

    // ============ ИНФОРМАЦИЯ ============
    
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
        
        // Очищаем мёртвые окна
        for (key in windows.keys()) {
            var data = windows.get(key);
            if (data == null || data.isClosed || data.window == null || data.window.closed) {
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

    // ============ ОЧИСТКА ПРИ ЗАВЕРШЕНИИ ============
    
    public static function shutdown():Void
    {
        _isShuttingDown = true;
        
        for (key in windows.keys()) {
            var data = windows.get(key);
            if (data != null) {
                data.isClosed = true;
                clearObjectsInternal(data);
                try {
                    if (data.window != null && !data.window.closed) {
                        data.window.close();
                    }
                } catch (e:Dynamic) {}
            }
        }
        
        windows.clear();
        _isShuttingDown = false;
    }

    // ============ СОБЫТИЯ ============
    
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
        } catch (e:Dynamic) {
            // Игнорируем ошибки в событиях
        }
        #end
    }
}

class WindowData
{
    public var window:Window = null;
    public var state:FlxState = null;
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
    public var objectGroup:FlxGroup = null;
}
