//
//  ProfileCoordinator.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 12..
//

import Foundation
import UIKit

protocol ProfileCoordinatorInput {
    func navigateToEditProfile(with profile: Profile)
    func navigateToMainScreen()
    func navigateToEventsOf(_ userid: UUID)
}

class ProfileCoordinator {
    private weak var rootViewController: UINavigationController?
    private weak var appCoordinator: AppCoordinator?
    private let profileApi: ProfileAPIInput
    private let interactor: ProfileInteractorInput
    init(rootViewController: UINavigationController,
         appCoordinator: AppCoordinator) {
        self.rootViewController = rootViewController
        self.appCoordinator = appCoordinator
        self.profileApi = ProfileAPI()
        self.interactor = ProfileInteractor(profileApi: profileApi)
    }
    func start(with profile: Profile) {
        let userProfileViewController = ProfileViewControllerFactory.makeUserProfileViewController()
        let userProfilePresenter = UserProfilePresenter(coordinator: self,
                                                        interactor: self.interactor,
                                                        view: userProfileViewController,
                                                        presentationModel: UserProfilePresentationModel(profile: profile))
        userProfileViewController.presenter = userProfilePresenter
        rootViewController?.setNavigationBarHidden(false, animated: false)
        rootViewController?.pushViewController(userProfileViewController, animated: true)
    }
}

extension ProfileCoordinator: ProfileCoordinatorInput {
    func navigateToEditProfile(with profile: Profile) {
        let editProfileViewController = ProfileViewControllerFactory.makeEditProfileViewController()
        let presenter = EditProfilePresenter(coordinator: self,
                                             interactor: self.interactor,
                                             view: editProfileViewController,
                                             presentationModel: EditProfilePresentationModel(profile: profile))
        editProfileViewController.presenter = presenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(editProfileViewController, animated: true)
    }
    func navigateToMainScreen() {
        appCoordinator?.navigateToMainScreen()
    }
    func navigateToEventsOf(_ userid: UUID) {
        guard let rootViewController = self.rootViewController,
              let appCoordinator = self.appCoordinator else { return }
        EventsCoordinator(rootViewController: rootViewController,
                          appCoordinator: appCoordinator)
            .start(with: userid)
    }
}
