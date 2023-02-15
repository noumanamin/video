//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<audioplayers_darwin/AudioplayersDarwinPlugin.h>)
#import <audioplayers_darwin/AudioplayersDarwinPlugin.h>
#else
@import audioplayers_darwin;
#endif

#if __has_include(<awesome_notifications/AwesomeNotificationsPlugin.h>)
#import <awesome_notifications/AwesomeNotificationsPlugin.h>
#else
@import awesome_notifications;
#endif

#if __has_include(<flutter_logs/FlutterLogsPlugin.h>)
#import <flutter_logs/FlutterLogsPlugin.h>
#else
@import flutter_logs;
#endif

#if __has_include(<flutter_share/FlutterSharePlugin.h>)
#import <flutter_share/FlutterSharePlugin.h>
#else
@import flutter_share;
#endif

#if __has_include(<flutter_vibrate/VibratePlugin.h>)
#import <flutter_vibrate/VibratePlugin.h>
#else
@import flutter_vibrate;
#endif

#if __has_include(<native_device_orientation/NativeDeviceOrientationPlugin.h>)
#import <native_device_orientation/NativeDeviceOrientationPlugin.h>
#else
@import native_device_orientation;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<wakelock/WakelockPlugin.h>)
#import <wakelock/WakelockPlugin.h>
#else
@import wakelock;
#endif

#if __has_include(<zego_express_engine/ZegoExpressEnginePlugin.h>)
#import <zego_express_engine/ZegoExpressEnginePlugin.h>
#else
@import zego_express_engine;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AudioplayersDarwinPlugin registerWithRegistrar:[registry registrarForPlugin:@"AudioplayersDarwinPlugin"]];
  [AwesomeNotificationsPlugin registerWithRegistrar:[registry registrarForPlugin:@"AwesomeNotificationsPlugin"]];
  [FlutterLogsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterLogsPlugin"]];
  [FlutterSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterSharePlugin"]];
  [VibratePlugin registerWithRegistrar:[registry registrarForPlugin:@"VibratePlugin"]];
  [NativeDeviceOrientationPlugin registerWithRegistrar:[registry registrarForPlugin:@"NativeDeviceOrientationPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [WakelockPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlugin"]];
  [ZegoExpressEnginePlugin registerWithRegistrar:[registry registrarForPlugin:@"ZegoExpressEnginePlugin"]];
}

@end
