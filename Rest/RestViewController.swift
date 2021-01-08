//
//  TimerViewController.swift
//  Rest
//
//  Created by Lucas Budz on 2020-12-30.
//

import Cocoa
import AVFoundation

class RestViewController: NSViewController {

    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var actionLabel: NSButton!
    
    var model: RestModel?
    var stage = Stage.PAUSED
    var statusButton: NSStatusBarButton?
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model = RestModel(self)
        actionLabel.title = "Start"
        statusLabel.stringValue = "20-20-20 rule"
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onWakeNote(note:)), name: NSWorkspace.didWakeNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(onSleepNote(note:)), name: NSWorkspace.willSleepNotification, object: nil)
    
    }
    
    func setStatusButton(_ button: NSStatusBarButton) {
        statusButton = button
    }
    
    @IBAction func actionButton(_ sender: NSButton) {
        switch stage {
        case .PAUSED:
            // 'Start' or 'Resume' button pressed
            stage = .SCREENTIME
            actionLabel.title = "Pause"
            statusLabel.stringValue = "Screen time"
            model?.startTimer()
        case .SCREENTIME:
            // 'Pause' button pressed
            stage = .PAUSED
            actionLabel.title = "Resume"
            statusLabel.stringValue = "Screen time paused"
            model?.stopTimer()
        case .WAITING_FOR_REST:
            // 'Start' button pressed
            stage = .RESTING
            actionLabel.title = "Skip"
            statusLabel.stringValue = "Look at an object 20 ft away!"
            model?.startTimer()
        case .RESTING:
            // 'Skip' button pressed
            model?.stopTimer()
            model?.reset()
            model?.setTime(K.screenTime)
            model?.startTimer()
            actionLabel.title = "Pause"
            statusLabel.stringValue = "Screen time"
            stage = .SCREENTIME
        }
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: K.soundFilename, withExtension: K.soundExtension)
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
    
    
    @IBAction func quitButton(_ sender: NSButton) {
        NSApplication.shared.terminate(sender)
    }
    
    @IBAction func resetButton(_ sender: NSButton) {
        model?.reset()
    }
    
    @objc func onWakeNote(note: Notification) {
        
    }
    
    @objc func onSleepNote(note: Notification) {
        
    }
}

// MARK: Create instance of the view controller
extension RestViewController {
    
  static func freshController() -> RestViewController {
    // Get reference to the storyboard
    let storyboard = NSStoryboard(name: NSStoryboard.Name(K.storyboardName), bundle: nil)
    // Get reference to the view controller
    let identifier = NSStoryboard.SceneIdentifier(K.storyboardID)
    // Instantiate the view controller
    guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? RestViewController else {
        fatalError(K.fatalErrorMsg)
    }
    
    return viewController
  }
}

// MARK: RestModel protocol
extension RestViewController: RestDelegate {
    func updateUI() {
        let minutes = model!.getMinutes()
        let seconds = model!.getSeconds()
        
        timeLabel.stringValue = String(format: "%d:%02d", arguments: [minutes, seconds])
        statusButton?.title = String(format: "%d:%02d", arguments: [minutes, seconds])
    }
    
    func timerFinished() {
        if stage == .SCREENTIME {
            model?.reset()
            model?.setTime(K.restTime)
            actionLabel.title = "REST"
            statusLabel.stringValue = "Take a break!"
            playSound()
            stage = .WAITING_FOR_REST
        } else if stage == .RESTING {
            model?.reset()
            model?.setTime(K.screenTime)
            model?.startTimer()
            actionLabel.title = "Pause"
            statusLabel.stringValue = "Screen time"
            stage = .SCREENTIME
        } else {
            print("Error: Invalid stage")
        }

    }
}
