//
//  MyBikeParkListViewController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import UIKit

class MyBikeParkListViewController: UITableViewController {

    @IBOutlet weak var noMyBikeSpotView: UIView! {
        didSet {
            noMyBikeSpotView.isHidden = true
        }
    }

    private var presenter: MyBikeParkListPresenter!
    func inject(presenter: MyBikeParkListPresenter) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        presenter.viewWillAppear()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return presenter.myBikeParksCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.myBikeParkCell, for: indexPath)

        if let myBikePark = presenter.myBikePark(forRow: indexPath.row) {
            cell.textLabel?.text = myBikePark.name
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.removeMyBikePark(forRow: indexPath.row)
    }
}

extension MyBikeParkListViewController: MyBikeParkListPresenterOutput {

    func showNoMyBikeParkMessage() {
        noMyBikeSpotView.isHidden = false
    }

    func hideNoMyBikeParkMessage() {
        noMyBikeSpotView.isHidden = true
    }

    func updateMyBikePark() {
        tableView.reloadData()
    }
}
