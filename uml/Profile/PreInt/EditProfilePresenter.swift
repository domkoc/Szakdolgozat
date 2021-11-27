//
//  EditProfilePresenter.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 14..
//

import Foundation

protocol EditProfilePresenterInput: AnyObject {
    var view: EditProfileView? { get set }
    var interactor: ProfileInteractorInput { get set }
    func saveChanges(with credentials: EditedProfileCredentials)
    func getIdOfUser() -> UUID
    func getPresentationModel() -> EditProfilePresentationModel
}

class EditProfilePresenter {
    weak var view: EditProfileView?
    var interactor: ProfileInteractorInput
    private let coordinator: ProfileCoordinator
    private var presentationModel: EditProfilePresentationModel
    init(coordinator: ProfileCoordinator,
         interactor: ProfileInteractorInput,
         view: EditProfileView,
         presentationModel: EditProfilePresentationModel) {
        self.coordinator = coordinator
        self.interactor = interactor
        self.view = view
        self.presentationModel = presentationModel
    }
}

extension EditProfilePresenter: EditProfilePresenterInput {
    func saveChanges(with credentials: EditedProfileCredentials) {
        interactor.saveProfile(credentials: credentials) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.coordinator.navigateToMainScreen()
            case .failure(.error(let message)):
                self.view?.showErrorAlert(message: message) { _ in
                    self.view?.enableSaveButton()
                }
            }
            self.view?.stopLoading()
        }
    }
    func getIdOfUser() -> UUID {
        presentationModel.profile.id
    }
    func getPresentationModel() -> EditProfilePresentationModel {
        presentationModel
    }
}
