//
//  DetailTableViewCell.swift
//  Word Scramble Project
//
//  Created by Anderson Sales on 31/10/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    
    static let identifier: String = "DetailTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupCell(name: String){
        wordLabel.text = name
    }
    
}
