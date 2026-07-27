runHaxeCode([[
    var winId = WindowManager.createWindow("HScript Window", 600, 400);
    if (winId == null) {
        trace("Failed to create window!");
        return;
    }
    
    if (WindowManager.exists(winId)) {
        WindowManager.setWindowTitle(winId, "New Title");
        WindowManager.setWindowSize(winId, 800, 600);
        
        if (WindowManager.createSprite(winId, "bg", 0, 0)) {
            WindowManager.loadSpriteGraphic(winId, "bg", "stages/myStage/bg");
        }
        
        var data = WindowManager.getWindowData(winId);
        if (data != null) {
            trace("Window: " + data.title);
        }
        
        WindowManager.closeWindow(winId);
    }
]]);
