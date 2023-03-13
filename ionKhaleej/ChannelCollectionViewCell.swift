//
//  ChannelCollectionViewCell.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 16/03/23.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ChannelCollectionViewCell.self)
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    
}
