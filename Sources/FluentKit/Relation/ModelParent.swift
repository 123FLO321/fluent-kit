@_propertyWrapper
public final class Parent<Value>: Property
    where Value: Model
{
    var name: String?
    var dataType: DatabaseSchema.DataType?
    var constraints: [DatabaseSchema.FieldConstraint]

    public var value: Value {
        get { fatalError() }
        set { fatalError() }
    }

    public init() {
        self.name = nil
        self.dataType = nil
        self.constraints = []
    }
}
//    public let id: ModelField<Child, Parent.ID>
//
//    public var name: String {
//        return self.id.name
//    }
//
//    public var type: Any.Type {
//        return self.id.type
//    }
//
//    public var dataType: DatabaseSchema.DataType? {
//        return self.id.dataType
//    }
//
//    public var constraints: [DatabaseSchema.FieldConstraint] {
//        return self.id.constraints
//    }
//
//    public init(_ id: ModelField<Child, Parent.ID>) {
//        self.id = id
//    }
//
//    func cached(from output: DatabaseOutput) throws -> Any? {
//        return try self.id.cached(from: output)
//    }
//
//    func encode(to encoder: inout ModelEncoder, from storage: ModelStorage) throws {
//        if let cache = storage.eagerLoads[Parent.entity] {
//            let parent = try cache.get(id: storage.get(self.id.name, as: Parent.ID.self))
//                .map { $0 as! Parent.Row }
//                .first!
//            try encoder.encode(parent, forKey: "\(Parent.self)".lowercased())
//        } else {
//            try self.id.encode(to: &encoder, from: storage)
//        }
//    }
//
//    func decode(from decoder: ModelDecoder, to storage: inout ModelStorage) throws {
//        try self.id.decode(from: decoder, to: &storage)
//    }
//}
//
//extension Model {
//    public typealias Parent<ParentType> = ModelParent<Self, ParentType>
//        where ParentType: Model
//
//    public typealias ParentKey<ParentType> = KeyPath<Self, Parent<ParentType>>
//        where ParentType: Model
//
//    public static func parent<T>(forKey key: ParentKey<T>) -> Parent<T> {
//        return self.shared[keyPath: key]
//    }
//}

//
//extension ModelParent: ModelProperty {
//    public var name: String {
//        return self.id.name
//    }
//
//    public var type: Any.Type {
//        return self.id.type
//    }
//
//    public var dataType: DatabaseSchema.DataType? {
//        return self.id.dataType
//    }
//
//    public var constraints: [DatabaseSchema.FieldConstraint] {
//        return self.id.constraints
//    }
//
//    public func encode(to encoder: inout ModelEncoder) throws {

//    }
//
//    public func decode(from decoder: ModelDecoder) throws {
//        try self.id.decode(from: decoder)
//    }
//}

