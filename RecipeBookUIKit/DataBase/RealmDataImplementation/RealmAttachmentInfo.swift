//
//  RealmAttachmentInfo.swift
//  RecipeBookUIKit
//
//  Created by Георгий on 09.10.2020.
//  Copyright © 2020 George Khaydenko. All rights reserved.
//

import Foundation
import RealmSwift

class RealmAttachmentInfo: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var url: String = ""
    @objc dynamic var location: Int = 0
    @objc dynamic var length: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(from info: AttachmentInfo) {
        self.init()
        id = info.id
        url = info.url
        location = info.range.location
        length = info.range.length
    }

    func converted() -> AttachmentInfo {
        return AttachmentInfo(
            id: id,
            url: url,
            range: NSRange(location: location, length: length)
        )
    }
}
