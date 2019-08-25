//
//  ViewController.swift
//  edl.apple.exercise
//
//  Created by jjpan on 25/8/19.
//  Copyright © 2019 jjpan. All rights reserved.
//

import UIKit

struct Album {
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    let collectionViewUrl: String?
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
     @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
     @IBOutlet weak var tableView: UITableView!
    
    var albums = [Album]() {
        didSet {
            print(albums.count)
            DispatchQueue.main.async {
                self.loadIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    let urlEndpointURL = "https://itunes.apple.com/lookup?id=909253&entity=album"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        loadIndicator.startAnimating()
        loadAlbumInformation()
    }
    
    
    func loadAlbumInformation() {
        
        let url = URL(string: urlEndpointURL)!
        let request = URLRequest(url: url)
        var values = [Album]()
        
        let defaultSession = URLSession(configuration: .default)
        let dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if let data = data {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                    let data = jsonData?["results"] as? [[String:Any]]
                    for album in data! {
                        let albumInfo = Album(
                            artistName: (album["artistName"] as? String)!,
                            collectionName: (album["collectionName"] as? String),
                            artworkUrl100: album["artworkUrl100"] as? String,
                            collectionViewUrl: album["collectionViewUrl"] as? String
                            )
                        if let artwork = albumInfo.artworkUrl100, !artwork.isEmpty {
                          values.append(albumInfo)
                          print(album)
                        }
                    }
                    self.albums = values
                } catch {
                    
                }
            }
        })
        dataTask.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumTableViewCell else {
            return UITableViewCell()
        }
        print(albums[indexPath.row])
        cell.setData(data: albums[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("We selected a row, Great! Row clicked was \(indexPath.row)")
        guard let albumUrl = albums[indexPath.row].collectionViewUrl
            else { return }
        print(albumUrl)
        let url = URL(string: albumUrl+"&app=music")!
        print(url)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

}

