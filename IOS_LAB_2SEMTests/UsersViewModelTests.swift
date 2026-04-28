//
//  UsersViewModelTests.swift
//  IOS_LAB_2SEMTests
//

import XCTest
@testable import IOS_LAB_2SEM

@MainActor //там же где и viewmodel
final class UsersViewModelTests: XCTestCase {
    //мок с одним юзером в вьюмодел вызываем загрузку и проверяем
    func testLoadOk() async {
        let mock = MockUsersService()
        let u = User(id: 1, name: "Test", username: "t", email: "t@test.com")
        mock.result = .success([u])
        let vm = UsersViewModel(service: mock)
        await vm.loadUsers(ids: [1])
        XCTAssertEqual(vm.users.count, 1)
        XCTAssertEqual(vm.users.first?.name, "Test")
        XCTAssertNil(vm.lastError)
    }

    func testLoadError() async {
        let mock = MockUsersService()
        mock.result = .failure(URLError(.badServerResponse))
        let vm = UsersViewModel(service: mock)
        await vm.loadUsers(ids: [1])
        XCTAssertTrue(vm.users.isEmpty)
        XCTAssertNotNil(vm.lastError)
    }

    func testLoadEmpty() async {
        let mock = MockUsersService()
        mock.result = .success([])
        let vm = UsersViewModel(service: mock)
        await vm.loadUsers(ids: [1, 2])
        XCTAssertTrue(vm.users.isEmpty)
        XCTAssertNil(vm.lastError)
    }
}
