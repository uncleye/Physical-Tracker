//
//  ExerciseTableViewCell.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 07/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    //MARK - Methods
    func exerciseTableViewCellConfigure(title: String, duration: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: Constants.Fonts.rubikMedium, size: 18)
        titleLabel.textColor = Constants.Colors.redUIColor

        durationLabel.text = duration
        durationLabel.font = UIFont(name: Constants.Fonts.rubikMedium, size: 12)
        durationLabel.textColor = Constants.Colors.redUIColor

        iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = Constants.Colors.redUIColor
    }
    
}
