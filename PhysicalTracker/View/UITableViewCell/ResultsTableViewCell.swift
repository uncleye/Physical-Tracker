//
//  ResultsTableViewCell.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 20/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ResultsTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var exerciseTitleLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var yellowView: UIView!
    @IBOutlet weak var greenView: UIView!
    @IBOutlet weak var blueView: UIView!
    
    //MARK: - Properties
    var viewsArray = [UIView]()
    var checkmarkImageView = UIImageView()
    
    //MARK: - Methods
    func initCheckmarkImageView() {
        checkmarkImageView.image = UIImage(named: Constants.Images.checkmark)
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        checkmarkImageView.contentMode = .scaleAspectFit
    }
    
    func setupCheckmarkImageViewConstraints() {
        checkmarkImageView.heightAnchor.constraint(equalTo: redView.heightAnchor, multiplier: 1).isActive = true
        checkmarkImageView.widthAnchor.constraint(equalTo: redView.widthAnchor, multiplier: 1).isActive = true
    }
    
    func addCheckmarkImageToView(index: Int) {
        switch index {
        case 0:
            redView.addSubview(checkmarkImageView)
            setupCheckmarkImageViewConstraints()
            break
        case 1:
            orangeView.addSubview(checkmarkImageView)
            setupCheckmarkImageViewConstraints()
            break
        case 2:
            yellowView.addSubview(checkmarkImageView)
            setupCheckmarkImageViewConstraints()
            break
        case 3:
            greenView.addSubview(checkmarkImageView)
            setupCheckmarkImageViewConstraints()
            break
        case 4:
            blueView.addSubview(checkmarkImageView)
            setupCheckmarkImageViewConstraints()
            break
        default:
            break
        }
    }
    
    //Helper method to set measure unit into resultLabel
    func setupMeasureUnit(exerciseKey: String?, result: Int) {
        let minutes = result / 60 % 60
        let seconds = result % 60
        
        switch exerciseKey {
        case Constants.RessourcesStrings.step:
            resultLabel.text = String(result) + " bpm"
        case Constants.RessourcesStrings.sixWalk:
            resultLabel.text = String(result) + " m"
        case Constants.RessourcesStrings.shirado:
            resultLabel.text = String(format: "%02i:%02i", minutes, seconds)
        case Constants.RessourcesStrings.sitStand:
            resultLabel.text = String(result) + " levées"
        case Constants.RessourcesStrings.chair:
            resultLabel.text = String(format: "%02i:%02i", minutes, seconds)
        case Constants.RessourcesStrings.handGrip:
            resultLabel.text = String(result) + " kg"
        case Constants.RessourcesStrings.sorensen:
            resultLabel.text = String(format: "%02i:%02i", minutes, seconds)
        case Constants.RessourcesStrings.flamingo:
            resultLabel.text = String(format: "%02i:%02i", minutes, seconds)
        case Constants.RessourcesStrings.sitReach:
            resultLabel.text = String(result) + " cm"
        case Constants.RessourcesStrings.shoulders:
            resultLabel.text = String(result)
        case Constants.RessourcesStrings.handGround:
            resultLabel.text = String(result)
        default:
            break
        }
    }
    
}
