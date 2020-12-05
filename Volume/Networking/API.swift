// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class GetHomeArticlesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetHomeArticles($since: String!) {
      trending: getTrendingArticles(since: $since) {
        __typename
        id
        articleURL
        date
        title
        imageURL
        shoutouts
      }
      following: getArticlesByPublication(publicationID: "5fcd4d4953db0000138e03c9") {
        __typename
        id
        articleURL
        date
        title
        imageURL
        shoutouts
      }
      other: getArticlesByPublication(publicationID: "5fcd4d4953db0000138e03cc") {
        __typename
        id
        articleURL
        date
        title
        imageURL
        shoutouts
      }
    }
    """

  public let operationName: String = "GetHomeArticles"

  public var since: String

  public init(since: String) {
    self.since = since
  }

  public var variables: GraphQLMap? {
    return ["since": since]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTrendingArticles", alias: "trending", arguments: ["since": GraphQLVariable("since")], type: .nonNull(.list(.nonNull(.object(Trending.selections))))),
        GraphQLField("getArticlesByPublication", alias: "following", arguments: ["publicationID": "5fcd4d4953db0000138e03c9"], type: .nonNull(.list(.nonNull(.object(Following.selections))))),
        GraphQLField("getArticlesByPublication", alias: "other", arguments: ["publicationID": "5fcd4d4953db0000138e03cc"], type: .nonNull(.list(.nonNull(.object(Other.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(trending: [Trending], following: [Following], other: [Other]) {
      self.init(unsafeResultMap: ["__typename": "Query", "trending": trending.map { (value: Trending) -> ResultMap in value.resultMap }, "following": following.map { (value: Following) -> ResultMap in value.resultMap }, "other": other.map { (value: Other) -> ResultMap in value.resultMap }])
    }

    public var trending: [Trending] {
      get {
        return (resultMap["trending"] as! [ResultMap]).map { (value: ResultMap) -> Trending in Trending(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Trending) -> ResultMap in value.resultMap }, forKey: "trending")
      }
    }

    public var following: [Following] {
      get {
        return (resultMap["following"] as! [ResultMap]).map { (value: ResultMap) -> Following in Following(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Following) -> ResultMap in value.resultMap }, forKey: "following")
      }
    }

    public var other: [Other] {
      get {
        return (resultMap["other"] as! [ResultMap]).map { (value: ResultMap) -> Other in Other(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Other) -> ResultMap in value.resultMap }, forKey: "other")
      }
    }

    public struct Trending: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Article"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("articleURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("shoutouts", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, articleUrl: String, date: String, title: String, imageUrl: String, shoutouts: Double) {
        self.init(unsafeResultMap: ["__typename": "Article", "id": id, "articleURL": articleUrl, "date": date, "title": title, "imageURL": imageUrl, "shoutouts": shoutouts])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var articleUrl: String {
        get {
          return resultMap["articleURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "articleURL")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var shoutouts: Double {
        get {
          return resultMap["shoutouts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "shoutouts")
        }
      }
    }

    public struct Following: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Article"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("articleURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("shoutouts", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, articleUrl: String, date: String, title: String, imageUrl: String, shoutouts: Double) {
        self.init(unsafeResultMap: ["__typename": "Article", "id": id, "articleURL": articleUrl, "date": date, "title": title, "imageURL": imageUrl, "shoutouts": shoutouts])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var articleUrl: String {
        get {
          return resultMap["articleURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "articleURL")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var shoutouts: Double {
        get {
          return resultMap["shoutouts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "shoutouts")
        }
      }
    }

    public struct Other: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Article"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("articleURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("shoutouts", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, articleUrl: String, date: String, title: String, imageUrl: String, shoutouts: Double) {
        self.init(unsafeResultMap: ["__typename": "Article", "id": id, "articleURL": articleUrl, "date": date, "title": title, "imageURL": imageUrl, "shoutouts": shoutouts])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var articleUrl: String {
        get {
          return resultMap["articleURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "articleURL")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var shoutouts: Double {
        get {
          return resultMap["shoutouts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "shoutouts")
        }
      }
    }
  }
}

public final class GetArticleByIdQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetArticleByID($id: String!) {
      article: getArticleByID(id: $id) {
        __typename
        id
        articleURL
        date
        title
        imageURL
        shoutouts
      }
    }
    """

  public let operationName: String = "GetArticleByID"

  public var id: String

  public init(id: String) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getArticleByID", alias: "article", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.object(Article.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(article: Article) {
      self.init(unsafeResultMap: ["__typename": "Query", "article": article.resultMap])
    }

    public var article: Article {
      get {
        return Article(unsafeResultMap: resultMap["article"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "article")
      }
    }

    public struct Article: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Article"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("articleURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("date", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("shoutouts", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, articleUrl: String, date: String, title: String, imageUrl: String, shoutouts: Double) {
        self.init(unsafeResultMap: ["__typename": "Article", "id": id, "articleURL": articleUrl, "date": date, "title": title, "imageURL": imageUrl, "shoutouts": shoutouts])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var articleUrl: String {
        get {
          return resultMap["articleURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "articleURL")
        }
      }

      public var date: String {
        get {
          return resultMap["date"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "date")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var shoutouts: Double {
        get {
          return resultMap["shoutouts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "shoutouts")
        }
      }
    }
  }
}

public final class GetAllPublicationsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query GetAllPublications {
      publications: getAllPublications {
        __typename
        id
        bio
        name
        shoutouts
        imageURL
        websiteURL
      }
    }
    """

  public let operationName: String = "GetAllPublications"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getAllPublications", alias: "publications", type: .nonNull(.list(.nonNull(.object(Publication.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(publications: [Publication]) {
      self.init(unsafeResultMap: ["__typename": "Query", "publications": publications.map { (value: Publication) -> ResultMap in value.resultMap }])
    }

    public var publications: [Publication] {
      get {
        return (resultMap["publications"] as! [ResultMap]).map { (value: ResultMap) -> Publication in Publication(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Publication) -> ResultMap in value.resultMap }, forKey: "publications")
      }
    }

    public struct Publication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Publication"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("bio", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("shoutouts", type: .nonNull(.scalar(Double.self))),
          GraphQLField("imageURL", type: .nonNull(.scalar(String.self))),
          GraphQLField("websiteURL", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, bio: String, name: String, shoutouts: Double, imageUrl: String, websiteUrl: String) {
        self.init(unsafeResultMap: ["__typename": "Publication", "id": id, "bio": bio, "name": name, "shoutouts": shoutouts, "imageURL": imageUrl, "websiteURL": websiteUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var bio: String {
        get {
          return resultMap["bio"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var shoutouts: Double {
        get {
          return resultMap["shoutouts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "shoutouts")
        }
      }

      public var imageUrl: String {
        get {
          return resultMap["imageURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageURL")
        }
      }

      public var websiteUrl: String {
        get {
          return resultMap["websiteURL"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "websiteURL")
        }
      }
    }
  }
}
