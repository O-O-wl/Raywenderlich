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

class PinterestLayout: UICollectionViewLayout {
  
  weak var delegate: PinterestLayoutDelegate?
  
  private let numOfColumns = 2
  private let cellPadding: CGFloat = 6
  
  
  private var cache: [UICollectionViewLayoutAttributes] = []
  
  private var contentHeight: CGFloat = 0
  private var contentWidth: CGFloat {
    guard let collectionView = self.collectionView else { return 0 }
    let padding = collectionView.contentInset.right + collectionView.contentInset.left
    return collectionView.bounds.width - padding
  }
  
  
  
  /// - Note: collectionViewContentSize
  /// 콜렉션뷰의 컨텐트뷰들의 높이와 너비를 반환
  override var collectionViewContentSize: CGSize {
    return CGSize(width: contentWidth, height: contentHeight)
  }
  
  /// - Note: prepare()
  /// 레이아웃 연산이 일어나기 직전에 호출되는 메소드
  /// item의 사이즈나 포지션을 결정하기위해 요구되는 연산을 할 수 있다.
  override func prepare() {
    super.prepare()
    
    // 캐시가 없다면 어트리뷰트 계산을 시작한다.
    guard cache.isEmpty,
      let collectionView = self.collectionView
      else { return }
    
    
    let columnWidth = contentWidth / CGFloat(numOfColumns)
    
    var xOffset: [CGFloat] = []
    
    // 모든 X좌표를 계산한다.
    // 칼럼인덱스 * 칼럼너비 = 셀의 시작 X좌표
    for column in 0..<numOfColumns {
      xOffset.append(CGFloat(column) * columnWidth)
    }
    
    var column = 0
    var yOffset: [CGFloat] = .init(repeating: 0, count: numOfColumns)
    
    // 모든 Y좌표를 계산한다.
    // 칼럼인덱스 * 칼럼너비 = 셀의 시작 X좌표
    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      
      // 높이를 구하기위해 사진의 높이 구하기
      let photoHeight = delegate?.collectionView(collectionView, heightForPhotoAt: indexPath) ?? 180
      
      // 사진높이 + padding * 2 로 높이 설정
      let height = cellPadding * 2 + photoHeight
      
      // 셀의 Frame 계산
      let frame = CGRect(x: xOffset[column],
                         y: yOffset[column],
                         width: columnWidth,
                         height: height)
      
      // 인셋이 적용된 Frame
      let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
      
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      attributes.frame = insetFrame
      
      // 다시 계산하지 않게 하기 위해서 캐시에 저장
      cache.append(attributes)
      
      //
      contentHeight = max(contentHeight, frame.maxY)
      yOffset[column] += height
      
      column = column < (numOfColumns - 1) ? (column + 1) : 0
    }
    
  }
  
  /// - Note: layoutAttributesForElements(in:)
  /// 주어진 Rect 안의 모든 아이템들의 attributes들을 반환한다.
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
    var visableLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    for attribute in cache {
      if attribute.frame.intersects(rect) {
        visableLayoutAttributes.append(attribute)
      }
    }
    
    return visableLayoutAttributes
  }
  
  /// - Note: layoutAttributesForItem(at:)
  /// 레이아웃의 정보를 콜렉션 뷰에게 제공한다
  /// indexPath 의 item에 해당하는 Attrubutes 를 전달한다.
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    return cache[indexPath.item]
  }
}


protocol PinterestLayoutDelegate: AnyObject {
  
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath) -> CGFloat
}
