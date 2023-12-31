//
//  NetworkService.swift
//  ionKhaleej
//
//  Created by Mohammad Tariq Shamim on 14/03/23.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    let customer_id = "1"
    let app_name = "ionKhaleej"
    
    func imageslide(category: String, language: String, completion: @escaping(Result<[ImageSlide], Error>) -> Void) {
        let params = ["channel": "all", "customer_id": customer_id, "category": category, "language": language]
            
        request(route: .channels, method: .post, parameters: params, completion: completion)
    }
    
    func vod(category: String, language: String, completion: @escaping(Result<[ImageSlide], Error>) -> Void) {
        let params = ["vod": "all", "customer_id": customer_id, "category": category, "language": language]
            
        request(route: .channels, method: .post, parameters: params, completion: completion)
    }

    func favorite(favorites: String, completion: @escaping(Result<[ImageSlide], Error>) -> Void) {
        let params = ["favorite": "all", "customer_id": customer_id, "favorites": favorites]
            
        request(route: .channels, method: .post, parameters: params, completion: completion)
    }
    
    func categories(completion: @escaping(Result<[CategoryModel], Error>) -> Void) {
        let params = ["category": "all", "customer_id": customer_id]
            
        request(route: .channels, method: .post, parameters: params, completion: completion)
    }
    
    func customer(completion: @escaping(Result<CustomerModel, Error>) -> Void) {
        let params = ["customer": "details", "customer_id": customer_id]
            
        request(route: .logo, method: .post, parameters: params, completion: completion)
    }
    
    
    private func request<T: Decodable>(route: Route, method: Method, parameters: [String: Any]? = nil, completion: @escaping(Result<T, Error>) -> Void) {
        guard let request = createRequest(route: route, method: method, parameters: parameters) else {
            completion(.failure(AppError.unknownError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Result<Data, Error>?
            if let data = data {
                result = .success(data)
                let responseString = String(data: data, encoding: .utf8) ?? "Could not stringify our data"
                print("The response is: \(responseString)")
            } else if let error = error {
                result = .failure(error)
                print("The error is " + error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.handleResponse(result: result, completion: completion)
            }
            
        }.resume()
    }
    
    private func handleResponse<T: Decodable>(result: Result<Data, Error>?, completion: (Result<T, Error>) -> Void) {
        guard let result = result else {
            completion(.failure(AppError.unknownError))
            return
        }
            
        switch result {
        case .success(let data):
            let decoder = JSONDecoder()
            guard let response = try? decoder.decode(ApiResponse<T>.self, from: data) else {
                completion(.failure(AppError.errorDecoding))
                return
            }
                
            if let error = response.error {
                completion(.failure(AppError.serverError(error)))
                return
            }
            
            if let decodedData = response.data {
                completion(.success(decodedData))
            } else {
                completion(.failure(AppError.unknownError))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func createRequest(route: Route, method: Method, parameters: [String: Any]? = nil) -> URLRequest? {
        let urlString = Route.baseurl + route.description
        guard let url = urlString.asUrl else {return nil}
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        
        if let params = parameters {
            switch method {
            case .get:
                var urlComponent = URLComponents(string: urlString)
                urlComponent?.queryItems = params.map { URLQueryItem(name: $0, value: "\($1)")}
                urlRequest.url = urlComponent?.url
            case .post:
                let bodyData = try?JSONSerialization.data(withJSONObject: params, options: [])
                urlRequest.httpBody = bodyData
            }
        }
        
        return urlRequest
    }
    
    //load image from url async
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
