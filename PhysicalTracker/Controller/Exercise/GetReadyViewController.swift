//
//  GetReadyViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 09/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class GetReadyViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var getReadyView: GetReadyView!
    
    //MARK: - Properties
    var exerciseKey: String?
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, true)
       
        // Buttons setup method
        getReadyView.setupButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, true)

    }
    
    //MARK: - Actions
    @IBAction func startExercise(_ sender: UIButton) {
        let userName = UserManager.shared.currentUser.userName
        
        UserManager.shared.getUsersArray()
        
        if !UserManager.shared.getCurrentUser() && UserManager.shared.usersArray.count > 0 {
            self.showAlert(title: "Définir Utilisateur Actuel", message: "Vous devez définir un profil comme utilisateur actuel !")
        }
        
        // To know if there is a currentUser
        if !UserManager.shared.getCurrentUser() {
            setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createFirstProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
            print("no currentuser")
        } else {
            setupAlert(title: Constants.Labels.verifyProfile, message: "Êtes-vous " + userName + " ?", actionsTitles: [Constants.Labels.no, Constants.Labels.yes], alertAction: alertActionsHandler)
        }
    }
    
    @IBAction func getBackToMainPage(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Methods        
    private func alertActionsHandler(action: UIAlertAction) {
        let exerciseDuration = Int(NSLocalizedString((exerciseKey ?? "") + Constants.RessourcesStrings.duration, comment: ""))
        
        UserManager.shared.getUsersArray()
        
        print("there is currentuser")
        
        switch action.title {
        case Constants.Labels.yes:
            switch exerciseDuration {
            case let x where x! > 0:
                performSegue(withIdentifier: Constants.SeguesIdentifiers.circularTimerRingSegue, sender: self)
                break
            case 0:
                performSegue(withIdentifier: Constants.SeguesIdentifiers.timerSegue, sender: self)
                break
            case -1:
                performSegue(withIdentifier: Constants.SeguesIdentifiers.goToKeepResultsDirectlySegue, sender: self)
                break
            default:
                break
            }
            
        case Constants.Labels.no:
            switch UserManager.shared.usersArray.count {
               case 0:
                setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createNewProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
               case 1:
                setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createNewProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
               case let x where x > 1:
                   performSegue(withIdentifier: Constants.SeguesIdentifiers.fromGetReadyToListOfProfilesSegue, sender: self)
               default:
                   break
               }
            
        case Constants.Labels.now:
            performSegue(withIdentifier: Constants.SeguesIdentifiers.createProfileSegue, sender: self)
            
        default:
            break
        }
    }
    
    //Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.SeguesIdentifiers.circularTimerRingSegue:
            if let destinationVC = segue.destination as? CircularTimerRingViewController {
                destinationVC.exerciseKey = exerciseKey
            }
        case Constants.SeguesIdentifiers.goToKeepResultsDirectlySegue:
            if let destinationVC = segue.destination as? KeepResultsViewController {
                destinationVC.exerciseKey = exerciseKey
            }
        case Constants.SeguesIdentifiers.timerSegue:
            if let destinationVC = segue.destination as? TimerViewController {
                destinationVC.exerciseKey = exerciseKey
            }
        default:
            break
        }
    }
    
}
