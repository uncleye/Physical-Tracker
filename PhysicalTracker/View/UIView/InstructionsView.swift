//
//  InstructionsView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 07/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class InstructionsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var skipLabel: UILabel!
    
    //MARK: - Methods
    func instructionsTextViewConfigure(instructions: String) {
        instructionsTextView.text = instructions
    }
    
    func skipLabelConfigure(exerciseKey: String?) {
        if exerciseKey == Constants.RessourcesStrings.sixWalk {
            let attributedWithTextColor: NSAttributedString = Constants.Labels.swipeToStart.attributedStringWithColor([">>"], color: Constants.Colors.redUIColor)
            
            skipLabel.attributedText = attributedWithTextColor
        } else {
            let attributedWithTextColor: NSAttributedString = Constants.Labels.swipeToWatchVideo.attributedStringWithColor([">>"], color: Constants.Colors.redUIColor)
            
            skipLabel.attributedText = attributedWithTextColor
        }
        
        skipLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 14)
    }
    
}
