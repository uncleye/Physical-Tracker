//
//  CollapsibleTableViewHeader.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 06/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    //MARK: - Properties
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    //UI properties
    let titleLabel = UILabel()
    let arrowLabel = UILabel()
    let imageView = UIImageView()
    
    //MARK: - Init
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
                
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
        
        // Content View
        contentView.backgroundColor = .white
        
        let marginGuide = contentView.layoutMarginsGuide

        // Image View
        contentView.addSubview(imageView)
        imageView.layer.borderWidth = 0.1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        // Arrow label
        contentView.addSubview(arrowLabel)
        arrowLabel.textColor = UIColor.white
        arrowLabel.font = UIFont(name: Constants.Fonts.rubikMedium, size: 20)
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowLabel.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        arrowLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        arrowLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        arrowLabel.layer.masksToBounds = false
        arrowLabel.layer.shouldRasterize = true

        // Title label
        contentView.addSubview(titleLabel)
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont(name: Constants.Fonts.rubikMedium, size: 22)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 15).isActive = true
        titleLabel.layer.masksToBounds = false
        titleLabel.layer.shouldRasterize = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setIsExpanded(_ isExpanded: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
        arrowLabel.rotate(isExpanded ? 0.0 : .pi / 2)
    }
}
