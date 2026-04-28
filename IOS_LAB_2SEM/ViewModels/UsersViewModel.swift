//
//  UsersViewModel.swift
//  IOS_LAB_2SEM
//

import SwiftUI

@MainActor //для перерисовки публишед
final class UsersViewModel: ObservableObject {
    @Published private(set) var users: [User] = [] //только вьюмодел может менять вью нет
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: String?
    @Published private(set) var followedUserIds = Set<Int>()

    private let service: any UsersService
    private var loadTask: Task<Void, Never>? //тек задача
    //try Task.checkCancellation()
    
    init(service: any UsersService) { //di
        self.service = service
    }

    func cancelLoad() {
        guard let loadTask else { return } // есть ли тек задача
        loadTask.cancel()// флаг отмены
        self.loadTask = nil //обнуляем ссылку
    }

    func isFollowing(userId: Int) -> Bool {
        followedUserIds.contains(userId)
    }

    func toggleFollow(userId: Int) {
        var next = followedUserIds //копия
        if next.contains(userId) {
            next.remove(userId)
        } else {
            next.insert(userId)
        }
        followedUserIds = next
    }
    //запуск загрзуки
    func startLoad(ids: [Int] = Array(1 ... 10)) { //загрузка пользователей id 1...10
        loadTask?.cancel() //отменяем пред загрузку при повторном нажатии
        loadTask = Task { @MainActor in
            await loadUsers(ids: ids)
            loadTask = nil //обнуляем ссылку
        }
    }

    func loadUsers(ids: [Int] = Array(1 ... 10)) async {
        isLoading = true
        lastError = nil
        defer { isLoading = false } //выполнится в ллюбом случае инд загрузки

        do {
            let list = try await service.loadUsers(ids: ids) //параллельно загружаем юзеров
            try Task.checkCancellation()
            users = list
        } catch is CancellationError {
            lastError = nil
        } catch {
            lastError = error.localizedDescription
        }
    }
}
