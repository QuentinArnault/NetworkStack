//
// Copyright 2017 niji
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import RxSwift

struct VideoDataStore {
  
  // MARK: - Public Properties
  weak var delegate: VideoView?
  
  // MARK: - Private Properties
  private var disposeBag = DisposeBag()
  private var webServiceClient: VideoWebServiceClient?
  
  // MARK: - Init
  init(webServiceClient: VideoWebServiceClient?) {
    self.webServiceClient = webServiceClient
  }
  
  // MARK: - Public Funcs
  func fetchVideos() {
    self.webServiceClient?.fetchAllVideos()
      .observeOn(MainScheduler.instance)
      .subscribe({ (event: Event<[Video]>) in
        switch event {
        case .next(let videos): self.delegate?.fetched(videos: videos)
        case .error(let error):
          let message = "Failed to fetch videos with error : \(error)"
          self.delegate?.error(message: message)
          LogModule.webServiceClient.error(message)
        case .completed: break
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func addVideo() {
    guard let video = webServiceClient?.fakeVideoToAdd() else {
      LogModule.webServiceClient.error("Failed to create fake video !")
      return
    }
    self.webServiceClient?.add(video: video)
      .observeOn(MainScheduler.instance)
      .subscribe({ (event: Event<Video>) in
        switch event {
        case .next(let video): self.delegate?.added(video: video)
        case .error(let error):
          let message = "Failed to add video with error : \(error)"
          self.delegate?.error(message: message)
          LogModule.webServiceClient.error(message)
        case .completed: break
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func deleteVideo(identifier: Int, completion: @escaping () -> Void) {
    self.webServiceClient?.deleteVideo(identifier: identifier)
      .observeOn(MainScheduler.instance)
      .subscribe({ (event: Event<()>) in
        switch event {
        case .next(_): break
        case .error(let error):
          let message = "Failed to delete video with error : \(error)"
          self.delegate?.error(message: message)
          LogModule.webServiceClient.error(message)
        case .completed: completion()
          
        }
      })
      .disposed(by: self.disposeBag)
  }
  
  func badAccess() {
    self.webServiceClient?.badAccess()
      .observeOn(MainScheduler.instance)
      .subscribe({ (event: Event<()>) in
        switch event {
        case .next(_): break
        case .error(let error):
          let message = "Failed to delete video with error : \(error)"
          self.delegate?.error(message: message)
          LogModule.webServiceClient.error(message)
        case .completed: break
          
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}
