//
//  Plugins.swift
//  Tenant
//
//  Created by liuhongli on 2024/4/4.
//

import Foundation
import Moya

#if DEBUG
public let plugins_phone: [PluginType] = [LoggerPlugin, FilterPlugin(), ErrorHandlerPlugin()]
#else
public let plugins_phone: [PluginType] = [FilterPlugin(), ErrorHandlerPlugin()]
#endif


