// swiftlint:disable all
import Amplify
import Foundation

public struct Post: Model {
  public let id: String
  public var imageKey: String
  public var itemType: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      imageKey: String,
      itemType: String) {
    self.init(id: id,
      imageKey: imageKey,
      itemType: itemType,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      imageKey: String,
      itemType: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.imageKey = imageKey
      self.itemType = itemType
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}