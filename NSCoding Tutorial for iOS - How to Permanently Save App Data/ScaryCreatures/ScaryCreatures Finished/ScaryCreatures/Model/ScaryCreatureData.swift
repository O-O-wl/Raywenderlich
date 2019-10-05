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

class ScaryCreatureData: NSObject, NSCoding, NSSecureCoding {
  var title = ""
  var rating: Float = 0
  
  init(title: String, rating: Float) {
    super.init()
    self.title = title
    self.rating = rating
  }
  
  // MARK: NSCoding Implementation
  
  enum Keys: String {
    case title = "Title"
    case rating = "Rating"
  }
  
  func encode(with aCoder: NSCoder) {
//    For NSCoding
    aCoder.encode(title, forKey: Keys.title.rawValue)
    aCoder.encode(rating, forKey: Keys.rating.rawValue)
    
//    For NSSecureCoding
//    aCoder.encode(title as NSString, forKey: Keys.title.rawValue)
//    aCoder.encode(NSNumber(value: rating), forKey: Keys.rating.rawValue)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
//    For NSCoding
//    let title = aDecoder.decodeObject(forKey: Keys.title.rawValue) as! String
//    let rating = aDecoder.decodeFloat(forKey: Keys.rating.rawValue)
    
//    For NSSecureCoding
    let title = aDecoder.decodeObject(of: NSString.self, forKey: Keys.title.rawValue) as String? ?? ""
    let rating = aDecoder.decodeObject(of: NSNumber.self, forKey: Keys.rating.rawValue)
    self.init(title: title, rating: rating?.floatValue ?? 0)
  }
  
  static var supportsSecureCoding: Bool {
    return true
  }
}
