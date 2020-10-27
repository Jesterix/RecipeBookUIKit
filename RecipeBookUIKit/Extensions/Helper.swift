//
//  Helper.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 09.10.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation

public enum Helper {
    static func imageName() -> String {
        let date: Date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"

        return "/\(dateFormatter.string(from: date)).png"
    }
}
