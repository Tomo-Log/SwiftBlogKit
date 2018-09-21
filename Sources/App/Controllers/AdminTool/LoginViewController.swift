//
//  LoginViewController.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/21.
//

import Vapor
import Crypto

final class LoginViewController : BaseViewController {

    override var templatePath: String { return "Admin/login"}
    
    private struct Credential : Codable {
        var email:String
        var password:String
    }
    
    func index(_ req: Request) throws -> Future<View> {
        return try req.view().render(self.templatePath)
    }
    
    func login(_ req: Request) throws -> Future<Response> {
        
        let credential = try req.content.decode(Credential.self)
        
        return credential.flatMap(to:Response.self){
            credential in
            
            //let hash = try BCrypt.hash(credential.password)
            
            let authed = User.authenticate(username: credential.email, password: credential.password, using: BCryptDigest(), on: req)
            
            return authed.flatMap(to:Response.self) {
                writer in
                
                if let user = writer {
                    try req.authenticateSession(user)//.authenticate(user)
                    
                    return try req.redirect(to: URI.AdminTool.articles.path).encode(for: req)
                    //                    return try  ErrorViewController.showError(req, message: "ログインした")
                }
                else {
                    return try req.redirect(to: URI.AdminTool.login.path).encode(for: req)
                    //                    return try  ErrorViewController.showError(req, message: "ログインできなかった")
                }
            }
        }
    }
}
