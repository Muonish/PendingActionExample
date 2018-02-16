//
//  ViewController.swift
//  PendingActionExample
//
//  Created by Valeria on 2/16/18.
//  Copyright © 2018 Valeria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLeftLabel: UILabel!
    var pendingActionManager: PendingActionManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTime(60)
    }

    func updateTime(_ time: TimeInterval) {
        let minutes = Int(time / 60.0)
        let seconds = Int(time.truncatingRemainder(dividingBy: 60.0))
        timeLeftLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }

    @IBAction func onStart(_ sender: Any) {
        pendingActionManager?.invalidate()
        updateTime(60)
        pendingActionManager = PendingActionManager(seconds: 60, tick: 1, tickHandler: { [weak self] (secondsLeft) in
            self?.updateTime(secondsLeft)
        }, completion: { [weak self] in
            self?.updateTime(0)
            let alert = UIAlertController(title: "Timer Done!", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        })
        pendingActionManager?.startWaiting()
    }
    
}

