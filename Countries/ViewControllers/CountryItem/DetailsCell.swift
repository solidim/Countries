//
//  DetailsCell.swift
//  Countries
//
//  Created by Icandeliver on 31/10/2018.
//  Copyright © 2018 DS. All rights reserved.
//

import UIKit

final class DetailsCell: UITableViewCell {
    
    @IBOutlet weak var lbHeader: UILabel!
    
    @IBOutlet weak var lbDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
        
}
