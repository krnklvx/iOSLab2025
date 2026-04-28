//
//  ProfileDetailView.swift
//  IOS_LAB_2SEM
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var viewModel: UsersViewModel //использует
    let user: User

    private var resolvedUser: User { //свежая версия
        viewModel.users.first(where: { $0.id == user.id }) ?? user
    }

    var body: some View {
        ProfileControllerWrapper(viewModel: viewModel, user: resolvedUser) //обертка ukit
            .navigationBarTitleDisplayMode(.inline)
    }
}
