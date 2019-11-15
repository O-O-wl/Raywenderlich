/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var viewForLayer: UIView!
  
  var layer: CALayer {
    return viewForLayer.layer
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayer()
  }
  
  func setUpLayer() {
    layer.backgroundColor = UIColor.blue.cgColor
    layer.borderWidth = 100
    layer.borderColor = UIColor.red.cgColor
    layer.shadowOpacity = 0.7
    layer.shadowRadius = 10
    
    layer.contents = UIImage(named: "star")?.cgImage
    layer.contentsGravity = kCAGravityCenter
    
    view.setNeedsDisplay()
    self.view.layer.drawsAsynchronously = true
  }
  
  
  @IBAction func tapGestureRecognized(_ sender: UITapGestureRecognizer) {
    self.layer.shadowOpacity = self.layer.shadowOpacity == 0.7 ? 0.0 : 0.7
  }
  
  @IBAction func pinchGestureRecognized(_ sender: UIPinchGestureRecognizer) {
    let offset: CGFloat = sender.scale < 1 ? 5 : -5
    let oldFrame = layer.frame
    let oldOrigin = oldFrame.origin
    
    let newOrigin = CGPoint(x: oldOrigin.x + offset,
                            y: oldOrigin.y + offset)
    let newSize = CGSize(width: oldFrame.width + (offset * -2.0),
                         height: oldFrame.height + (offset * -2.0))
    let newFrame = CGRect(origin: newOrigin, size: newSize)
    print(offset)
    print("oldFrame = \(oldFrame) \nnewFrame\(newFrame)")
    if newFrame.width >= 100.0 && newFrame.width <= 300.0 {
      layer.borderWidth -= offset
      layer.cornerRadius += (offset / 2.0)
      layer.frame = newFrame
    }
  }
  
}
