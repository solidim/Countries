//
//  CountryCell.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit
import RxSwift

final class CountryCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbPopulation: UILabel!
    
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        accessoryType = .disclosureIndicator
    }
    
    var viewModel: CountriesAllTableViewModelType? {
        willSet {
            disposeBag = DisposeBag()
        }
        didSet {
            setupBindings()
        }
    }
    
    func setupBindings() {
        guard let viewModel = viewModel else { return }
        
        viewModel.name.bind(to: lbName.rx.text).disposed(by: disposeBag)
        viewModel.population.bind(to: lbPopulation.rx.text).disposed(by: disposeBag)
    }

        
}
