//
//  RegisterPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 14..
//

import Foundation

protocol RegisterPresenterInput: AnyObject {
    var view: RegisterView? { get set }
    var interactor: AuthenticationInteractorInput { get set }
    func register(with credentials: ProfileUploadDto)
}

class RegisterPresenter {
    weak var view: RegisterView?
    var interactor: AuthenticationInteractorInput
    private let coordinator: AuthenticationCoordinatorInput
    init(coordinator: AuthenticationCoordinatorInput,
         interactor: AuthenticationInteractorInput,
         view: RegisterView) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.view = view
    }
}

extension RegisterPresenter: RegisterPresenterInput {
    func register(with credentials: ProfileUploadDto) {
        interactor.register(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.navigateBackToLogin()
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message) { _ in
                    self.view?.enableRegisterButton()
                }
            }
        }
    }
}
