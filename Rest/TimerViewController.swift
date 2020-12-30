//
//  TimerViewController.swift
//  Rest
//
//  Created by Lucas Budz on 2020-12-30.
//

import Cocoa

class TimerViewController: NSViewController {

    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    
    var timer = Timer()
    var elapsedTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onWakeNote(note:)), name: NSWorkspace.didWakeNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onSleepNote(note:)), name: NSWorkspace.willSleepNotification, object: nil)
    
    }
    
    @objc func onWakeNote(note: Notification) {
        
    }
    
    @objc func onSleepNote(note: Notification) {
        
    }
    
    
    @objc func updateTimer() {
        elapsedTime += 1
        
        let duration = 20*60 - elapsedTime
        let minutes = duration / 60;
        let seconds = duration % 60;
        
        timeLabel.stringValue = String(format: "%d:%02d", arguments: [minutes, seconds])
        
        if elapsedTime >= 20 * 60 {
            timer.invalidate()
        }
    }
}

extension TimerViewController {
  // MARK: Storyboard instantiation
  static func freshController() -> TimerViewController {
    //1.
    let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
    //2.
    let identifier = NSStoryboard.SceneIdentifier("TimerViewController")
    //3.
    guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? TimerViewController else {
      fatalError("Why cant i find QuotesViewController? - Check Main.storyboard")
    }
    return viewcontroller
  }
}

// MARK: Actions
extension TimerViewController {
    
    @IBAction func quitButton(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
}
