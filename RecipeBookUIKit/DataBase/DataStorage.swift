//
//  DataStorage.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 11.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import MeasureLibrary

final class DataStorage: CustomMeasureProvider {
    public static let shared: DataStorage = DataStorage()
    
    var customMeasures: [CustomMeasure] = []
    
    func updateMeasures(_ measures: [CustomMeasure]) {
        customMeasures = measures
    }
}
