import Vapor
import Crypto
import Authentication

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }

    
    //Admin tool
    do {
        
        //Login
        let controller = LoginViewController()
        controller.addPath(URI.AdminTool.login.path, to: router)
        
        //Logined
        var controllers : [String:BaseViewController] = [:]
//        controllers[URI.Admin.article.path] = AdminArticleController()
  
        let session = User.authSessionsMiddleware()
        let guardAuth = RedirectMiddleware<User>(path: URI.AdminTool.login.path)
        let authedRouter = router.grouped([session, guardAuth])
        
        do {
            for path in controllers.keys {
                let controller = controllers[path]
                controller?.addPath(path, to: authedRouter)
            }
        }
    }    
}
