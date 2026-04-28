//
//  JSONPlaceholderClient.swift
//  IOS_LAB_2SEM
//

import Foundation

enum JSONPlaceholderClient: Sendable { //пространство имен
    private static let base = URL(string: "https://jsonplaceholder.typicode.com")!

    static func fetchUser(id: Int) async throws -> User {
        try Task.checkCancellation() //проверка флага не отменена ли задача то бросает ошибку
        let url = Self.base.appendingPathComponent("users/\(id)")
        let (data, response) = try await URLSession.shared.data(from: url) //отправляем get
        guard let http = response as? HTTPURLResponse, (200 ..< 300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(User.self, from: data)//декодируем json байты в user
    }
}
