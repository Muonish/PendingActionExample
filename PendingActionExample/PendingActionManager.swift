//
//  PendingActionManager.swift
//
//  Created by Valeria on 1/17/18.
//  Copyright © 2018 Valeria. All rights reserved.
//

import Foundation

class PendingActionManager {
    let secondsToRetry: TimeInterval
    private var secondsLeft: TimeInterval
    private var tick: TimeInterval
    private var timer: Timer?
    private var tickHandler: ((TimeInterval) -> Void)?
    private var completion: (() -> Void)?
    
    private var pausedDateTime: Date?
    
    init(seconds: TimeInterval, tick: TimeInterval, tickHandler: ((TimeInterval) -> Void)? = nil, completion: (() -> Void)? = nil) {
        self.secondsToRetry = seconds
        self.tick = tick
        self.secondsLeft = seconds
        self.tickHandler = tickHandler
        self.completion = completion
        observeAppState()
    }

    func observeAppState() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAppBecomeInactive),
                                               name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAppBecomeActive),
                                               name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        invalidate()
    }
    
    func invalidate() {
        timer?.invalidate()
        timer = nil
    }
    
    func startWaiting() {
        secondsLeft = secondsToRetry
        startNewTimer()
    }
    
    private func startNewTimer() {
        invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: tick, repeats: true, block: handleTimerTick)
    }
    
    private func handleTimerTick(timer: Timer) {
        guard secondsLeft > 1 else {
            completion?()
            invalidate()
            return
        }
        secondsLeft -= tick
        tickHandler?(secondsLeft)
    }
    
    // MARK: - Application states handling
    
    @objc private func onAppBecomeInactive() {
        pausedDateTime = Date()
        invalidate()
    }
    
    @objc private func onAppBecomeActive() {
        guard let pausedTime = pausedDateTime else { return }
        let secondsPast = Int(Date().timeIntervalSince1970 - pausedTime.timeIntervalSince1970)
        let previousSecondsLeft = Int(secondsLeft)
        if secondsPast < previousSecondsLeft {
            secondsLeft = TimeInterval(previousSecondsLeft - secondsPast)
            startNewTimer()
        } else {
            completion?()
        }
        pausedDateTime = nil
    }
}
