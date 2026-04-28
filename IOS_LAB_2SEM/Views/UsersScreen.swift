//
//  UsersScreen.swift
//  IOS_LAB_2SEM
//

import SwiftUI
import UIComponents

struct UsersScreen: View {
    @StateObject private var viewModel: UsersViewModel

    init(service: any UsersService = RealUsersService()) { //любой объект подходящий под протокол
        _viewModel = StateObject(wrappedValue: UsersViewModel(service: service)) //следит за состоянием
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                if let err = viewModel.lastError { //отображение ошибки
                    Text(err)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                HStack(spacing: 8) {
                    Button("Загрузить 1…10") {
                        viewModel.startLoad()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading) //при нажатии серая загрузка

                    Button("Отменить") {
                        viewModel.cancelLoad()
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.isLoading) //не активна если нет загрузки
                }

                //список юзеров
                List(viewModel.users) { user in //для каждого строка
                    NavigationLink {
                        ProfileDetailView(viewModel: viewModel, user: user)
                    } label: {
                        UserCardView(
                            name: user.name,
                            email: user.email,
                            detail: "@\(user.username) · id \(user.id)",
                            imageURL: user.avatarURL
                        )
                    }
                }
                .overlay { //загрузка поверх
                    if viewModel.isLoading {
                        LoadingView(message: "Загрузка…")
                    }
                }
            }
            .padding()
            .navigationTitle("Users")
        }
    }
}
