public protocol Fields: class, Codable {
    var properties: [AnyProperty] { get }
    init()
}

extension Fields {
    public static func path<Field>(for field: KeyPath<Self, Field>) -> [FieldKey]
        where Field: FieldProtocol
    {
         Self.init()[keyPath: field].path
    }

    public func hasChanges(database: Database?) -> Bool {
        return !input(database: database).values.isEmpty
    }

    public func input(database: Database?) -> DatabaseInput {
        var input = DatabaseInput(database: database)
        self.properties.forEach { field in
            field.input(to: &input)
        }
        return input
    }

    public func output(from output: DatabaseOutput) throws {
        try self.properties.forEach { field in
            try field.output(from: output)
        }
    }

    public var properties: [AnyProperty] {
        Mirror(reflecting: self).children.compactMap {
            $0.value as? AnyProperty
        }
    }

    // Internal

    var labeledProperties: [String: AnyProperty] {
        .init(uniqueKeysWithValues:
            Mirror(reflecting: self).children.compactMap { child in
                guard let label = child.label else {
                    return nil
                }
                guard let field = child.value as? AnyProperty else {
                    return nil
                }
                // remove underscore
                return (String(label.dropFirst()), field)
            }
        )
    }

    static var keys: [[FieldKey]] {
        func collect(
            _ properties: [AnyProperty],
            prefix: [FieldKey] = [],
            into keys: inout [[FieldKey]]
        ) {
            properties.forEach {
                if $0 is AnyField {
                    keys.append(prefix + $0.path)
                }
                collect($0.nested, prefix: prefix + $0.path, into: &keys)
            }
        }
        var keys: [[FieldKey]] = []
        collect(self.init().properties, into: &keys)
        return keys
    }

}
