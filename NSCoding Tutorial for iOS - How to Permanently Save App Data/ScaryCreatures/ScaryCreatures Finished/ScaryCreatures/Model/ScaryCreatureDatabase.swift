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

import Foundation

class ScaryCreatureDatabase: NSObject {
  static let privateDocsDir: URL = {
    // 1
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    // 2
    let documentsDirectoryURL = paths.first!.appendingPathComponent("PrivateDocuments")
    
    // 3
    do {
      try FileManager.default.createDirectory(at: documentsDirectoryURL,
                                              withIntermediateDirectories: true,
                                              attributes: nil)
    } catch {
      print("Couldn't create directory")
    }
    return documentsDirectoryURL
  }()

  class func nextScaryCreatureDocPath() -> URL? {
    // 1) Get all the files and folders within the database folder
    guard let files = try? FileManager.default.contentsOfDirectory(at: privateDocsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return nil }
    var maxNumber = 0
    
    // 2) Get the highest numbered item saved within the database
    files.forEach {
      if $0.pathExtension == "scarycreature" {
        let fileName = $0.deletingPathExtension().lastPathComponent
        maxNumber = max(maxNumber, Int(fileName) ?? 0)
      }
    }
    
    // 3) Return a path with the consecutive number
    return privateDocsDir.appendingPathComponent("\(maxNumber + 1).scarycreature", isDirectory: true)
  }
  
  class func loadScaryCreatureDocs() -> [ScaryCreatureDoc] {
    guard let files = try? FileManager.default.contentsOfDirectory(at: privateDocsDir, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else { return [] }
    
    return files
      .filter { $0.pathExtension == "scarycreature" }
      .map { ScaryCreatureDoc(docPath: $0) }
  }
}
