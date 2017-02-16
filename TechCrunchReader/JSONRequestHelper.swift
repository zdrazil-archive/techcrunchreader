//
//  JSONRequestHelper.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 23/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//
import Foundation

class JSONRequestHelper {
    
    // Get url of an image with a specified dimensions and cropping
    static func getImageURLStringWithDimension(width: Double, height: Double, crop: Bool, url: String) -> String {
        let URLPart = url + "?w=" + String(width) + "&h=" + String(height)
        if crop == true {
            return URLPart + "&crop=1"
        } else {
            return URLPart
        }
    }
    
    // Get base image URL without paremeters
    static func getURLWithoutParameters(inputURL: NSURL) -> String {
        let scheme = inputURL.scheme
        let host = inputURL.host
        let components = inputURL.pathComponents
        let componentsString = components?.joined(separator: "/")
        let baseUrlToImage = scheme! + "://" + host! + componentsString!
        return baseUrlToImage
    }
}
