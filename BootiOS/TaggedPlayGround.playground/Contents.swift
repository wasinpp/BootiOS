import Foundation
import BootiOSFramework

let usersJson = """
[
{
"id": 1,
"name": "Brandon",
"email": "brandon@pointfree.co",
"subscriptionId": 1
},
{
"id": 2,
"name": "Stephen",
"email": "stephen@pointfree.co",
"subscriptionId": null
},
{
"id": 3,
"name": "Blob",
"email": "blob@pointfree.co",
"subscriptionId": 1
}
]
"""

//struct Email: Decodable, RawRepresentable { let rawValue: String }
// {"email": String}
enum EmailTag {}
typealias Email = Tagged<EmailTag, String>

//newtype Email = String
struct Subscription: Decodable {
  //  struct Id: Decodable, RawRepresentable, Equatable { let rawValue: Int }
  typealias Id = Tagged<Subscription, Int>

  let id: Id
  let ownerId: User.Id
}

struct User: Decodable {
  //  struct Id: Decodable, RawRepresentable { let rawValue: Int }
  typealias Id = Tagged<User, Int>

  let id: Id
  let name: String
  let email: Email
  let subscriptionId: Subscription.Id?
}

//{
//  "id": 3,
//  "name": "Blob",
//  "email": {"email": "blob@pointfree.co"},
//  "subscriptionId": 1
//}
User.init(from:)


let subscriptionsJson = """
[
{
"id": 1,
"ownerId": 1
}
]
"""

let decoder = JSONDecoder()

let users = try! decoder.decode([User].self, from: Data(usersJson.utf8))

let subscriptions = try! decoder.decode([Subscription].self, from: Data(subscriptionsJson.utf8))


func sendEmail(email: Email) {
  //
}

typealias _Email = String

let user = users[0]
sendEmail(email: user.email)
//sendEmail(email: user.name)
//RawRepresentable

enum Status: Int {
  case ok = 200
  case notFound = 404
}

Status.ok.rawValue
Status.init(rawValue: 200)
Status.init(rawValue: 600)


subscriptions
  .first { $0.id == user.subscriptionId }

//subscriptions
//  .first { $0.id == user.id }
