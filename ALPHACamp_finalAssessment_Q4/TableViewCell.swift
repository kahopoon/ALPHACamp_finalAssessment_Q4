//
//  TableViewCell.swift
//  ALPHACamp_finalAssessment_Q4
//
//  Created by Ka Ho on 16/5/2016.
//  Copyright © 2016 Ka Ho. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel, arrivedStationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
