//
//  SubEventsViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 22..
//

import Foundation
import UIKit

protocol SubEventsView: BaseView {
    var presenter: SubEventsPresenterInput? { get set }
    func loadData()
}

class SubEventsViewController: UIViewController {
    @IBOutlet weak var subEventsTableView: UITableView!
    var presenter: SubEventsPresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.loadData()
    }
    private func customizeViews() {
        customizeTableView()
    }
    private func customizeTableView() {
        subEventsTableView.dataSource = self
        subEventsTableView.registerCell(SubEventsTableViewCell.self)
    }
    @IBAction func newSubEventButtonTapped(_ sender: UIButton) {
        presenter?.navigateToNewSubEvent()
    }
}

extension SubEventsViewController: SubEventsView {
    func loadData() {
        subEventsTableView.reloadData()
    }
}

extension SubEventsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.presentationModel?.subEvents.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SubEventsTableViewCell = tableView.dequeueReusableCell()
        guard let subEvent = presenter?.presentationModel?.subEvents[indexPath.row] else { return cell }
        cell.configure(with: SubEventsTableViewCellConfig(event: subEvent))
        cell.delegate = self
        return cell
    }
}

extension SubEventsViewController: SubEventsTableViewCellDelegate {
    func subEventSelected(_ event: Event) {
        presenter?.navigateToSubEvent(event)
    }
}
