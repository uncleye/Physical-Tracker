//
//  KeepResultsViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 21/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import KRProgressHUD

class KeepResultsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var keepResultsView: KeepResultsView!
    
    //MARK - Properties
    var exerciseKey: String?
    var time: Int?
    var databaseService = DatabaseService()
    
    // PickerView
    let pickerView = UIPickerView()
    fileprivate let toolbarPickerView = ToolbarPickerView()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
       
        // Setup differents elements of the UI
        keepResultsView.setupUI()
        keepResultsView.setupTimeLabel(time: time)
        keepResultsView.titleLabelAndGradingTextFieldConfigure(exerciseKey: exerciseKey, pickerView: pickerView, toolbarPickerView: toolbarPickerView)
        keepResultsView.setupAddTargetIsNotEmptyTextFields()
        
        // Set Toolbar delegate to VC
        toolbarPickerView.toolbarDelegate = self
        
        // PickerView setup method
        setupPickerView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
        
    }
    
    //MARK: - Actions
    @IBAction func resultsTextFieldIsChanging(_ sender: UITextField) {
        if exerciseKey == Constants.RessourcesStrings.step {
            keepResultsView.pulsePerMinuteLabel.text = keepResultsView.convertResultIntoPulsesPerMinute(sender: sender) + Constants.Labels.pulsesPerMinute
        }
        
    }
    
    @IBAction func startAgainButtonTapped(_ sender: UIButton) {
        navigationController?.popToViewController(ofClass: InstructionsViewController.self)
    }
    
    @IBAction func keepResultButtonTapped(_ sender: UIButton) {
        if keepResultsView.gradingTextField.text?.isEmpty == true && keepResultsView.gradingTextField.isHidden == false {
            showAlert(title: "Erreur !", message: "Veuillez inscrire votre résultat !")
        } else if keepResultsView.timeLabel.isHidden == false {
            keepButtonIsTapped()
            
            navigationController?.popToRootViewController(animated: true)
        } else if keepResultsView.gradingTextField.text?.isEmpty == false {
            keepButtonIsTapped()
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func keepResultAndShowResultsButtonTapped(_ sender: UIButton) {
        if keepResultsView.gradingTextField.text?.isEmpty == true && keepResultsView.gradingTextField.isHidden == false {
            showAlert(title: "Erreur !", message: "Veuillez inscrire votre résultat !")
            
        } else if keepResultsView.timeLabel.isHidden == false {
            keepButtonIsTapped()
            
            performSegue(withIdentifier: Constants.SeguesIdentifiers.checkResultsSegue, sender: self)
            
        } else if keepResultsView.gradingTextField.text?.isEmpty == false {
            keepButtonIsTapped()
            
            performSegue(withIdentifier: Constants.SeguesIdentifiers.checkResultsSegue, sender: self)
        }
    }
        
    @IBAction func useFrequencymeter(_ sender: UISwitch) {
        if sender.isOn {
            keepResultsView.titleLabel.text = Constants.Labels.numberOfPulsesIn1Min
            
            keepResultsView.pulsePerMinuteLabel.isHidden = true
        
            sender.setOn(true, animated: true)
        } else {
            keepResultsView.titleLabel.text = Constants.Labels.numberOfPulsesIn15Sec
            
            keepResultsView.pulsePerMinuteLabel.isHidden = false
            keepResultsView.pulsePerMinuteLabel.text = String(describing: keepResultsView.convertResultIntoPulsesPerMinute(sender: keepResultsView.gradingTextField)) + Constants.Labels.pulsesPerMinute
            
            sender.setOn(false, animated: true)
        }
    }
    
    //MARK: - Methods
    private func keepButtonIsTapped() {
        var result = Int()
        let exerciseDuration = Int(NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.duration, comment: ""))
        
        if exerciseKey == Constants.RessourcesStrings.handGround||exerciseKey == Constants.RessourcesStrings.shoulders {
            result = pickerView.selectedRow(inComponent: 0) + 1
            
        } else {
            
            switch exerciseDuration {
            case -1:
                result = Int(keepResultsView.gradingTextField.text ?? "0") ?? -1
                break
            case 0:
                result = time ?? 0
                break
            case let x where x! > 0:
                result = Int(keepResultsView.gradingTextField.text ?? "0") ?? -2
                
                if exerciseKey == Constants.RessourcesStrings.step {
                    if (!keepResultsView.frequencymeterSwitch.isOn) {
                        result = (Int(keepResultsView.gradingTextField.text ?? "0")! * 4)
                    } else{
                        result = Int(keepResultsView.gradingTextField.text ?? "0")!
                    }
                }
                break
            default:
                break
            }
            
        }
        
        postData(result: String(result))
        
        UserManager.shared.currentUser.resultDictionary.updateValue(result, forKey: (exerciseKey ?? ""))
        
        UserManager.shared.updateCurrentUser()
        
        UserManager.shared.updateModifiedUserInUsersArray()
        
    }
    
    private func postData(result: String) {
        KRProgressHUD.show()
        KRProgressHUD.show(withMessage: "Envoi du résultat...")
        
        databaseService.postData(isCreatingProfile: false, idQuiz: Constants.RessourcesStrings.idQuiz533, parameters: buildResultsRequest(execiseKey: exerciseKey!, result: String(result))) { success in
        
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                    KRProgressHUD.showOn(self).showSuccess(withMessage: "Résultat envoyé avec succès !")
                }
            } else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Désolé !", message: "Votre résultat n'a pas pu être envoyé à la base de données !")
            }
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.checkResultsSegue,
            let destinationVC = segue.destination as? ResultsViewController {
         
            destinationVC.backToMenuButtonIsHidden = false
            destinationVC.backItemNavigationBarIsHidden = true
        }
    }
    
    // Method to dismiss keyboard by tapping anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


//MARK: - UIPickerView Helpers methods
extension KeepResultsViewController {
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.reloadAllComponents()
    }
    
    private func setupPickerViewGradingsDatas() -> [String] {
        switch exerciseKey {
        case Constants.RessourcesStrings.shoulders:
            return NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.grading, comment: "").split(separator: "|").map(String.init)
        case Constants.RessourcesStrings.sitReach:
            return NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.grading, comment: "").split(separator: "|").map(String.init)
        case Constants.RessourcesStrings.handGround:
            return NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.grading, comment: "").split(separator: "|").map(String.init)
        default:
            return []
        }
    }
}


//MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension KeepResultsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if keepResultsView.gradingTextField.isFirstResponder {
            return setupPickerViewGradingsDatas().count
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if keepResultsView.gradingTextField.isFirstResponder {
            return setupPickerViewGradingsDatas()[row]
        }
        
        return nil
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if keepResultsView.gradingTextField.isFirstResponder {
            let gradingSelected = setupPickerViewGradingsDatas()[row]
            keepResultsView.gradingTextField.text = gradingSelected
        }
    }
}


//MARK: - ToolbarPickerViewDelegate
extension KeepResultsViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        keepResultsView.gradingTextField.resignFirstResponder()
    }

    func didTapCancel() {
        keepResultsView.gradingTextField.text = nil
        keepResultsView.gradingTextField.resignFirstResponder()
    }
}


//MARK: - Build Request
extension KeepResultsViewController {
    private func buildResultsRequest(execiseKey: String, result: String) -> [String:String] {
        var dictionary = [String:String]()
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dictionary[Constants.RessourcesStrings.inputUserIdentifier] = UserManager.shared.currentUser.userId
        dictionary[Constants.RessourcesStrings.inputDate] = dateFormatter.string(from: currentDateTime)
        dictionary[Constants.RessourcesStrings.inputTest] = exerciseKey
        dictionary[Constants.RessourcesStrings.inputData1] = result
        
        print(dictionary)
        
        return dictionary
    }
}
