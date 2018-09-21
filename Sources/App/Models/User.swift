//
//  User.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/21.
//

import Vapor
import FluentMySQL
import Authentication

final class User : Model {
    var id: Int?
    
    var displayName : String
    var email : String
    var passwordHash : String
    
    init(id: Int? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.displayName = name
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension User : MySQLModel {}
extension User : Migration {}
extension User : Content {}

extension User : SessionAuthenticatable {}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \User.email
    }
    static var passwordKey: WritableKeyPath<User, String> {
        return \User.passwordHash
    }
}
