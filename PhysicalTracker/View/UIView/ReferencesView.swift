//
//  ReferencesView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 17/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ReferencesView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiTextView: UITextView!
    @IBOutlet weak var surveyLabel: UILabel!
    @IBOutlet weak var surveyTextView: UITextView!
    @IBOutlet weak var testsLabel: UILabel!
    @IBOutlet weak var testsTextView: UITextView!
    
    //MARK: - Methods
    func setupUI() {
        testsTextView.text = testsTextView.text.convertStringIntoListOfString(testsTextView.text)
    }
    
}
