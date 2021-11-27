//
//  LoginPresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 06..
//

import Foundation

protocol LoginPresenterInput: AnyObject {
    var view: LoginView? { get set }
    var interactor: AuthenticationInteractorInput { get set }
    func navigateToRegister()
    func login()
}

class LoginPresenter {
    weak var view: LoginView?
    var interactor: AuthenticationInteractorInput
    private let coordinator: AuthenticationCoordinatorInput
    init(coordinator: AuthenticationCoordinatorInput,
         interactor: AuthenticationInteractorInput,
         view: LoginView) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.view = view
    }
}

extension LoginPresenter: LoginPresenterInput {
    func login() {
        guard let credentials = view?.credentials() else {
            return
        }
        view?.startLoading()
        interactor.login(credentials: Login(email: credentials.email,
                                            password: credentials.password)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let loginResult):
                self.coordinator.navigateToMainScreen()
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
            self.view?.stopLoading()
        }
    }
    func navigateToRegister() {
        coordinator.navigateToRegister()
    }
}
