//
//  FirebaseRepository.swift
//  Bappy
//
//  Created by 정동천 on 2022/06/28.
//

import Foundation
import FirebaseAuth
import RxSwift

protocol FirebaseRepository {
    static var shared: Self { get }
    var isUserSignedIn: BehaviorSubject<Bool> { get }
    var isAnonymous: BehaviorSubject<Bool> { get }
    var token: BehaviorSubject<String?> { get }
    
    func getIDTokenForcingRefresh() -> Observable<Result<String?, Error>>
    func signIn(with credential: AuthCredential) -> Single<Result<AuthDataResult?, Error>>
    func signInAnonymously() -> Single<Result<AuthDataResult?, Error>>
    func signOut() -> Single<Result<Void, Error>>
}