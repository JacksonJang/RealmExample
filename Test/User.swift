import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var password: String
}
