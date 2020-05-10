//
//  Category.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 10/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import Foundation

struct Category {
    var isExpanded: Bool
    var exercises: [Exercise]
}

struct Exercise {
    let key: String
    let title: String
}
