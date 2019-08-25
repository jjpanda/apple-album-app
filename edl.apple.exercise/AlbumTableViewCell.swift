//
//  AlbumTableViewCell.swift
//  edl.apple.exercise
//
//  Created by jjpan on 25/8/19.
//  Copyright © 2019 jjpan. All rights reserved.
//

import UIKit
import SDWebImage

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkUrl100Image: UIImageView!

    func setData(data: Album) {
        print(data.collectionName!)
        collectionNameLabel.text = data.collectionName
        artistNameLabel.text = data.artistName
        if let imgURL = data.artworkUrl100 {
            artworkUrl100Image.sd_setImage(with: URL(string: imgURL), placeholderImage: UIImage(named: "placeholder"))
            
        }
    }
}
