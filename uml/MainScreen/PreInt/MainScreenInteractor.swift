//
//  MainScreenInteractor.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation

enum MainScreenInteractorSuccess {
    enum Logout {
        case loggedOut
    }
}

enum MainScreenInteractorError: Error {
    case error(String)
}

protocol MainScreenInteractorInput: AnyObject {
    func getProfile(completion: @escaping (Result<Profile, MainScreenInteractorError>) -> Void)
    func logout(completion: @escaping (Result<MainScreenInteractorSuccess.Logout,
                                       MainScreenInteractorError>) -> Void)
}

class MainScreenInteractor {
    private let profileApi: ProfileAPIInput
    private let authenticationService: AuthenticationService
    init(profileApi: ProfileAPIInput,
         authenticationService: AuthenticationService) {
        self.profileApi = profileApi
        self.authenticationService = authenticationService
    }
}

extension MainScreenInteractor: MainScreenInteractorInput {
    func getProfile(completion: @escaping (Result<Profile, MainScreenInteractorError>) -> Void) {
        profileApi.getProfile { result in
            switch result {
            case .success(let profileDto):
                completion(.success(Profile(dto: profileDto)))
            case .error(let message):
                completion(.failure(.error(message)))
            }
        }
    }
    func logout(completion: @escaping (Result<MainScreenInteractorSuccess.Logout,
                                       MainScreenInteractorError>) -> Void) {
        authenticationService.logout { result in
            switch result {
            case .success:
                completion(.success(.loggedOut))
            case .failure(.error(let message)):
                completion(.failure(.error(message)))
            }
        }
    }
}
