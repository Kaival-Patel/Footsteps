package com.kaival.footsteps;
import android.content.Intent;
import android.app.Service;
import androidx.appcompat.app.AppCompatActivity;
import android.os.Bundle;
import android.app.Activity;
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import com.kaival.footsteps.MyLocationService;
public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.kaival.footsteps/getLocation";
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler(
            (call, result) -> {
                if(call.method.equals("getLocation")){
                    startService(new Intent(this,MyLocationService.class));
                    result.success("::::::::NATIVE BRIDGING COMPLETED!::::::");
                }
            }
            );
    }
}
