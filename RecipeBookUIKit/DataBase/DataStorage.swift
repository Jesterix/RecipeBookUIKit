//
//  DataStorage.swift
//  RecipeBookUIKit
//
//  Created by Георгий Хайденко on 11.08.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

final class DataStorage {
    public static let shared: DataStorage = DataStorage()

    var userMeasures: [String] = []
}
