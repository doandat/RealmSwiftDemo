//
//  DogCell.swift
//  RealmSwiftDemo
//
//  Created by DatDV on 9/21/16.
//  Copyright © 2016 DatDV. All rights reserved.
//

import UIKit

class DogCell: UITableViewCell {

    
    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbAge: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
