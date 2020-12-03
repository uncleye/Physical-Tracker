//
//  ListOfProfilesViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ListOfProfilesViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var listOfProfilesTableView: UITableView!
    
    //MARK: - Properties
    // UserDefault property
    let decoded  = UserDefaults.standard.data(forKey: "usersArray")
    var users = [User]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.listOfProfiles)
        setupNavigationBarIsHidden(false, false)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        
        // Load & Reload users array
        UserManager.shared.getUsersArray()
        
        // Init users
        users = UserManager.shared.usersArray
        
        // Set listOfProfilesTableView FooterView
        listOfProfilesTableView.tableFooterView = UIView()
        
        // Set checkmark on the current user cell
        setupCheckmarkOnCell()

        listOfProfilesTableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.listOfProfiles)
        
        // Load & Reload users array
        UserManager.shared.getUsersArray()
        
        // Init users
        users = UserManager.shared.usersArray
        
        listOfProfilesTableView.reloadData()
        
    }

    //MARK: - Methods
    // Setup Checkmark on the current user cell: to know who is the current user
    private func setupCheckmarkOnCell() {
        let decoded  = UserDefaults.standard.data(forKey: "currentUserCellRow")
        
        if decoded != nil {
            let indexPathOfCurrentUser = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! IndexPath
            let cell = listOfProfilesTableView.cellForRow(at: indexPathOfCurrentUser)
            cell?.accessoryType = .checkmark
        }
    }
    
    // Alerts
    private func alertActionsHandler(action: UIAlertAction) {
        switch action.title {
        case Constants.Labels.yes:
            if let indexPath = self.listOfProfilesTableView.indexPathForSelectedRow {
                UserManager.shared.setCurrentUser(index: indexPath.row)
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: indexPath)
                //Stock which cell the current user cell is
                UserDefaults.standard.set(encodedData, forKey: "currentUserCellRow")
                
                //Remove the checkmark for all cells
                for index in 0...listOfProfilesTableView.numberOfRows(inSection: 0){
                    let cell = listOfProfilesTableView.cellForRow(at: IndexPath(row: index, section: 0))
                    cell?.accessoryType = .none
                }
                
                listOfProfilesTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                
                setupAlert(title: Constants.Labels.consultProfileDetailed, message: Constants.Labels.askToConsultProfileDetailed, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
            }
            
        case Constants.Labels.no:
            if self.listOfProfilesTableView.indexPathForSelectedRow != nil {
                setupAlert(title: Constants.Labels.consultProfileDetailed, message: Constants.Labels.askToConsultProfileDetailed, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
            }
            
        case Constants.Labels.now:
            performSegue(withIdentifier: Constants.SeguesIdentifiers.detailedProfileSegue, sender: self)
        default:
            break
        }
    }

    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.detailedProfileSegue,
            let detailedProfileVC = segue.destination as? DetailedProfileViewController,
            let indexPath = self.listOfProfilesTableView.indexPathForSelectedRow {
            
            detailedProfileVC.user = users[indexPath.row]
            detailedProfileVC.indexUser = indexPath.row
            detailedProfileVC.users = users
        }
    }
    
}


//MARK: - UITableViewDataSource
extension ListOfProfilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = listOfProfilesTableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.userNameLabel?.text = users[indexPath.row].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alertController = UIAlertController(title: Constants.Labels.suppressProfile, message: Constants.Labels.askToDeleteProfile, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: Constants.Labels.cancel, style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: Constants.Labels.erase, style: .destructive, handler: { (action) in
                self.users.remove(at: indexPath.row)
                
                let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self.users)
                UserDefaults.standard.set(encodedData, forKey: "usersArray")
                
                UserManager.shared.removeCurrentUser(index: indexPath.row)

                self.listOfProfilesTableView.beginUpdates()
                self.listOfProfilesTableView.deleteRows(at: [indexPath], with: .fade)
                self.listOfProfilesTableView.endUpdates()
                self.listOfProfilesTableView.reloadData()
            })
            
            alertController.addAction(deleteAction)

            present(alertController, animated: true, completion: nil)
        }
    }
}


//MARK: - UITableViewDelegate
extension ListOfProfilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return users.isEmpty ? 220 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Appuyez sur le bouton '+' pour créer un nouveau profil."
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .gray
        
        return label
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listOfProfilesTableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            listOfProfilesTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
            setupAlert(title: Constants.Labels.consultProfileDetailed, message: Constants.Labels.askToConsultProfileDetailed, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
        }
        
        setupAlert(title: Constants.Labels.setCurrentUser, message: Constants.Labels.askToSetCurrentUser, actionsTitles: [Constants.Labels.no, Constants.Labels.yes], alertAction: alertActionsHandler)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        setupAlert(title: Constants.Labels.setCurrentUser, message: Constants.Labels.askToSetCurrentUser, actionsTitles: [Constants.Labels.no, Constants.Labels.yes], alertAction: alertActionsHandler)
    }
}
