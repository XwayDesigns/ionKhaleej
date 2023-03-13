//
//  ViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 13/03/23.
//

import UIKit
import LanguageManager_iOS

class ChannelViewController: UIViewController {

    @IBOutlet weak var isCollectionView: UICollectionView!
    @IBOutlet weak var channelCollectionView: UICollectionView!
    @IBOutlet weak var isPageControl: UIPageControl!
    
    var slides: [ImageSlide] = []
    
    var currenrPage = 0
    var timer : Timer?
    
    let current_language = LanguageManager.shared.currentLanguage
    var language = "English"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        
        if(current_language.rawValue == "en"){
            leftLabel.text = "Channels"
        } else {
            leftLabel.text = "القنوات"
            language = "Arabic"
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        NetworkService.shared.imageslide(category: "all_categories", language: language) { [weak self] (result) in
            switch result {
            case .success(let slides):
                self?.slides = slides
                self?.isCollectionView.reloadData()
                self?.channelCollectionView.reloadData()
                self?.isPageControl.numberOfPages = slides.count
            case .failure(let error):
                print(error)
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }
    
    @objc func slideToNext(){
        if currenrPage < slides.count - 1{
            currenrPage+=1
        } else {
            currenrPage = 0
        }
        
        isCollectionView.scrollToItem(at: IndexPath(item: currenrPage, section: 0), at: .right, animated: true)
        isPageControl.currentPage = currenrPage
    }

}

extension ChannelViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == isCollectionView {
            return slides.count
        } else {
            return slides.count
        }
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == isCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSlideCollectionViewCell.identifier, for: indexPath) as!     ImageSlideCollectionViewCell
            
            cell.setup(slides[indexPath.row])
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.identifier, for: indexPath) as!     ChannelCollectionViewCell
            let slide = slides[indexPath.row]
            
            if current_language.rawValue == "en"{
                cell.channelName.text = slide.channel_name
            } else {
                cell.channelName.text = slide.channel_name_ar
            }
                
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
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == channelCollectionView{
            let size = (collectionView.frame.size.width-10)/2
            return CGSize(width: size, height: 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slide = slides[indexPath.row]
        
        let homeVC = storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        homeVC.channel_id = slide.channel_id!
        homeVC.slide = slide
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currenrPage = Int(scrollView.contentOffset.x / width)
        isPageControl.currentPage = currenrPage
    }
}
