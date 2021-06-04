//
//  DogAPI.swift
//  Randog
//
//  Created by YoYo on 2021-06-04.
//

import Foundation
import UIKit
class DogAPI{
    enum Endpoint {
        //getting the random Image
        case randomImageFromDogAllCollection(String)
        case randomImageFromBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String{
            switch self {
            case .randomImageFromDogAllCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageFromBreed(let breed): return "https://dog.ceo/api/breed/\(breed)/images/random"
            case . listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            default:
                print("helloe")
            }
        }
    }
    class func requestBreedsList (completionHandler: @escaping ([String], Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            let decoder = JSONDecoder()
            let breedsResponse = try! decoder.decode(BreedsListResponse.self, from: data)
            let breeds = breedsResponse.message.keys.map({$0})
            completionHandler(breeds, nil)
        }
        task.resume()
    }
    
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImageEndpoint = DogAPI.Endpoint.randomImageFromBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) {( data, response, error) in
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let imageData = try! decoder.decode(DogImage.self, from: data)
            completionHandler(imageData,nil)
        }
        task.resume()
    }
    
    class func requestImageFile(url:URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else{
                completionHandler(nil, error)
                return
            }
            //Loaded the image into UIImage
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage,nil)
    })
    task.resume()
}
   
}

