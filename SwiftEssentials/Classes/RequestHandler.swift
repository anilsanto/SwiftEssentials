//
//  RequestHandler.swift
//  FBSnapshotTestCase
//
//  Created by Anil Santo on 29/10/18.
//

import Foundation
import Security

class RequestHandler: NSObject ,URLSessionDelegate{
    
    let configuration : URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        return config
    }()
    
    var session : URLSession!
    var trustedCertificatesPath : [String]?
    class var shared: RequestHandler {
        struct Static {
            static let instance : RequestHandler = RequestHandler()
        }
        return Static.instance
    }
    
    override init(){
        super.init()
        configuration.timeoutIntervalForRequest = TimeInterval(300)
        configuration.timeoutIntervalForResource = TimeInterval(300)
        session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
    }
    
    init(withTimeout timeout: TimeInterval,sslPinningEnable enabled: Bool = false){
        super.init()
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        if enabled{
            session = URLSession(configuration: configuration, delegate: self, delegateQueue:OperationQueue.main)
        }
        else{
            session = URLSession(configuration: configuration, delegate: nil, delegateQueue:OperationQueue.main)
        }
    }
    
    func httpCancelRequest(){
        session.getTasksWithCompletionHandler { (tasks : [URLSessionDataTask], _: [URLSessionUploadTask], _: [URLSessionDownloadTask]) in
            for task in tasks{
                task.cancel()
            }
        }
    }
    
    func request<T: Decodable,E: Decodable,R: Encodable>(forUrl urlString : String,isEncoded : Bool = false,withMethod method: String,withHeader header : Dictionary<String,String>?,withBody body : R?,completionHandler: @escaping (T?,E?) ->()){
        
        var encodedString = ""
        if isEncoded {
            let percentageEncoded = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            encodedString = percentageEncoded!.trimWhiteSpace
        }
        else{
            encodedString = urlString.trimWhiteSpace
        }
        guard let url = URL(string: encodedString) else{ return }
        var requestObj = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: configuration.timeoutIntervalForRequest)
        requestObj.httpMethod = method
        if let headerField = header{
            let allKeys = headerField.keys
            for key in allKeys{
                requestObj.addValue(headerField[key] ?? "", forHTTPHeaderField: key)
            }
        }
        if body != nil{
            let jsonData = try? JSONEncoder().encode(body)
            requestObj.httpBody = jsonData
        }
        guard let urlSession = session else{
            completionHandler(nil,nil)
            return
        }
        urlSession.dataTask(with: requestObj) { ( data, response, err) in
            guard err != nil else {
                completionHandler(nil,nil)
                return
            }
            guard let dataObj = data else {
                completionHandler(nil,nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(nil,nil)
                return
            }
            if (200..<300).contains(httpResponse.statusCode) {
                do{
                    let obj = try JSONDecoder().decode(T.self, from: dataObj)
                    completionHandler(obj,nil)
                }
                catch{
                    do{
                        let obj = try JSONDecoder().decode(E.self, from: dataObj)
                        completionHandler(nil,obj)
                    }
                    catch{
                        completionHandler(nil,nil)
                    }
                }
            }
            else{
                do{
                    let obj = try JSONDecoder().decode(T.self, from: dataObj)
                    completionHandler(obj,nil)
                }
                catch{
                    do{
                        let obj = try JSONDecoder().decode(E.self, from: dataObj)
                        completionHandler(nil,obj)
                    }
                    catch{
                        completionHandler(nil,nil)
                    }
                }
            }
            }.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else{return}
        guard let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else{return}
        
        // Set SSL policies for domain name check
        let policies = NSMutableArray();
        policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
        SecTrustSetPolicies(serverTrust, policies);
        
        // Evaluate server certificate
        var result: SecTrustResultType = SecTrustResultType(rawValue: 0)!
        SecTrustEvaluate(serverTrust, &result)
        let isServerTrusted : Bool = (result == .unspecified || result == .proceed)
        let credential:URLCredential = URLCredential(trust: serverTrust)
        
        
        let remoteCertificateData:NSData = SecCertificateCopyData(certificate)
        guard let paths = trustedCertificatesPath else{
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        paths.forEach { (path) in
            guard let localCertificate: NSData = NSData(contentsOfFile: path) else{
                completionHandler(.cancelAuthenticationChallenge, nil)
                return
            }
            if (isServerTrusted && remoteCertificateData.isEqual(to: localCertificate as Data)) {
                completionHandler(.useCredential, credential)
                return
            }
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(nil)
    }
}
