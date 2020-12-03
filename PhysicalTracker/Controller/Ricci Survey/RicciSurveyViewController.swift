//
//  RicciSurveyViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 15/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import KRProgressHUD

class RicciSurveyViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var ricciAnswersTableView: UITableView!
    @IBOutlet weak var ricciSurveyView: RicciSurveyView!
    
    //MARK: - Properties
    let questions = NSLocalizedString(Constants.RessourcesStrings.ricciQuestions, comment: "").split(separator: "|").map(String.init)
    var answers = [[String]]()
    var choiceMade = Array(repeating: 7, count: 10)
    
    // Database Service
    let databaseService = DatabaseService()
    
    // Handle score properties
    var step = 0
    var score = 0
    var diffScore = 0
    var isPraticingExercise = true

    // End button property
    var endButton = UIButton()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.surveyRicciGagnon)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        // Questions & Answers setup method
        setupAnswersAndQuestions()
        
        // QuestionsTextView setup method
        ricciSurveyView.ricciQuestionsTextViewSetup(text: questions[step])
        
        // BackToPreviousButton setup method
        ricciSurveyView.setupBackToPreviousButton(step: step)
        
        // Set ricciAnswersTableView FooterView
        ricciAnswersTableView.tableFooterView = UIView()
        
        ricciAnswersTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.surveyRicciGagnon)
        
    }
    
    //MARK: - Actions
    @IBAction func backToPreviousQuestion(_ sender: UIButton) {
        backToPreviousQuestionButtonIsTapped()
    }
    
    //MARK: - Methods
    private func setupAnswersAndQuestions() {
        for question in 0...questions.count - 1 {
            let answerString = NSLocalizedString(Constants.RessourcesStrings.answers + String(describing: question), comment: "").split(separator: "|").map(String.init)
            answers.append(answerString)
        }
    }
    
    private func backToPreviousQuestionButtonIsTapped() {
        if !isPraticingExercise && step == 5 {
            step -= 3
            isPraticingExercise = true
        }
        
        step -= 1
        
        ricciSurveyView.ricciQuestionsTextViewSetup(text: questions[step])
        
        ricciAnswersTableView.reloadData()
        
        ricciSurveyView.setupBackToPreviousButton(step: step)
        
        endButton.isHidden = true
        
        score -= diffScore
    }
    
}

//MARK: - UIButton Helpers Methods
extension RicciSurveyViewController {
    private func setupFinishButton() {
        endButton = UIButton(frame: CGRect(x: self.view.center.x - 50, y: self.view.center.y - 30, width: 100, height: 35))
        
        endButton.setTitle(Constants.Labels.endTitleButton, for: .normal)
        endButton.titleLabel?.font = UIFont(name: Constants.Fonts.rubikMedium, size: 15)
        endButton.titleLabel?.textColor = UIColor.white
        endButton.backgroundColor = Constants.Colors.redUIColor
        endButton.layer.cornerRadius = 0.03 * endButton.bounds.size.width
        endButton.addTarget(self, action: #selector(finishButtonisTapped), for: .touchUpInside)
        
        self.view.addSubview(endButton)
    }
    
    @objc private func finishButtonisTapped() {
        UserManager.shared.currentUser.ricciResult = score
        UserManager.shared.updateCurrentUser()
        UserManager.shared.saveRicciSurveyResult()
        
        postData()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func postData() {
        KRProgressHUD.show()
        KRProgressHUD.show(withMessage: "Envoi du score...")
        
        databaseService.postData(isCreatingProfile: false, idQuiz: Constants.RessourcesStrings.idQuiz533, parameters: buildSurveyScoreRequest(score: String(score))) { (success) in
            
            if success {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.8) {
                    KRProgressHUD.showOn(self).showSuccess(withMessage: "Score envoyé avec succès !")
                }
            } else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Désolé !", message: "Votre score n'a pas pu être envoyé à la base de données !")
            }
        }
    }
    
}


//MARK: - UITableViewDataSource
extension RicciSurveyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers[step].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if step == 9 {
            return 0
        }
        return ricciAnswersTableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = ricciAnswersTableView.dequeueReusableCell(withIdentifier: RicciAnswersTableViewCell.identifier, for: indexPath) as? RicciAnswersTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textLabel?.text = answers[step][indexPath.row]
        cell.ricciAnswersTableViewCellConfigure()
        
        if indexPath.row == choiceMade[step] {
            cell.textLabel?.font = UIFont(name: Constants.Fonts.rubikMedium, size: 16)
        }
        
        return cell
    }
}


//MARK: - UITableViewDelegate
extension RicciSurveyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if step < 9 {
            switch indexPath.row {
            case 0:
                diffScore = 1
                
                if answers[step].count == 2{
                    choiceMade[step] = indexPath.row
                    step += 3
                    isPraticingExercise = false
                }
                
                break
            case 1:
                if answers[step].count == 2 {
                    diffScore = 5
                    isPraticingExercise = true
                } else {
                    diffScore = 2
                }
                
                break
            case 2:
                diffScore = 3
                break
            case 3:
                diffScore = 4
                break
            case 4:
                diffScore = 5
                break
            default:
                break
            }
            
            score += diffScore
            
            if (isPraticingExercise || step >= 5) {
                choiceMade[step] = indexPath.row
            }
            
            step += 1
            print("step" + String(step))
            
            if step == 9 {
                ricciAnswersTableView.reloadData()
                ricciSurveyView.ricciQuestionsTextViewSetup(text: Constants.Labels.endSurveyText)
                setupFinishButton()
            } else {
                ricciSurveyView.ricciQuestionsTextViewSetup(text: questions[step])
                ricciAnswersTableView.reloadData()
                ricciSurveyView.setupBackToPreviousButton(step: step)
            }
        }
    }
    
}


//MARK: - Build Request
extension RicciSurveyViewController {
    private func buildSurveyScoreRequest(score: String) -> [String:String] {
        var dictionary = [String:String]()
        
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        dictionary[Constants.RessourcesStrings.inputUserIdentifier] = UserManager.shared.currentUser.userId
        dictionary[Constants.RessourcesStrings.inputDate] = dateFormatter.string(from: currentDateTime)
        dictionary[Constants.RessourcesStrings.inputTest] = Constants.RessourcesStrings.ricciGagnon
        dictionary[Constants.RessourcesStrings.inputData1] = score
        
        print(dictionary)
        
        return dictionary
    }
}
