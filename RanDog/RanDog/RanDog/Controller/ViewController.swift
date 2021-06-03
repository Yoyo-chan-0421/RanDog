//
//  ViewController.swift
//  RanDog
//
//  Created by YoYo on 2021-05-29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var dogImage: UIImageView!
    var  breeds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         // Getting the random https into a link and GET it
        pickerView.dataSource = self
        pickerView.delegate = self
        Dog.BreedsResponse(completionHandler: handleBreedsResponse(breeds:error:))
     
    }
    func handleBreedsResponse(breeds: [String],error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageURL = URL(string: imageData!.message) else{return}
        Dog.ImageFile(url: imageURL , completionHandler: self.handleImageFile(image:error:))
    }
    
    func handleImageFile(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.dogImage.image = image
        }
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Dog.requestRandomImage( breed: breeds[row], completionHandler: handleRandomImageResponse(imageData: error:))
    }
}
















