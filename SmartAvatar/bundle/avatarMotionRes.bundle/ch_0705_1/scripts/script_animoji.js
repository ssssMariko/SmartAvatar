/*** light-js-config
***/
// 加载 AEJSBridge.js
light.execute("light://js/AEJSBridge.js");

// 素材逻辑函数体
(function () {
    // 定义global对象
    var global = global || (function () {return this;}());
    // 定义素材对象
    var template = global.template || (function () {return {};}());
    // 并挂在global对象下
    global.template = template;
    // 定义需要用到的resource
    var resourcePool = {
    }
    // 也挂在global对象下
    global.resourcePool = resourcePool;
    // 素材初始化, 对应c++的configure
    template.onTemplateInit = function (entityManager, eventManager) {
        template.entityManager = entityManager;
        template.eventManager = eventManager;
        template.animoji_on = false;
        template.animoji_rdt = entityManager.getEntityByName("bool对象").getComponent(light.BasicTransform);
    }
    // 对应c++的update， 在ai分类信息回调之后
    template.onFrameUpdate = function (currentTime, entityManager, eventManager) {
        if(template.animoji_on == false) {
            if(template.animoji_rdt != null && template.animoji_rdt.objectEnabled == true) {
                template.animoji_on = true;
                // eventManager.emit(new light.AIRequireEvent("BG_SEG_AGENT","false", entityManager, eventManager));
                light._disableDefaultBeauty([BASIC_STRETCH, BASIC_LIQUIFY, BASIC_SMOOTH, BASIC_BEAUTY, BASIC_BODY, BASIC_LUT]);
            }
        }
        let pointInfoList = light.AIDataUtils.GetAIPointDataFromAIDataCenter(entityManager, "Face_Point");
        if (pointInfoList.size() != 0) {
            let pointInfo = pointInfoList.get(0);
            if (pointInfo.roll_ < 90 && pointInfo.roll_ > -90) {
               
                    eventManager.emit(new light.TipsEvent("", "", false, 0, 0, entityManager));
                
                return;
            }
        }
        eventManager.emit(new light.TipsEvent("请保持人脸正常出镜", "", true, 0, 0, entityManager));
    }
}()); 

light.dealloc = function () {
    // template.eventManager.emit(new light.AIRequireEvent("BG_SEG_AGENT","none", template.entityManager, template.eventManager));
    return "onUnload";
}