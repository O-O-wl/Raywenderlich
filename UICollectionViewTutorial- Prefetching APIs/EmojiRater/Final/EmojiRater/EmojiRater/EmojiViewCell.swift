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

class EmojiViewCell: UICollectionViewCell {
  @IBOutlet weak var emojiLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
  
  var emojiRating: EmojiRating?
  
  override func prepareForReuse() {
    DispatchQueue.main.async {
      self.displayEmojiRating(.none)
    }
  }
  
  func updateAppearanceFor(_ emojiRating: EmojiRating?, animated: Bool = true) {
    DispatchQueue.main.async {
      if animated {
        UIView.animate(withDuration: 0.5) {
          self.displayEmojiRating(emojiRating)
        }
      } else {
        self.displayEmojiRating(emojiRating)
      }
    }
  }
  
  private func displayEmojiRating(_ emojiRating: EmojiRating?) {
    self.emojiRating = emojiRating
    if let emojiRating = emojiRating {
      emojiLabel?.text = emojiRating.emoji
      ratingLabel?.text = emojiRating.rating
      emojiLabel?.alpha = 1
      ratingLabel?.alpha = 1
      loadingIndicator?.alpha = 0
      loadingIndicator?.stopAnimating()
      backgroundColor = #colorLiteral(red: 0.9338415265, green: 0.9338632822, blue: 0.9338515401, alpha: 1)
      layer.cornerRadius = 10
    } else {
      emojiLabel?.alpha = 0
      ratingLabel?.alpha = 0
      loadingIndicator?.alpha = 1
      loadingIndicator?.startAnimating()
      backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
      layer.cornerRadius = 10
    }
  }
}
