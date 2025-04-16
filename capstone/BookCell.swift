//
//  BookCell.swift
//  capstone
//
//  Created by Mena Tadesse on 4/12/25.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bookPosterImageView: UIImageView!
    @IBOutlet weak var favoritesButton: UIButton!
    
    var book: Book?
    var onFavoriteToggled: (() -> Void)?
    
    @IBAction func didTapFavoriteButton(_ sender: UIButton) {
        //Set the button's isSelected state to the opposite of it's current value
        sender.isSelected = !sender.isSelected
        
        guard let book = book else { return }
        
        if sender.isSelected {
            book.addToFavorites()
        } else {
            book.removeFromFavorites()
        }
        
        onFavoriteToggled?() //notifies controller to refresh the table
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
