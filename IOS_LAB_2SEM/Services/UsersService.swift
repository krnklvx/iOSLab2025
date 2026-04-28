//
//  UsersService.swift
//  IOS_LAB_2SEM
//

import Foundation

protocol UsersService {
    func loadUsers(ids: [Int]) async throws -> [User] //должны уметь
}

class RealUsersService: UsersService {
    private let cache = UsersCache(maxParallelFetches: 3)

    func loadUsers(ids: [Int]) async throws -> [User] {
        try await withThrowingTaskGroup(of: User.self) { group in //группа задач для параллельного выполнения
            for id in ids {
                group.addTask {
                    try await self.cache.loadUser(id: id) { uid in //если есть в кэше загружаем, если нет то идем в инет
                        try await JSONPlaceholderClient.fetchUser(id: uid)
                    }
                }
            }
            var result: [User] = []
            for try await user in group { //ждем каждую задачу
                result.append(user)
            }
            return result.sorted { $0.id < $1.id } //сортируем по айди
        }
    }
}

final class MockUsersService: UsersService {
    var result: Result<[User], Error> = .success([])

    func loadUsers(ids: [Int]) async throws -> [User] {
        switch result {
        case let .success(users):
            return users
        case let .failure(err):
            throw err
        }
    }
}
