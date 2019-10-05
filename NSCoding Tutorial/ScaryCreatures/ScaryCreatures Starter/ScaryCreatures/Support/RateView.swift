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

protocol RateViewDelegate {
  func rateViewRatingDidChange(rateView: RateView, newRating: Float)
}

class RateView: UIView {
  var notSelectedImage: UIImage? {
    didSet {
      refresh()
    }
  }
  
  var fullSelectedImage: UIImage? {
    didSet {
      refresh()
    }
  }
  
  var rating: Float = 0 {
    didSet {
      refresh()
    }
  }
  
  var editable = false
  var imageViews: [UIImageView] = []
  var maxRating = 5 {
    didSet {
      rebindMaxRating()
    }
  }
  
  var midMargin: CGFloat = 5
  var leftMargin: CGFloat = 0
  var minImageSize = CGSize(width: 5, height: 5)
  var delegate: RateViewDelegate!
  
  private func refresh() {
    for (i, imageView) in imageViews.enumerated() {
      if (rating >= Float(i + 1)) {
        imageView.image = fullSelectedImage;
      } else {
        imageView.image = notSelectedImage;
      }
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    guard notSelectedImage != nil else { return }
    
    let desiredImageWidth = (frame.width - (leftMargin * 2) - (midMargin * CGFloat(imageViews.count))) / CGFloat(imageViews.count)
    let imageWidth = max(minImageSize.width, desiredImageWidth)
    let imageHeight = max(minImageSize.height, frame.height);
    
    for (i, imageView) in imageViews.enumerated() {
      let imageFrame = CGRect(x: leftMargin + (CGFloat(i) * (midMargin + imageWidth)), y: 0, width: imageWidth, height: imageHeight)
      imageView.frame = imageFrame
    }
  }
  
  private func rebindMaxRating() {
    imageViews.forEach { $0.removeFromSuperview() }
    imageViews.removeAll()
    
    for _ in 0..<maxRating {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageViews.append(imageView)
      addSubview(imageView)
    }
    
    setNeedsLayout()
    refresh()
  }
  
  func handleTouch(touchLocation: CGPoint) {
    guard editable else { return }
    
    var newRating = 0
    
    for i in stride(from: imageViews.count - 1, to: -1, by: -1) {
      let imageView = imageViews[i]
      if touchLocation.x > imageView.frame.minX {
        newRating = i + 1
        break;
      }
    }
    
    rating = Float(newRating)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self)
      handleTouch(touchLocation: touchLocation)
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let touchLocation = touch.location(in: self)
      handleTouch(touchLocation: touchLocation)
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    delegate.rateViewRatingDidChange(rateView: self, newRating: rating)
  }
}
