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
        let testUser = User(id: 1, name: "Test", username: "t", email: "t@test.com")
        mock.result = .success([testUser])
        let viewModel = UsersViewModel(service: mock)
        await viewModel.loadUsers(ids: [1])
        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.name, "Test")
        XCTAssertNil(viewModel.lastError)
    }

    func testLoadError() async {
        let mock = MockUsersService()
        mock.result = .failure(URLError(.badServerResponse))
        let viewModel = UsersViewModel(service: mock)
        await viewModel.loadUsers(ids: [1])
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNotNil(viewModel.lastError)
    }

    func testLoadEmpty() async {
        let mock = MockUsersService()
        mock.result = .success([])
        let viewModel = UsersViewModel(service: mock)
        await viewModel.loadUsers(ids: [1, 2])
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertNil(viewModel.lastError)
    }
}
