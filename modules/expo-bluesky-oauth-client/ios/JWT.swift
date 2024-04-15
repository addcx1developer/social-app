import ExpoModulesCore
import JOSESwift

struct JWTHeader : Record {
  @Field
  var alg: String = "ES256"
  @Field
  var jku: String?
  @Field
  var jwk: JWK
  @Field
  var kid: String?
  @Field
  var typ: String?
  @Field
  var cty: String?
  @Field
  var crit: String?
  
  func toField() -> Field<JWTHeader> {
    return Field(wrappedValue: self)
  }
  
  func toJWSHeader() throws -> JWSHeader? {
    return JWSHeader(try JSONSerialization.data(withJSONObject: self.toDictionary()))
  }
}

struct JWTPayload : Record {
  @Field
  var iss: String?
  @Field
  var aud: String?
  @Field
  var sub: String?
  @Field
  var exp: Int?
  @Field
  var nbr: Int?
  @Field
  var iat: Int?
  @Field
  var jti: String?
  @Field
  var htm: String?
  @Field
  var htu: String?
  @Field
  var ath: String?
  @Field
  var acr: String?
  @Field
  var azp: String?
  @Field
  var amr: String?
  @Field
  var cnf: JWTPayloadCNF?
  @Field
  var client_id: String?
  @Field
  var scope: String?
  @Field
  var nonce: String?
  @Field
  var at_hash: String?
  @Field
  var c_hash: String?
  @Field
  var s_hash: String?
  @Field
  var auth_time: Int?
  @Field
  var name: String?
  @Field
  var family_name: String?
  @Field
  var given_name: String?
  @Field
  var middle_name: String?
  @Field
  var nickname: String?
  @Field
  var preferred_username: String?
  @Field
  var gender: String?
  @Field
  var picture: String?
  @Field
  var profile: String?
  @Field
  var website: String?
  @Field
  var birthdate: String?
  @Field
  var zoneinfo: String?
  @Field
  var locale: String?
  @Field
  var updated_at: Int?
  @Field
  var email: String?
  @Field
  var email_verified: String?
  @Field
  var phone_number: String?
  @Field
  var phone_number_verified: Bool?
  @Field
  var address: JWTPayloadAddress?
  @Field
  var authorization_details: JWTPayloadAuthorizationDetails?
  
  func toField() -> Field<JWTPayload> {
    return Field(wrappedValue: self)
  }
  
  func toPayload() throws -> Payload {
    return Payload(try JSONSerialization.data(withJSONObject: self.toDictionary()))
  }
}

struct JWTPayloadCNF : Record {
  @Field
  var kid: String?
  @Field
  var jwk: JWK?
  @Field
  var jwe: String?
  @Field
  var jku: String?
  @Field
  var jkt: String?
  @Field
  var osc: String?
  
  func toField() -> Field<JWTPayloadCNF> {
    return Field(wrappedValue: self)
  }
}

struct JWTPayloadAddress : Record {
  @Field
  var formatted: String?
  @Field
  var street_address: String?
  @Field
  var locality: String?
  @Field
  var region: String?
  @Field
  var postal_code: String?
  @Field
  var country: String?
  
  func toField() -> Field<JWTPayloadAddress> {
    return Field(wrappedValue: self)
  }
}

struct JWTPayloadAuthorizationDetails : Record {
  @Field
  var type: String
  @Field
  var locations: [String]?
  @Field
  var actions: [String]?
  @Field
  var datatypes: [String]?
  @Field
  var identifier: String?
  @Field
  var privileges: [String]?
  
  func toField() -> Field<JWTPayloadAuthorizationDetails> {
    return Field(wrappedValue: self)
  }
}

struct JWTVerifyResponse : Record {
  @Field
  var protectedHeader: JWTHeader
  @Field
  var payload: String
}