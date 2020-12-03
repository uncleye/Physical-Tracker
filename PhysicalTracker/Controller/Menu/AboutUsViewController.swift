//
//  AboutUsViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 17/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var aboutUsView: AboutUsView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.aboutUs)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        // UI setup method
        aboutUsView.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup methods
        setupNavigationControllerTitle(Constants.Labels.aboutUs)
        
    }
}
