//
//  Config.swift
//  SwiftIpfsApi
//
//  Created by Teo on 10/11/15.
//  Copyright © 2015 Teo Sartori. All rights reserved.
//
//  Licensed under MIT See LICENCE file in the root of this project for details. 

/** Config controls configuration variables. It works much like 'git config'.
 The configuration values are stored in a config file inside your IPFS repository.
 */
public class Config : ClientSubCommand {
    
    var parent: IpfsApiClient?
    
    public func show(completionHandler: (JsonType) -> Void) throws {
        
        try parent!.fetchJson("config/show",completionHandler: completionHandler )
    }
    
    public func replace(filePath: String, completionHandler: (Bool) -> Void) throws {
        try parent!.net.sendTo(parent!.baseUrl+"config/replace?stream-channels=true", content: [filePath]) {
            _ in
        }
    }
    
    public func get(key: String, completionHandler: (JsonType) throws -> Void) throws {
        try parent!.fetchJson("config?arg=" + key) {
            result in
            guard let value = result.object?["Value"] else {
                throw IpfsApiError.SwarmError("Config get error: \(result.object?["Message"]?.string)")
            }
            
            try completionHandler(value)
            
        }
    }
    
    public func set(key: String, value: String, completionHandler: (JsonType) throws -> Void) throws {
        
        try parent!.fetchJson("config?arg=\(key)&arg=\(value)", completionHandler: completionHandler )
    }
}