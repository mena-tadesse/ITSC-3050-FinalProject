//
//  DetailViewController.swift
//  capstone
//
//  Created by Mena Tadesse on 4/14/25.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {
    
    enum BookBackgroundStyle {
        case favorited
        case notFavorited
        
        var backgroundColor: UIColor {
            switch self {
            case .favorited:
                return UIColor.systemPink.withAlphaComponent(0.1)
            case .notFavorited:
                return UIColor.systemBackground
            }
        }
    }

    @IBOutlet weak var summaryParagrahLabel: UITextView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = book.bookInfo.title
        authorLabel.text = book.bookInfo.authors?.joined(separator: ", ")
        ratingLabel.text = String(book.bookInfo.rating ?? 3.0)
        summaryParagrahLabel.text = book.bookInfo.description
        
        //need to replace http with https or else image wont render
        if let imageUrlString = book.bookInfo.image?.thumbnail.replacingOccurrences(of: "http://", with: "https://"),
           let imageUrl = URL(string: imageUrlString),
           let imageView = imageView {
            
            let request = ImageRequest(url: imageUrl)
            
            ImagePipeline.shared.loadImage(with: request) { result in
                switch result {
                case .success(let response):
                    imageView.image = response.image
                case .failure(let error):
                    print("❌ Failed to load image: \(error)")
                    imageView.image = UIImage(systemName: "photo") // fallback image
                }
            }
        }
        
        let style: BookBackgroundStyle = Book.getBooks(forKey: Book.favoritesKey).contains(book) ? .favorited : .notFavorited
        view.backgroundColor = style.backgroundColor

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
