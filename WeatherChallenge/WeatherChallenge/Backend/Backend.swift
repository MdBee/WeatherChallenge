//
//  Backend.swift
//  WeatherChallenge
//
//  Created by Bearson, Matt D. on 11/26/17.
//  Copyright © 2017 Bearson, Matt D. All rights reserved.
//

import Foundation
import UIKit

enum RequestMethods: String
{
    case GET = "GET"
    case POST = "POST"
}

typealias ServerResponseWithData = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void
typealias ServerResponseWithDictionary = (_ dictionary: [String: AnyObject]?, _ response: URLResponse?, _ error: Error?) -> Void
typealias ServerResponseWithImage = (_ image: UIImage?, _ response: URLResponse?, _ error: Error?) -> Void

class Backend: NSObject
{
    /** Singleton */
    static let sharedBackend = Backend()
    
    private override init()
    {
        super.init()
    }
    
    //MARK: Private methods
    
    private func sendRequest(withHttpMethod method: RequestMethods, url: URL, parameters: Data?, completionBlock: @escaping ServerResponseWithData) -> URLSessionDataTask
    {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let parameters = parameters
        {
            request.httpBody = parameters
        }
        
        return session.dataTask(with: request, completionHandler: completionBlock)
    }
    
    /** Private GET to use inside this class only */
    private func GET(url: URL, parameters: Data?, completionBlock: @escaping ServerResponseWithData) -> URLSessionDataTask
    {
        return sendRequest(withHttpMethod: .GET, url: url, parameters: parameters, completionBlock: completionBlock)
    }
    
    private func getImageWithURL(url: URL, completionBlock: @escaping ServerResponseWithImage) -> URLSessionDataTask
    {
        return GET(url: url, parameters: nil, completionBlock: { (data, response, error) in
            if (error != nil)
            {
                completionBlock(nil,response,error)
            }
            else
            {
                if let data = data, let newImage = UIImage(data: data)
                {
                    completionBlock(newImage,response,error)
                }
                else
                {
                    completionBlock(nil,response,error)
                }
            }
        })
    }
    

    private func getDataWithURL(url: URL, completionBlock: @escaping ServerResponseWithData) -> URLSessionDataTask
    {
        return GET(url: url, parameters: nil, completionBlock: { (data, response, error) in
            if (error != nil)
            {
                completionBlock(nil,response,error)
            }
            else
            {
                if let data = data
                {
                    completionBlock(data,response,error)
                }
                else
                {
                    completionBlock(nil,response,error)
                }
            }
        })
    }
    
    
    //MARK: - General Methods

    func getWeather(forCity city: String, completionBlock: @escaping ServerResponseWithDictionary) -> URLSessionDataTask
    {
        return getWeatherDictionary(forCity: city) { (dictionary, response, error) in
            if error == nil, let dictionary = dictionary
            {
                guard dictionary["cod"]?.description != "404"
                    else { completionBlock(nil,response,NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "City not found.  Please check spelling of city name."]))
                        return }
                CoreDataManager.defaultManager().storeServerResponse(response: dictionary, searchText: city)
                completionBlock(dictionary,response,error)
            }
            else
            {
                completionBlock(nil,response,error)
            }
        }
    }
    
    func getWeatherDictionary(forCity city: String, completionBlock: @escaping  ServerResponseWithDictionary) -> URLSessionDataTask
    {
        let urlString = OpenWeatherMapConstants.baseURL.appending(OpenWeatherAPI.getWeather)+"?"+"q=\(city)"+"&APPID=\(OpenWeatherMapConstants.apiKey)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        return GET(url: url!, parameters: nil) { (data, response, error) in
            
            if error == nil, let data = data, let dictionary = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : AnyObject]
            {
                completionBlock(dictionary,response,error)
            }
            else
            {
                completionBlock(nil,response,error)
            }
        }
    }
    
    func getWeatherIcon(byCode: String, completionBlock: @escaping ServerResponseWithImage) -> URLSessionDataTask
    {
        let urlString = OpenWeatherMapConstants.baseURL.appending(OpenWeatherAPI.getIcon)+byCode+".png"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        return getImageWithURL(url: url!, completionBlock: completionBlock)
    }
}
