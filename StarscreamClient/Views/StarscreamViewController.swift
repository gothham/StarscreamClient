//
//  ViewController.swift
//  ScreamingRocket
//
//  Created by doss-zstch1212 on 30/10/23.
//
//http://localhost:8080

import UIKit
import Starscream

class StarscreamViewController: UIViewController {
    var starscream: WebSocketClient = StarscreamClient()

//    var SR_Socket: SRWebSocket?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starscream.fusionSocketDelegate = self
        starscream.webSocketStateHandler = self
        starscream.eventDelegate = self
    }

    @IBAction func connectButtonAction(_ sender: Any) {
        if let url = URL(string: TestSockets.localHost.rawValue) {
            starscream.openWebSocketConnection(with: url)
        }
    }
    
    @IBAction func disconnectButtonAction(_ sender: Any) {      
        starscream.closeWebSocketConnection()
    }
    
    @IBAction func reconnectAction(_ sender: Any) {
        starscream.reconnectWebSocketConneciton()
    }
    
    private func sendMessage() {
        starscream.sendString("Hello") { isSuccess in
            switch isSuccess {
            case true:
                print("Message sent.")
            case false:
                print("Message failed to sent.")
            }
        }
    }
}

// MARK: - Replica methods delegate
extension StarscreamViewController: FusionSocketDelegate {
    func webSocketDidOpen(_ websocket: Starscream.WebSocket) {
        websocket.write(string: "Handshake established!") {
            print("Success!")
            
        }
    }
    
    func webSocket(_ websocket: Starscream.WebSocket, didReceiveMessageWith string: String) {
        if starscream.readyState == .open {
            print("Message received: \(string)")
        }
    }
    
    func webSocket(_ websocket: Starscream.WebSocket, didReceiveMessageWith data: Data) {
        print("Message(Data) received: \(data)")
    }
    
    func webSocket(_ websocket: Starscream.WebSocket, didFailWithError error: Error) {
        websocket.write(string: "Connection failed: \(error)")
        print("Connection failed: \(error)")
    }
    
    func webSocket(_ websocket: Starscream.WebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
        websocket.write(string: "Client: Connection closed! didCloseWithCode \(code), reason: \(code)")
        print("Connection closed! didCloseWithCode \(code), reason: \(code)")
    }
}

// MARK: - ReadyState Delegate
extension StarscreamViewController: WebSocketStateDelegate {
    func readyStateDidChanged(to state: ReadyState) {
        print("ReadyState will change to -> \(state)")
        print("Current client ReadyState: \(starscream.readyState)")
    }
}

// MARK: - SocketRocket delagate methods

/*extension StarscreamViewController: SRWebSocketDelegate {
    func webSocketDidOpen(_ webSocket: SRWebSocket) {
        if webSocket.readyState == .OPEN {
            print("Socket is connected")
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any) {
        if webSocket.readyState == .OPEN {
            print("Msg received: \(message)")
        }
    }
    
    func webSocket(_ webSocket: SRWebSocket, didFailWithError error: Error) {
        if webSocket.readyState == .CLOSED {
            print("Not closed")
        }
        print("Error Msg received: \(error)")
    }
    
    func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
        if webSocket.readyState == .CLOSED {
            print("------------------------------------Closed------------------------------------")
        }
    }
}*/
// MARK: - Websocket event delegate

extension StarscreamViewController: WebSocketEventDelegate {
    func webSocketDidViabilityChange(isViable: Bool) {
        print("webSocketDidViabilityChange: \(isViable)")
    }
    
    func webSocketShouldReconnect() {
        print("Reconnect!")
    }
    
    func webSocketPeerClosed() {
        print("Peer closed connection!")
        print("ReadyState: \(starscream.readyState)")
    }
    
    
}

enum WebsocketType {
    case starscream
    case socketRocket
}




