//
//  BaseApiService.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/18/22.
//

import Alamofire
import RxRestClient

class BaseApiService {
    let client: RxRestClient

    init(client: RxRestClient) {
        self.client = client
    }
}
