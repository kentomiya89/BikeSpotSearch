//
//  MyBikeParkListViewController.swift
//  BikeSpotSearch
//
//  Created by kentomiyabayashi on 2020/12/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MyBikeParkListViewController: UITableViewController {

    @IBOutlet weak var noMyBikeSpotView: UIView!

    private let disposebag = DisposeBag()
    private lazy var viewModel = MyBikeParkListViewModel(itemDeleted: tableView.rx.itemDeleted.asObservable(),
                                                         model: MyBikeParkListModel())

    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<BikeParkSectionModel> { _, tableView, indexPath, myBikePark -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.myBikeParkCell,
                                                 for: indexPath)
        cell.textLabel?.text = myBikePark.name
        return cell
    } canEditRowAtIndexPath: { _, _ in
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBind()
    }

    private func setUpTableView() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: TableViewCellIdentifier.myBikeParkCell)
    }

    private func viewModelBind() {

        viewModel.noBikeSpotViewIsHidden
            .bind(to: noMyBikeSpotView.rx.isHidden)
            .disposed(by: disposebag)

        viewModel.bikeParkSection
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposebag)
    }
}
