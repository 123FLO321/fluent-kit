public struct DatabaseInput {
    public var database: Database?
    public var values: [FieldKey: DatabaseQuery.Value]
    public init(database: Database?) {
        self.values = [:]
        self.database = database
    }
}
