//
//  Recipe.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 20.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//
import Foundation

struct Recipe {
    var id: String = UUID().uuidString
    var title: String
    var ingredients: [Ingredient] = []
    var text: String = ""
}
