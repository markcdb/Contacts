//
//  ImageViewHelper.swift
//  Contacts
//
//  Created by Mark Christian Buot on 03/07/2019.
//  Copyright © 2019 Mark Christian Buot. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    internal func setKFImage(with urlString: String,
                    placeholder: Placeholder? = nil,
                    shouldAnimate: Bool = true,
                    keepCurrentImageWhileLoading: Bool = false,
                    completion: CompletionHandler? = nil) {
        
        let urlStringWithSize = urlString
        
        if let url = urlStringWithSize.toURL() {
            var options: KingfisherOptionsInfo = []
            if shouldAnimate == true {
                options.append(.transition(ImageTransition.fade(0.33)))
                if keepCurrentImageWhileLoading == true {
                    options.append(.keepCurrentImageWhileLoading)
                }
            }
            
            if url != kf.webURL || image == nil {
                if let path = url.absoluteString.split(separator: "/").last {
                    let resource = ImageResource(downloadURL: url, cacheKey: String(path))
                    self.kf.setImage(with: resource,
                                     placeholder: placeholder,
                                     options: options,
                                     completionHandler: completion)
                }
            }
        }
        else {
            self.image = placeholder as? UIImage
        }
    }
    
    /*
    internal func setKFImage(with url: URL,
                    placeholder: Placeholder? = nil,
                    targetSize: CGSize? = nil,
                    cornerRadius: CGFloat? = nil,
                    animate: Bool = true,
                    keepCurrentImageWhileLoading: Bool = false,
                    priority: Float? = nil,
                    completion: CompletionHandler? = nil) {
        
        let urlStringWithSize = url.absoluteString
        
        let currentScale = UIScreen.main.scale
        
        if let url = urlStringWithSize.toURL() {
            var options: KingfisherOptionsInfo!
            var processor: ImageProcessor!
            
            let roundedCornerImageProcessor = RoundCornerImageProcessor(cornerRadius: cornerRadius ?? 0,
                                                                        targetSize: targetSize ?? .zero,
                                                                        roundingCorners: .all,
                                                                        backgroundColor: .clear)
            
            let targetSize = targetSize ?? .zero
            let resizer    = ResizingImageProcessor(referenceSize: targetSize,
                                                    mode: .aspectFill) >> roundedCornerImageProcessor
            
            processor = resizer
            
            if keepCurrentImageWhileLoading  {
                options = [
                    .keepCurrentImageWhileLoading,
                    .processor(processor),
                    .scaleFactor(currentScale),
                    .cacheSerializer(FormatIndicatedCacheSerializer.png)]
            } else {
                options = [
                    .processor(processor),
                    .scaleFactor(currentScale),
                    .backgroundDecode,
                    .cacheSerializer(FormatIndicatedCacheSerializer.png)]
            }
            
            if animate == true {
                options.append(.transition(ImageTransition.fade(0.33)))
            }
            
            if let prior = priority {
                options.append(.downloadPriority(prior))
            }
            
            if let path = urlStringWithSize.split(separator: "/").last ??
                url.absoluteString.split(separator: "/").last {
                
                let resource = ImageResource(downloadURL: urlStringWithSize.toURL() ?? url,
                                             cacheKey: String(path))
                
                self.kf.setImage(with: resource,
                                 placeholder: placeholder,
                                 options: options,
                                 completionHandler: completion)
            }
        }
    }
    */
    
    internal func cancelKFTask() {
        self.kf.cancelDownloadTask()
    }
}
