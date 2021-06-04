//
//  ViewController.swift
//  Randog
//
//  Created by YoYo on 2021-06-04.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!

    var breeds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        DogAPI.requestBreedsList(completionHandler: handleBreedsListResponse(breeds:error:))
   }
    func handleBreedsListResponse(breeds: [String], error: Error?){
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
    }
    func handleRandomImageResponse(imageData: DogImage?, error: Error?){
        guard let imageURL = URL(string: imageData?.message ?? "") else{return}
        DogAPI.requestImageFile(url: imageURL, completionHandler: self.handleImageFileResponse(image:error:))
    }
    func handleImageFileResponse(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.imageView.image = image
    }
}








/* This is the JSON Serialization. It is the older way of parsing JSON to Swift we don't use this in new apps. The codable is on top
do{
let json = try JSONSerialization.jsonObject(with: data, options: []) as!
    [String:Any]
    let url = json["message"] as! String
    print(url)
}catch{
    print(error)
}
 End of JSONSerialization
*/
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
    
    
}
