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

class ScaryCreatureDatabase: NSObject {
  
  static let privateDocDir: URL = {
    // 앱의 도큐먼트 폴더 url
    let paths = FileManager.default.urls(for: .documentDirectory,
                                         in: .userDomainMask)
    print("경로: \(paths.first!)")
    // 도큐먼트 경로 생성
    let documentDirectoryURL = paths.first!.appendingPathComponent("PrivateDocuments")
    
    do {
      // 경로에 디렉터리 생성
      try FileManager.default.createDirectory(at: documentDirectoryURL,
                                              withIntermediateDirectories: true,
                                              attributes: nil)
    } catch {
      print("Couldn't create directory")
    }
    return documentDirectoryURL
  }()
  
  class func nextScaryCreatureDocPath() -> URL? {
    guard let files = try? FileManager.default.contentsOfDirectory(at: privateDocDir,
                                                                   includingPropertiesForKeys: nil,
                                                                   options: .skipsHiddenFiles)
      else { return nil }
    
    var maxNumber = 0
    files.forEach {
      let fileName = $0.deletingPathExtension().lastPathComponent
      maxNumber = max(Int(fileName) ?? 0, maxNumber)
    }
    
    return privateDocDir
      .appendingPathComponent("\(maxNumber+1).scarycreature", isDirectory: true)
  }
  
  class func loadScaryCreatureDoc() -> [ScaryCreatureDoc] {
    guard
      let files = try? FileManager.default.contentsOfDirectory(at: privateDocDir,
                                                               includingPropertiesForKeys: nil,
                                                               options: .skipsHiddenFiles)
      else { return [] }
    
    return files
      .compactMap { ScaryCreatureDoc(docPath: $0 ) }
    
  }
  
}
