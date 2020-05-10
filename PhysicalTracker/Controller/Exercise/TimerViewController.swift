//
//  TimerViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 22/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var timerView: TimerView!
    
    //MARK: - Properties
    var exerciseKey: String?
    var timer = Timer()
    var time = 0

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Idle Timer
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    //MARK: - Actions
    @IBAction func startAndStopButtonTapped(_ sender: UIButton) {
        if time == 0 {
            timer.invalidate()

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
            
            timerView.setupStartAndStopButton()
        }
        
        if time != 0 {
            timer.invalidate()
            
            performSegue(withIdentifier: Constants.SeguesIdentifiers.keepResultsSegue, sender: self)
        }
    }
    
    //MARK: - Methods
    @objc func timerAction() {
        let minutes = Int(time + 1) / 60 % 60
        let seconds = Int(time + 1) % 60
        
        time += 1
        
        print(time)
        
        timerView.timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.keepResultsSegue,
            let destinationVC = segue.destination as? KeepResultsViewController {
            
            destinationVC.exerciseKey = exerciseKey
            destinationVC.time = time
        }
    }
    
}
