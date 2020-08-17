//
//  RealmCustomMeasurement.swift
//  RecipeBookUIKit
//
//  Created by Georgy Khaydenko on 17.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCustomMeasurement: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var baseUnitSymbol: String = ""
    @objc dynamic var coefficient: Double = 1.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from measure: CustomMeasure) {
        self.init()
        id = measure.id
        title = measure.title
        baseUnitSymbol = measure.baseUnitSymbol
        coefficient = measure.coefficient
    }
    
    func converted() -> CustomMeasure {
        return CustomMeasure(
            id: id,
            title: title,
            baseUnitSymbol: baseUnitSymbol,
            coefficient: coefficient
        )
    }
}
