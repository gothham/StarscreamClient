//
//  WebSocketClient.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 09/11/23.
//

import Foundation
import Starscream

/*This is an effort to handle the websocket readyState from the client side since Starscream doesn't provide the functionality for readyState. But the library (Starscream) has handled it gracefully inside their framework.*/
/// Type used for checking the ReadyState/ConnectionState/SocketState.
enum ReadyState: Int {
    /// Initial state of WebSocket connection lifecycle.
    case connecting = 0
    
    /// The connection is fully open, and you can send and receive data.
    case open = 1
    
    /// WebSocket connection is going to be closed.
    case closing = 2
    
    /// Connection is no longer open, and you can't send or receive data through it.
    case closed = 3
    
    /// Connection Failed.
    case failed = 4
}

/// Delegate that informs the state changes of Websocket.
protocol WebSocketStateDelegate {
    func readyStateDidChanged(to state: ReadyState)
}

protocol WebSocketEventDelegate {
    /// Called when the connection health is changed.
    func webSocketDidViabilityChange(isViable: Bool)
    
    /// Called when the device network connection gets upgraded.
    func webSocketShouldReconnect()
    
    /// Called when the peer(Server) closes the connection.
    func webSocketPeerClosed()
}

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

protocol WebSocketClient {
    /// Current WebSocket connection state.
    var readyState: ReadyState { get set }
    /// Client WebSocket.
    var socket: WebSocket! { get set }
    /// Delegate property for replica methods of SocketRocket.
    var fusionSocketDelegate: FusionSocketDelegate? { get set }
    /// Delegate for additional events that Starscream provides.
    var eventDelegate: WebSocketEventDelegate? { get set }
    /// Delegate property for tracking the readyState changes.
    var webSocketStateHandler: WebSocketStateDelegate? { get set }
    /// Opens the WebSocket connection.
    func openWebSocketConnection(with url: URL)
    /// Closed the WebSocket connection.
    func closeWebSocketConnection()
    /// Close the existing and reconnect the WebSocket connection.
    func reconnectWebSocketConneciton()
    /// Sends string value to the server.
    func sendString(_ string: String, completion: @escaping (Bool) -> Void)
}
