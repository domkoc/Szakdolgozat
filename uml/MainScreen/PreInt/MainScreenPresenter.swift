//
//  MainScreenPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation

protocol MainScreenPresenterInput: AnyObject {
    var view: MainScreenView? { get set }
    var interactor: MainScreenInteractorInput { get set }
    func loadProfileData()
    func navigateToEvents()
    func navigateToProfile(with profile: Profile)
    func logout()
}

class MainScreenPresenter {
    weak var view: MainScreenView?
    var interactor: MainScreenInteractorInput
    private let coordinator: MainScreenCoordinatorInput
    private var profilePresentationModel: Profile?
    init(coordinator: MainScreenCoordinatorInput,
         interactor: MainScreenInteractorInput,
         view: MainScreenView) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.view = view
    }
}

extension MainScreenPresenter: MainScreenPresenterInput {
    func loadProfileData() {
        interactor.getProfile { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                let tempPresentationModel = MainScreenPresentationModel(profile: profile)
                self.view?.loadProfileData(tempPresentationModel)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
            self.view?.stopLoading()
        }
    }
    func navigateToEvents() {
        coordinator.navigateToEvents()
    }
    func navigateToProfile(with profile: Profile) {
        coordinator.navigateToProfile(with: profile)
    }
    func logout() {
        interactor.logout { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.navigateBackToLogin()
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
            self.view?.stopLoading()
        }
    }
}
