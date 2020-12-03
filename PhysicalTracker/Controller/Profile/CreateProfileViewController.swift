//
//  CreateProfileViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import KRProgressHUD

class CreateProfileViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var createProfileView: CreateProfileView!
    
    //MARK: - Properties
    let databaseService = DatabaseService()
    var user: User?
    var users = [User]()
    
    // Modify Profile UI properties
    var isEditable = true
    var sexSegmentedControlSelectedIndex = 0
    var statusSegmentedControlSelectedIndex = 0
    var isCreatingProfile = true
    var numberOfPostIsSent = 0
    var numberOfPostIsModified = 0
    var isBMIModified = true
    var isStatusModified = true
    
    // PickerView
    let pickerView = UIPickerView()
    fileprivate let toolbarPickerView = ToolbarPickerView()
    
    // PickerView Data
    let pickerViewDomainsDatas = NSLocalizedString(Constants.RessourcesStrings.studentCategories, comment: "").split(separator: "|").map(String.init)
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.createYourProfile)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        // Load & Reload UsersArray
        UserManager.shared.getUsersArray()
        
        // Init users
        users = UserManager.shared.usersArray
        
        // PickerView setup method
        setupPickerView()
        
        // Set toolbarDelegate to VC
        toolbarPickerView.toolbarDelegate = self
        
        // Set textfieldsDelegates to VC
        textsFieldsDelegates()
        
        // UI setup methods
        createProfileView.setupAddTargetIsNotEmptyTextFields()
        createProfileView.setupButtons()
        createProfileView.buttonsAreHidden()
        createProfileView.startButton.setupIsEnabled(createProfileView.startButton, isEnabled: false)
        createProfileView.segmentedControlConfigure()
        
        setupDomainTextFieldIsHidden()
        
        // ModifyProfile UI setup method
        setupModifyProfileUI()
        
    }
    
    //MARK: - Actions
    @IBAction func statusSegmentedControlTapped(_ sender: UISegmentedControl) {
        setupDomainTextFieldIsHidden()
    }
    
    @IBAction func startButtonIsTapped(_ sender: UIButton) {
        startButtonTapped(sender: sender)
    }
    
    @IBAction func cancelButtonIsTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func modifyButtonIsTapped(_ sender: UIButton) {
        modifyButtonTapped(sender: sender)
    }
    
    //MARK: - Methods
    private func startButtonTapped(sender: UIButton) {
        isCreatingProfile = true
        
        let newUser = User(userId: "101", userName: (createProfileView.firstNameTextField.text ?? "")  + (createProfileView.lastNameTextField.text ?? ""),ricciResult: 0, birthyear: Int(createProfileView.birthYearTextField.text ?? "") ?? 0, height: Int(createProfileView.heightTextField.text ?? "") ?? 0, weight: Int(createProfileView.weightTextField.text ?? "") ?? 0, sex:  createProfileView.sexSegmentedControl.selectedSegmentIndex , status: (createProfileView.statusSegmentedControl.titleForSegment(at: createProfileView.statusSegmentedControl.selectedSegmentIndex) ?? ""), domain: createProfileView.domainTextField.text ?? "", descriptions: createProfileView.domainTextField.text ?? "", resultDictionary: ["":0])
        
        switch user?.status {
        case Constants.RessourcesStrings.student:
            user?.descriptions = ""
            break
        case Constants.RessourcesStrings.other:
            user?.domain = ""
            break
        default:
            break
        }
        
        // Check value into text fields and post data to database
        let isValueCorrect = setupRestrictionsIntoTextFields(isCreatingProfile: isCreatingProfile, user: newUser, idQuiz: Constants.RessourcesStrings.idQuiz532, sender: sender)
        
        if isValueCorrect {
            // Get userId from response Database
            newUser.userId = UserManager.shared.currentUser.userId
            
            users.append(newUser)
            
            UserManager.shared.setUsersArray(users: users)
            
            UserManager.shared.setCurrentUser(index: users.count - 1)
            
            let indexPath = IndexPath(row: users.count - 1, section: 0)
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: indexPath)
            
            // Stock which cell the current user cell is
            UserDefaults.standard.set(encodedData, forKey: "currentUserCellRow")
            
            // Move back to MainPage screen
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func modifyButtonTapped(sender: UIButton) {
        isCreatingProfile = false
        
        // Send only height or weight related data to database
        isBMIModified = !((user?.height==Int(createProfileView.heightTextField.text!)!) && (user?.weight == Int(createProfileView.weightTextField.text!)!))
        
        let isDomaineModified = user?.domain == createProfileView.domainTextField.text!
        let isDescriptionModified = user?.descriptions == createProfileView.domainTextField.text!
        
        // Send only status related data to database
        isStatusModified = !((user?.status == (createProfileView.statusSegmentedControl.titleForSegment(at: createProfileView.statusSegmentedControl.selectedSegmentIndex) ?? "")) && isDomaineModified && isDescriptionModified)
        
        user?.height = Int(createProfileView.heightTextField.text!)!
        user?.weight = Int(createProfileView.weightTextField.text!)!
        user?.status = (createProfileView.statusSegmentedControl.titleForSegment(at: createProfileView.statusSegmentedControl.selectedSegmentIndex) ?? "")
        
        switch createProfileView.statusSegmentedControl.selectedSegmentIndex {
        case 0:
            user?.domain = createProfileView.domainTextField.text!
            user?.descriptions = ""
            break
            
        case 1:
            user?.domain = ""
            user?.descriptions = ""
            break
            
        case 2:
            user?.descriptions = createProfileView.domainTextField.text!
            user?.domain = ""
            break
            
        default:
            break
        }
        
        // Check value into text fields and post modified data to database
        let isValueAvailable : Bool = setupRestrictionsIntoTextFields(isCreatingProfile: isCreatingProfile, user: user, idQuiz: Constants.RessourcesStrings.idQuiz533, sender: sender)
        
        if isValueAvailable {
            UserManager.shared.updateCertaindUserInUsersArray(user: user!)
            
            UserManager.shared.setCurrentUsersArray()
            
            if (UserManager.shared.currentUser.userName == user?.userName) {
                UserManager.shared.currentUser = user!
                UserManager.shared.updateCurrentUser()
            }
            
            navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    // Modify Profile UI
    private func setupModifyProfileUI() {
        if isEditable == false {
            setupNavigationControllerTitle(Constants.Labels.modifyProfile)
            
            createProfileView.setupUiIsEditable(isEditable)
            createProfileView.setupModifyProfileUI(user: user!, sexIndex: sexSegmentedControlSelectedIndex, statusIndex: statusSegmentedControlSelectedIndex)
            createProfileView.setupButtonsAreHiddenForModifyProfileUI()
            createProfileView.setupTextFieldsAreNotEnabledBackgroundColor()
            
            if statusSegmentedControlSelectedIndex == 1 {
                createProfileView.setupDomainTextField(isHidden: true, inputView: nil, inputAccessoryView: nil, placeholder: "", text: "Aucun domaine")
            }
            
            if statusSegmentedControlSelectedIndex == 2 {
                createProfileView.setupDomainTextField(isHidden: false, inputView: nil, inputAccessoryView: nil, placeholder: "Description", text: user?.descriptions)
            }
        }
        
    }
    
    // Method to dismiss keyboard by tapping anywhere on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


//MARK: - Post Data
extension CreateProfileViewController {
    private func postData(isCreatingProfile: Bool, user: User, idQuiz: String, parameters: [String:String], sender: UIButton) {
        if numberOfPostIsSent < 1 {
            KRProgressHUD.show()
            KRProgressHUD.show(withMessage: "Envoi des données en cours...")
        }
        
        databaseService.postData(isCreatingProfile: isCreatingProfile, idQuiz: idQuiz, parameters: parameters) { success in
            print("success: " + String(success))
            if success {
                if sender.tag == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                        KRProgressHUD.showOn(self).showSuccess(withMessage: "Profil créé avec succès !")
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                        if self.numberOfPostIsModified < 1 {
                            KRProgressHUD.showOn(self).showSuccess(withMessage: "Profil modifié avec succès !")
                            self.numberOfPostIsModified += 1
                        }
                    }
                }
                
            } else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Désolé !", message: "Les données de votre profil n'ont pas pu être envoyées correctement au serveur !")
            }
        }
        numberOfPostIsSent += 1
    }
    
}


//MARK: - UIPickerView
extension CreateProfileViewController {
    private func setupPickerView() {
        pickerView.delegate = self
        pickerView.backgroundColor = .white
        pickerView.reloadAllComponents()
    }
}


//MARK: - Text Field Helpers Methods
extension CreateProfileViewController {
    private func textsFieldsDelegates() {
        createProfileView.firstNameTextField.delegate = self
        createProfileView.lastNameTextField.delegate = self
        createProfileView.birthYearTextField.delegate = self
        createProfileView.heightTextField.delegate = self
        createProfileView.weightTextField.delegate = self
        createProfileView.domainTextField.delegate = self
    }
    
    //Method to setup if domainTextField is hidden or not
    private func setupDomainTextFieldIsHidden() {
        switch createProfileView.statusSegmentedControl.selectedSegmentIndex {
        case 0:
            createProfileView.setupAddTargetIsNotEmptyTextFields()
            
            createProfileView.setupDomainTextField(isHidden: false, inputView: pickerView, inputAccessoryView: self.toolbarPickerView.toolbar, placeholder: "Choisir un domaine", text: nil)
        case 1:
            createProfileView.setupAddTargetIsNotEmptyTextFields()
            
            createProfileView.setupDomainTextField(isHidden: true, inputView: nil, inputAccessoryView: nil, placeholder: "", text: "Aucun domaine")
            
            createProfileView.setupStartButtonIsEnabled()
        case 2:
            createProfileView.setupAddTargetIsNotEmptyTextFields()
            
            createProfileView.setupDomainTextField(isHidden: false, inputView: nil, inputAccessoryView: nil, placeholder: "Description", text: nil)
        default:
            break
        }
    }
    
    private func setupRestrictionsIntoTextFields(isCreatingProfile: Bool, user: User?, idQuiz: String, sender: UIButton) -> Bool {
        // Check if user has the same identifier with someone else
        if UserManager.shared.findIndexInUsersArray(user: user!) != -1&&isCreatingProfile {
            showAlert(title: Constants.Labels.error, message: Constants.Labels.nameAndFirstNameAlreadyTaken)
            
            return false
        }
        // Check if user is writing right values
        else if (createProfileView.birthYearTextField.text! as NSString).integerValue < 1920 || (createProfileView.weightTextField.text! as NSString).integerValue > 300 || (createProfileView.heightTextField.text! as NSString).integerValue > 250 {
            
            showAlert(title: Constants.Labels.error, message: Constants.Labels.writeRightValues)
            
            return false
            
        } else {
            if sender.tag == 1 {
                postData(isCreatingProfile: isCreatingProfile, user: user!, idQuiz: idQuiz, parameters: (user?.toDictionary())!, sender: sender)
            } else {
                let dictionnaryBMI = buildBmiRequest(data1: createProfileView.heightTextField.text!, data2: createProfileView.weightTextField.text!)
                let dictionnaryStatus = buildStatusRequest(data1: user?.status ?? "", data2: user?.descriptions ?? "", data3: user?.domain ?? "")
                if(isBMIModified){
                
                postData(isCreatingProfile: isCreatingProfile, user: user!, idQuiz: idQuiz, parameters: dictionnaryBMI, sender: sender)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    if(self.isStatusModified){
                        self.postData(isCreatingProfile: self.isCreatingProfile, user: self.user!, idQuiz: idQuiz, parameters: dictionnaryStatus, sender: sender)
                    }
                }
            }
            
            return true
        }
    }
    
}


//MARK: - UITextFieldDelegate
extension CreateProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 3
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if currentString == createProfileView.birthYearTextField.text! as NSString {
            let maxLength = 4
            return newString.length <= maxLength
        }
        
        if currentString == createProfileView.domainTextField.text! as NSString {
            let maxLength = 100
            return newString.length <= maxLength
        }
        
        return newString.length <= maxLength
    }
    
}


//MARK: - UIPickerViewDelegate & UIPickerViewDataSource
extension CreateProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if createProfileView.domainTextField.isFirstResponder {
            return pickerViewDomainsDatas.count
        }
        
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if createProfileView.domainTextField.isFirstResponder {
            return pickerViewDomainsDatas[row]
        }
        
        return nil
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if createProfileView.domainTextField.isFirstResponder {
            let domainSelected = pickerViewDomainsDatas[row]
            createProfileView.domainTextField.text = domainSelected
        }
    }
    
}


//MARK: - ToolbarPickerViewDelegate
extension CreateProfileViewController: ToolbarPickerViewDelegate {
    func didTapDone() {
        let row = self.pickerView.selectedRow(inComponent: 0)
        self.pickerView.selectRow(row, inComponent: 0, animated: false)
        createProfileView.domainTextField.resignFirstResponder()
    }
    
    func didTapCancel() {
        createProfileView.domainTextField.text = nil
        createProfileView.domainTextField.resignFirstResponder()
    }
    
}


//MARK: - Build Requests
extension CreateProfileViewController {
    private func buildBmiRequest(data1: String, data2: String) -> [String:String] {
        var dictionary = [String:String]()
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dictionary[Constants.RessourcesStrings.inputUserIdentifier] = user?.userId
        dictionary[Constants.RessourcesStrings.inputDate] = dateFormatter.string(from: currentDateTime)
        dictionary[Constants.RessourcesStrings.inputTest] = Constants.RessourcesStrings.bmi
        dictionary[Constants.RessourcesStrings.inputData1] = data1
        dictionary[Constants.RessourcesStrings.inputData2] = data2
        
        print(dictionary)
        
        return dictionary
    }
    
    private func buildStatusRequest(data1: String, data2: String, data3: String) -> [String:String] {
        var dictionary = [String:String]()
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
         dictionary[Constants.RessourcesStrings.inputUserIdentifier] = user?.userId
         dictionary[Constants.RessourcesStrings.inputDate] = dateFormatter.string(from: currentDateTime)
         dictionary[Constants.RessourcesStrings.inputTest] = Constants.RessourcesStrings.status
        
        switch data1 {
            case Constants.RessourcesStrings.student:
                dictionary[Constants.RessourcesStrings.inputData1] = Constants.RessourcesStrings.studentStatus
                break
                
            case Constants.RessourcesStrings.employee:
                dictionary[Constants.RessourcesStrings.inputData1] = Constants.RessourcesStrings.employeeStatus
                break
                
            case Constants.RessourcesStrings.other:
                dictionary[Constants.RessourcesStrings.inputData1] = Constants.RessourcesStrings.otherStatus
                dictionary[Constants.RessourcesStrings.inputData2] = data2
                break
                
            default:
                break
            }
            
            switch data3 {
            case Constants.RessourcesStrings.societiesAndHumanities:
                dictionary[Constants.RessourcesStrings.inputData3] = Constants.RessourcesStrings.sohu
                break
                
            case Constants.RessourcesStrings.health:
                dictionary[Constants.RessourcesStrings.inputData3] = Constants.RessourcesStrings.sant
                break
                
            case Constants.RessourcesStrings.sciences:
                dictionary[Constants.RessourcesStrings.inputData3] = Constants.RessourcesStrings.scie
                break
                
            case Constants.RessourcesStrings.staps:
                dictionary[Constants.RessourcesStrings.inputData3] = Constants.RessourcesStrings.stap
                break
                
            default:
                break
            }
        
        print(dictionary)
        
        return dictionary
    }

}
