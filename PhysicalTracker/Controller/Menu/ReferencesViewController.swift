//
//  ReferencesViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 17/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ReferencesViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var referencesView: ReferencesView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.references)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        referencesView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.references)
    }

}
