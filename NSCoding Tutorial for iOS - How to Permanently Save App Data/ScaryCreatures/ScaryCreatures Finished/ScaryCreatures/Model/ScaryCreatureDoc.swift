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

class ScaryCreatureDoc: NSObject {
  enum Keys: String {
    case dataFile = "Data.plist"
    case thumbImageFile = "thumbImage.png"
    case fullImageFile = "fullImage.png"
  }
  
  private var _data: ScaryCreatureData?
  var data: ScaryCreatureData? {
    get {
      // 1) return the value if already loaded
      if _data != nil { return _data }
      
      // 2) read the saved file as 'Data'
      let dataURL = docPath!.appendingPathComponent(Keys.dataFile.rawValue)
      guard let codedData = try? Data(contentsOf: dataURL) else { return nil }
//      For NSCoding
      // 3) unarchive the object from the Data object
      _data = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as? ScaryCreatureData
      
//      For NSSecureCoding
      
//      _data = try! NSKeyedUnarchiver.unarchivedObject(ofClass: ScaryCreatureData.self, from: codedData)
      return _data
    }
    set {
      _data = newValue
    }
  }
  
  private var _thumbImage: UIImage?
  var thumbImage: UIImage? {
    get {
      if _thumbImage != nil { return _thumbImage }
      if docPath == nil { return nil }
      
      let thumbImageURL = docPath!.appendingPathComponent(Keys.thumbImageFile.rawValue)
      guard let imageData = try? Data(contentsOf: thumbImageURL) else { return nil }
      _thumbImage = UIImage(data: imageData)
      return _thumbImage
    }
    set {
      _thumbImage = newValue
    }
  }
  
  private var _fullImage: UIImage?
  var fullImage: UIImage? {
    get {
      if _fullImage != nil { return _fullImage }
      if docPath == nil { return nil }
      
      let fullImageURL = docPath!.appendingPathComponent(Keys.fullImageFile.rawValue)
      guard let imageData = try? Data(contentsOf: fullImageURL) else { return nil }
      _fullImage = UIImage(data: imageData)
      return _fullImage
    }
    set {
      _fullImage = newValue
    }
  }
  
  var docPath: URL?
  
  init(docPath: URL) {
    super.init()
    self.docPath = docPath
  }
  
  init(title: String, rating: Float, thumbImage: UIImage?, fullImage: UIImage?) {
    super.init()
    _data = ScaryCreatureData(title: title, rating: rating)
    self.thumbImage = thumbImage
    self.fullImage = fullImage
    saveData()
    saveImages()
  }
  
  func createDataPath() throws {
    guard docPath == nil else { return }
    
    docPath = ScaryCreatureDatabase.nextScaryCreatureDocPath()
    try FileManager.default.createDirectory(at: docPath!, withIntermediateDirectories: true, attributes: nil)
  }
  
  func saveData() {
    // 1) Do nothing if there is nothing to save
    guard let data = data else { return }
    
    // 2) Create the docPath and the folder on disk
    do {
      try createDataPath()
    }catch {
      print("Couldn't create save folder. " + error.localizedDescription)
      return
    }
    
    // 3) Build the path of the file to write
    let dataURL = docPath!.appendingPathComponent(Keys.dataFile.rawValue)
    
    // 4) Encode the data using NSCoding
    let codedData = try! NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    
    // 5) Write the encoded data to the file.
    do {
      try codedData.write(to: dataURL)
    }catch {
      print("Couldn't write to save file: " + error.localizedDescription)
    }
  }
  
  func deleteDoc() {
    if let docPath = docPath {
      do {
        try FileManager.default.removeItem(at: docPath)
      }catch {
        print("Error Deleting Folder. " + error.localizedDescription)
      }
    }
  }
  
  func saveImages() {
    // 1) Make sure that there are images stored
    if _fullImage == nil || _thumbImage == nil { return }
    
    // 2) Create the storage folder if required
    do {
      try createDataPath()
    }catch {
      print("Couldn't create save Folder. " + error.localizedDescription)
      return
    }
    
    // 3) Build the paths for each file
    let thumbImageURL = docPath!.appendingPathComponent(Keys.thumbImageFile.rawValue)
    let fullImageURL = docPath!.appendingPathComponent(Keys.fullImageFile.rawValue)
    
    // 4) Convert the images to Data objects with a PNG representation
    let thumbImageData = _thumbImage!.pngData()
    let fullImageData = _fullImage!.pngData()
    
    // 5) Write the PNG data to disk
    try! thumbImageData!.write(to: thumbImageURL)
    try! fullImageData!.write(to: fullImageURL)
  }
}
