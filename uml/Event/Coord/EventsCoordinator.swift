//
//  EventsCoordinator.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation
import UIKit

protocol EventsCoordinatorInput {
    func navigateToNewEvent()
    func navigateToNewEvent(with parent: Event)
    func navigateToEventDetails(with event: Event)
    func navigateToProfile(of profile: Profile)
    func navigateToApplicants(of event: Event)
    func navigateBack()
    func navigateToSubEvents(of event: Event)
}

class EventsCoordinator {
    private weak var rootViewController: UINavigationController?
    private weak var appCoordinator: AppCoordinator?
    private let eventApi: EventAPIInput
    private let profileApi: ProfileAPIInput
    private let interactor: EventsInteractorInput
    init(rootViewController: UINavigationController,
         appCoordinator: AppCoordinator) {
        self.rootViewController = rootViewController
        self.appCoordinator = appCoordinator
        self.eventApi = EventAPI()
        self.profileApi = ProfileAPI()
        self.interactor = EventsInteractor(eventApi: eventApi,
                                           profileApi: profileApi)
    }
    func start(with userid: UUID? = nil) {
        let allEventsViewController = EventsViewControllerFactory.makeAllEventsViewController()
        let allEventsPresenter = AllEventsPresenter(view: allEventsViewController,
                                                    interactor: self.interactor,
                                                    coordinator: self,
                                                    userid: userid)
        allEventsViewController.presenter = allEventsPresenter
        rootViewController?.setNavigationBarHidden(false, animated: false)
        rootViewController?.pushViewController(allEventsViewController, animated: true)
    }
}

extension EventsCoordinator: EventsCoordinatorInput {
    func navigateToNewEvent() {
        let newEventViewController = EventsViewControllerFactory.makeNewEventViewController()
        let newEventPresenter = NewEventPresenter(view: newEventViewController,
                                                  interactor: self.interactor,
                                                  coordinator: self)
        newEventViewController.presenter = newEventPresenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(newEventViewController, animated: true)
    }
    func navigateToNewEvent(with parent: Event) {
        let newEventViewController = EventsViewControllerFactory.makeNewEventViewController()
        let newEventPresenter = NewEventPresenter(view: newEventViewController,
                                                  interactor: self.interactor,
                                                  coordinator: self,
                                                  mainEvent: parent)
        newEventViewController.presenter = newEventPresenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(newEventViewController, animated: true)
    }
    func navigateToEventDetails(with event: Event) {
        let eventDetailsViewController = EventsViewControllerFactory.makeEventDetailsViewController()
        let eventDetailsPresenter = EventDetailsPresenter(view: eventDetailsViewController,
                                                          interactor: self.interactor,
                                                          coordinator: self,
                                                          presentationModel: EventDetailsPresentationModel(event: event))
        eventDetailsViewController.presenter = eventDetailsPresenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(eventDetailsViewController, animated: true)
    }
    func navigateToProfile(of profile: Profile) {
        guard let rootViewController = self.rootViewController,
              let appCoordinator = self.appCoordinator else { return }
        ProfileCoordinator(rootViewController: rootViewController,
                           appCoordinator: appCoordinator)
            .start(with: profile)
    }
    func navigateToApplicants(of event: Event) {
        let eventApplicantsViewController = EventsViewControllerFactory.makeEventApplicantsViewController()
        let eventApplicantsPresenter = EventApplicantsPresenter(view: eventApplicantsViewController,
                                                                interactor: self.interactor,
                                                                coordinator: self,
                                                                event: event)
        eventApplicantsViewController.presenter = eventApplicantsPresenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(eventApplicantsViewController, animated: true)
    }
    func navigateBack() {
        rootViewController?.popViewController(animated: true)
    }
    func navigateToSubEvents(of event: Event) {
        let subEventsViewController = EventsViewControllerFactory.makeSubEventsViewController()
        let subEventsPresenter = SubEventsPresenter(view: subEventsViewController,
                                                    interactor: self.interactor,
                                                    coordinator: self,
                                                    parentEvent: event)
        subEventsViewController.presenter = subEventsPresenter
        rootViewController?.setNavigationBarHidden(false, animated: true)
        rootViewController?.pushViewController(subEventsViewController, animated: true)
    }
}
