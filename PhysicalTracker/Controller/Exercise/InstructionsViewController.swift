//
//  InstructionsViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 07/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class InstructionsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var instructionsView: InstructionsView!
    
    //MARK: - Properties
    var exerciseKey: String?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.instructions + NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.title, comment: ""))
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        // Instructions TexView setup method
        instructionsView.instructionsTextViewConfigure(instructions: NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.instructions, comment: ""))
        
        // Skip Label configure method
        instructionsView.skipLabelConfigure(exerciseKey: exerciseKey)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.instructions + NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.title, comment: ""))
    }
    
    //MARK: - Actions
    @IBAction func swipeToVideoVC(_ sender: UISwipeGestureRecognizer) {
        if exerciseKey == Constants.RessourcesStrings.sixWalk {
            performSegue(withIdentifier: Constants.SeguesIdentifiers.goToGetReadyDirectlySegue, sender: self)
        } else {
            performSegue(withIdentifier: Constants.SeguesIdentifiers.videoSegue, sender: self)
        }
    }
    
    //MARK : - Methods
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.SeguesIdentifiers.videoSegue:
            if let destinationVC = segue.destination as? VideoViewController {
                destinationVC.exerciseKey = exerciseKey
            }
            
        case Constants.SeguesIdentifiers.goToGetReadyDirectlySegue:
            if let destinationVC = segue.destination as? GetReadyViewController {
                destinationVC.exerciseKey = exerciseKey
            }
        default:
            break
        }
    }
    
}
