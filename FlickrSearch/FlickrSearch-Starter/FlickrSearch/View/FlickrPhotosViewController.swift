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


class FlickrPhotosViewController: UICollectionViewController {
  
  private let reuseIdentifier = "FlickrCell"
  private let sectionInset = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
  
  private let flickrAPI = FlickrAPI()
  private var searchs = [FlickrSearchResults]()
  
  private let itemsPerRows: CGFloat = 3
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.collectionView.register(UINib(nibName: reuseIdentifier,
                                       bundle: nil),
                                 forCellWithReuseIdentifier: reuseIdentifier)
  }
  
  private func photo(for indexPath: IndexPath) -> FlickrPhoto {
    return searchs[indexPath.section].searchResults[indexPath.row]
  }
  
  
}

// MARK: UICollectionViewDataSource
extension FlickrPhotosViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return searchs.count
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of items
    return searchs[section].searchResults.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlikrCell
    cell.backgroundColor = .white
    let data = searchs[indexPath.section].searchResults[indexPath.row]
    cell.configure(data: data)
    return cell
  }
  
}

// MARK: UICollectionViewDelegate
extension FlickrPhotosViewController {
  
}
extension FlickrPhotosViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInset.left * (itemsPerRows + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth/itemsPerRows
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInset
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInset.left
  }
}
// MARK: UITextFieldDelegate
extension FlickrPhotosViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let searchKeyword = textField.text else { return false }
    
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    textField.addSubview(activityIndicator)
    activityIndicator.frame = textField.bounds
    activityIndicator.startAnimating()
    
    
    flickrAPI.searchFlickr(for: searchKeyword, completion: {
      result in
      activityIndicator.removeFromSuperview()
      switch result {
      case .results(let results):
        print("Found \(results.searchResults.count) matching \(results.searchTerm)")
        self.searchs.insert(results, at: 0)
        self.collectionView.reloadData()
      case .error(let error):
        print(error.localizedDescription)
      }
    })
    
    textField.text = nil
    textField.resignFirstResponder()
    
    return true
  }
}
