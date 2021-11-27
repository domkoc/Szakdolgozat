//
//  MainCoordinator.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation
import UIKit

protocol MainScreenCoordinatorInput {
    func navigateBackToRoot()
    func navigateBackToLogin()
    func navigateToProfile(with profile: Profile)
    func navigateToEvents()
}

class MainScreenCoordinator {
    private let rootViewController: UINavigationController
    private var appCoordinator: AppCoordinator
    private let profileApi: ProfileAPIInput
    init(rootViewController: UINavigationController,
         appCoordinator: AppCoordinator) {
        self.rootViewController = rootViewController
        self.appCoordinator = appCoordinator
        self.profileApi = ProfileAPI()
    }
    func start() {
        navigateMainScreen()
        navigateBackToRoot()
    }
    func navigateMainScreen() {
        let mainScreenViewController = MainScreenViewControllerFactory.makeMainScreenViewController()
        let interactor = MainScreenInteractor(profileApi: self.profileApi,
                                              authenticationService: .shared)
        let presenter = MainScreenPresenter(coordinator: self,
                                           interactor: interactor,
                                           view: mainScreenViewController)
        mainScreenViewController.presenter = presenter
        rootViewController.setNavigationBarHidden(false, animated: false)
        rootViewController.setViewControllers([mainScreenViewController], animated: false)
    }
}

extension MainScreenCoordinator: MainScreenCoordinatorInput {
    func navigateBackToRoot() {
        rootViewController.popToRootViewController(animated: false)
    }
    func navigateBackToLogin() {
        appCoordinator.navigateBackToLogin()
    }
    func navigateToProfile(with profile: Profile) {
        ProfileCoordinator(rootViewController: self.rootViewController,
                           appCoordinator: self.appCoordinator)
            .start(with: profile)
    }
    func navigateToEvents() {
        EventsCoordinator(rootViewController: self.rootViewController,
                          appCoordinator: self.appCoordinator)
            .start()
    }
}
