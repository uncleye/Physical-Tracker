//
//  InterpretationsView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 31/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class InterpretationsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var interpretationsScrollView: UIScrollView!
    @IBOutlet weak var interpretationsScrollViewContentView: UIView!
    @IBOutlet weak var bmiGradingView: UIView!
    @IBOutlet weak var bmiGradingLabel: UILabel!
    @IBOutlet weak var bmiAdviceLabel: UILabel!
    @IBOutlet weak var physicalActivityGradingView: UIView!
    @IBOutlet weak var physicalActivityGradingLabel: UILabel!
    @IBOutlet weak var physicalActivityAdviceLabel: UILabel!
    @IBOutlet weak var physicalConditionGradingViewRed: UIView!
    @IBOutlet weak var physicalConditionGradingViewOrange: UIView!
    @IBOutlet weak var physicalConditionGradingViewYellow: UIView!
    @IBOutlet weak var physicalConditionGradingViewBlue: UIView!
    @IBOutlet weak var physicalConditionGradingViewGreen: UIView!
    
    //MARK: - Methods
    func setupUI() {
        let views = [bmiGradingView, physicalActivityGradingView, physicalConditionGradingViewRed, physicalConditionGradingViewOrange, physicalConditionGradingViewYellow, physicalConditionGradingViewBlue, physicalConditionGradingViewGreen]
        
        views.forEach { (view) in
            view?.layer.borderWidth = 1
        }
        
        setupGradingScaleColorBMI(view: bmiGradingView)
        
        if (UserManager.shared.currentUser.ricciResult != 0) {
             setupGradingScaleColorRicci(view: physicalActivityGradingView)
         }
       
        bmiGradingLabel.text = setupGradingTextBMI()
        bmiAdviceLabel.text = setupGradingAdviceBMI()
        
        physicalActivityGradingLabel.text = setupPhysicalLevelText()
        physicalActivityAdviceLabel.text = setupPhysicalLevelGradingAdvice()
    }
    
}
