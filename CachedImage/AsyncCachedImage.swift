//
//  AsyncCachedImage.swift
//  CachedImage
//
//  Created by Jeffrey Tabios on 12/20/21.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

public class AsyncCachedImage: UIImageView {
    var task: URLSessionDownloadTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask)[0]
    
    public func loadImage(from url: URL, cacheId: String) {
        image = nil
        
        if let task = task {
            task.cancel()
        }
        
        let imageFileName = documentDirectory.appendingPathComponent("\(cacheId).jpg")
        
        if FileManager.default.fileExists(atPath: imageFileName.path) {
            let fileUrl = URL(fileURLWithPath: imageFileName.path)
            let data = try? Data(contentsOf: fileUrl)
            if let data = data, let newImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = newImage
                }
                return
            }
        }
        
        addSpinner()
        task = URLSession.shared.downloadTask(with: url) { [weak self] (localURL, response, error) in
            
            DispatchQueue.main.async {
                self?.removeSpinner()
            }
            
            if let localURL = localURL {
                
                do {
                    // Remove any existing document at file
                    if FileManager.default.fileExists(atPath: imageFileName.path) {
                        try FileManager.default.removeItem(at: imageFileName)
                    }

                    // Copy the tempURL to file
                    try FileManager.default.copyItem (
                        at: localURL,
                        to: imageFileName
                    )
                    
                    let fileUrl = URL(fileURLWithPath: imageFileName.path)
                    let data = try Data(contentsOf: fileUrl)
                    if let newImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = newImage
                        }
                    }
                    
                } catch {
                    return
                }
                
            } else {
                return
            }
        }
        
        task.resume()
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
