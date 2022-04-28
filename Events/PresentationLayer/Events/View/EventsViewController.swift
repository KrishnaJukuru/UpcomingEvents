//
//  EventsViewController.swift
//  Events
//
//  Created by Krishna Jukuru on 04/27/22.
//  Copyright © 2022 Krishna Jukuru. All rights reserved.
//

import Foundation
import UIKit

class EventsViewController: BaseViewController {
    var viewModel = EventsViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        self.navigationController?.navigationBar.prefersLargeTitles = true
        fetchEvents()
    }

    private func fetchEvents() {
        viewModel.fetchallEvents(completionBlock: { [weak self ] (success, errString) in
            if success {
                self?.reloadData()
            } else {
                guard let errorMessage = errString else {
                    return
                }
                self?.showAlert(with: "Something went wrong", alertMessage: errorMessage)
            }
        })
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.groupKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = viewModel.groupKeys[section]
        return viewModel.eventsGroupedByDate[group]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let group = viewModel.groupKeys[section] else {
            return "Unknown"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: group)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier,
                                                 for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = viewModel.item(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.headerheight
    }
}
