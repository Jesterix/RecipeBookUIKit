//
//  TextFieldMask.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 10.07.2021.
//  Copyright © 2021 George Khaydenko. All rights reserved.
//

import Foundation

public protocol TextFieldMask {
    func validate(change: TextFieldStringChange) -> Bool
}

public class TextFieldStringChange {
    /// Original value that is currently in the text field
    let oldValue: String
    
    /// Range of the original string that's gonna be changed
    let range: NSRange
    
    /// The string that is gonna replace 'range' inside 'oldValue'
    let replacementString: String
    
    /// Calculated length after the change
    lazy var newLength: Int = {
        return self.oldValue.count - self.range.length + self.replacementString.count
    }()
    
    /// Calculated value after the change
    lazy var newValue: String = {
        return (self.oldValue as NSString).replacingCharacters(in: self.range, with: self.replacementString)
    }()
    
    /// Set this to fix the original value
    var correctedValue: String?
    
    init(oldValue: String, range: NSRange, replacementString: String) {
        self.oldValue = oldValue
        self.range = range
        self.replacementString = replacementString
    }
}

//MARK:- TextFieldMeasureValueMask
public struct TextFieldMeasureValueMask: TextFieldMask {
    public func validate(change: TextFieldStringChange) -> Bool {
        if change.replacementString.count == 0 {
            return true
        }
        
        let isPasted = change.replacementString.count > 1
        if isPasted {
            let fixedPasting = format(pasted: change.replacementString)
            change.correctedValue = type(of: self).format(value: fixedPasting)
            
            return false
        }
        
        let formattedReplacement = format(pasted: change.replacementString)
        let newValue = (change.oldValue as NSString).replacingCharacters(in: change.range, with: formattedReplacement)
        let newFormattedValue = type(of: self).format(value: newValue)
        
        change.correctedValue = newFormattedValue
        
        return false
    }
    
    /// Cleans value 765,43,210  to 765.43210
    public static func clean(value: String) -> String {
        var result = ""
        let newValue = value
            .replacingOccurrences(of: ",", with: ".")
        
        let components = newValue.components(separatedBy: ".")
        if components.count > 2 {
            result.append("\(components[0]).")
            result.append(components.dropFirst().joined())
        } else {
            result = newValue
        }
        
        return result
    }
    
    /// Formats string to the value we need
    public static func format(value: String) -> String {
        let cleaned = self.clean(value: value)
        
        return cleaned
    }
    
    /// Fixes pasted values
    func format(pasted: String) -> String {
        var pastedMutable: String = pasted
        let notAllowed = CharacterSet(charactersIn: "0123456789.").inverted
        
        while let notAllowedCharactersRange = pastedMutable.rangeOfCharacter(from: notAllowed) {
            if notAllowedCharactersRange.isEmpty {
                break
            }
            
            pastedMutable.replaceSubrange(notAllowedCharactersRange, with: "")
        }
        
        return pastedMutable
    }
    
    public static func correct(value: String) -> String {
        if let doubleValue = Double(value) {
            return doubleValue.removeZerosFromEnd()
        }
        
        return value
    }
}

public struct TextFieldMaxLengthMask: TextFieldMask {
    public var maxLength: Int
    
    public init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    public func validate(change: TextFieldStringChange) -> Bool {
        return change.newLength <= maxLength
    }
}
