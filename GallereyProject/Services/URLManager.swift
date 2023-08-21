//
//  URLManager.swift
//  GallereyProject
//
//  Created by Артём Черныш on 21.08.23.
//

import Foundation
class URLManager {

    public static func getImagesURL() -> [String] {
        return UserDefaults.standard.array(forKey: "ImagesURLS") as? [String] ?? []
    }
    
    public static func setImageName(imageURL: String) {
        var otherImages = getImagesURL()
        otherImages.append(imageURL)
        UserDefaults.standard.set(otherImages, forKey: "ImagesURLS")
    }
}
