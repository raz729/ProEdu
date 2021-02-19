//
//  NetworkManager.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation
import UIKit

public enum APIServiceError: Error {
    
    case error(_ data: String?)
    case apiError
    case noData
    case decodeError
}

extension APIServiceError {
    var value: String? {
        switch self {
        case .error(let data):
            return data
        case .apiError:
            return nil
        case .noData:
            return nil
        case .decodeError:
            return nil
        }
    }
}

class NetworkManager {
    
    public static let shared = NetworkManager()
    private init() {}
    
    private let urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.httpShouldSetCookies = false
        configuration.httpShouldUsePipelining = true
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.timeoutIntervalForResource = TimeInterval(20)
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    private let baseURL = URL(string: Constants.URLs.apiBaseURL)!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        return jsonDecoder
    }()
    
    private func fetchResources<T: Decodable>(urlRequest: URLRequest, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                let dataStr = String(data: data, encoding: .utf8)
                print(dataStr!)
                completion(.failure(.error(dataStr)))
                return
            }
            
            do {
                let dataStr = String(data: data, encoding: .utf8)
                print(dataStr!)
                
                let values = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(values))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    class func handle(error: APIServiceError) -> String {
        switch error {
        case .error:
            if let errorData = error.value {
                let json = errorData.toDictionary()
                if let firstValue = json?.first {
                    if isString(firstValue.value) {
                        return firstValue.value as! String
                    } else if isArray(firstValue.value) {
                        return (firstValue.value as! [String]).first ?? Constants.Strings.serverError
                    }
                }
            }
        default:
            return Constants.Strings.serverError
        }
        
        return Constants.Strings.serverError
    }
}

// MARK: - Configuration
extension NetworkManager {
    func getPreview(result: @escaping (Result<PreviewDetails, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getPreviewDetails
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
}

// MARK: - Users
extension NetworkManager {
    func phoneVerification(_ phoneNumber: String, result: @escaping (Result<VerificationResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.phoneVerification(phoneNumber)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func phoneConfirmation(_ phoneNumber: String, _ sessionToken: String, securityCode: String, result: @escaping (Result<ConfirmationResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.phoneConfirmation(phoneNumber, sessionToken, securityCode)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func isUserExists(_ phoneNumber: String, result: @escaping (Result<ExistUserResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.isUserExists(phoneNumber)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getSecureCode(_ phoneNumber: String, result: @escaping (Result<[String: String], APIServiceError>) -> Void) {
        let method = APIServiceMethod.getSecureCode(phoneNumber)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func updateUserInfo(_ userInfo: UserInfo, result: @escaping (Result<UserUpdateResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.updateUserInfo(userInfo)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getUserInfo(token: String? = nil, result: @escaping (Result<UserInfo, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getUserInfo
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken(token)
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func updateAvatar(_ imageData: Data, result: @escaping (Result<UserInfo, APIServiceError>) -> Void) {
        let method = APIServiceMethod.updateAvatar
        let url = baseURL.appendingPathComponent(method.path)
        var request = URLRequest(url: url)
        request.setBearerToken()
        request.httpMethod = "PATCH"
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("\r\n--Boundary-\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"avatar\"; filename=\"\(boundary).jpg\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: avatar/jpg\r\n\r\n".data(using: .utf8)!)
        data.append(imageData)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getAvatar(with path: String, result: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: Constants.URLs.baseURL)?.appendingPathComponent(path) else {
            result(UIImage(named: "ic_user_placeholder"))
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    result(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    result(UIImage(named: "ic_user_placeholder"))
                }
            }
        }
    }
}

// MARK: - Plans
extension NetworkManager {
    func getPlans(result: @escaping (Result<PlansResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getPlans
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func buyPlan(with id: Int, result: @escaping (Result<Plan, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getPlans
        let url = baseURL.appendingPathComponent(method.path).appendingPathComponent("\(id)").appendingPathComponent("buy/")
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getSession(with id: Int, result: @escaping (Result<Session, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getSession(id)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getProducts(with id: Int, result: @escaping (Result<ProductsResult, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getProducts(id)
        let url = baseURL.appendingPathComponent(method.path)

        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data

        fetchResources(urlRequest: request, completion: result)
    }
    
    func activateSession(with id: Int, result: @escaping (Result<Session, APIServiceError>) -> Void) {
        let method = APIServiceMethod.activateSession(id)
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
}

// MARK: - News
extension NetworkManager {
    func getNewsCategories(result: @escaping (Result<[NewsCategory], APIServiceError>) -> Void) {
        let method = APIServiceMethod.getNewsCategories
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
    
    func getNews(result: @escaping (Result<NewsItems, APIServiceError>) -> Void) {
        let method = APIServiceMethod.getNews
        let url = baseURL.appendingPathComponent(method.path)
        
        var request = URLRequest(url: url)
        request.setApplicationJson()
        request.setBearerToken()
        request.httpMethod = method.httpMethod
        request.httpBody = method.data
        
        fetchResources(urlRequest: request, completion: result)
    }
}

extension URLRequest {
    mutating func setApplicationJson() {
        self.setValue("Application/json", forHTTPHeaderField: "Content-Type")
    }
    
    mutating func setBearerToken(_ t: String? = nil) {
        let token = t != nil ? t : AppManager.token
        let bToken = "Bearer \(token ?? "")"
        self.setValue(bToken, forHTTPHeaderField: "Authorization")
    }
}
