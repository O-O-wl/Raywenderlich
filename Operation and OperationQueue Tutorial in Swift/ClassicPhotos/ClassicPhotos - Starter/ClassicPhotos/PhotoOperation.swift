/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

// MARK: - PhotoRecordState

enum PhotoRecordState {
    
    case new
    case downloaded
    case filtered
    case failed
}

// MARK: - PhotoRecord

class PhotoRecord {
    
    let name: String
    let url: URL
    var state: PhotoRecordState = .new
    var image: UIImage? = UIImage(named: "Placeholder")
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}

// MARK: - PendingOperation

class PendingOperations {
    
    // MARK: - Download queue
    
    lazy var downloadsInProcess: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue  = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    // MARK: - Image Filtration queue
    
    lazy var filterationsInProcess: [IndexPath: Operation] = [:]
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration Queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}


// MARK: - ImageDownloader

class ImageDownloader: Operation {
    
    let photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        guard let imageData = try? Data(contentsOf: photoRecord.url) else { return }
        
        if self.isCancelled {
            return
        }
        
        if !imageData.isEmpty {
            photoRecord.image = UIImage(data: imageData)
            photoRecord.state = .downloaded
        } else {
            photoRecord.image = UIImage(named: "Failed")
            photoRecord.state = .failed
        }
    }
}

// MARK: - ImageFiltration

class ImageFiltration: Operation {
    
    let photoRecord: PhotoRecord
    
    init(_ photoRecord: PhotoRecord) {
        self.photoRecord = photoRecord
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        guard photoRecord.state == .downloaded else { return }
        
        if let image = photoRecord.image,
            let filteredImage = applySepiaFilter(image) {
            photoRecord.image = filteredImage
            photoRecord.state = .failed
        }
    }
    
    func applySepiaFilter(_ image: UIImage) -> UIImage?  {
        guard let data = UIImagePNGRepresentation(image) else { return nil }
        
        let inputImage = CIImage(data: data)
        
        if self.isCancelled {
            return nil
        }
        
        let context = CIContext(options: nil)
        
        guard let filter = CIFilter(name: "CISepiaTone") else { return nil }
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(0.8, forKey: "inputIntensity")
        
        if self.isCancelled {
            return nil
        }
        
        
        guard let outputImage = filter.outputImage,
            let outImage = context.createCGImage(outputImage, from: outputImage.extent)
            else { return nil }
        
        
        return UIImage(cgImage: outImage)
    }
    
    
}

struct A {
    mutating func a() {
        self = A()
    }
}
