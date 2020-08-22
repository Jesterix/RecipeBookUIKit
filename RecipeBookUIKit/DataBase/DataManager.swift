//
//  DataManager.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 22.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import MeasureLibrary

protocol DataManager {
    func createDefaultData()
    
    func getRecipes() -> [Recipe]
    func remove(recipe: Recipe)
    func update(recipe: Recipe)
    
    func getCustomMeasures() -> [CustomMeasure]
    func update(measure: CustomMeasure)
}
