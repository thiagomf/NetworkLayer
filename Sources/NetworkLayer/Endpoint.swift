//
//  EndPoint.swift
//  
//
//  Created by Thiago M Faria on 30/11/23.
//
// scheme + host + patch : https://leetcode.com/problems/valid-palindrome/
// scheme: https
// host: leetcode.com/
// path: problems/valid-palindrome/

import Foundation

public protocol EndPoint {
    
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String : String]? { get }
    var body: [String : String]? { get }
    var queryItems: [URLQueryItem]? { get }
}

public extension EndPoint {
    
    var scheme: String {
        return "https"
    }
}
