//
//  AllEventsViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 15..
//

import Foundation
import UIKit

protocol AllEventsView: BaseView {
    var presenter: AllEventsPresenterInput? { get set }
    func loadEventsData(_ presentationModel: AllEventsPresentationModel)
}

class AllEventsViewController: UIViewController {
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var newEventButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var newEventButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newEventButton: UIButton!
    var presenter: AllEventsPresenterInput?
    private var presentationModel: AllEventsPresentationModel? {
        didSet {
            presenter?.presentationModel = self.presentationModel
            guard self.presentationModel != nil else { return }
            eventsTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadEventsData()
    }
    private func customizeViews() {
        customizeTableView()
    }
    private func customizeTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.registerCell(EventTableViewCell.self)
    }
    @IBAction func newEventButtonTapped(_ sender: UIButton) {
        presenter?.navigateToNewEvent()
    }
}

extension AllEventsViewController: AllEventsView {
    func loadEventsData(_ presentationModel: AllEventsPresentationModel) {
        self.presentationModel = presentationModel
        if presenter?.isUsersEvents() ?? false {
            newEventButton.isHidden = true
            newEventButtonHeightConstraint.constant = 0
            newEventButtonTopConstraint.constant = 0
        }
    }
}

extension AllEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presentationModel?.events.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventTableViewCell = tableView.dequeueReusableCell()
        guard let event = presentationModel?.events[indexPath.row] else { return cell }
        cell.configure(with: EventTableViewCellConfig(title: event.title,
                                                      eventStart: event.startDate,
                                                      eventEnd: event.endDate,
                                                      isApplyable: event.isApplyable))
        return cell
    }
}

extension AllEventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.navigateToEvent(index: indexPath.row)
    }
}
