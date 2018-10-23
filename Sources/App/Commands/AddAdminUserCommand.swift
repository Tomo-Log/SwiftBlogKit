//
//  AddAdminUserCommand.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/10/19.
//

import Vapor
import MySQL
import FluentMySQL
import Crypto

struct AddAdminUserCommand: Command {
    
    static func addCommand(to commandConfig: inout CommandConfig) {
        commandConfig.use(AddAdminUserCommand(), as: "addAdmin")
    }
    
    var arguments: [CommandArgument] {
        return [
            .argument(name: "name"),
            .argument(name: "email"),
            .argument(name: "password")
        ]
    }

    var options: [CommandOption] {
        return [
        ]
    }

    var help: [String] {
        return ["This command is for registering new admin user. Please enter name/email/password for new one."]
    }

    func run(using context: CommandContext) throws -> Future<Void> {
        
        let name = try context.argument("name")
        let email = try context.argument("email")
        let password = try context.argument("password")
        let hash = try BCrypt.hash(password)

        let container = context.container

        return container.withNewConnection(to: .mysql) {
            conn in
            
            return  User.query(on: conn).filter(\User.email == email).count().flatMap() {
                count in
                
                if count > 0 {
                    context.console.print("[" + email + "] is already registered.")
                    return .done(on: context.container)
                }
                else {
                    context.console.print("------- Registered ------")
                    context.console.print("Name : " + name)
                    context.console.print("e-mail : " + email)
                    context.console.print("password : " + password)
                    context.console.print("-----------------------")
                    
                    let admin = User(name: name, email: email, passwordHash: hash)
                    return [admin.create(on: conn)
                        ].flatten(on: container).transform(to: ())
                }
                
            }
        }
    }
}
