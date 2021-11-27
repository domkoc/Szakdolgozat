//
//  UserProfilePresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 12..
//

import Foundation
import UIKit

protocol UserProfilePresenterInput: AnyObject {
    var view: UserProfileView? { get set }
    var interactor: ProfileInteractorInput { get set }
    var presentationModel: UserProfilePresentationModel { get set }
    func navigateToEditProfile()
    func isMyProfile() -> Bool
    func navigateToUsersEvents()
    func uploadProfilePicture(_ image: UIImage)
    func loadPicture()
}

class UserProfilePresenter {
    weak var view: UserProfileView?
    var interactor: ProfileInteractorInput
    private let coordinator: ProfileCoordinatorInput
    var presentationModel: UserProfilePresentationModel
    internal init(coordinator: ProfileCoordinatorInput,
                  interactor: ProfileInteractorInput,
                  view: UserProfileView,
                  presentationModel: UserProfilePresentationModel) {
        self.view = view
        self.interactor = interactor
        self.coordinator = coordinator
        self.presentationModel = presentationModel
    }
}

extension UserProfilePresenter: UserProfilePresenterInput {
    func navigateToEditProfile() {
        coordinator.navigateToEditProfile(with: presentationModel.profile)
    }
    func isMyProfile() -> Bool {
        presentationModel.profile.id == UserService.shared.currentUser?.id
    }
    func navigateToUsersEvents() {
        coordinator.navigateToEventsOf(presentationModel.profile.id)
    }
    func uploadProfilePicture(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        interactor.uploadProfilePicture(imageData) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.view?.updateImage(image)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
    func loadPicture() {
        interactor.getProfileImage(of: presentationModel.profile) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                self.view?.updateImage(image)
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message, handler: nil)
            }
        }
    }
}
