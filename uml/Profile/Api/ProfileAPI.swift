//
//  ProfileAPI.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Alamofire
import Foundation

protocol ProfileAPIInput {
    func getProfile(completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void)
    func editProfile(with credentials: ProfileEditDto,
                     completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void)
    func getProfilebyId(with id: UUID,
                        completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void)
    func uploadProfilePicture(_ image: ProfilePictureUploadDto,
                              progressCompletion: @escaping (Double) -> Void,
                              completion: @escaping (APIBase.EmptyAPIResult) -> Void)
    func getProfilePicture(of userid: UUID,
                           completion: @escaping (APIBase.APIResult<UIImage>) -> Void)
}

class ProfileAPI: APIBase { }

extension ProfileAPI: ProfileAPIInput {
    func getProfile(completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void) {
        NetworkManager.shared.request(method: .get,
                                      path: "/users/me",
                                      isAuthenticated: true,
                                      completion: { (result: NetworkManager.Result<ProfileDownloadDto>) in
                                        switch result {
                                        case .success(let profile):
                                            completion(.success(profile))
                                        case .customError(let error):
                                            let message = self.errorManager.errorMessage(for: error)
                                            completion(.error(message))
                                        case .other:
                                            let message = self.errorManager.errorMessage()
                                            completion(.error(message))
                                        }
                                      })
    }
    func editProfile(with credentials: ProfileEditDto,
                     completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void) {
        NetworkManager.shared.request(method: .put,
                                      path: "/users/update",
                                      body: credentials,
                                      isAuthenticated: true,
                                      completion: { (result: NetworkManager.Result<ProfileDownloadDto>) in
                                        switch result {
                                        case .success(let profile):
                                            completion(.success(profile))
                                        case .customError(let error):
                                            let message = self.errorManager.errorMessage(for: error)
                                            completion(.error(message))
                                        case .other:
                                            let message = self.errorManager.errorMessage()
                                            completion(.error(message))
                                        }
                                      })
    }
    func getProfilebyId(with id: UUID,
                        completion: @escaping (APIBase.APIResult<ProfileDownloadDto>) -> Void) {
        NetworkManager.shared.request(method: .get,
                                      path: "/users/\(id.uuidString)",
                                      isAuthenticated: true,
                                      completion: { (result: NetworkManager.Result<ProfileDownloadDto>) in
                                        switch result {
                                        case .success(let profile):
                                            completion(.success(profile))
                                        case .customError(let error):
                                            let message = self.errorManager.errorMessage(for: error)
                                            completion(.error(message))
                                        case .other:
                                            let message = self.errorManager.errorMessage()
                                            completion(.error(message))
                                        }
                                      })
    }
    func uploadProfilePicture(_ image: ProfilePictureUploadDto,
                              progressCompletion: @escaping (Double) -> Void,
                              completion: @escaping (APIBase.EmptyAPIResult) -> Void) {
        NetworkManager.shared.uploadPicture(
            path: "/users/me/image",
            imageData: image.image,
            completion: { result in
                switch result {
                case .success:
                    completion(.success)
                case .customError(let error):
                    let message = self.errorManager.errorMessage(for: error)
                    completion(.error(message))
                case .other:
                    let message = self.errorManager.errorMessage()
                    completion(.error(message))
                }
            },
            progressHandler: progressCompletion)
    }
    func getProfilePicture(of userid: UUID,
                           completion: @escaping (APIBase.APIResult<UIImage>) -> Void) {
        NetworkManager.shared.getPicture(
            path: "/users/\(userid.uuidString)/image",
            completion: { result in
                guard let image = result else {
                    completion(.error("Could not load image!"))
                    return
                }
                completion(.success(image))
            })
    }
}
