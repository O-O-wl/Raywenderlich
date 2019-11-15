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
import SnapKit

extension QuizViewController {
  func setupConstraints() {
    
    updateProgress(to: 0)
    
    lblTimer.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.45).labeled("Timer Width") // 1
      make.height.equalTo(45) // 2
      make.top.equalTo(viewProgress.snp.bottom).offset(32) // 3
      make.centerX.equalToSuperview().labeled("Timer cenerX") // 4
    }
    
    lblQuestion.snp.makeConstraints { make in
      make.top.equalTo(lblTimer.snp.bottom).offset(24)
      make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    lblMessage.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    svButtons.snp.makeConstraints { make in
      make.leading.trailing.equalTo(lblQuestion)
      make.top.equalTo(lblQuestion.snp.bottom).offset(16)
      make.height.equalTo(80)
    }
  }
  
  func updateProgress(to progress: Double) {
    
    viewProgress.snp.remakeConstraints { maker in
      maker.top.equalTo(view.safeAreaLayoutGuide)
      maker.width.equalToSuperview().multipliedBy(progress)
      maker.height.equalTo(32)
      maker.leading.equalToSuperview().labeled("ViewProgress Leading To SuperView")
    }
    
  }
}
extension QuizViewController {
  
  override func willTransition(to newCollection: UITraitCollection,
                               with coordinator: UIViewControllerTransitionCoordinator) {
    super.willTransition(to: newCollection, with: coordinator)
    
    let isPortrait = UIDevice.current.orientation.isPortrait
    
    lblTimer.snp.updateConstraints { maker in
      maker.height.equalTo(isPortrait ? 45 : 65)
    }
    
    lblTimer.font = UIFont.systemFont(ofSize: isPortrait ? 20 : 32, weight: .light)
  }
}
