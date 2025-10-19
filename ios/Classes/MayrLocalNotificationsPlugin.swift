import Flutter
import UIKit
import UserNotifications

public class MayrLocalNotificationsPlugin: NSObject, FlutterPlugin {
  private var debugLogs: Bool = false
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "mayr_local_notifications", binaryMessenger: registrar.messenger())
    let instance = MayrLocalNotificationsPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "init":
      handleInit(call: call, result: result)
    case "send":
      handleSend(call: call, result: result)
    case "schedule":
      handleSchedule(call: call, result: result)
    case "cancelAll":
      handleCancelAll(result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func handleInit(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any] else {
      result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
      return
    }
    
    debugLogs = args["enableDebugLogs"] as? Bool ?? false
    let requestPermissions = args["requestPermissions"] as? Bool ?? true
    
    log("Initializing notifications")
    
    if requestPermissions {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if let error = error {
          self.log("Permission error: \(error.localizedDescription)")
        }
        self.log("Permission granted: \(granted)")
      }
    }
    
    result(nil)
  }
  
  private func handleSend(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let title = args["title"] as? String,
          let body = args["body"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing title or body", details: nil))
      return
    }
    
    log("Sending notification - Title: \(title)")
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    if let payload = args["payload"] as? [String: Any] {
      content.userInfo = payload
    }
    
    // Send immediately (with a tiny delay to ensure it fires)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
    let identifier = UUID().uuidString
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        self.log("Error sending notification: \(error.localizedDescription)")
        result(FlutterError(code: "SEND_ERROR", message: error.localizedDescription, details: nil))
      } else {
        self.log("Notification sent successfully")
        result(nil)
      }
    }
  }
  
  private func handleSchedule(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let title = args["title"] as? String,
          let body = args["body"] as? String,
          let timestamp = args["timestamp"] as? NSNumber else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
      return
    }
    
    let scheduledDate = Date(timeIntervalSince1970: TimeInterval(timestamp.doubleValue / 1000.0))
    log("Scheduling notification - Title: \(title), Time: \(scheduledDate)")
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    
    if let payload = args["payload"] as? [String: Any] {
      content.userInfo = payload
    }
    
    // Calculate time interval from now
    let timeInterval = scheduledDate.timeIntervalSinceNow
    
    if timeInterval > 0 {
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
      let identifier = UUID().uuidString
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
      
      UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
          self.log("Error scheduling notification: \(error.localizedDescription)")
          result(FlutterError(code: "SCHEDULE_ERROR", message: error.localizedDescription, details: nil))
        } else {
          self.log("Notification scheduled successfully")
          result(nil)
        }
      }
    } else {
      result(FlutterError(code: "INVALID_TIME", message: "Scheduled time must be in the future", details: nil))
    }
  }
  
  private func handleCancelAll(result: @escaping FlutterResult) {
    log("Canceling all notifications")
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    result(nil)
  }
  
  private func log(_ message: String) {
    if debugLogs {
      print("[MayrLocalNotifications] \(message)")
    }
  }
}

