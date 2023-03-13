//
//  ImageSlideCollectionViewCell.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import UIKit
import LanguageManager_iOS

class ImageSlideCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ImageSlideCollectionViewCell.self)
    
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var slideLable: UILabel!
    
    let current_language = LanguageManager.shared.currentLanguage
    
    func setup(_ slide: ImageSlide) {
        if(current_language.rawValue == "en"){
            slideLable.text = slide.channel_name
        } else {
            slideLable.text = slide.channel_name_ar
        }
        
        let url = URL(string: slide.channel_logo!)!
        NetworkService.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.slideImageView.image = UIImage(data: data)
            }
        }
    }
}
