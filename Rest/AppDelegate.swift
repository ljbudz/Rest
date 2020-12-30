//
//  AppDelegate.swift
//  Rest
//
//  Created by Lucas Budz on 2020-12-30.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    // Status bar icon
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.variableLength)
    
    // Status bar popover
    let popover = NSPopover()
    
    // Event monitor for global events
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Initialize the status bar icon
        if let button = statusItem.button {
            button.title = NSString(string: "Rest") as String
            button.action = #selector(togglePopover(_:))
        }
        
        // Initialize the view controller for the status bar popover
        popover.contentViewController = RestViewController.freshController()
        
        // Initialize event montior for clicking outside the status bar popover
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
        if let strongSelf = self, strongSelf.popover.isShown {
            strongSelf.closePopover(sender: event) // Close on mouse click outside popover
        }
      }
    }

    // Toggle the status bar popover on or off
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
        closePopover(sender: sender)
      } else {
        showPopover(sender: sender)
      }
    }

    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start() // Start event monitor for clicks outside popover
      }
    }

    // Close the status bar popover
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop() // Stop listening for global events
    }
}

