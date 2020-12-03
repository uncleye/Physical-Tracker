//
//  ResultsView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 20/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ResultsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var gradingScaleColorBmiView: UIView!
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var gradingScalePhysicalLevelView: UIView!
    @IBOutlet weak var physicalLevelLabel: UILabel!
    @IBOutlet weak var shareScrollView: UIScrollView!
    @IBOutlet weak var scrollViewSuperview: UIView!
    @IBOutlet weak var scrollViewContentView: UIView!
    @IBOutlet weak var backToMainPageButton: UIButton!
    
    //MARK: - Methods
    func setupUI() {
        let views = [gradingScaleColorBmiView, gradingScalePhysicalLevelView]
        
        views.forEach { (view) in
            view?.layer.borderWidth = 1
        }
        
        setupGradingScaleColorBMI(view: gradingScaleColorBmiView)
        
        if (UserManager.shared.currentUser.ricciResult != 0) {
            setupGradingScaleColorRicci(view: gradingScalePhysicalLevelView)
        }
        
        bmiLabel.text = setupBMIValue()
        physicalLevelLabel.text = setupPhysicalLevelLabel()
        
    }
    
    func setupBorderButton() {
        backToMainPageButton.layer.borderColor = UIColor.lightGray.cgColor
        backToMainPageButton.layer.borderWidth = 1
        backToMainPageButton.layer.cornerRadius = 0.01 * backToMainPageButton.bounds.size.width
    }
    
}
