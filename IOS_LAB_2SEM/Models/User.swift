//
//  User.swift
//  IOS_LAB_2SEM
//

import Foundation

struct User: Codable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
