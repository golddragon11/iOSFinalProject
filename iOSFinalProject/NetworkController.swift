//import SwiftUI
//
//extension URL {
//    func withQueries(_ queries: [String: String]) -> URL? {
//        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
//        components?.queryItems = queries.map {
//            URLQueryItem(name: $0.0, value: $0.1)
//        }
//        return components?.url
//    }
//}
//
//enum NetworkError: Error{
//   case invalidURL
//}
//
//class NetworkController {
//    
//    static let shared = NetworkController()
//    
//    let baseURL = URL(string: "https://reqres.in/api")!
//    
//    func getUsers(page: Int, completion: @escaping (Result<UsersResponse, Error>) -> Void) {
//        let queries = ["page": "\(1)"]
//        guard let url = baseURL.appendingPathComponent("users").withQueries(queries) else {
//            completion(.failure(NetworkError.invalidURL))
//            return
//        }
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    let usersResponse = try decoder.decode(UsersResponse.self, from: data)
//                    completion(.success(usersResponse))
//                } catch  {
//                    completion(.failure(error))
//                }
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func createUser(_ user: CreateUserBody, completion: @escaping (Result<CreateUserResponse, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("users")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let encoder = JSONEncoder()
//        let data = try? encoder.encode(user)
//        request.httpBody = data
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    let dateFormatter = ISO8601DateFormatter()
//                    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//                        let container = try decoder.singleValueContainer()
//                        let dateString = try container.decode(String.self)
//                        if let date = dateFormatter.date(from: dateString) {
//                            return date
//                        } else {
//                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
//                        }
//                    })
//                    let createUserResponse = try decoder.decode(CreateUserResponse.self, from: data)
//                    completion(.success(createUserResponse))
//                } catch  {
//                    completion(.failure(error))
//                }
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func deleteUser(userId: Int, completion: @escaping (Result<String, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("users/\(userId)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "DELETE"
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let httpResponse = response as? HTTPURLResponse,
//               httpResponse.statusCode == 204 {
//                completion(.success("ok"))
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//    
//    func updateUser(_ user: UpdateUserBody, completion: @escaping (Result<UpdateUserResponse, Error>) -> Void) {
//        
//        let url = baseURL.appendingPathComponent("users")
//        var request = URLRequest(url: url)
//        request.httpMethod = "PUT"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let encoder = JSONEncoder()
//        let data = try? encoder.encode(user)
//        request.httpBody = data
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let data = data {
//                do {
//                    let decoder = JSONDecoder()
//                    let dateFormatter = ISO8601DateFormatter()
//                    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//                    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
//                        let container = try decoder.singleValueContainer()
//                        let dateString = try container.decode(String.self)
//                        if let date = dateFormatter.date(from: dateString) {
//                            return date
//                        } else {
//                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "")
//                        }
//                    })
//                    let updateUserResponse = try decoder.decode(UpdateUserResponse.self, from: data)
//                    completion(.success(updateUserResponse))
//                } catch  {
//                    completion(.failure(error))
//                }
//            } else if let error = error {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
//
///*
//// http method get test
//NetworkController.shared.getUsers(page: 1) { (result) in
//    switch result {
//    case .success(let usersResponse):
//        print(usersResponse)
//    case .failure(let error):
//        print(error)
//    }
//}
//// http method post test
//let createUserBody = CreateUserBody(name: "Peter", job: "Writer")
//NetworkController.shared.createUser(createUserBody) { (result) in
//    switch result {
//    case .success(let createUserResponse):
//        print(createUserResponse)
//    case .failure(let error):
//        print(error)
//    }
//}
//// http method delete test
//NetworkController.shared.deleteUser(userId: 2) { (result) in
//    switch result {
//    case .success(_):
//        print("delete ok")
//    case .failure(let error):
//        print(error)
//    }
//}
//// http method put test
//let updateUserBody = UpdateUserBody(name: "Peter", job: "情歌王子")
//NetworkController.shared.updateUser(updateUserBody) { (result) in
//    switch result {
//    case .success(let updateUserResponse):
//        print(updateUserResponse)
//    case .failure(let error):
//        print(error)
//    }
//}
//*/
