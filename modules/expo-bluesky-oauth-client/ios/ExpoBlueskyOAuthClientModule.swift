import ExpoModulesCore
import JOSESwift

public class ExpoBlueskyOAuthClientModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoBlueskyOAuthClient")

    AsyncFunction("digest") { (data: Data, promise: Promise) in
      promise.resolve(CryptoUtil.digest(data: data))
    }

    // We are going to leave this as sync to line up the APIs. It's fast, so not a big deal.
    Function("getRandomValues") { (byteLength: Int) in
      return CryptoUtil.getRandomValues(byteLength: byteLength)
    }

    AsyncFunction ("generateJwk") { (algo: String?, promise: Promise) in
      if algo != "ES256" {
        promise.reject("GenerateKeyError", "Algorithim not supported.")
        return
      }
      
      let keypair = try? CryptoUtil.generateKeyPair()

      guard keypair != nil else {
        promise.reject("GenerateKeyError", "Error generating JWK.")
        return
      }

      promise.resolve(keypair)
    }

    AsyncFunction("createJwt") { (header: JWTHeader, payload: JWTPayload, jwk: JWK, promise: Promise) in
      guard let jwt = JWTUtil.createJwt(header: header, payload: payload, jwk: jwk) else {
        promise.reject("JWTError", "Error creating JWT.")
        return
      }
      promise.resolve(jwt)
    }

    AsyncFunction("verifyJwt") { (token: String, jwk: JWK, promise: Promise) in
      promise.resolve(JWTUtil.verifyJwt(token: token, jwk: jwk))
    }
  }
}