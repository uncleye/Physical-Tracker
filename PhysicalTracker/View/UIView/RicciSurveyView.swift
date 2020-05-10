//
//  RicciSurveyView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 15/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class RicciSurveyView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var ricciQuestionsTextView: UITextView!
    @IBOutlet weak var backToPreviousQuestionButton: UIButton!
    
    //MARK: - Methods
    func ricciQuestionsTextViewSetup(text: String) {
        ricciQuestionsTextView.text = text
    }
    
    func setupBackToPreviousButton(step: Int) {
        if step == 0 {
            backToPreviousQuestionButton.isHidden = true
        } else {
            backToPreviousQuestionButton.isHidden = false
        }
    }
    
}
