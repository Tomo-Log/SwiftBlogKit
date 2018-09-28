//
//  LoginViewController.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/21.
//

import Vapor
import Crypto

final class LoginViewController : BaseViewController {

    override var templatePath: String { return "AdminTool/login"}
    
    override func addPath(_ path: String, to router: Router) {
        super.addPath(path, to: router)
        
        router.get(path, use: self.index)
        router.post(path, use: self.login)
    }
    
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
            let authed = User.authenticate(username: credential.email, password: credential.password, using: BCryptDigest(), on: req)
            
            return authed.flatMap(to:Response.self) {
                writer in
                
                if let user = writer {
                    try req.authenticateSession(user)
                    return try req.redirect(to: URI.AdminTool.articles.path).encode(for: req)
                }
                else {
                    return try req.redirect(to: URI.AdminTool.login.path).encode(for: req)
                }
            }
        }
    }
}
