//
//  CreateProfileView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class CreateProfileView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthYearTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var modifyButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    //MARK: - Methods
    func setupButtons() {
        startButton.layer.cornerRadius = 0.03 * startButton.bounds.size.width
        cancelButton.layer.cornerRadius = 0.03 * startButton.bounds.size.width
        modifyButton.layer.cornerRadius = 0.03 * startButton.bounds.size.width
    }
    
    func buttonsAreHidden() {
        cancelButton.isHidden = true
        modifyButton.isHidden = true
    }
    
    func setupAddTargetIsNotEmptyTextFields() {
        startButton.setupIsEnabled(startButton, isEnabled: false)

        [firstNameTextField, lastNameTextField, birthYearTextField, heightTextField, weightTextField, domainTextField].forEach({ $0.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: UIControl.Event.editingDidEnd) })
    }
    
    @objc func textFieldsIsNotEmpty(_ sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        guard let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let birthYear = birthYearTextField.text, !birthYear.isEmpty,
            let height = heightTextField.text, !height.isEmpty,
            let weight = weightTextField.text, !weight.isEmpty,
            let domain = domainTextField.text, !domain.isEmpty
            
            else {
                startButton.setupIsEnabled(startButton, isEnabled: false)
                return
        }
        
        startButton.setupIsEnabled(startButton, isEnabled: true)
    }
    
    func setupStartButtonIsEnabled() {
        if let firstName = firstNameTextField.text, !firstName.isEmpty,
            let lastName = lastNameTextField.text, !lastName.isEmpty,
            let birthYear = birthYearTextField.text, !birthYear.isEmpty,
            let height = heightTextField.text, !height.isEmpty,
            let weight = weightTextField.text, !weight.isEmpty {
            
            startButton.setupIsEnabled(startButton, isEnabled: true)
        }
    }
    
    func setupDomainTextField(isHidden: Bool, inputView: UIView?, inputAccessoryView: UIView?, placeholder: String?, text: String?) {
        domainTextField.isHidden = isHidden
        domainTextField.inputView = inputView
        domainTextField.inputAccessoryView = inputAccessoryView
        domainTextField.placeholder = placeholder
        domainTextField.text = text
    }
    
    func setupUiIsEditable(_ isEditable: Bool) {
        firstNameTextField.isEnabled = isEditable
        lastNameTextField.isEnabled = isEditable
        birthYearTextField.isEnabled = isEditable
        sexSegmentedControl.isEnabled = isEditable
    }
    
    func setupModifyProfileUI(user: User, sexIndex: Int, statusIndex: Int) {
        firstNameTextField.text = String(user.userName.prefix(3))
        lastNameTextField.text = String(user.userName.suffix(3))
        birthYearTextField.text = String(user.birthyear)
        heightTextField.text = String(user.height)
        weightTextField.text = String(user.weight)
        sexSegmentedControl.selectedSegmentIndex = sexIndex
        statusSegmentedControl.selectedSegmentIndex = statusIndex
        domainTextField.text = user.domain
    }
    
    func setupButtonsAreHiddenForModifyProfileUI() {
        modifyButton.isHidden = false
        cancelButton.isHidden = false
        startButton.isHidden = true
    }
    
    func setupTextFieldsAreNotEnabledBackgroundColor() {
        firstNameTextField.backgroundColor = .lightGray
        lastNameTextField.backgroundColor = .lightGray
        birthYearTextField.backgroundColor = .lightGray
    }
    
    func segmentedControlConfigure() {
        if #available(iOS 13.0, *) {
            //Storyboard handles it
        
        } else {
            sexSegmentedControl.backgroundColor = .white
            statusSegmentedControl.backgroundColor = .white
            
            sexSegmentedControl.tintColor = .lightGray
            statusSegmentedControl.tintColor = .lightGray
        }
    }
    
}
