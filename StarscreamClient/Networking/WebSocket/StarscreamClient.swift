//
//  WSStarscream.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 04/11/23.
//

import Foundation
import Starscream

/// Client side websocket handler.
open class StarscreamClient: WebSocketClient {
    private let stateUpdateQueue = DispatchQueue(label: "com.chainsaw.ScreamingRocket.websocketStateUpdateQueue")
    
    private var _readyState: ReadyState = .closed
    
    /// Current WebSocket connection state. (Thread safe)
    var readyState: ReadyState {
        get {
            var state: ReadyState?
            stateUpdateQueue.sync {
                state = _readyState
            }
            return state ?? .closed
        }
        set {
            stateUpdateQueue.async(flags: .barrier) {
                self._readyState = newValue
            }
        }
    }

    var isConnected: Bool = false
    
    public var socket: WebSocket!
    
    var fusionSocketDelegate: FusionSocketDelegate?
    var eventDelegate: WebSocketEventDelegate?
    var webSocketStateHandler: WebSocketStateDelegate? //Delegate to track readyState changes(Optional)
    
    
    // MARK: - WebSocketClient Delegate methods
    /// Open websocket connection.
    public func openWebSocketConnection() {
        guard readyState != .open /*|| StarscreamClient.readyState == .connecting*/ else {
            print("Connection is already open")
            return
        }
        
        guard let url = URL(string: TestSockets.localHost.rawValue) else {
            print("Failed to unwrap url")
            return
        }
        
        var request = URLRequest(url: url)
        // set timeout to 5 secs
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()

        // Set the readyState to connecting
        //StarscreamClient.readyState = .connecting
        //webSocketStateHandler?.readyStateDidChanged(to: .connecting)
    }
    
    /// Close websocket connection.
    public func closeWebSocketConnection() {
        guard readyState != .closed else {
            print("Connection not yet established.")
            return
        }
        
        // Disconnect from the WS server
        socket.disconnect()
        readyState = .closing
        webSocketStateHandler?.readyStateDidChanged(to: .closing)
    }
    
    /// Closes the current connection and establish a new connection.
    public func reconnectWebSocketConneciton() {
        print("Triggered \(#function)")
        // Close the connection
        closeWebSocketConnection()
        
        // Initailizing the handshake again
        openWebSocketConnection()
    }
    
    /// Simple method to send string(Experimental).
    func sendString(string: String) {
        socket.write(string: string) {
            print("Successfully send the string to the server.")
        }
    }
    
    private func handleError(_ error: Error?) {
        guard let error = error else { return }
        
        print("Type of error produced by starscream: \(error)")
    }
    
    // MARK: - Private methods
    private func disconnectWebSocket() {
        socket.disconnect()
        socket.delegate = nil
        webSocketStateHandler?.readyStateDidChanged(to: .closed)
        readyState = .closed
    }
    
    deinit {
        disconnectWebSocket()
    }
}

// MARK: - Starscream delegate
extension StarscreamClient: WebSocketDelegate {
    public func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocketClient) {
        switch event {
        case .connected(let headers):
            readyState = .open
            webSocketStateHandler?.readyStateDidChanged(to: .open)
            isConnected = true
            print("websocket is connected: \(headers)")
            fusionSocketDelegate?.webSocketDidOpen(socket)
        case .disconnected(let reason, let code):
            readyState = .closed
            webSocketStateHandler?.readyStateDidChanged(to: .closed)
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            let code = Int(code)
            fusionSocketDelegate?.webSocket(socket, didCloseWithCode: code, reason: reason, wasClean: true)
        case .text(let string):
            print("Received text: \(string) (Inside client class)")
            fusionSocketDelegate?.webSocket(socket, didReceiveMessageWith: string)
        case .binary(let data):
            print("Received data: \(data.count)")
            fusionSocketDelegate?.webSocket(socket, didReceiveMessageWith: data)
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_): // Health status changes
            break
        case .reconnectSuggested(_): // Connection upgrade
            reconnectWebSocketConneciton()
            break
        case .cancelled: // Connection closed
            isConnected = false
            print("Cancelled")
            readyState = .closed
            webSocketStateHandler?.readyStateDidChanged(to: .closed)
        case .error(let error): // Connection closed
            readyState = .closed
            webSocketStateHandler?.readyStateDidChanged(to: .closed)
            isConnected = false
            handleError(error)
            if let error = error {
                fusionSocketDelegate?.webSocket(socket, didFailWithError: error)
            }
            
        case .peerClosed: // peer closed the connection.
            readyState = .closed
            webSocketStateHandler?.readyStateDidChanged(to: .closed)
            isConnected = false
            eventDelegate?.webSocketPeerClosed()
            break
        }
    }
}

extension StarscreamClient: WebSocketConvey {
    func sendMessage(message: String) {
        socket.write(string: message) {
            print("Successfully conveyed to server!")
        }
    }
}

// TODO: - Remove after testing ;)
enum TestSockets: String {
    case localHost = "ws://localhost:8080"
    case sandyWebSocket = "wss://ws.postman-echo.com/raw"
    case onlineWebsocketHost = ""
}
