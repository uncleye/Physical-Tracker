//
//  AboutUsView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 17/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class AboutUsView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstDescriptionTextView: UITextView!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var secondDescriptionTextView: UITextView!
    @IBOutlet weak var thirdNameLabel: UILabel!
    @IBOutlet weak var thirdDescriptionTextView: UITextView!
    @IBOutlet weak var mgenTextView: UITextView!
    @IBOutlet weak var dynseoTextView: UITextView!
    @IBOutlet weak var coqSportifTextView: UITextView!
    
    //MARK: - Methods
    func setupUI() {
        firstDescriptionTextView.text = Constants.Texts.thierryBarriere
        
        secondDescriptionTextView.text = Constants.Texts.philippeDecq
        
        thirdDescriptionTextView.text = Constants.Texts.samiaSerri

    }
    
}
