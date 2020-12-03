//
//  CircularTimerRingViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 07/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import SRCountdownTimer
import AVFoundation

class CircularTimerRingViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var circularTimerRingView: CircularTimerRingView!
    
    //MARK: - Properties
    var exerciseKey: String?
    
    // Time & Timer properties
    var timeInterval: Int = 0
    var timer1 = Timer()
    var timer2 = Timer()
    
    // To handle the 3 circularTimerRingViews chaining by incrementing numberOfStep
    var numberOfStep = 0
    
    // AudioPlayer properties
    var player: AVAudioPlayer?
    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Idle Timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
        
        // Set delegate to VC
        circularTimerRingView.countdownTimerView.delegate = self
        
        // Init timeInterval
        timeInterval = Int(NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.duration, comment: "")) ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
        
    }
    
    //MARK: - Actions
    @IBAction func startButtonIsTapped(_ sender: UIButton) {
        // StartButton is hidden and show CountdownTimerView
        circularTimerRingView.startButtonIsHiddenAndShowCountdownTimerView()
        
        // CircularTimerRing setup method
        circularTimerRingView.circularTimerRingSetup(timeInterval: timeInterval)
        
        // Play Beep sound only for step exercise
        stepExerciseConfigure()
    }
    
    //MARK: - Methods
    private func stepExerciseConfigure() {
        if exerciseKey == Constants.RessourcesStrings.step {
            setupRepeatTimerBeepLoop()
        }
    }
    
    // Play first beep sound setup method
    @objc private func playTimerBeep1Sound() {
        guard let path = Bundle.main.path(forResource: Constants.RessourcesStrings.timerBeep1 + Constants.RessourcesStrings.audioWithExtensionWav, ofType: nil) else {
            debugPrint("Sound not found!")
            
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.play()
        } catch {
            print("There is an issue with this code!")
        }
        
    }
    
    // Play second beep sound setup method
    @objc private func playTimerBeep2Sound() {
        guard let path = Bundle.main.path(forResource: Constants.RessourcesStrings.timerBeep2 + Constants.RessourcesStrings.audioWithExtensionMp3, ofType: nil) else {
            debugPrint("Sound not found!")
            
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.play()
        } catch {
            print("There is an issue with this code!")
        }
    }
        
    private func setupRepeatTimerBeepLoop() {
        timer1.invalidate()
        
        timer2.invalidate()
        
        timer1 = Timer.scheduledTimer(timeInterval: 0.625, target: self, selector: #selector(playTimerBeep1Sound), userInfo: nil, repeats: true)
        
        timer2 = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(playTimerBeep2Sound), userInfo: nil, repeats: true)
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.keepResultsSegue,
            let destinationVC = segue.destination as? KeepResultsViewController {
            
            destinationVC.exerciseKey = exerciseKey
        }
    }
    
}


//MARK: - SRCountdownTimerDelegate
extension CircularTimerRingViewController: SRCountdownTimerDelegate {
    func timerDidEnd() {
        if exerciseKey == Constants.RessourcesStrings.step {
            numberOfStep = numberOfStep + 1
            
            timer1.invalidate()
            
            timer2.invalidate()
         
            circularTimerRingView.countdownTimerView.start(beginingValue: Constants.Durations.stepRestDuration, interval: 1)
            circularTimerRingView.instructionLabel.isHidden = false

            if numberOfStep == 2 {
                circularTimerRingView.countdownTimerView.start(beginingValue: Constants.Durations.stepPulseDuration, interval: 1)
                
                circularTimerRingView.instructionLabel.text = Constants.Labels.takingYourPulse
            }
            
            if numberOfStep == 3 {
                performSegue(withIdentifier: Constants.SeguesIdentifiers.keepResultsSegue, sender: self)
            }
            
        } else {
            performSegue(withIdentifier: Constants.SeguesIdentifiers.keepResultsSegue, sender: self)
        }
    }
    
}
