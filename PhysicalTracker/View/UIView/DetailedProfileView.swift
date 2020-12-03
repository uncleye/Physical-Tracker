//
//  DetailedProfileView.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 14/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

class DetailedProfileView: UIView {
    //MARK: - Outlets
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var deleteProfileButton: UIButton!
    @IBOutlet weak var modifyProfileButton: UIButton!
    
    //MARK: - Methods
    func setupUI(user: User?) {
        userIdLabel.text = "Identifiant : " + (user?.userName ?? "")
        userIdLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        birthYearLabel.text = "Année de naissance : " + String(describing: user?.birthyear ?? 0000)
        birthYearLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        heightLabel.text = "Taille : " + String(describing: user?.height ?? 000)
        heightLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        weightLabel.text = "Poids : " + String(describing: user?.weight ?? 00)
        weightLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        if(user?.sex == 0){
            sexLabel.text = "Sexe : Féminin"
        } else {
            sexLabel.text = "Sexe : Masculin"
        }
        sexLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        
        statusLabel.text = "Statut : " + (user?.status ?? "")
        statusLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
        switch user?.status {
        case "Étudiant UP":
            domainLabel.isHidden = false
            domainLabel.text = "Domaine : " + (user?.domain ?? "")
            break
            
        case "Personnel UP":
            domainLabel.isHidden = true
            break
            
        case "Autre":
            domainLabel.isHidden = false
            domainLabel.text = "Description : " + (user?.descriptions ?? "")
            break
            
        default:
            break
        }
        domainLabel.font = UIFont(name: Constants.Fonts.rubikRegular, size: 16)
        
    }
    
    func setupBordersButtons() {
        deleteProfileButton.layer.borderWidth = 1
        deleteProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        deleteProfileButton.layer.cornerRadius = 0.03 * deleteProfileButton.bounds.size.width
        
        modifyProfileButton.layer.borderWidth = 1
        modifyProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        modifyProfileButton.layer.cornerRadius = 0.03 * modifyProfileButton.bounds.size.width
    }
    
}
