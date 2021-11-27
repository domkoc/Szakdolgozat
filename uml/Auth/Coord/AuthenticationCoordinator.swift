//
//  AuthenticationCoordinator.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation
import UIKit

protocol AuthenticationCoordinatorInput {
    func navigateToRegister()
    func navigateToMainScreen()
    func navigateBackToLogin()
}

class AuthenticationCoordinator {
    private weak var rootViewController: UINavigationController?
    private weak var appCoordinator: AppCoordinator?
    private let authenticationApi: AuthenticationAPIInput
    private let profileApi: ProfileAPIInput
    private var interactor: AuthenticationInteractorInput
    private let authenticationService: AuthenticationService
    init(rootViewController: UINavigationController, appCoordinator: AppCoordinator) {
        self.rootViewController = rootViewController
        self.appCoordinator = appCoordinator
        self.authenticationApi = AuthenticationAPI()
        self.profileApi = ProfileAPI()
        self.interactor = AuthenticationInteractor(authenticationApi: authenticationApi,
                                                   profileApi: profileApi,
                                                   authenticationService: AuthenticationService.shared)
        self.authenticationService = .shared
    }
    func start() {
        navigateToLogin()
        if authenticationService.hasValidAccessToken {
            navigateToMainScreen()
        }
    }
    private func navigateToLogin() {
        let loginViewController = AuthenticationViewControllerFactory.makeLoginViewController()
        let presenter = LoginPresenter(coordinator: self,
                                       interactor: interactor,
                                       view: loginViewController)
        loginViewController.presenter = presenter
        rootViewController?.setNavigationBarHidden(true, animated: false)
        rootViewController?.pushViewController(loginViewController, animated: true)
    }
}

extension AuthenticationCoordinator: AuthenticationCoordinatorInput {
    func navigateToRegister() {
        let registerViewController = AuthenticationViewControllerFactory.makeRegisterViewController()
        let presenter = RegisterPresenter(coordinator: self, interactor: self.interactor, view: registerViewController)
        registerViewController.presenter = presenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(registerViewController, animated: true)
    }
    func navigateToMainScreen() {
        appCoordinator?.navigateToMainScreen()
    }
    func navigateBackToLogin() {
        let loginViewController = AuthenticationViewControllerFactory.makeLoginViewController()
        let interactor = AuthenticationInteractor(authenticationApi: authenticationApi,
                                                  profileApi: profileApi,
                                                  authenticationService: authenticationService)
        let presenter = LoginPresenter(coordinator: self, interactor: interactor, view: loginViewController)
        loginViewController.presenter = presenter
        rootViewController?.setNavigationBarHidden(true, animated: false)
        rootViewController?.setViewControllers([loginViewController], animated: false)
    }
}
