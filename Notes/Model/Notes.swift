//
//  Notes.swift
//  Notes
//
//  Created by Maria on 10/02/2021.
//

import Foundation
import RealmSwift

@objcMembers class Notes: Object {
    
    dynamic var line: String = ""
    let score = RealmOptional<Int>()
    dynamic var email: String? = nil
    
    convenience init(line: String, score: Int?, email: String?) {
        self.init()
        self.line = line
        self.score.value = score
        self.email = email
    }
    
    func scoreString() -> String? {
        guard let score = score.value else { return nil }
        return String(score)
    }
}
