//
//  URI.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/20.
//

import Foundation

protocol URIPath {
    var path : String {get}
    static var prefix : String {get}
}

enum URI {
    enum API : String, URIPath {
        case article, articles
        
        static var prefix: String = "api/"
        
        var path: String {
            return API.prefix + self.rawValue
        }
    }
    
    enum Blog : String, URIPath {
        case article, articles
        
        static var prefix: String = ""
        
        var path: String {
            return Blog.prefix + self.rawValue
        }
    }

    enum AdminTool : String, URIPath {
        case article, articles
        case login

        static var prefix: String = ""
        
        var path: String {
            return AdminTool.prefix + self.rawValue
        }
    }
}
