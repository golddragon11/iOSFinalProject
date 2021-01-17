import SwiftUI

struct source: Codable {
    let name: String
}

struct article: Codable {
    let source: source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct TopHeadlinesResult: Codable {
    let status: String
    let totalResults: Int
    let articles: [article]
}


struct UsersResponse: Decodable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [User]
}
//struct User: Decodable {
//    let id: Int
//    let email: String
//    let firstName: String
//    let lastName: String
//    let avatar: URL
//}
struct CreateUserResponse: Decodable {
    let name: String
    let job: String
    let id: String
    let createdAt: Date
}
struct UpdateUserResponse: Decodable {
    let name: String
    let job: String
    let updatedAt: Date
}
struct CreateUserBody: Encodable {
    let name: String
    let job: String
}
struct UpdateUserBody: Encodable {
    let name: String
    let job: String
}
