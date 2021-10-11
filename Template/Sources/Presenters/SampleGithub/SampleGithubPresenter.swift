//
//  SampleGithubPresenter.swift
//  Template
//
//  Created by doi on 2021/07/26.
//

import Combine
import UIKit

final class SampleGithubPresenter {
    class Input {
        let didTapUserDetail = PassthroughSubject<String, Never>()
        let didTapUserFollowing = PassthroughSubject<String, Never>()
    }

    var input: Input

    private let navigator: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    init(navigator: UINavigationController) {
        self.input = Input()
        self.navigator = navigator
        bind()
    }

    func bind() {
        input.didTapUserDetail
            .sink { [weak self] urlString in
                guard let self = self, let url = URL(string: urlString) else { return }
                let coordinator = SampleGithubWebViewCoordinator(navigator: self.navigator, url: url)
                coordinator.start()
            }
            .store(in: &cancellables)
        
        input.didTapUserFollowing
            .sink { [weak self] login in
                guard let self = self, !login.isEmpty else { return }
                let coordinator = SampleGithubFollowingCoordinator(self.navigator, login: login, navigationDelegate: self.navigator)
                coordinator.start()
            }
            .store(in: &cancellables)
    }
}
