//
//  AccountsList+DependencyValues.swift
//  AccountsListTCA
//
//  Created by Ilya Yushkov on 24.08.2025.
//

import ComposableArchitecture

extension DependencyValues {
    enum TransparentAccountConverterDependencyKey: DependencyKey {
        static var liveValue: any TransparentAccountConverter {
            TransparentAccountConverterImp()
        }
    }

    var transparentAccountConverter: TransparentAccountConverter {
        get { self[TransparentAccountConverterDependencyKey.self] }
        set { self[TransparentAccountConverterDependencyKey.self] = newValue }
    }
}
