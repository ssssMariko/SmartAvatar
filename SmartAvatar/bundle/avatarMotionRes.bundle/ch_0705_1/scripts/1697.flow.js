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
   // 属性赋值
   code_AnimationNode_2.entityId = 1697;
   code_AnimationNode_2.clipIndex = 2;
   code_AnimationNode_2.loopCount = -1;
   code_AnimationNode_2.progress = 0;
   code_AnimationNode_2.isPlayTogether = false;
   // 数据连接
   // 事件连接
   context.connectEvent(code_Start_1, "Run", code_AnimationNode_2, "Play")
   code_Start_1.Run();
});