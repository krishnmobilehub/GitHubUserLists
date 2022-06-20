//
//  NetworkManager.swift
//  GithubUserList
//

import Foundation
import Alamofire

public enum NetworkError: Error {
    case unprocessableEntity(Int?, String?)
    case internetConnectionError
}

extension NetworkError: LocalizedError {
    public var errorTypes: (Int?, String?) {
        switch self {
        case .internetConnectionError:
            return (0, Constants.Alert.noInternetMessage)
        case .unprocessableEntity(let code, let errorString):
            return (code, errorString)
        }
    }
}

class NetworkManager {
    public static func makeRequest<T: Codable>(_ urlRequest: URLRequestConvertible, mode: T.Type, isShowLoader: Bool = true, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if isShowLoader {
            LoadingView.shared.showIndicator()
        }
        let request = AF.request(urlRequest).validate().responseString { response in
            switch response.result {
            case .success(let jsonString):
                let jsonData: Data = jsonString.data(using: .utf8)!
                #if DEBUG
                let dict = jsonString.convertToDictionary()
                debugPrint("\nResponse: ")
                debugPrint(dict ?? "No response")
                if dict == nil {
                    let dict = jsonString.convertToDictArray()
                    debugPrint("\nDictArrayResponse: ")
                    debugPrint(dict ?? "No response")
                }
                #endif
                let decoder = JSONDecoder()
                do {
                    let decodedJson = try decoder.decode(T.self, from: jsonData)
                    completion(.success(decodedJson))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.unprocessableEntity(200, error.localizedDescription)))
                }
            case .failure(let failError):
                print("Error response", response)
                do {
                    if let responseData = response.data,
                       let errorResponce = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] {
                        var errorMessage = ""
                        if let message = errorResponce["message"] as? String {
                            errorMessage = message
                        } else if errorMessage.contains("A data connection is not currently allowed") || errorMessage.contains("The internet connection appears to be offline") {
                            errorMessage = Constants.Alert.noInternetMessage
                        }
                        completion(.failure(.unprocessableEntity(response.response?.statusCode, errorMessage)))
                    }
                    else {
                        if let descriptionMessage = failError.errorDescription, (descriptionMessage.contains("A data connection is not currently allowed") || descriptionMessage.contains("The internet connection appears to be offline")) {
                            completion(.failure(.unprocessableEntity(response.response?.statusCode, Constants.Alert.noInternetMessage)))
                        } else if let descriptionMessage = failError.errorDescription, descriptionMessage.contains("Response could not be serialized, input data was nil or zero length.") {
                            completion(.failure(.unprocessableEntity(response.response?.statusCode, failError.errorDescription)))
                        }
                        completion(.failure(.unprocessableEntity(response.response?.statusCode, Constants.Alert.genericMessage)))
                    }
                } catch {
                    if failError.errorDescription!.contains("A data connection is not currently allowed") || failError.errorDescription!.contains("The internet connection appears to be offline") {
                        completion(.failure(.unprocessableEntity(response.response?.statusCode, Constants.Alert.noInternetMessage)))
                    }
                    completion(.failure(.unprocessableEntity(response.response?.statusCode, Constants.Alert.genericMessage)))
                }
            }
            if isShowLoader {
                LoadingView.shared.hideIndicator()
            }
        }
        #if DEBUG
        debugPrint("\nRequest: ")
        debugPrint(request.cURLDescription())
        #endif
    }
}

