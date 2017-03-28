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

extension CustomAPI {
  public var parameters: [String: Any]? {
    switch self {
    case .authent(let email, let passwd):
      let stringToEncode: String = String(format: "%@:%@", email, passwd)
      guard let credentialData: Data = stringToEncode.data(using: .utf8) else {
        logger.error(.webServiceClient, "Failed to encod data, user:\(email), password:\(passwd)")
        return nil
      }
      let base64Credentials: String = credentialData.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
      return ["Authorization": "Basic \(base64Credentials)"]
    case .postVideo(let video), .putVideo(let video):
      return video.toJSON().dictionaryObject
    default:
      return nil
    }
  }
}
