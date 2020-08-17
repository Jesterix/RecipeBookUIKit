//
//  CustomMeasure.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 17.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

struct CustomMeasure {
    var id: String = UUID().uuidString
    var title: String
    var baseUnitSymbol: String
    var coefficient: Double
}
