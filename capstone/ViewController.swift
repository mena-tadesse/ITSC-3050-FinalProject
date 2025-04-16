//
//  ViewController.swift
//  capstone
//
//  Created by Mena Tadesse on 4/1/25.
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    private var books: [Book] = []
    private var searchedBooks: [Book] = []
    
    
    //returns # of rows for the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedBooks.count
    }
    
    
    //creates & returns a cell for the given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creates the custom cell BookCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        
        //get the book at the specific row
        let book = searchedBooks[indexPath.row]
        
        //assign the book to the cell
        cell.book = book
        
        let favorites = Book.getBooks(forKey: Book.favoritesKey)
        if favorites.contains(book) {
            cell.favoritesButton.isSelected = true
        } else {
            cell.favoritesButton.isSelected = false
        }
        
        //need to replace http with https or else image wont render
        if let imageUrlString = book.bookInfo.image?.thumbnail.replacingOccurrences(of: "http://", with: "https://"),
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
        cell.titleLabel.text = book.bookInfo.title
        cell.authorLabel.text = book.bookInfo.authors?.joined(separator: ", ")
        cell.ratingLabel.text = String(book.bookInfo.rating ?? 3.0)
        
        return cell
    }
    
    // MARK: - Search Bar Logic
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchedBooks = books
        } else {
            searchedBooks = books.filter {
                $0.bookInfo.title.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tells table how many cells to display & provides ui for each cell
        tableView.dataSource = self
        searchBar.delegate = self
        fetchBooks()
    }
    
    //API Call to Google Books
    private func fetchBooks() {
        
        let key = "AIzaSyCe0Ksb8CWsuGdCN95QEv1DNjLetgGNYBM"
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=a&maxResults=40"
        let url = URL(string: urlString)!
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("Request failed: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Server error: \(String(describing: response))")
                return
            }
            
            guard let data = data else {
                print("No data returned from request")
                return
            }
            
            do {
                //decodes the JSON data into our custom 'BookResponse' model, which is an array of Books
                let bookResponse = try JSONDecoder().decode(BookResponse.self, from: data)
                let books = bookResponse.items
                
                
                DispatchQueue.main.async {[weak self] in
                    print("SUCCESS! FETCHED \(books.count) books")
                    for book in books {
                        print("BOOK ---------")
                        print("Title: \(book.id)")
                        print("Overview:  \(book.bookInfo.title)")
                    }
                    
                    //Sets the global books array to bookResponse.items
                    self?.books = books
                    self?.searchedBooks = books
                        
                    //reloads the numberOfRowsInSection & cellForRowAt to display updated data of books.
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding the JSON data into a Book Response: \(error.localizedDescription)")
                return
            }
        }
        session.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //get index path for the selected row
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return }
        
        //get the selected book based on the selected index
        let selectedBook = books[selectedIndexPath.row]
        
        //get access to the detail view controller via the segue's destination.
        guard let detailViewController = segue.destination as? DetailViewController else { return }
        
        //set the detailViewController's book as the one selected.
        detailViewController.book = selectedBook
    }
}


