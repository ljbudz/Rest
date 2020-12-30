//
//  EventMonitor.swift
//  Rest
//
//  Created by Lucas Budz on 2020-12-30.
//

import Cocoa

public class EventMonitor {
    // Monitor object
    private var monitor: Any?
    // Mask of events
    private let mask: NSEvent.EventTypeMask
    // Event handler function
    private let handler: (NSEvent?) -> Void

    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    // Create new monitor to listen to masked events, handled with the event handler
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    // Delete event monitor
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
