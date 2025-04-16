//
//  Book.swift
//  capstone
//
//  Created by Mena Tadesse on 4/11/25.
//

import Foundation
import DeveloperToolsSupport
import UIKit


struct BookResponse: Decodable {
    let items: [Book]
    
    private enum CodingKeys: String, CodingKey {
        case items = "items"
    }
}

struct Book: Encodable, Decodable, Equatable {
    let id: String
    let bookInfo: BookInfo
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case bookInfo = "volumeInfo"
    }
}

struct BookInfo: Encodable, Decodable, Equatable {
    let title: String
    let authors: [String]?
    let description: String?
    let image: ImageLink?
    let categories: [String]?
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case title = "title"
        case authors = "authors"
        case description = "description"
        case image = "imageLinks"
        case categories = "categories"
        case rating = "averageRating"
    }
    
}

struct ImageLink: Encodable, Decodable, Equatable {
    let thumbnail: String
    
    private enum CodingKeys: String, CodingKey {
        case thumbnail = "thumbnail"
    }
}

//an extension allows us to add new functionality to existing types like book!
//extensions also avoid clutter. its much cleaner than putting all the functionality of
//the type inside the struct/class.
extension Book {
    
    //remember static means it belongs to the class/struct, not the instance
    //favorites key is 
    static var favoritesKey: String {
        return "Favorites"
    }
    
    static func save(_ books: [Book], forKey key: String) {
        let defaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(books)
        defaults.set(encodedData, forKey: key)
    }
    
    static func getBooks(forKey key: String) -> [Book] {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: key) {
            let decodedBooks = try! JSONDecoder().decode([Book].self, from: data)
            return decodedBooks
        } else {
            return []
        }
    }
    
    func addToFavorites() {
        var favoriteBooks = Book.getBooks(forKey: Book.favoritesKey)
        favoriteBooks.append(self)
        Book.save(favoriteBooks, forKey: Book.favoritesKey)
    }
    
    func removeFromFavorites() {
        var favoriteBooks = Book.getBooks(forKey: Book.favoritesKey)
        favoriteBooks.removeAll { book in
            return self == book
        }
        Book.save(favoriteBooks, forKey: Book.favoritesKey)
    }
}



/*

JSON RESPONSE BELOW:
 
 "items": [
         {
             "kind": "books#volume",
             "id": "TuveDwAAQBAJ",
             "etag": "glQGIdJ8D2w",
             "selfLink": "https://www.googleapis.com/books/v1/volumes/TuveDwAAQBAJ",
             "volumeInfo": {
                 "title": "When We Were Animals",
                 "authors": [
                     "Joshua Gaylord"
                 ],
                 "publisher": "Random House",
                 "publishedDate": "2020-04-30",
                 "description": "Nobody knew why, but when the boys and girls reached a certain age the parents locked themselves up in their houses, and the teenagers ran wild... Lumen Fowler knows she is different. While the rest of her peers are falling beneath the sway of her community’s darkest rite of passage, she resists. For Lumen has a secret. Her mother never ‘breached’ and she knows she won’t either. But as she investigates her town’s strange traditions and unearths stories from her family’s past, she soon realises she may not know herself – or her wild side – at all...",
                 "industryIdentifiers": [
                     {
                         "type": "ISBN_13",
                         "identifier": "9781473584761"
                     },
                     {
                         "type": "ISBN_10",
                         "identifier": "1473584760"
                     }
                 ],
                 "readingModes": {
                     "text": true,
                     "image": false
                 },
                 "pageCount": 338,
                 "printType": "BOOK",
                 "categories": [
                     "Fiction"
                 ],
                 "maturityRating": "NOT_MATURE",
                 "allowAnonLogging": false,
                 "contentVersion": "0.1.1.0.preview.2",
                 "panelizationSummary": {
                     "containsEpubBubbles": false,
                     "containsImageBubbles": false
                 },
                 "imageLinks": {
                     "smallThumbnail": "http://books.google.com/books/content?id=TuveDwAAQBAJ&printsec=frontcover&img=1&zoom=5&source=gbs_api",
                     "thumbnail": "http://books.google.com/books/content?id=TuveDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
                 },
                 "language": "en",
                 "previewLink": "http://books.google.com/books?id=TuveDwAAQBAJ&dq=fiction&hl=&cd=1&source=gbs_api",
                 "infoLink": "http://books.google.com/books?id=TuveDwAAQBAJ&dq=fiction&hl=&source=gbs_api",
                 "canonicalVolumeLink": "https://books.google.com/books/about/When_We_Were_Animals.html?hl=&id=TuveDwAAQBAJ"
             },
             "saleInfo": {
                 "country": "US",
                 "saleability": "NOT_FOR_SALE",
                 "isEbook": false
             },
             "accessInfo": {
                 "country": "US",
                 "viewability": "NO_PAGES",
                 "embeddable": false,
                 "publicDomain": false,
                 "textToSpeechPermission": "ALLOWED",
                 "epub": {
                     "isAvailable": true
                 },
                 "pdf": {
                     "isAvailable": true
                 },
                 "webReaderLink": "http://play.google.com/books/reader?id=TuveDwAAQBAJ&hl=&source=gbs_api",
                 "accessViewStatus": "NONE",
                 "quoteSharingAllowed": false
             },
             "searchInfo": {
                 "textSnippet": "Nobody knew why, but when the boys and girls reached a certain age the parents locked themselves up in their houses, and the teenagers ran wild."
             }
         }
  ]
 */
