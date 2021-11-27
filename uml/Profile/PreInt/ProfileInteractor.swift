//
//  ProfileInteractor.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 12..
//

import Foundation
import UIKit

struct ProfileInteractorSuccess {
    enum Save {
        case saved
    }
    enum Upload {
        case uploaded
    }
}

enum ProfileInteractorError: Error {
    case error(String)
}

protocol ProfileInteractorInput: AnyObject {
    func saveProfile(credentials: EditedProfileCredentials,
                  completion: @escaping (Result<ProfileInteractorSuccess.Save,
                                         ProfileInteractorError>) -> Void)
    func uploadProfilePicture(_ image: Data,
                              completion: @escaping (Result<ProfileInteractorSuccess.Upload,
                                                     ProfileInteractorError>) -> Void)
    func getProfileImage(of user: Profile,
                         completion: @escaping (Result<UIImage,
                                                ProfileInteractorError>) -> Void)
}

class ProfileInteractor {
    private let profileApi: ProfileAPIInput
    init(profileApi: ProfileAPIInput) {
        self.profileApi = profileApi
    }
}

extension ProfileInteractor: ProfileInteractorInput {
    func saveProfile(credentials: EditedProfileCredentials,
                  completion: @escaping (Result<ProfileInteractorSuccess.Save,
                                         ProfileInteractorError>) -> Void) {
        profileApi.editProfile(with: credentials.dto) { result in
            switch result {
            case .success:
                completion(.success(.saved))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func uploadProfilePicture(_ image: Data,
                              completion: @escaping (Result<ProfileInteractorSuccess.Upload,
                                                     ProfileInteractorError>) -> Void) {
        profileApi.uploadProfilePicture(ProfilePictureUploadDto(image: image),
                                        progressCompletion: {_ in },
                                        completion: { result in
            switch result {
            case .success:
                completion(.success(.uploaded))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        })
    }
    func getProfileImage(of user: Profile,
                         completion: @escaping (Result<UIImage,
                                                ProfileInteractorError>) -> Void) {
        profileApi.getProfilePicture(of: user.id) { result in
            switch result {
            case .success(let image):
                completion(.success(image))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
}
