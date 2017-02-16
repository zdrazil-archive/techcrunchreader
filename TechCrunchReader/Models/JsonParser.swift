//
//  JsonParser.swift
//  TechCrunchReader
//
//  Created by Vladimír Zdražil on 16/02/2017.
//  Copyright © 2017 Vladimír Zdražil. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import CoreData

class JsonParser: NSObject {
    
    private func requestJSON(stringURL: String, completion: @escaping (JSON) -> Void)  {
        
        Alamofire.request(stringURL).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Validation Succesful")
                let json = JSON(value)
                completion(json)
            case .failure(let error):
                print("Error while fetching remote JSON: \(error)")
            }
        }
    }
    
    // Define and later use private queue to support concurrency
    private let moc = (UIApplication.shared.delegate as? AppDelegate)?.dataController.managedObjectContext
    private let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    
    func parseJSONtoCoreData(stringURL: String) {
        requestJSON(stringURL: stringURL) { json in
            guard json["status"] == "ok" else {
                print("status of json is not ok, cancelling parsing")
                return
            }
            
            self.privateMOC.parent = self.moc
            
            if let jsonArticles = json["articles"].array {
                self.privateMOC.perform {
                    for article in jsonArticles {
                        let url = article["url"].stringValue
                        let author = article["author"].stringValue
                        let title = article["title"].stringValue
                        let description = article["description"].stringValue
                        var urlToImage = article["urlToImage"].stringValue
                        
                        // Get only base url of image without parameters
                        // Later allows requesting image resolution
                        if let URLFormatted = NSURL(string: urlToImage) {
                            urlToImage = JSONRequestHelper.getURLWithoutParameters(inputURL: URLFormatted)
                        }
                        
                        // Transform string to Date
                        let publishedAt = article["publishedAt"].stringValue
                        let dateFormatter = DateFormatter()
                        dateFormatter.calendar = Calendar(identifier: .iso8601)
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                        
                        guard let publishedAtDate = dateFormatter.date(from: publishedAt) else {
                            print("Couldn't convert json date format to Date type")
                            break
                        }
                        
                        // Create Article object for easier manipulation with ArticleMO
                        let articleObject = Article(author: author, title: title, description: description, url: url, urlToImage: urlToImage, publishedAt: publishedAtDate)
                        
                        // Check for duplicates in database
                        // Unique id is url
                        // Newer replaces older
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
                        let fetchPredicate = NSPredicate(format: "url ==[c] %@", url)
                        request.predicate = fetchPredicate
                        do {
                            let count = try self.privateMOC.count(for: request)
                            // If duplicate records exist, delete them
                            if count > 0 {
                                do {
                                    guard let result = try self.moc?.fetch(request) else {
                                        break
                                    }
                                    // Delete duplicate
                                    for object in result {
                                        self.moc?.delete(object as! NSManagedObject)
                                    }
                                } catch {
                                    print("Failure to delete duplicate Article entities with error: \(error)")
                                }
                            }
                        } catch let error {
                            print("Failure to count number of Article entities with error: \(error)")
                        }
                        
                        // Create entity from Article object in MOC
                        _ = ArticleMO.createArticleMOEntity(article: articleObject, inManagedObjectContext: self.privateMOC)
                        
                    }
                    do {
                        try self.privateMOC.save()
                        self.moc?.performAndWait {
                            do {
                                try self.moc?.save()
                            } catch {
                                fatalError("Failure to save context: \(error)")
                            }
                        }
                    } catch let error {
                        print("Failure to save context: \(error)")
                    }
                }
            }
        }
    }
}
