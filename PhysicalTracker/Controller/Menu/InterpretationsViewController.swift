//
//  InterpretationsViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 31/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class InterpretationsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var interpretationsView: InterpretationsView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.interpretation)
       
        // UI setup method
        interpretationsView.setupUI()
    }

}
