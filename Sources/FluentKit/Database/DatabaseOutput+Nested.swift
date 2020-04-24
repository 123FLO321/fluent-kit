extension DatabaseOutput {
    func nested(_ key: FieldKey) -> DatabaseOutput {
        return NestedOutput(wrapped: self, prefix: key)
    }
}

private struct NestedOutput: DatabaseOutput {
    let database: Database
    let wrapped: DatabaseOutput
    let prefix: FieldKey

    init(wrapped: DatabaseOutput, prefix: FieldKey) {
        self.database = wrapped.database
        self.wrapped = wrapped
        self.prefix = prefix
    }

    var description: String {
        self.wrapped.description
    }

    func schema(_ schema: String) -> DatabaseOutput {
        self.wrapped.schema(schema)
    }

    func contains(_ path: [FieldKey]) -> Bool {
        self.wrapped.contains([self.prefix] + path)
    }

    func decode<T>(_ path: [FieldKey], as type: T.Type) throws -> T
        where T : Decodable
    {
        try self.wrapped.decode([self.prefix] + path)
    }

    func decodeNil(_ path: [FieldKey]) throws -> Bool {
        return try self.wrapped.decodeNil([self.prefix] + path)
    }
}
