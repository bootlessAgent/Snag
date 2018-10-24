//
//  SnagCell.swift
//  Snag
//
//  Created by Eugene Trumpelmann on 2018/10/24.
//  Copyright © 2018 Eugene Trumpelmann. All rights reserved.
//

import UIKit

class SnagCell: UITableViewCell {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDetail: UITextView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellBackground: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
