package com.example.alarm_manager;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;


public class Application extends FlutterApplication implements PluginRegistrantCallback{
    
    public void onCreate(){
        super.onCreate();
        AlarmService.setPluginRegistrant(this); 
    }
    public void registerWith(PluginRegistry registry){
        GeneratedPluginRegistrant.registerWith(registry);
    }
    
    

}





