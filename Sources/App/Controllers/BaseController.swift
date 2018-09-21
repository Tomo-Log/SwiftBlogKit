//
//  BaseController.swift
//  App
//
//  Created by TOMOYUKI NAKAGOMI on 2018/09/21.
//

import Vapor

class BaseController {
    internal var path : String = ""
    func addRoute(to router:Router, path:String) {
        self.path = path
    }
}


class BaseViewController : BaseController {
    var templatePath : String {
        return "article"
    }
}
