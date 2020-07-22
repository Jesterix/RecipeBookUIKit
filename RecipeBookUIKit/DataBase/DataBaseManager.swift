//
//  DataBaseManager.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 22.07.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class DataBaseManager {
    private var realm: Realm = try! Realm()

    private lazy var recipes: Results<RealmRecipe> = { self.realm.objects(RealmRecipe.self)
    }()

    func createBaseData() {
        do {
            try realm.write() {
                realm.delete(recipes)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }

        do {
            if recipes.count == 0 {
                try realm.write() {
                    let defaultRecipes = [
                        Recipe(
                            title: "first",
                            ingredients: [
                                Ingredient(
                                    title: "Water",
                                    measurement: Measurement(
                                        value: 3,
                                        unit: UnitMass.grams)),
                                Ingredient(
                                    title: "Flour",
                                    measurement: Measurement(
                                        value: 5.34,
                                        unit: Unit(symbol: "шт")))],
                            text: "Put one vial of water.."),
                        Recipe(
                            title: "second",
                            text: "recipeText here"),
                        Recipe(title: "third")]

                    for recipe in defaultRecipes {
                        let newRecipe = RealmRecipe(from: recipe)
                        realm.add(newRecipe)
                    }
                }
                recipes = realm.objects(RealmRecipe.self)
            }
        } catch (let error) {
            print(error.localizedDescription)
        }
    }

    func getRecipesData() -> [Recipe] {
        return recipes.map { $0.converted() }
    }
}
