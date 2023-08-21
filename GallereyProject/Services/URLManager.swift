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
    
    public static func setImagesNames(arrayOfImagesURLS: [String]) {
        UserDefaults.standard.set(nil, forKey: "ImagesURLS")
        UserDefaults.standard.set(arrayOfImagesURLS, forKey: "ImagesURLS")
    }
}
