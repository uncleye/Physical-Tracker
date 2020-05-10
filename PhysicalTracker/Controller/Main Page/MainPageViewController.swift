//
//  MainPageViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 06/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import Floaty

class MainPageViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var mainPageTableView: UITableView!
    
    //MARK: - Properties
    let categoriesKeys = NSLocalizedString(Constants.RessourcesStrings.categoriesKeys, comment: "").split(separator: "|").map(String.init)
    let categoriesTitles = NSLocalizedString(Constants.RessourcesStrings.categoriesTitles, comment: "").split(separator: "|").map(String.init)
    
    var exercisesKeys = [[String]]()
    var exercisesTitles = [[String]]()
    
    var exercises = [[Exercise]]()
    var categories = [Category]()
    
    var currentUserBool = false
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.measureYourPhysicalCondition)
        setupBackButton(isHidden: true, isAnimated: false)
        
        // Add Categories Keys & Titles
        addExercisesTitlesAndExercisesKeysIntoArray()
        addAllExercisesIntoArray()
        addAllCategoriesIntoCategoriesArray()
        
        // Height cell resized setup method
        autoResizingHeightCell()
        
        // Floating Menu Button setup method
        setupFloatingButton()
        
        // Init currentUserBool
        currentUserBool = UserManager.shared.getCurrentUser()
        UserManager.shared.getUsersArray()
        
        // MainPageTableView Footer View setup
        mainPageTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // NavigationBar setup methods
        setupNavigationBarIsHidden(false, false)
        setupNavigationControllerTitle(Constants.Labels.measureYourPhysicalCondition)
        
        // Reload data in table view
        mainPageTableView.reloadData()
    }
    
    //MARK: - Methods
    // Add Categories Keys & Titles
    private func addExercisesTitlesAndExercisesKeysIntoArray() {
        for key in categoriesKeys {
            exercisesTitles.append(NSLocalizedString((key + Constants.RessourcesStrings.exercises), comment: "").split(separator: "|").map(String.init))
            exercisesKeys.append(NSLocalizedString((key + Constants.RessourcesStrings.exercisesKeys), comment: "").split(separator: "|").map(String.init))
        }
    }
    
    private func addAllExercisesIntoArray() {
        for categoryTitle in 0..<categoriesTitles.count {
            exercises.append([])
            for exerciseTitle in 0..<exercisesTitles[categoryTitle].count {
                exercises[categoryTitle].append(Exercise(key: exercisesKeys[categoryTitle][exerciseTitle], title: exercisesTitles[categoryTitle][exerciseTitle]))
            }
        }
    }
    
    private func addAllCategoriesIntoCategoriesArray() {
        for categoryTitle in 0..<categoriesTitles.count {
            categories.append(Category(isExpanded: true, exercises: exercises[categoryTitle]))
        }
    }
    
    // Handle Current User Check and different alerts/actions controllers
    private func checkCurrentUser() {
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
    
    private func alertActionsHandler(action: UIAlertAction) {
        print("there is currentuser")
        UserManager.shared.getUsersArray()
        
        switch action.title {
        case Constants.Labels.yes:
            performSegue(withIdentifier: Constants.SeguesIdentifiers.ricciSurveySegue, sender: self)
            break
            
        case Constants.Labels.no:
            switch UserManager.shared.usersArray.count {
            case 0:
                setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createFirstProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
                break
                
            case 1:
                setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createNewProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: alertActionsHandler)
                break
                
            case let x where x > 1:
                performSegue(withIdentifier: Constants.SeguesIdentifiers.fromRicciSurveyToListOfProfilesSegue, sender: self)
                break
                
            default:
                break
            }
            
        case Constants.Labels.now:
            performSegue(withIdentifier: Constants.SeguesIdentifiers.fromMainPageToCreateProfileSegue, sender: self)
            break
            
        case Constants.Labels.later:
            self.navigationController?.popToRootViewController(animated: true)
            break
            
        default:
            break
        }
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.SeguesIdentifiers.instructionsSegue:
            if let destinationVC = segue.destination as? InstructionsViewController,
                let indexPath = mainPageTableView.indexPathForSelectedRow {
                let selectedExerciseKey = categories[indexPath.section].exercises[indexPath.row].key
                
                destinationVC.exerciseKey = selectedExerciseKey
            }
            break
            
        case Constants.SeguesIdentifiers.resultsSegue:
            if let destinationVC = segue.destination as? ResultsViewController {
                
                destinationVC.backToMenuButtonIsHidden = true
                destinationVC.backItemNavigationBarIsHidden = false
            }
            break
            
        default:
            break
            
        }
    }
    
}


//MARK: - Floating Button Setup
extension MainPageViewController {
    func setupFloatingButton() {
        let floaty = Floaty()
        
        floaty.addItem(Constants.Labels.profiles, icon: UIImage(named: Constants.Images.profile)!, handler: { item in
            self.performSegue(withIdentifier: Constants.SeguesIdentifiers.listOfProfilesSegue, sender: self)
            floaty.close()
        })
        
        floaty.addItem(Constants.Labels.results, icon: UIImage(named: Constants.Images.results)!, handler: { item in
            if UserManager.shared.usersArray.count > 0 && UserManager.shared.getCurrentUser() == true {
                self.performSegue(withIdentifier: Constants.SeguesIdentifiers.resultsSegue, sender: self)
                floaty.close()
            } else {
                if UserManager.shared.usersArray.count == 0 {
                    self.setupAlert(title: Constants.Labels.createYourProfile, message: Constants.Labels.createFirstProfile, actionsTitles: [Constants.Labels.later, Constants.Labels.now], alertAction: self.alertActionsHandler)
                }
                
                if UserManager.shared.getCurrentUser() == false {
                    self.showAlert(title: "Définir Utilisateur Actuel", message: "Vous devez définir un profil comme utilisateur actuel !")
                }
            }
        })
        
        floaty.addItem(Constants.Labels.introduction, icon: UIImage(named: Constants.Images.info)!, handler: { item in
            let mainStoryboard = UIStoryboard(name: Constants.StoryboardsIdentifiers.mainStoryboardIdentifier, bundle: nil)
            
            if #available(iOS 13.0, *) {
                let introductionVC = mainStoryboard.instantiateViewController(identifier: Constants.ViewControllersIdentifiers.introductionViewControllerIdentifier)
                
                self.navigationController?.pushViewController(introductionVC, animated: true)
                
            } else {
                self.performSegue(withIdentifier: Constants.SeguesIdentifiers.introductionSegue, sender: self)
            }
            
            floaty.close()
        })
        
        floaty.addItem(Constants.Labels.references, icon: UIImage(named: Constants.Images.info)!, handler: { item in
            self.performSegue(withIdentifier: Constants.SeguesIdentifiers.referencesSegue, sender: self)
        })
        
        floaty.addItem(Constants.Labels.aboutUs, icon: UIImage(named: Constants.Images.info)!, handler: { item in
            self.performSegue(withIdentifier: Constants.SeguesIdentifiers.aboutUsSegue, sender: self)
        })
        
        floaty.openAnimationType = .slideUp
        floaty.buttonColor = Constants.Colors.redUIColor
        floaty.plusColor = .white
        
        self.view.addSubview(floaty)
    }
}


//MARK: - Table View Cell Setup
extension MainPageViewController {
    private func autoResizingHeightCell() {
        mainPageTableView.estimatedRowHeight = 85
        mainPageTableView.rowHeight = 85
    }
}


//MARK: - UITableViewDataSource
extension MainPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories[section].isExpanded ? 0 : categories[section].exercises.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.view.frame.size.width * 235/1058
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width * 230/1058
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spacingView = UIView()
        spacingView.backgroundColor = .white
        
        return spacingView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let widthOfScreen = self.view.frame.size.width
        let heightOfHeader = widthOfScreen * 235/1058
    
        let gradient: CAGradientLayer = CAGradientLayer()
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.HeadersIdentifiers.mainPageHeaderIdentifier) as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: Constants.HeadersIdentifiers.mainPageHeaderIdentifier)
        
        header.titleLabel.text = categoriesTitles[section]
        
        header.arrowLabel.text = Constants.Labels.disclosureIndicator
        
        header.imageView.frame = CGRect(x: 10, y: 0, width: widthOfScreen-20, height: heightOfHeader)
        header.imageView.image = UIImage(named: Constants.RessourcesStrings.background + categoriesKeys[section] + Constants.RessourcesStrings.backgroundImageWithExtensionJPEG)
        header.imageView.layer.insertSublayer(gradient, at: 0)
        
        header.setIsExpanded(categories[section].isExpanded)
        
        header.section = section
        
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: header.imageView.frame.size.width, height: header.imageView.frame.size.height)
        gradient.colors = [Constants.Colors.redUIColor.cgColor, UIColor.clear.cgColor]
        
        if section == 0 {
             gradient.locations = [0.0 , 2.0]
             gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
             gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        } else {
            gradient.locations = [0.0 , 1.0]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.6)
            gradient.endPoint = CGPoint(x: 0.6, y: 0.6)
        }
        
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selectedCategoryKey = categoriesKeys[indexPath.section]
        let categoriesDurationsTable = NSLocalizedString(selectedCategoryKey + Constants.RessourcesStrings.helperText, comment: "").split(separator: "|").map(String.init)
        
        guard let cell = mainPageTableView.dequeueReusableCell(withIdentifier: ExerciseTableViewCell.identifier, for: indexPath) as? ExerciseTableViewCell else {
            return UITableViewCell()
        }
                        
        cell.exerciseTableViewCellConfigure(title: categories[indexPath.section].exercises[indexPath.row].title, duration: categoriesDurationsTable[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


//MARK: - UITableViewDelegate
extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            checkCurrentUser()
            
            performSegue(withIdentifier: Constants.SeguesIdentifiers.ricciSurveySegue, sender: self)
            
        } else {
            performSegue(withIdentifier: Constants.SeguesIdentifiers.instructionsSegue, sender: self)
        }
    }
}


//MARK - CollapsibleTableViewHeaderDelegate
extension MainPageViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let isExpanded = !categories[section].isExpanded
        
        // Toggle collapse
        categories[section].isExpanded = isExpanded
        
        header.setIsExpanded(isExpanded)
        
        // Reload the whole section
        mainPageTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
