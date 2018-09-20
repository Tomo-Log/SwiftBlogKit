import FluentMySQL
import Vapor
import Leaf
import Authentication

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {

    //Auth
    try services.register(AuthenticationProvider())
    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)

    //Leaf
    try setLeaf(&config, &env, &services)

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middleware
    try setMiddlewares(&config, &env, &services)
    
    //Database & Mgirations
    try setupDatabase(&config, &env, &services)
    try setMigrations(&config, &env, &services)
}

public func setLeaf(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try services.register(LeafProvider())
    config.prefer(LeafRenderer.self, for: ViewRenderer.self)
}

public func setMiddlewares(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(SessionsMiddleware.self)
    services.register(middlewares)
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

public func setMigrations(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    var migrations = MigrationConfig()
    migrations.add(model: Article.self, database: .mysql)
    services.register(migrations)
}
