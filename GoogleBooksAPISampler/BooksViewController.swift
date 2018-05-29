//
//  BooksViewController.swift
//  GoogleBooksAPISampler
//
//  Created by Masuhara on 2018/05/30.
//  Copyright © 2018年 Ylab, Inc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class BooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let cellIdentifier = "BookCell"
    var books = [Book]()
    
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var booksSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        booksTableView.dataSource = self
        booksTableView.delegate = self
        booksSearchBar.delegate = self
        
        let nib = UINib(nibName: "BookTableViewCell", bundle: Bundle.main)
        booksTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        loadBooks(searchTitle: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! BookTableViewCell
        cell.bookTitleLabel.text = books[indexPath.row].title
        cell.authorLabel.text = books[indexPath.row].author
        
        if books[indexPath.row].imagePath != nil {
            cell.bookImageView.kf.setImage(with: URL(string: books[indexPath.row].imagePath!), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        return cell
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UISearchBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Search books
        loadBooks(searchTitle: searchBar.text)
        
        // Close Keyboard
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Private
    func loadBooks(searchTitle: String?) {
        
        books = [Book]()
        
        if let searchTitle = searchTitle {
            // Input someting -> Search its title
            // E.g. Title->intitle, Author->inauthor, Publisher->inpublisher
            // https://developers.google.com/books/docs/v1/using#WorkingVolumes
            // startIndex - The position in the collection at which to start. The index of the first item is 0.
            // maxResults - The maximum number of results to return. The default is 10, and the maximum allowable value is 40.
            
            let path = "https://www.googleapis.com/books/v1/volumes?q=\(searchTitle)+intitle"
            
            // include Japanese
            let encodedPath = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
            guard let searchPath = encodedPath else {
                print("無効な検索ワードが入力されました。")
                return
            }
            
            Alamofire.request(searchPath).responseJSON { (response) in
                let json = JSON(response.result.value!)
                // print(json)
                
                json["items"].forEach{(_, data) in
                    let title = data["volumeInfo"]["title"].string!
                    let authors = data["volumeInfo"]["authors"].array
                    let imagePath = data["volumeInfo"]["imageLinks"]["thumbnail"].string
                    // let publishedDate = data["publishedDate"].string!
                    
                    var book = Book(title: title)
                    var authorName = ""
                    if let authors = authors {
                        for author in authors {
                            authorName = authorName + author.string!
                        }
                    }
                    book.author = authorName
                    book.imagePath = imagePath
                    self.books.append(book)
                }
                self.booksTableView.reloadData()
            }
        } else {
            // Empty -> Search Random
            let path = "https://www.googleapis.com/books/v1/volumes?q=programming+intitle"
            Alamofire.request(path).responseJSON { (response) in
                let json = JSON(response.result.value!)
                
                // print(json)
                
                json["items"].forEach{(_, data) in
                    let title = data["volumeInfo"]["title"].string!
                    let authors = data["volumeInfo"]["authors"].array
                    let imagePath = data["volumeInfo"]["imageLinks"]["thumbnail"].string
                    // let publishedDate = data["publishedDate"].string!
                    
                    var book = Book(title: title)
                    var authorName = ""
                    if let authors = authors {
                        for author in authors {
                            authorName = authorName + author.string!
                        }
                    }
                    book.author = authorName
                    book.imagePath = imagePath
                    self.books.append(book)
                }
                self.booksTableView.reloadData()
            }
        }
    }
    
}
