import Foundation

@objc(CallKitPlugin) class CallKitPlugin: CDVPlugin {
  
  private enum Keys {
    static let appName = "appName"
    static let icon = "icon"
    static let supportsVideo = "supportsVideo"
    static let title = "title"
    static let hasVideo = "hasVideo"
    static let uuid = "uuid"
    static let action = "action"
    static let reset = "reset"
    static let started = "started"
    static let connected = "connected"
    static let answered = "answered"
    static let ended = "ended"
  }
  
  private lazy var handler = CallsHandler()
  
  @objc(setup:)
  func setup(command: CDVInvokedUrlCommand) {
    guard let arguments = command.arguments.first as? [String: String] else {
      sendErrorCallback(for: command, info: "Invalid arguments \(command.arguments ?? [])")
      return
    }
    
    let appName = arguments[Keys.appName] ?? ""
    let iconBase64 = arguments[Keys.icon]
    let icon = image(with: iconBase64 ?? "")
    let supportsVideoString = arguments[Keys.supportsVideo]
    let supportsVideo = Bool(supportsVideoString?.lowercased() ?? "") ?? false
    
    handler.setup(
      appName: appName,
      icon: icon,
      ringtoneSound: "",
      supportsVideo: supportsVideo
    ) { [weak self] in
      self?.sendSuccessCallback(
        for: command,
        keepCallback: true,
        arguments: [Keys.action: Keys.reset]
      )
    }
    
    sendSuccessCallback(for: command, keepCallback: true)
  }
  
  @objc(startOutgoingCall:)
  func startOutgoingCall(command: CDVInvokedUrlCommand) {
    guard let arguments = command.arguments.first as? [String: String] else {
      sendErrorCallback(for: command, info: "Invalid arguments \(command.arguments ?? [])")
      return
    }
    
    let title = arguments[Keys.title] ?? ""
    
    handler.startOutgoingCall(
      title: title,
      onStarted: { [weak self] uuid in
        self?.sendSuccessCallback(
          for: command,
          keepCallback: true,
          arguments: [
            Keys.action: Keys.started,
            Keys.uuid: uuid.uuidString
          ]
        )
      },
      onEnded: { [weak self] uuid in
        self?.sendSuccessCallback(
          for: command,
          arguments: [
            Keys.action: Keys.ended,
            Keys.uuid: uuid.uuidString
          ]
        )
      },
      onError: { [weak self] error in
        self?.sendErrorCallback(
          for: command,
          info: error.localizedDescription
        )
      }
    )
  }
  
  @objc(connectOutgoingCall:)
  func connectOutgoingCall(command: CDVInvokedUrlCommand) {
    guard let arguments = command.arguments.first as? [String: String] else {
      sendErrorCallback(for: command, info: "Invalid arguments \(command.arguments ?? [])")
      return
    }
    
    guard let uuidString = arguments[Keys.uuid], let uuid = UUID(uuidString: uuidString) else {
      sendErrorCallback(for: command, info: "Invalid uuid \(arguments[Keys.uuid] ?? "null")")
      return
    }
    
    handler.connectOutgoingCall(uuid: uuid)
    
    sendSuccessCallback(
      for: command,
      arguments: [Keys.action : Keys.connected]
    )
  }
  
  @objc(endCall:)
  func endCall(command: CDVInvokedUrlCommand) {
    guard let arguments = command.arguments.first as? [String: String] else {
      sendErrorCallback(for: command, info: "Invalid arguments \(command.arguments ?? [])")
      return
    }
    
    guard let uuidString = arguments[Keys.uuid], let uuid = UUID(uuidString: uuidString) else {
      sendErrorCallback(for: command, info: "Invalid uuid \(arguments[Keys.uuid] ?? "null")")
      return
    }
    
    handler.endCall(
      uuid: uuid,
      onComplete: { [weak self] in
        self?.sendSuccessCallback(
          for: command,
          arguments: [Keys.action : Keys.ended]
        )
      },
      onError: { [weak self] error in
        self?.sendErrorCallback(
          for: command,
          info: error.localizedDescription
        )
      }
    )
  }
  
  @objc(handleIncomingCall:)
  func handleIncomingCall(command: CDVInvokedUrlCommand) {
    guard let arguments = command.arguments.first as? [String: String] else {
      sendErrorCallback(for: command, info: "Invalid arguments \(command.arguments ?? [])")
      return
    }
    
    let title = arguments[Keys.title] ?? ""
    let hasVideoString = arguments[Keys.hasVideo]
    let hasVideo = Bool(hasVideoString?.lowercased() ?? "") ?? false
    
    handler.handleIncomingCall(
      title: title,
      hasVideo: hasVideo,
      onAnswered: { [weak self] uuid in
        self?.sendSuccessCallback(
          for: command,
          keepCallback: true,
          arguments: [
            Keys.action: Keys.answered,
            Keys.uuid: uuid.uuidString
          ]
        )
      },
      onEnded: { [weak self] uuid in
        self?.sendSuccessCallback(
          for: command,
          arguments: [
            Keys.action: Keys.ended,
            Keys.uuid: uuid.uuidString
          ]
        )
      },
      onError: { [weak self] error in
        self?.sendErrorCallback(
          for: command,
          info: error.localizedDescription
        )
      }
    )
  }
  
  // MARK: - Private
  
  private func image(with base64: String) -> UIImage? {
    guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters) else { return nil }
    return UIImage(data: data)
  }
  
  private func sendSuccessCallback(
    for command: CDVInvokedUrlCommand,
    keepCallback: Bool = false,
    arguments: [String: String] = [:]
  ) {
    let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: arguments)
    result?.keepCallback = keepCallback as NSNumber
    commandDelegate.send(result, callbackId: command.callbackId)
  }
  
  private func sendErrorCallback(for command: CDVInvokedUrlCommand, info: String = "") {
    commandDelegate.send(
      CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: info),
      callbackId: command.callbackId
    )
  }
}
