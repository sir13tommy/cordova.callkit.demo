import Foundation
import CallKit
import UIKit

class CallsHandler: NSObject {
  
  private var provider: CXProvider?
  private let controller = CXCallController()
  
  private var onCallEnded: ((UUID) -> Void)?
  private var onCallAnswered: ((UUID) -> Void)?
  private var onReset: (() -> Void)?
  
  func setup(
    appName: String,
    icon: UIImage? = nil,
    ringtoneSound: String? = nil,
    supportsVideo: Bool = false,
    onReset: @escaping () -> Void
  ) {
    let config = CXProviderConfiguration(localizedName: appName)
    config.includesCallsInRecents = false;
    config.iconTemplateImageData = icon?.pngData()
    config.ringtoneSound = ringtoneSound
    config.supportsVideo = supportsVideo
    config.maximumCallsPerCallGroup = 1
    config.maximumCallGroups = 1
    
    let provider = CXProvider(configuration: config)
    provider.setDelegate(self, queue: nil)
    self.provider = provider
    self.onReset = onReset
  }
  
  func startOutgoingCall(
    title: String,
    onStarted: @escaping (UUID) -> Void,
    onEnded: @escaping (UUID) -> Void,
    onError: @escaping (Error) -> Void
  ) {
    let callUUID = UUID()
    let transaction = CXTransaction(
      action: CXStartCallAction(
        call: callUUID,
        handle: CXHandle(type: .generic, value: title)
      )
    )
    controller.request(transaction) { [weak self] error in
      if let error = error {
        onError(error)
      } else {
        self?.onCallEnded = onEnded
        onStarted(callUUID)
      }
    }
  }
  
  func connectOutgoingCall(uuid: UUID) {
    provider?.reportOutgoingCall(with: uuid, connectedAt: nil)
  }
  
  func endCall(
    uuid: UUID,
    onComplete: @escaping () -> Void,
    onError: @escaping (Error) -> Void
  ) {
    let transaction = CXTransaction(
      action: CXEndCallAction(call: uuid)
    )
    controller.request(transaction) { error in
      if let error = error {
        onError(error)
      } else {
        onComplete()
      }
    }
  }
  
  func handleIncomingCall(
    title: String,
    hasVideo: Bool = false,
    onAnswered: @escaping (UUID) -> Void,
    onEnded: @escaping (UUID) -> Void,
    onError: @escaping (Error) -> Void
  ) {
    let update = CXCallUpdate()
    update.remoteHandle = CXHandle(type: .generic, value: title)
    update.hasVideo = hasVideo
    let callUUID = UUID()
    provider?.reportNewIncomingCall(with: callUUID, update: update) { [weak self] error in
      if let error = error {
        onError(error)
      } else {
        self?.onCallEnded = onEnded
        self?.onCallAnswered = onAnswered
      }
    }
  }
}

extension CallsHandler: CXProviderDelegate {
  func providerDidReset(_ provider: CXProvider) {
    onReset?()
  }
  
  func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
    onCallEnded?(action.callUUID)
    action.fulfill()
  }
  
  func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
    onCallAnswered?(action.callUUID)
    action.fulfill()
  }
}
