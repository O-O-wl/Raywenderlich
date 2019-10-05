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

class DetailViewController: UIViewController {
  @IBOutlet weak var rateView: RateView!
  @IBOutlet weak var detailDescriptionLabel: UILabel!
  @IBOutlet weak var titleField: UITextField!
  @IBOutlet weak var imageView: UIImageView!
  
  private var picker: UIImagePickerController!
  
  var detailItem: ScaryCreatureDoc? {
    didSet {
      if isViewLoaded {
        configureView()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    picker = UIImagePickerController()
    configurePicker()
    configureView()
  }
  
  func configurePicker() {
    picker.delegate = self
    picker.sourceType = .photoLibrary
    picker.allowsEditing = false
  }
  
  func configureView() {
    rateView.notSelectedImage = #imageLiteral(resourceName: "shockedface2_empty")
    rateView.fullSelectedImage = #imageLiteral(resourceName: "shockedface2_full")
    rateView.editable = true
    rateView.maxRating = 5
    rateView.delegate = self
    
    if let detailItem = detailItem {
      titleField.text = detailItem.data!.title
      rateView.rating = detailItem.data!.rating
      imageView.image = detailItem.fullImage
      detailDescriptionLabel.isHidden = imageView.image != nil
    }
  }
  
  @IBAction func addPictureTapped(_ sender: UIButton) {
    present(picker, animated: true, completion: nil)
  }
  
  @IBAction func titleFieldTextChanged(_ sender: UITextField) {
    detailItem?.data?.title = sender.text!
    detailItem?.saveData()
  }
}

// MARK: - RateViewDelegate

extension DetailViewController: RateViewDelegate {
  func rateViewRatingDidChange(rateView: RateView, newRating: Float) {
    detailItem?.data?.rating = newRating
    detailItem?.saveData()
  }
}

// MARK: - UIImagePickerControllerDelegate

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    let fullImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    let concurrentQueue = DispatchQueue(label: "ResizingQueue", attributes: .concurrent)
    
    concurrentQueue.async {
      let thumbImage = fullImage.resized(newSize: CGSize(width: 107, height: 107))
      
      DispatchQueue.main.async {
        self.detailItem?.fullImage = fullImage
        self.detailItem?.thumbImage = thumbImage
        self.imageView.image = fullImage
        self.detailItem?.saveImages()
      }
    }
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITextFieldDelegate

extension DetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
