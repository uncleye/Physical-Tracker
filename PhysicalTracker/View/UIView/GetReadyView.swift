//
//  GetReadyView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 09/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class GetReadyView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var startExerciseButton: UIButton!
    @IBOutlet weak var backToMainPageButton: UIButton!
    
    //MARK: - Methods
    func setupButtons() {
        startExerciseButton.layer.borderColor = UIColor.lightGray.cgColor
        startExerciseButton.layer.borderWidth = 1
        startExerciseButton.layer.cornerRadius = 0.01 * startExerciseButton.bounds.size.width
        
        backToMainPageButton.layer.borderColor = UIColor.lightGray.cgColor
        backToMainPageButton.layer.borderWidth = 1
        backToMainPageButton.layer.cornerRadius = 0.01 * backToMainPageButton.bounds.size.width
    }
    
}
