//
//  Dog.swift
//  RanDog
//
//  Created by YoYo on 2021-05-31.
//

import Foundation
import UIKit
class Dog{
    enum Endpoint{
        case randomImageFromDogBreedCollection(String)
        case randomImageFromBreed(String)
        case randomBreedName
        var url: URL{
            return URL(string: self.stringValue)!
        }
        var stringValue: String{
            switch self {
            case .randomImageFromDogBreedCollection: return "https://dog.ceo/api/breeds/image/random "
            case .randomImageFromBreed(let breed): return "https://dog.ceo/api/breed/\(breed)/images"
            case .randomBreedName: return "https://dog.ceo/api/breeds/list/all"
            }
            
        }
    }

class func ImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
            
            let task = URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                guard let data = data else {
                    completionHandler(nil, error)
                    return
                }
                let downloadedImage = UIImage(data: data)
                completionHandler(downloadedImage, nil)
            })
               
            task.resume()
            
        }
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void){
        let randomImage = Dog.Endpoint.randomImageFromBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImage) { data, response, error in
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
             // Changing the JSON code into swift using Codable
                let decoder = JSONDecoder()
            do{
                let imageData = try decoder.decode(DogImage.self, from: data)
                print(imageData)
            completionHandler(imageData, error)
            }catch{
                print(error)
            }
             
            // Adding the image to the UIImage
         
    }
        task.resume()
        
}
    class func BreedsResponse(completionHandler: @escaping ([String], Error?) -> Void){
        let task = URLSession.shared.dataTask(with: Endpoint.randomBreedName.url){(data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            let decoder = JSONDecoder()
           
            let breeds = try! decoder.decode(BreedsList.self, from: data)
            let breedsToarray =  breeds.message.keys.map({$0})
            completionHandler(breedsToarray,error)
        }
        task.resume()
    }
    
}
