package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    ShimPluginRegistry shimPluginRegistry = new ShimPluginRegistry(flutterEngine);
    flutterEngine.getPlugins().add(new io.flutter.plugins.camera.CameraPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.connectivity.ConnectivityPlugin());
    flutterEngine.getPlugins().add(new com.jrai.flutter_keyboard_visibility.FlutterKeyboardVisibilityPlugin());
      io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin.registerWith(shimPluginRegistry.registrarFor("io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.googlemaps.GoogleMapsPlugin());
      com.ko2ic.imagedownloader.ImageDownloaderPlugin.registerWith(shimPluginRegistry.registrarFor("com.ko2ic.imagedownloader.ImageDownloaderPlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.imagepicker.ImagePickerPlugin());
    flutterEngine.getPlugins().add(new com.example.maps_launcher.MapsLauncherPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
      com.shekarmudaliyar.social_share.SocialSharePlugin.registerWith(shimPluginRegistry.registrarFor("com.shekarmudaliyar.social_share.SocialSharePlugin"));
    flutterEngine.getPlugins().add(new io.flutter.plugins.urllauncher.UrlLauncherPlugin());
  }
}
