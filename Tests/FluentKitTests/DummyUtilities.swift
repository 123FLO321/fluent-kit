@testable import FluentKit
import FluentSQL
import NIO
import SQLKit

public class DummyDatabaseForTestSQLSerializer: Database, SQLDatabase {
    public var dialect: SQLDialect {
        DummyDatabaseDialect()
    }
    
    public let context: DatabaseContext
    public var sqlSerializers: [SQLSerializer]

    public init() {
        self.context = .init(
            configuration: .init(),
            logger: .init(label: "test"),
            eventLoop: EmbeddedEventLoop()
        )
        self.sqlSerializers = []
    }
    
    public func reset() {
        self.sqlSerializers = []
    }
    
    public func execute(query: DatabaseQuery, onRow: @escaping (DatabaseRow) -> ()) -> EventLoopFuture<Void> {
        var sqlSerializer = SQLSerializer(database: self)
        guard let sqlExpression = SQLQueryConverter(delegate: DummyDatabaseConverterDelegate()).convert(query) else {
            return self.eventLoop.makeSucceededFuture(())
        }

        sqlExpression.serialize(to: &sqlSerializer)
        self.sqlSerializers.append(sqlSerializer)
        return self.eventLoop.makeSucceededFuture(())
    }
    
    public func execute(sql query: SQLExpression, _ onRow: @escaping (SQLRow) -> ()) -> EventLoopFuture<Void> {
        fatalError()
    }
    
    public func execute(schema: DatabaseSchema) -> EventLoopFuture<Void> {
        var sqlSerializer = SQLSerializer(database: self)
        let sqlExpression = SQLSchemaConverter(delegate: DummyDatabaseConverterDelegate()).convert(schema)
        sqlExpression.serialize(to: &sqlSerializer)
        self.sqlSerializers.append(sqlSerializer)
        return self.eventLoop.makeSucceededFuture(())
    }
    
    public func withConnection<T>(
        _ closure: @escaping (Database) -> EventLoopFuture<T>
    ) -> EventLoopFuture<T> {
        closure(self)
    }
    
    public func shutdown() {
        //
    }
}

// Copy from PostgresDialect
struct DummyDatabaseDialect: SQLDialect {
    var name: String {
        "dummy db"
    }
    
    var identifierQuote: SQLExpression {
        return SQLRaw("\"")
    }

    var literalStringQuote: SQLExpression {
        return SQLRaw("'")
    }

    func bindPlaceholder(at position: Int) -> SQLExpression {
        return SQLRaw("$" + (position + 1).description)
    }

    func literalBoolean(_ value: Bool) -> SQLExpression {
        switch value {
        case false:
            return SQLRaw("false")
        case true:
            return SQLRaw("true")
        }
    }

    var autoIncrementClause: SQLExpression {
        return SQLRaw("GENERATED BY DEFAULT AS IDENTITY")
    }
}

// Copy from PostgresConverterDelegate
struct DummyDatabaseConverterDelegate: SQLConverterDelegate {
    func customDataType(_ dataType: DatabaseSchema.DataType) -> SQLExpression? {
        switch dataType {
        case .uuid:
            return SQLRaw("UUID")
        case .bool:
            return SQLRaw("BOOL")
        case .data:
            return SQLRaw("BYTEA")
        case .datetime:
            return SQLRaw("TIMESTAMPTZ")
        default:
            return nil
        }
    }

    func nestedFieldExpression(_ column: String, _ path: [String]) -> SQLExpression {
        return SQLRaw("\(column)->>'\(path[0])'")
    }
}
