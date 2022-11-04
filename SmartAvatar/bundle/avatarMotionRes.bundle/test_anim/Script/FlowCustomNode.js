/*** light-js-config
***/
/**
 * 用于判断节点Slot是数据/事件
 */
var EVENT_SLOT = -1;
var DATA_SLOT = 0;

function FlowNode() { }

/**
 * 与Event Input一致的函数名，prototype上会挂entityManager/eventManager/scriptSystem三个属性
 */
FlowNode.prototype.Run = function () {
    // 下面示例为间隔n秒显示隐藏/隐藏带pag组件的对象的功能
    var lastTriggerTime;
    const eventKey = 'event.script.lightsdk.CustomEventPlayAnim'
    light.on('UpdateInputEvent',params=>{
        const jsonData = params[eventKey];
        if (jsonData !== undefined && jsonData !== null){
            var animID = jsonData["animID"];
            console.error("<<<<<<<<<<<<paddyjiang-test-js:animID=" + animID + ">>>>>>>>>>>>>>")
            if (animID === 'test001'){
                this.Next();
            } else if (animID === 'test002'){
                this.Next2();

            } else {

            }
        }
        // var entity = this.entityManager.getEntityById(this.entityId);
        // if(entity){
        //     let pag = entity.getComponent(light.PAGAsset);
        //     if(pag){
        //         if(lastTriggerTime === undefined || time - lastTriggerTime > this.time){
        //             pag.enabled = !pag.enabled;
        //             lastTriggerTime = time;
        //             this.currentTime += 1;
        //             this.Next();
        //         }
        //     }
        // }
    })
}

/**
 * 与Event Output一致的函数名，一般设置为如下空函数即可
 */
FlowNode.prototype.Next = function () { }
FlowNode.prototype.Next2 = function () { }

FlowNode.definition = {
    meta: { /** TODO: meta对象下的属性需更改，避免冲突 */
        title: '自定义节点', 
        nodeType: 'code/customNode',
        category: '自定义',
        description: '自定义节点功能描述',
        group: 'ObjectDisplaySetting',
    },

    properties: [ //节点自有属性
        {
            label: '对象选择',
            type: 'entity',
            componentType: ['PAGAsset'],
            name: 'entityId'
        }
    ],
    outputs: [
        {
            slotType: EVENT_SLOT,
            name: 'Next',
            label: 'Next'
        },
        {
            slotType: EVENT_SLOT,
            name: 'Next2',
            label: 'Next2'
        },
        {
            slotType: DATA_SLOT,
            name: 'currentTime',
            label: '当前触发次数',
            type: 'number',
            defaultValue: 0
        }
    ],
    inputs: [
        {
            slotType: EVENT_SLOT,
            name: 'Run',
            label: 'Run',
        },
        {
            slotType: DATA_SLOT,
            name: 'time',
            label: '输入值',
            type: 'number'
        }
    ]
}

light.FlowNodeClasses = light.FlowNodeClasses || [];
light.FlowNodeClasses.push(FlowNode)