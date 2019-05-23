//
//  QuestionCell.swift
//  TestProject
//
//  Created by Newagesmb/ArunM on 5/3/19.
//  Copyright © 2019 Newagesmb/ArunM. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var questionLblHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
