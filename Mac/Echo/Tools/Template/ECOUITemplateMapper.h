//
//  ECOUITemplateMapper.h
//  Echo
//
//  Created by 陈爱彬 on 2019/7/31. Maintain by 陈爱彬
//  Description 
//

#ifndef ECOUITemplateMapper_h
#define ECOUITemplateMapper_h

#import <Foundation/Foundation.h>
#import <EchoSDK/ECOBasePlugin.h>

//UI模板和ViewController的映射表
static inline NSString *ECOViewControllerFromTemplateType(NSString *type) {
    if ([type isEqualToString:ECOUITemplateType_ListDetail]) {
        return @"ECOTemplateListDetailViewController";
    }else if ([type isEqualToString:ECOUITemplateType_Outline]) {
        return @"ECOTemplateOutlineViewController";
    }else if ([type isEqualToString:ECOUITemplateType_H5]) {
        return @"ECOTemplateH5ViewController";
    }else if ([type isEqualToString:ECOUITemplateType_Network]) {
        return @"ECONetworkViewController";
    }else if ([type isEqualToString:@"beatlesH5"]) {
        return @"ECOBeatlesH5ViewController";
    }else if ([type isEqualToString:@"viewHierarchy"]) {
        return @"ECOViewHierarchyViewController";
    }
    
    return @"";
}

//插件和icon的映射表
static inline NSString *ECOPluginDefaultIconFromTemplateType(NSString *type) {
    if ([type isEqualToString:ECOUITemplateType_ListDetail]) {
        return @"plugin_icon_default";
    }else if ([type isEqualToString:ECOUITemplateType_Outline]) {
        return @"plugin_icon_default";
    }else if ([type isEqualToString:ECOUITemplateType_H5]) {
        return @"plugin_icon_default";
    }else if ([type isEqualToString:ECOUITemplateType_Network]) {
        return @"plugin_network_default";
    }
    return @"plugin_icon_default";
}


//插件和icon的映射表
static inline NSString *ECOPluginSelectedIconFromTemplateType(NSString *type) {
    if ([type isEqualToString:ECOUITemplateType_ListDetail]) {
        return @"plugin_icon_selected";
    }else if ([type isEqualToString:ECOUITemplateType_Outline]) {
        return @"plugin_icon_selected";
    }else if ([type isEqualToString:ECOUITemplateType_H5]) {
        return @"plugin_icon_selected";
    }else if ([type isEqualToString:ECOUITemplateType_Network]) {
        return @"plugin_network_selected";
    }
    return @"plugin_icon_selected";
}

#endif /* ECOUITemplateMapper_h */
