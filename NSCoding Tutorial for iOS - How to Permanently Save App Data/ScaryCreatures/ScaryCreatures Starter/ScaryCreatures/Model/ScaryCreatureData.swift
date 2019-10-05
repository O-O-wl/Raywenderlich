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

class ScaryCreatureData: NSObject, NSCoding {
  var title = ""
  var rating: Float = 0
  
  init(title: String, rating: Float) {
    super.init()
    self.title = title
    self.rating = rating
  }
  
  // 첫번째 파라미터인 value또한 NSCoding을 따르는 타입이어야한다.
  func encode(with coder: NSCoder) {
    coder.encode(title, forKey: Keys.title.rawValue)
    coder.encode(rating, forKey: Keys.rating.rawValue)
  }
  
  // 디코딩 과 초기화
  required convenience init?(coder: NSCoder) {
    let title = coder.decodeObject(forKey: Keys.title.rawValue) as! String
    let rating = coder.decodeFloat(forKey: Keys.rating.rawValue)
    self.init(title: title, rating: rating)
  }
  
  // 오타 방지
  // 명시적으로 해당스트링을 키라고 표현할 수 있다
  // 이걸 컴파일러에게 까지 인지 가능하게 할 수 있다.
  enum Keys: String {
    case title = "Title"
    case rating = "Rating"
  }
  
}
