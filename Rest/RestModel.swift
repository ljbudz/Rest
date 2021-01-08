//
//  RestModel.swift
//  Rest
//
//  Created by Lucas Budz on 2021-01-07.
//

import Cocoa

protocol RestDelegate {
    func updateUI()
    func timerFinished()
}

class RestModel {
    
    private var timer = Timer()
    private var elapsedTime = 0
    private var delegate: RestDelegate?
    private var totalTime = K.screenTime
    
    init(_ delegate: RestDelegate?) {
        self.delegate = delegate
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func setTime(_ time: Int) {
        totalTime = time
        delegate?.updateUI()
    }
    
    func reset() {
        elapsedTime = 0
        delegate?.updateUI()
    }
    
    @objc func updateTimer() {
        elapsedTime += 1
        
        if elapsedTime > totalTime {
            timer.invalidate()
            delegate?.timerFinished()
        } else {
            delegate?.updateUI()
        }
    }
    
    func getMinutes() -> Int {
        return (totalTime - elapsedTime) / 60
    }
    
    func getSeconds() -> Int {
        return (totalTime - elapsedTime) % 60
    }
}
