//
//  FavoritesViewController.swift
//  capstone
//
//  Created by Mena Tadesse on 4/14/25.
//

import UIKit
import Nuke

class FavoritesViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates the custom cell BookCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        //get the book at the specific row
        let favoriteBook = favoriteBooks[indexPath.row]
        
        //assign the book to the cell
        cell.book = favoriteBook
        
        let favorites = Book.getBooks(forKey: Book.favoritesKey)
        if favorites.contains(favoriteBook) {
            cell.favoritesButton.isSelected = true
        } else {
            cell.favoritesButton.isSelected = false
        }
        
        //need to replace http with https or else image wont render
        if let imageUrlString = favoriteBook.bookInfo.image?.thumbnail.replacingOccurrences(of: "http://", with: "https://"),
           let imageUrl = URL(string: imageUrlString),
           let imageView = cell.bookPosterImageView {
            
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
        
        //updates the cell's UI elements
        cell.titleLabel.text = favoriteBook.bookInfo.title
        cell.authorLabel.text = favoriteBook.bookInfo.authors?.joined(separator: ", ")
        cell.ratingLabel.text = String(favoriteBook.bookInfo.rating ?? 3.0)
        
        //if unfavorited, the book is removed from UserDefaults, we refetch the updated favorites list, and the Favorites Table View refreshes
        cell.onFavoriteToggled = { [weak self] in
            guard let self = self else { return }
            self.favoriteBooks = Book.getBooks(forKey: Book.favoritesKey)
            self.favoritesTableView.reloadData()
        }
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let books = Book.getBooks(forKey: Book.favoritesKey)
        self.favoriteBooks = books
        favoritesTableView.reloadData()
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
