//
//  Article.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/20.
//

import Vapor
import FluentMySQL

final class Article : Model {
     var id: Int?
    
    var title : String?
    var content : String?
    var summary : String?
}

extension Article : MySQLModel {}
extension Article : Migration {}
extension Article : Content {}

