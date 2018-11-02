//
//  CountriesAllViewController.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import SVProgressHUD

final class CountriesAllViewController: BaseViewController {
    
    @IBOutlet weak var countriesTable: UITableView!
    
    private let CELL_ID = "CountryCell"
    private let disposeBag = DisposeBag()
    private let refresher = Refresher()
    
    var viewModel: CountriesAllViewModel!
    
    convenience init(viewModel: CountriesAllViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries list"
        
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.dataReceived.subscribe { [weak self] event in
            guard let received = event.element else { return }
            if !received {
                self?.refresher.sendActions(for: .valueChanged)
            }
        }.disposed(by: disposeBag)        
    }
    
    private func setupUI() {
        countriesTable.dataSource = nil
        countriesTable.delegate = nil
        countriesTable.refreshControl = refresher
        
        countriesTable.register(UINib(nibName: CELL_ID, bundle: nil), forCellReuseIdentifier: CELL_ID)
    }
    
    private func setupBindings() {
        
        countriesTable.rx
            .itemSelected
            .do(onNext: { [weak self] in self?.countriesTable.deselectRow(at: $0, animated: true) })
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
        
        viewModel.countriesObservable
            .bind(to: countriesTable.rx.items) { table, i, item in
                let indexPath = IndexPath(row: i, section: 0)
                let cell = table.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
                cell.viewModel = item
                return cell
            }
            .disposed(by: disposeBag)
        
        refresher.rx
            .controlEvent(.valueChanged)
            .do(onNext: { [weak self] in self?.refresher.endRefreshing() })
            .subscribe { [weak self] _ in
                self?.viewModel.reload.onNext(true)
        }.disposed(by: disposeBag)
        
        viewModel.loaded.subscribe { (event) in
            guard let val = event.element else { return }
            if val
                { DispatchQueue.main.async { SVProgressHUD.dismiss() }
            } else
                { DispatchQueue.main.async { SVProgressHUD.show() } }
        }.disposed(by: disposeBag)

        viewModel.errorObservable.subscribe({ error in
            SVProgressHUD.showError(withStatus: error.element!)
        }).disposed(by: disposeBag)
        
    }
    
}
