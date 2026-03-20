//
//  Group.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 10/05/23.
//

import Foundation
import RealmSwift

class TodoTaskModel: Object {
    @Persisted var id: String
    @Persisted var name = ""
    @Persisted var especifications = ""
    @Persisted var date: Date = Date()
}
