//
//  ProfileViewController.swift
//  IOS_LAB_2SEM
//

import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {
    private let cardView = UIView()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let followButton = UIButton(type: .system)

    private var currentUser: User?
    private var followViewModel: UsersViewModel?

    override func viewDidLoad() { //метод жизненного цикла один раз при загрузке вью
        super.viewDidLoad() //род реализация
        view.backgroundColor = .systemGroupedBackground //основное вью серое
        title = "Профиль"

        setupCard() //карточка с элементами
        setupFollowButton() //настройки кнопки
        setupLayout() //расположение элементов
    }

    //обновляет данные
    func configure(user: User, followViewModel: UsersViewModel) { //показ нового польз
        self.followViewModel = followViewModel
        currentUser = user
        nameLabel.text = user.name
        emailLabel.text = user.email
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 48
        avatarImageView.layer.masksToBounds = true
        //используем библиотеку
        avatarImageView.kf.setImage(
            with: user.avatarURL,
            placeholder: UIImage(systemName: "person.crop.circle.fill")
        )
        applyFollowTitle() //кнопка подписан/не обновл
    }

    private func setupCard() {
        cardView.translatesAutoresizingMaskIntoConstraints = false //отключаем автомат изменение размеров
        cardView.backgroundColor = .secondarySystemGroupedBackground
        cardView.layer.cornerRadius = 16
        cardView.layer.cornerCurve = .continuous //скругление
    
        view.addSubview(cardView) //доб карт на вью

        [avatarImageView, nameLabel, emailLabel, followButton].forEach { //для каждого элемента убираем автомат огранич
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0) //добавляем в карточку
        }

        nameLabel.font = .preferredFont(forTextStyle: .title2)
        nameLabel.textColor = .label //адаптивные цвета для darkmode
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0

        emailLabel.font = .preferredFont(forTextStyle: .subheadline)
        emailLabel.textColor = .secondaryLabel
        emailLabel.textAlignment = .center
        emailLabel.numberOfLines = 0

        avatarImageView.contentMode = .scaleAspectFit //впис сохр пропорц
    }

    private func setupFollowButton() {
        followButton.addAction(UIAction { [weak self] _ in
            guard let self, let id = self.currentUser?.id else { return } //сущесвует ли контроллер и айди
            self.followViewModel?.toggleFollow(userId: id)//перекл статус подписки
            self.applyFollowTitle()
        }, for: .touchUpInside) //для нажатия кнопки
        applyFollowTitle() //обновл кнопку
    }

    private func applyFollowTitle() {
        var cfg = UIButton.Configuration.filled() //конфигурация для кнопки
        if let id = currentUser?.id, followViewModel?.isFollowing(userId: id) == true { //если есть айди и подписка
            cfg.title = "Following"
        } else {
            cfg.title = "Follow"
        }
        cfg.cornerStyle = .medium
        followButton.configuration = cfg //применяем конфигурацию
    }

    //настройки расположения
    private func setupLayout() {
        let avatarSize: CGFloat = 96
        //массив правил расп отступы от чего сколько
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            avatarImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: avatarSize),

            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            emailLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            followButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 20),
            followButton.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            followButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -20),
        ])
    }
}
