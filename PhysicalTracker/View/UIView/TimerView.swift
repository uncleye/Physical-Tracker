//
//  TimerView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 22/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class TimerView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startAndStopButton: UIButton!
    
    //MARK: - Methods
    func setupStartAndStopButton() {
        startAndStopButton.setTitle(Constants.Labels.stopTitleButton, for: .normal)
        startAndStopButton.titleLabel?.font = UIFont(name: Constants.Fonts.rubikMedium, size: 50)
        startAndStopButton.titleLabel?.textColor = .white
        startAndStopButton.backgroundColor = Constants.Colors.redUIColor
    }
    
}
