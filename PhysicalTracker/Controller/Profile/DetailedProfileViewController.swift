//
//  DetailedProfileViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit 

class DetailedProfileViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var detailedProfileView: DetailedProfileView!
    
    //MARK: - Properties
    var user: User?
    var indexUser: Int?
    var users = [User]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.profileDetailed)
        
        // UI setup method
        detailedProfileView.setupUI(user: user)
        detailedProfileView.setupBordersButtons()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Reload users array
        users = UserManager.shared.usersArray
        
    }
    
    //MARK: - Actions
    @IBAction func modifyProfile(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.SeguesIdentifiers.modifyProfileSegue, sender: self)
    }
    
    @IBAction func deleteProfile(_ sender: UIButton) {
        showDeleteAlert(title: "Suppression du profil", message: "Voulez-vous supprimer ce profil ?")
    }
    
    //MARK: - Methods
    // Alert
    private func showDeleteAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.Labels.cancel, style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: Constants.Labels.erase, style: .destructive, handler: { (action) in
            self.users.remove(at: self.indexUser!)
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.users)
            
            UserDefaults.standard.set(encodedData, forKey: "usersArray")
            
            UserManager.shared.removeCurrentUser(index: self.indexUser!)
            
            self.navigationController?.popViewController(animated: true)
        })
        alertController.addAction(deleteAction)
    
        present(alertController, animated: true, completion: nil)
    }
    
    // Helper's method Segue
    private func setupSexSwitch(destinationVC: CreateProfileViewController) {
        switch user?.sex {
        case 0:
            destinationVC.sexSegmentedControlSelectedIndex = 0
        case 1:
            destinationVC.sexSegmentedControlSelectedIndex = 1
        default:
            break
        }
        
    }
    
    // Helper's method Segue
    private func setupStatusSwitch(destinationVC: CreateProfileViewController) {
        switch user?.status {
        case "Étudiant UP":
            destinationVC.statusSegmentedControlSelectedIndex = 0
        case "Personnel UP":
            destinationVC.statusSegmentedControlSelectedIndex = 1
        case "Autre":
            destinationVC.statusSegmentedControlSelectedIndex = 2
        default:
            break
        }
        
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.modifyProfileSegue,
            let destinationVC = segue.destination as? CreateProfileViewController {
            
            destinationVC.user = user
            destinationVC.isEditable = false
            
            setupSexSwitch(destinationVC: destinationVC)
            
            setupStatusSwitch(destinationVC: destinationVC)
            
        }
    }
    
}
