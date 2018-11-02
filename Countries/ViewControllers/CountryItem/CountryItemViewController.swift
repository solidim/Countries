//
//  CountryItemViewController.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

final class CountryItemViewController: BaseViewController {
    
    @IBOutlet weak var detailsTable: UITableView!
    
    private let CELL_ID = "DetailsCell"

    private let disposeBag = DisposeBag()
    
    var viewModel: CountryItemViewModel!
    
    convenience init(viewModel: CountryItemViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupBindings()
    }
    
    private func setupUI() {
        detailsTable.dataSource = nil
        detailsTable.delegate = nil
        detailsTable.tableFooterView = UIView()
        
        detailsTable.register(UINib(nibName: CELL_ID, bundle: nil), forCellReuseIdentifier: CELL_ID)
    }
    
    private func setupBindings() {
        
        viewModel.countryName
            .bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
        
        viewModel.countryDetailsObservable.bind(to: detailsTable.rx.items(cellIdentifier: CELL_ID, cellType: DetailsCell.self))
            { _, element, cell in
                cell.lbHeader.text = element.header
                cell.lbDescription.text = element.desc
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

