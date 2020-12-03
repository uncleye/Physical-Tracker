//
//  KeepResultsView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 22/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class KeepResultsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pulsePerMinuteLabel: UILabel!
    @IBOutlet weak var frequencymeterLabel: UILabel!
    @IBOutlet weak var gradingTextField: UITextField!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var keepResultsButton: UIButton!
    @IBOutlet weak var keepResultsAndShowResultsButton: UIButton!
    @IBOutlet weak var frequencymeterSwitch: UISwitch!
    
    //MARK: - Methods
    func setupUI() {
        restartButton.layer.borderColor = UIColor.lightGray.cgColor
        restartButton.layer.borderWidth = 1
        restartButton.layer.cornerRadius = 0.02 * restartButton.bounds.size.width
        
        keepResultsButton.layer.borderColor = UIColor.lightGray.cgColor
        keepResultsButton.layer.borderWidth = 1
        keepResultsButton.layer.cornerRadius = 0.02 * keepResultsButton.bounds.size.width
        
        keepResultsAndShowResultsButton.layer.borderColor = UIColor.lightGray.cgColor
        keepResultsAndShowResultsButton.layer.borderWidth = 1
        keepResultsAndShowResultsButton.layer.cornerRadius = 0.02 * keepResultsAndShowResultsButton.bounds.size.width
    }
    
    func switchAndLabelFrequencymeterAreHidden() {
        frequencymeterSwitch.isHidden = true
        frequencymeterLabel.isHidden = true
    }
    
    func titleLabelAndGradingTextFieldConfigure(exerciseKey: String?, pickerView: UIPickerView, toolbarPickerView: ToolbarPickerView) {
        switch exerciseKey {
        case Constants.RessourcesStrings.shoulders:
            titleLabel.text = Constants.Labels.howFarAreYouGoing
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            gradingTextField.inputView = pickerView
            
            gradingTextField.inputAccessoryView = toolbarPickerView.toolbar
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
        case Constants.RessourcesStrings.sitReach:
            titleLabel.text = Constants.Labels.howFarAreYouGoing
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
        case Constants.RessourcesStrings.handGround:
            titleLabel?.text = Constants.Labels.howFarAreYouGoing
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            gradingTextField.inputView = pickerView
            
            gradingTextField.inputAccessoryView = toolbarPickerView.toolbar
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
        case Constants.RessourcesStrings.sixWalk:
            titleLabel.text = Constants.Labels.numberOfMetersCovered
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
        case Constants.RessourcesStrings.step:
            titleLabel.text = Constants.Labels.numberOfPulsesIn15Sec
            
            timeLabel.isHidden = true
            
            pulsePerMinuteLabel.isHidden = false
            
            gradingTextField.isHidden = false
            
            frequencymeterSwitch.isHidden = false
            
            frequencymeterLabel.isHidden = false
            
            break
            
        case Constants.RessourcesStrings.sitStand:
            titleLabel.text = Constants.Labels.numberOfLifts
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
            
        case Constants.RessourcesStrings.handGrip:
            titleLabel.text = Constants.Labels.sumTwoHands
            
            timeLabel.isHidden = true
            
            gradingTextField.isHidden = false
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
        default:
            titleLabel.text = Constants.Labels.resultsLabel
            
            timeLabel.isHidden = false
            
            gradingTextField.isHidden = true
            
            frequencymeterSwitch.isHidden = true
            
            frequencymeterLabel.isHidden = true
            
            break
        }
    }
    
    func setupTimeLabel(time: Int?) {
        if let time = time {
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            
            timeLabel.text = String(format:"%02i:%02i", minutes, seconds)
        }
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        gradingTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: UIControl.Event.editingDidEnd)
    }
    
    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        pulsePerMinuteLabel.text = convertResultIntoPulsesPerMinute(sender: sender) + Constants.Labels.pulsesPerMinute
    }
    
    //Helper method
    func convertResultIntoPulsesPerMinute(sender: UITextField) -> String {
        if sender.inputView == nil {
            let textfieldInt: Int? = Int(sender.text!) ?? 0
            let convert = textfieldInt! * 4
            let convertText = String(convert)
            
            return convertText
        }
        
        return ""
    }
    
}
