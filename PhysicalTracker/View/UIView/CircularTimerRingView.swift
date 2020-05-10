//
//  CircularTimerRingView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 22/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import SRCountdownTimer

class CircularTimerRingView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var countdownTimerView: SRCountdownTimer!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Methods
    func startButtonIsHiddenAndShowCountdownTimerView() {
        startButton.isHidden = true
        countdownTimerView.isHidden = false
    }
    
    func circularTimerRingSetup(timeInterval: Int) {
        countdownTimerView.useMinutesAndSecondsRepresentation = true
        countdownTimerView.labelFont = UIFont(name: Constants.Fonts.rubikMedium, size: 50)
        countdownTimerView.labelTextColor = UIColor.black
        countdownTimerView.lineWidth = 8
        countdownTimerView.start(beginingValue: timeInterval, interval: 1)
    }
    
}
