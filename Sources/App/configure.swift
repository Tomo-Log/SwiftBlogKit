import FluentMySQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
//    try services.register(FluentMySQLProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    //Database
    try setupDatabase(&config, &env, &services)
}

func setupDatabase(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    guard
        let hostname = Environment.get("MYSQL_HOSTNAME"),
        let username = Environment.get("MYSQL_USERNAME"),
        let password = Environment.get("MYSQL_ROOT_PASSWORD"),
        let database = Environment.get("MYSQL_DATABASE")
        else {
            throw Abort(.internalServerError)
    }
    
    //DB
    try services.register(FluentMySQLProvider())
    
    //MyWSQL
    let databaseConfig : MySQLDatabaseConfig = MySQLDatabaseConfig(hostname: hostname,
                                                                port: 3306,
                                                                username: username,
                                                                password: password,
                                                                database: database)

    services.register(databaseConfig)
}
