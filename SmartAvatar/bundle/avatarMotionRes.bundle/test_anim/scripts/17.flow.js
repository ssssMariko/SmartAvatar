/*** light-js-config
//@requireAbility
***/
/* 该脚本流程面板生成 */
// 开始 Flow 生成代码
light.on('start',function (entityManager, eventManager, scriptSystem) {
   var context = new light.NodeContext(entityManager, eventManager, scriptSystem);
   // 实例化
   let code_Start_1 = context.create("code/Start");
   code_Start_1.id = "1";
   let code_AnimationNode_2 = context.create("code/AnimationNode");
   code_AnimationNode_2.id = "2";
   let code_customNode_6 = context.create("code/customNode");
   code_customNode_6.id = "6";
   let code_AnimationNode_7 = context.create("code/AnimationNode");
   code_AnimationNode_7.id = "7";
   let code_AnimationNode_9 = context.create("code/AnimationNode");
   code_AnimationNode_9.id = "9";
   // 属性赋值
   code_AnimationNode_2.entityId = 95;
   code_AnimationNode_2.clipIndex = 0;
   code_AnimationNode_2.loopCount = -1;
   code_AnimationNode_2.progress = 0;
   code_AnimationNode_2.isPlayTogether = false;
   code_customNode_6.time = "";
   code_AnimationNode_7.entityId = 95;
   code_AnimationNode_7.clipIndex = 3;
   code_AnimationNode_7.loopCount = -1;
   code_AnimationNode_7.progress = 0;
   code_AnimationNode_7.isPlayTogether = false;
   code_AnimationNode_9.clipIndex = 0;
   code_AnimationNode_9.loopCount = 0;
   code_AnimationNode_9.progress = 0;
   code_AnimationNode_9.isPlayTogether = false;
   // 数据连接
   // 事件连接
   context.connectEvent(code_customNode_6, "Next", code_AnimationNode_2, "Play")
   context.connectEvent(code_Start_1, "Run", code_customNode_6, "Run")
   context.connectEvent(code_customNode_6, "Next2", code_AnimationNode_7, "Play")
   code_Start_1.Run();
});