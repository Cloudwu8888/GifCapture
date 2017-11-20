//
//  AppDelegate.swift
//  GifCapture
//
//  Created by Khoa Pham on 01/03/2017.
//  Copyright © 2017 Fantageek. All rights reserved.
//

import Cocoa
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import AppCenterPush

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

  @IBOutlet weak var recordMenuItem: NSMenuItem!
  @IBOutlet weak var stopMenuItem: NSMenuItem!

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    MSPush.setDelegate(self)
    MSAppCenter.start("{8d632d83-2cf0-44b9-ac9b-a284df98accd}", withServices: [MSAnalytics.self, MSCrashes.self, MSPush.self])
    let window = NSApplication.shared().windows.first!

    // Window
    window.isOpaque = false
    window.backgroundColor = NSColor.clear

    window.contentView?.wantsLayer = true
    window.contentView?.layer?.borderColor = NSColor.gray.cgColor
    window.contentView?.layer?.borderWidth = 2

    window.toggleMoving(enabled: true)

    // Notification
    NSUserNotificationCenter.default.delegate = self
    
  }
    func push(_ push: MSPush!, didReceive pushNotification: MSPushNotification!) {
        let alert: NSAlert = NSAlert()
        alert.messageText = "Sorry about that!"
        alert.informativeText = "Do you want to send an anonymous crash report so we can fix the issue?"
        alert.addButton(withTitle: "Always send")
        alert.addButton(withTitle: "Send")
        alert.addButton(withTitle: "Don't send")
        alert.alertStyle = NSWarningAlertStyle
        
        switch (alert.runModal()) {
        case NSAlertFirstButtonReturn:
            MSCrashes.notify(with: .always)
            break;
        case NSAlertSecondButtonReturn:
            MSCrashes.notify(with: .send)
            break;
        case NSAlertThirdButtonReturn:
            MSCrashes.notify(with: .dontSend)
            break;
        default:
            break;
        }
    }

  // MARK: - MenuItem

  @IBAction func helpMenuItemTouched(_ sender: NSMenuItem) {
    let url = URL(string: "https://github.com/onmyway133/GifCapture")!
    NSWorkspace.shared().open(url)
  }
}

extension AppDelegate: NSUserNotificationCenterDelegate {

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
    guard let text = notification.informativeText,
      let url = URL(string: text) else {
      return
    }

    NSWorkspace.shared().activateFileViewerSelecting([url])
  }
}

