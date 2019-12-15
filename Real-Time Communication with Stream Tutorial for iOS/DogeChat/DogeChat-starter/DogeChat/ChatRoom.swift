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
import Foundation

class ChatRoom: NSObject {
  
  ///===========================================================
  /// - Note: App & Server 사이에 소켓베이스의 커넥션을 가능하게해준다.
  ///===========================================================
  var inputStream: InputStream!
  var outputStream: OutputStream!
  
  var userName = ""
  
  /// 메시지 최대 길이
  let maxLength = 4096
  
  weak var delegate: ChatRoomDelegate?
  
  // MARK: - Methods
  
  func setupNetworkCommunication() {
    
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    // read & write stream 해당 소켓 호스트와 바인딩하며 초기화
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       "localhost" as CFString,
                                       80,
                                       &readStream,
                                       &writeStream)
    
    /// - Note: takeRetainedValue()
    /// unmanged 객체의 reference를 retain 한다.
    inputStream = readStream?.takeRetainedValue()
    outputStream = writeStream?.takeRetainedValue()
    
    inputStream.delegate = self
    
    // run loop 로 네트워크 반응을 적절히 하기위해서 호출
    inputStream.schedule(in: .current, forMode: .common)
    outputStream.schedule(in: .current, forMode: .common)
    
    inputStream.open()
    outputStream.open()
  }
  
  func joinChat(userName: String) {
    let data = "iam:\(userName)".data(using: .utf8)!
    self.userName = userName
    
    _ = data.withUnsafeBytes {
      guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
      
      outputStream.write(pointer, maxLength: data.count)
    }
  }
  
  func send(message: String) {
    let data = "msg:\(message)".data(using: .utf8)!
    
    _ = data.withUnsafeBytes {
      guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
      
      outputStream.write(pointer, maxLength: data.count)
    }
  }
  
  func stopChatSession() {
    inputStream.close()
    outputStream.close()
  }
}

extension ChatRoom: StreamDelegate {
  
  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case .hasBytesAvailable:
      print("new message received1")
    case .endEncountered:
      print("new message received2")
      stopChatSession()
    case .errorOccurred:
      print("error occur")
    case .hasSpaceAvailable:
      print("has space available")
    default:
      print("some other event")
    }
    
    readAvailableBytes(stream: aStream as! InputStream)
  }
  
  private func readAvailableBytes(stream: InputStream) {
    
    // 들어오는 바이트를 읽어들이기 위한 버퍼 설정
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
    
    // 읽기가능한 바이트모두를 이터레이팅
    while stream.hasBytesAvailable {
      
      // 스트림을 읽어서 버퍼에 저장
      let numOfBytesRead = inputStream.read(buffer, maxLength: maxLength)
      
      if numOfBytesRead < 0,
        let error = stream.streamError {
        print(error)
        break
      }
      
      print(numOfBytesRead)
      if let message = processMessageString(buffer: buffer, length: numOfBytesRead) {
        delegate?.received(message: message)
      }
    }
  }
  
  private func processMessageString(buffer:UnsafeMutablePointer<UInt8>,
                                    length: Int) -> Message? {
    // buffer 를 이용한 문자열 초기화
    guard let stringArray = String(bytesNoCopy: buffer,
                                   length: length,
                                   encoding: .utf8,
                                   freeWhenDone: true)?.components(separatedBy: ":"),
      let name = stringArray.first,
      let message = stringArray.last
      else { return nil }

    print(stringArray)
    // 수신자에 대한 enum
    let messageSender: MessageSender = name == self.userName ? .ourself : .someoneElse
    
    return Message(message: message,
                   messageSender: messageSender,
                   username: name)
  }
  
}


protocol ChatRoomDelegate: AnyObject {
  func received(message: Message)
}
