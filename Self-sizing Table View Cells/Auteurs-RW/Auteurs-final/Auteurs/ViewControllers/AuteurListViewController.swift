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

class AuteurListViewController: UIViewController {
  let auteurs = Auteur.auteursFromBundle()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 600
    navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34, weight: .bold) ]
    navigationItem.largeTitleDisplayMode = .automatic
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destination = segue.destination as? AuteurDetailViewController,
      let indexPath = tableView.indexPathForSelectedRow {
      destination.selectedAuteur = auteurs[indexPath.row]
    }
  }
}

extension AuteurListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return auteurs.count
  }
 
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AuteurTableViewCell
    let auteur = auteurs[indexPath.row]
    
    cell.bioLabel.text = auteur.bio
    cell.auteurImageView.image = UIImage(named: auteur.image)
    cell.nameLabel.text = auteur.name
    cell.source.text = auteur.source
    cell.auteurImageView.layer.cornerRadius = cell.auteurImageView.frame.size.width / 2
    cell.nameLabel.textColor = .white
    cell.bioLabel.textColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0)
    cell.source.textColor = UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.0)
    cell.source.font = UIFont.italicSystemFont(ofSize: cell.source.font.pointSize)
    cell.nameLabel.textAlignment = .center
    cell.selectionStyle = .none
    
    return cell
  }
}
