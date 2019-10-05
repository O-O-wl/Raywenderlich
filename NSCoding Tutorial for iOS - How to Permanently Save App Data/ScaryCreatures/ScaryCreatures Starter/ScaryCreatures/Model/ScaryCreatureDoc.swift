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
  
  private var _data: ScaryCreatureData?
  
  var data: ScaryCreatureData? {
    get {
      if _data != nil { return _data }
      guard
        let dataURL = docPath?.appendingPathComponent(Keys.dataFile.rawValue),
        let encodedData = try? Data(contentsOf: dataURL)
        else { return nil }
      
      // 읽어온 데이터 언아카이빙
      _data = try! NSKeyedUnarchiver.unarchivedObject(ofClass: ScaryCreatureData.self,
                                                     from: encodedData)
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
      guard
        let thumbImageURL = docPath?.appendingPathComponent(Keys.thumbImageFile.rawValue),
        let imageData = try? Data(contentsOf: thumbImageURL)
        else { return nil }
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
      guard
        let fullImageURL = docPath?.appendingPathComponent(Keys.fullImageFile.rawValue),
        let imageData = try? Data(contentsOf: fullImageURL)
        else { return nil }
      _fullImage = UIImage(data: imageData)
      return _fullImage
    }
    set {
      _fullImage = newValue
    }
  }
  
  init(title: String, rating: Float, thumbImage: UIImage?, fullImage: UIImage?) {
    super.init()
    _data = ScaryCreatureData(title: title, rating: rating)
    self.thumbImage = thumbImage
    self.fullImage = fullImage
    // 생성 후 데이터저장
    saveData()
  }
  
  // 해당 인스턴스를 저장할 디스크의 위치
  var docPath: URL?
  
  init(docPath: URL) {
    super.init()
    self.docPath = docPath
  }
  
  // docPath가 없다면 한번만 생성 
  func createDocPath() throws {
    guard
      docPath != nil
      else { return }
    
    docPath = ScaryCreatureDatabase.nextScaryCreatureDocPath()
    try FileManager.default.createDirectory(at: docPath!,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
  }
  
  func saveData() {
    guard let data = data else { return }
    
    do {
      try createDocPath()
    } catch {
      print("Couldn't create save folder. " + error.localizedDescription)
      return
    }
    
    let dataURL = docPath!.appendingPathComponent(Keys.dataFile.rawValue)
    
    // ScaryCreatureData encoding
    let encodedData = try! NSKeyedArchiver.archivedData(withRootObject: data,
                                                        requiringSecureCoding: false)
    do {
      try encodedData.write(to: dataURL)
    } catch {
      print("Couldn't write save folder. " + error.localizedDescription)
      return
    }
    
  }
  
  // 파일을 통째로 삭제
  func deleteData() {
    if let docPath = docPath {
      do {
        try FileManager.default.removeItem(at: docPath)
      } catch {
       print("Couldn't delete folder. " + error.localizedDescription)
      }
    }
  }
  
}
extension ScaryCreatureDoc {
  
  enum Keys: String {
    case dataFile = "Data.plist"
    case thumbImageFile = "thumbImage.png"
    case fullImageFile = "fullImage.png"
  }
  
}
