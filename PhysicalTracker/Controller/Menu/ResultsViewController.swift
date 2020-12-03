//
//  ResultsViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var resultsView: ResultsView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    //MARK: - Properties
    // ModifyProfile UI setup properties
    var backToMenuButtonIsHidden = true
    var backItemNavigationBarIsHidden = true
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar setup method
        setupNavigationControllerTitle(Constants.Labels.results)
        setupNavigationBarIsHidden(false, false)
        setupNavigationBarTintColor(Constants.Colors.redUIColor)
        setupBackButton(isHidden: backItemNavigationBarIsHidden, isAnimated: false)
        
        // UI setup method
        resultsView.setupUI()
        resultsView.setupBorderButton()
        
        // Init backToMainPageButton isHidden attribute setup
        resultsView.backToMainPageButton.isHidden = backToMenuButtonIsHidden
        
        // Set resultsTableView footerView
        resultsTableView.tableFooterView = UIView()
        
    }
    
    //MARK: - Actions
    @IBAction func backToMainPageButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        didTapShareButton()
    }
    
    @IBAction func getResultsInterpretations(_ sender: UIButton) {
        performSegue(withIdentifier: Constants.SeguesIdentifiers.interpretationSegue, sender: self)
    }
    
    //MARK: - Methods
    // Method to take a screenshot of the results and to share it
    private func didTapShareButton() {
        let interpretationsVC = self.storyboard!.instantiateViewController(withIdentifier: Constants.ViewControllersIdentifiers.interpretationsIdentifier) as! InterpretationsViewController
        
        interpretationsVC.view.frame = self.view.bounds;
        interpretationsVC.willMove(toParent: self)
        self.view.addSubview(interpretationsVC.view)
        self.addChild(interpretationsVC)
        interpretationsVC.didMove(toParent: self)
        
        guard let screenshot1 = resultsView.scrollViewContentView.snapshotViewHierarchy(scrollView: resultsView.shareScrollView) else { return }
        guard let screenshot2 = interpretationsVC.interpretationsView.interpretationsScrollViewContentView.snapshotViewHierarchy(scrollView: interpretationsVC.interpretationsView.interpretationsScrollView) else { return }
        
        let items = [self, screenshot1, screenshot2]
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        present(activityController, animated: true) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}


//MARK: - UITableViewDataSource
extension ResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ResultsManager.shared.numberOfRowIncategory(categoryNumber: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellExerciseKey = ResultsManager.shared.setResultKeyList(categoryNumber: indexPath.section)[indexPath.row]
        let evaluationExercise = ResultsManager.shared.evaluationExercise(exerciseKey: cellExerciseKey)
        
        guard let cell = resultsTableView.dequeueReusableCell(withIdentifier: ResultsTableViewCell.identifier, for: indexPath) as? ResultsTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.exerciseTitleLabel.text = NSLocalizedString(cellExerciseKey + Constants.RessourcesStrings.title, comment: "")
        
        cell.setupMeasureUnit(exerciseKey: cellExerciseKey, result: UserManager.shared.currentUser.resultDictionary[cellExerciseKey] as! Int)
        
        cell.initCheckmarkImageView()
        
        cell.addCheckmarkImageToView(index: evaluationExercise)
        
        return cell
    }
    
}


//MARK: - UITableViewDelegate
extension ResultsViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultsManager.shared.numberOfSectionsInResult()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let categoryList = NSLocalizedString(Constants.RessourcesStrings.categoriesTitles, comment: "").split(separator: "|").map(String.init)
        
        return categoryList[section + 1]
    }
    
}


//MARK: - UIActivityItemSource
extension ResultsViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        // Ignore
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        // Setup subject in Gmail
        if activityType == UIActivity.ActivityType.mail {
            return ""
        }
        
        return Constants.Labels.subjectResultsString + UserManager.shared.currentUser.userName
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        // Setup subject in Mail
        if activityType == UIActivity.ActivityType.mail {
            return Constants.Labels.subjectResultsString + UserManager.shared.currentUser.userName
        }
        
        return Constants.Labels.subjectResultsString + UserManager.shared.currentUser.userName
    }
    
}
