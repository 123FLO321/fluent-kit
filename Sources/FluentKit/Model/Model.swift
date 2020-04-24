public protocol Model: AnyModel {
    associatedtype IDValue: Codable, Hashable
    var id: IDValue? { get set }
}

extension Model {

    /// Indicates whether the model has fields that have been set, but the model
    /// has not yet been saved to the database.
    public var hasChanges: Bool {
        return !self.input.values.isEmpty
    }

    public var input: DatabaseInput {
        self.input(database: self.anyID.cachedDatabase)
    }

    public static func query(on database: Database) -> QueryBuilder<Self> {
        .init(database: database)
    }

    public static func find(
        _ id: Self.IDValue?,
        on database: Database
    ) -> EventLoopFuture<Self?> {
        guard let id = id else {
            return database.eventLoop.makeSucceededFuture(nil)
        }
        return Self.query(on: database)
            .filter(\._$id == id)
            .first()
    }

    public func requireID() throws -> IDValue {
        guard let id = self.id else {
            throw FluentError.idRequired
        }
        return id
    }

    public var _$id: ID<IDValue> {
        self.anyID as! ID<IDValue>
    }
}
