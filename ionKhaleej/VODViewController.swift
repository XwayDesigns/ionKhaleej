//
//  VODViewController.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 18/03/23.
//

import UIKit
import LanguageManager_iOS

class VODViewController: UIViewController {

    @IBOutlet weak var HeadingLabel: UILabel!
    @IBOutlet weak var SelectCategoryLabel: UILabel!
    @IBOutlet weak var CategoryPickerView: UIPickerView!
    @IBOutlet weak var ChannelCollectionView: UICollectionView!
    @IBOutlet weak var PickerViewContainer: UIView!
    
    var slides: [ImageSlide] = []
    var categories : [CategoryModel] = []
    
    let current_language = LanguageManager.shared.currentLanguage
    var language = "English"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftLabel = UILabel()
        let rightLabel = UILabel()
        rightLabel.text = NetworkService.shared.app_name
        rightLabel.textColor = UIColor.gray
        
        if(current_language.rawValue == "en"){
            leftLabel.text = "VOD"
        } else {
            leftLabel.text = "فیدیوھات"
            language = "Arabic"
        }
        
        let leftBarButtonItem = UIBarButtonItem(customView: leftLabel)
        let rightBarButtonItem = UIBarButtonItem(customView: rightLabel)
        
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        PickerViewContainer.isHidden = true
        self.CategoryPickerView.delegate = self
        self.CategoryPickerView.dataSource = self
        
        self.SelectCategoryLabel.isUserInteractionEnabled = true
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnLabel(_ :)))
        tapgesture.numberOfTapsRequired = 1
        self.SelectCategoryLabel.addGestureRecognizer(tapgesture)
        
        loadChannels(category_type: "all_categories")
        
        NetworkService.shared.categories() { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.CategoryPickerView.reloadAllComponents()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadChannels(category_type : String){
        NetworkService.shared.vod(category: category_type, language: language) { [weak self] (result) in
            switch result {
            case .success(let slides):
                self?.slides = slides
                self?.ChannelCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        PickerViewContainer.isHidden = false
    }
}

extension VODViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = categories[row]
        return category.category
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let category = categories[row]
        PickerViewContainer.isHidden = true
        if(category.category == "All"){
            SelectCategoryLabel.text = "Select category"
            loadChannels(category_type: "all_categories")
        } else {
            SelectCategoryLabel.text = category.category
            loadChannels(category_type: category.category ?? "all_categories")
        }
    }
    
}

extension VODViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
