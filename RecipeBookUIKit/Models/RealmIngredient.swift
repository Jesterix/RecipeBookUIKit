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
    dynamic var title: String = ""
    let measurement = RealmOptional<Measurement<Unit>>()
}

extension Measurement: RealmOptionalType {
}
