//
//  Helper.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 09.10.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import UIKit

public enum Helper {
    static func imageName() -> String {
        let date: Date = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'_'HH_mm_ss"

        return "/\(dateFormatter.string(from: date)).png"
    }
    
    ///saving png image with data and filename
    static func saveToDiskImage(name: String, with data: Data) {
        //create an instance of the FileManager
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask).first else { return }
        
        //get the image path
        let fileURL = documentsDirectory.appendingPathComponent(name)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
            print("saved to disk")
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    static func loadImageFromDiskWith(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }
        return nil
    }
}
