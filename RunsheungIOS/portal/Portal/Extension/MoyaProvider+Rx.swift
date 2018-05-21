//
//  MoyaProvider+Rx.swift
//  Portal
//
//  Created by 이정구 on 2018/5/21.
//  Copyright © 2018年 linpeng. All rights reserved.
//

import Foundation
import Moya
import RxSwift

extension MoyaProvider: ReactiveCompatible {}

public extension Reactive where Base: MoyaProviderType {
    
    public func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create(subscribe: { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil, completion: { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            })
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        })
    }
    
    public func requestWithProgress(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Observable<ProgressResponse> {
        let progressBlock: (AnyObserver) -> (ProgressResponse) -> Void = { observer in
            return { progress in
                observer.onNext(progress)
            }
        }
        
        let response: Observable<ProgressResponse> = Observable.create { [weak base] observer in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: progressBlock(observer), completion: { result in
                switch result {
                case .success:
                    observer.onCompleted()
                case let .failure(error):
                    observer.onError(error)
                }
            })
            
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
        
        return response.scan(ProgressResponse(), accumulator: { last, progress in
            let progressObject = progress.progressObject ?? last.progressObject
            let response = progress.response ?? last.response
            return ProgressResponse(progress: progressObject, response: response)
        })
    }
    
}
