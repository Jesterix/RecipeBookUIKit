//
//  RealmIngredient.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmIngredient: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var value: Double = 0.0
    @objc dynamic var symbol: String = ""

    convenience init(from ingredient: Ingredient) {
        self.init()
        title = ingredient.title
        guard let measurement = ingredient.measurement else {
            return
        }
        value = measurement.value
        symbol = measurement.unit.symbol
    }

    func converted() -> Ingredient {
        return Ingredient(
            title: title,
            measurement: Measurement(
                value: value,
                unit: Unit(symbol: symbol))
        )
    }
}
