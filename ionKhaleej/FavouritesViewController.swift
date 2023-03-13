//
//  FavouritesViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 18/03/23.
//

import UIKit
import LanguageManager_iOS

class FavouritesViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var channelCollectionView: UICollectionView!
    
    var slides: [ImageSlide] = []
    
    let defaults = UserDefaults.standard
    
    let current_language = LanguageManager.shared.currentLanguage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        
        if(current_language.rawValue == "en"){
            leftLabel.text = "FAVORITES"
        } else {
            leftLabel.text = "المفضلة"
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        var favourites = defaults.string(forKey: "favourites") ?? ""
        
        NetworkService.shared.favorite(favorites: favourites) { [weak self] (result) in
            switch result {
            case .success(let slides):
                self?.slides = slides
                self?.channelCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.identifier, for: indexPath) as!     ChannelCollectionViewCell
        let slide = slides[indexPath.row]
        
        cell.channelName.text = slide.channel_name
        let url = URL(string: slide.channel_logo!)!
        NetworkService.shared.getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                cell.channelImage.image = UIImage(data: data)
            }
        }
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize(width: size, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slide = slides[indexPath.row]
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        homeVC.channel_id = slide.channel_id!
        homeVC.slide = slide
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
}
