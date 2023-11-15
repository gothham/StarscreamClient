//
//  FusionSocketDelegate.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 09/11/23.
//

import Foundation
import Starscream

/// Protocol soley made for making the transition from `SocketRocket` to `Starscream` easy.
protocol FusionSocketDelegate { // Contains functionalities that are similar to SocketRocket
    /// Called when the connection is open and ready to send and receive events.
    func webSocketDidOpen(_ websocket: WebSocket)
    
    /// Called when message(Type String) from the server.
    func webSocket(_ websocket: WebSocket, didReceiveMessageWith string: String)
    
    /// Called when message(Type Data) from the server.
    func webSocket(_ websocket: WebSocket, didReceiveMessageWith data: Data)
    
    /// Called when when the connection fail.
    func webSocket(_ websocket: WebSocket, didFailWithError error: Error)
    
    /// Called when the connection is closed.
    func webSocket(_ websocket: WebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool)
}
