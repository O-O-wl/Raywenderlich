/// Copyright (c) 2018 Razeware LLC
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
import Nuke

class PhotoGalleryViewController: UICollectionViewController {
  var photoURLs: [URL] = []
  
  let cellSpacing: CGFloat = 1
  let columns: CGFloat = 3
  var cellSize: CGFloat = 0
  
  var pixelSize: CGFloat {
    get {
      return cellSize * UIScreen.main.scale
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.topItem?.title = "NASA Photos"
    
    guard
      let plist = Bundle.main.url(forResource: "NASAPhotos", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let plistSerialized = try? PropertyListSerialization.propertyList(from: contents, options: [], format: nil),
      let urlPaths = plistSerialized as? [String]
      else {
        return
    }
    
    photoURLs = urlPaths.compactMap { URL(string: $0) }
    
    let contentModes = ImageLoadingOptions.ContentModes(success: .scaleAspectFill,
                                                        failure: .scaleAspectFit,
                                                        placeholder: .scaleAspectFit)
    
    ImageLoadingOptions.shared.placeholder = UIImage(named: "dark-moon")
    ImageLoadingOptions.shared.failureImage = UIImage(named: "annoyed")
    ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.5)
    ImageLoadingOptions.shared.contentModes = contentModes
    
    DataLoader.sharedUrlCache.diskCapacity = 0
    
    let pipeline = ImagePipeline {
      $0.dataCache = try! DataCache(name: "com.razeware.Far-Out-Photos.datacache")
    }
    ImagePipeline.shared = pipeline
  }
}

// MARK: Collection View Data Source Methods

extension PhotoGalleryViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return photoURLs.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
    
    let request = ImageRequest(url: photoURLs[indexPath.row], targetSize: CGSize(width: pixelSize, height: pixelSize), contentMode: .aspectFill)
    Nuke.loadImage(with: request, into: cell.imageView)
    
    return cell
  }
}

// MARK: Collection View Delegate Flow Layout Methods

extension PhotoGalleryViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      let emptySpace = layout.sectionInset.left + layout.sectionInset.right + (columns * cellSpacing - 1)
      cellSize = (view.frame.size.width - emptySpace) / columns
      return CGSize(width: cellSize, height: cellSize)
    }
    
    return CGSize()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
}

// MARK: Collection View Delegate Methods

extension PhotoGalleryViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let photoViewController = PhotoViewController.instantiate() else {
      return
    }
    
    photoViewController.image = ImageLoadingOptions.shared.placeholder
    photoViewController.contentMode = .scaleAspectFit
    
    ImagePipeline.shared.loadImage(
      with: photoURLs[indexPath.row],
      progress: nil) { response, err in
        if err != nil {
          photoViewController.image = ImageLoadingOptions.shared.failureImage
          photoViewController.contentMode = .scaleAspectFit
        } else {
          photoViewController.image = response?.image
          photoViewController.contentMode = .scaleAspectFill
        }
    }
    
    navigationController?.pushViewController(photoViewController, animated: true)
  }
}
