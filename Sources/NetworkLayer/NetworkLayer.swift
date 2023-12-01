import Foundation

@available(iOS 13.0.0, *)
public protocol HTTPClient {
    
    func sendRequest<T: Decodable>(endPoint: EndPoint, responseModel: T.Type) async -> Result <T, RequestError>
    
}

@available(iOS 13.0.0, *)
public struct NetworkLayer: HTTPClient {
    
    public init() {}
    
    public func sendRequest<T>(endPoint: EndPoint,
                        responseModel: T.Type) async -> Result<T, RequestError> where T: Decodable {

        var urlComp = URLComponents()
        urlComp.scheme = endPoint.scheme
        urlComp.host = endPoint.host
        urlComp.path = endPoint.path

        guard let url = urlComp.url else {
            return .failure(.invalidURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.allHTTPHeaderFields = endPoint.header

        if let body = endPoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        do {
            let (data , response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }

            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
    
}
