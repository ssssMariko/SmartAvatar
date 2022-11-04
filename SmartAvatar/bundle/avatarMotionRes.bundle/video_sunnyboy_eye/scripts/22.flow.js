/*** light-js-config
***/
/* 该脚本流程面板生成 */
// 开始 Flow 生成代码
light.on('start',function (entityManager, eventManager, scriptSystem) {
   var context = new light.NodeContext(entityManager, eventManager, scriptSystem);
   // 实例化
   let code_SwitchObject_14 = context.create("code/SwitchObject");
   let code_SwitchObject_12 = context.create("code/SwitchObject");
   let code_Random_8 = context.create("code/Random");
   let code_SwitchObject_18 = context.create("code/SwitchObject");
   let code_Delay_17 = context.create("code/Delay");
   let code_SwitchObject_16 = context.create("code/SwitchObject");
   let code_Random_7 = context.create("code/Random");
   let code_SwitchObject_20 = context.create("code/SwitchObject");
   let code_SwitchObject_21 = context.create("code/SwitchObject");
   let code_Start_1 = context.create("code/Start");
   let code_SwitchObject_2 = context.create("code/SwitchObject");
   let code_SwitchObject_15 = context.create("code/SwitchObject");
   let code_Delay_19 = context.create("code/Delay");
   // 属性赋值
   code_SwitchObject_14.entityToDisplay = [379];
   code_SwitchObject_14.entityToHide = [101];
   code_SwitchObject_12.entityToDisplay = [101];
   code_SwitchObject_12.entityToHide = [379];
   code_Random_8.entityToDisplay = [57,18];
   code_Random_8.entityToHide = [];
   code_SwitchObject_18.entityToDisplay = [];
   code_SwitchObject_18.entityToHide = [81];
   code_Delay_17.duration = 450000;
   code_SwitchObject_16.entityToDisplay = [81,29];
   code_SwitchObject_16.entityToHide = [30];
   code_Random_7.entityToDisplay = [21,65];
   code_Random_7.entityToHide = [];
   code_SwitchObject_20.entityToDisplay = [];
   code_SwitchObject_20.entityToHide = [57,18,21,65];
   code_SwitchObject_21.entityToDisplay = [];
   code_SwitchObject_21.entityToHide = [57,18,21,65];
   code_SwitchObject_2.entityToDisplay = [20,30];
   code_SwitchObject_2.entityToHide = [101,379,57,18,21,65,81,29,25,39];
   code_SwitchObject_15.entityToDisplay = [25,39];
   code_SwitchObject_15.entityToHide = [20];
   code_Delay_19.duration = 156000;
   // 数据连接
   // 事件连接
   context.connectEvent(code_Delay_19, "Next", code_SwitchObject_12, "Run")
   context.connectEvent(code_SwitchObject_21, "Next", code_Random_8, "Run")
   context.connectEvent(code_Delay_17, "Next", code_SwitchObject_18, "Run")
   context.connectEvent(code_SwitchObject_16, "Next", code_Delay_17, "Run")
   context.connectEvent(code_SwitchObject_20, "Next", code_Random_7, "Run")
   context.connectEvent(code_Start_1, "Run", code_SwitchObject_2, "Run")
   context.connectEvent(code_Delay_19, "Next", code_SwitchObject_15, "Run")
   context.connectEvent(code_SwitchObject_2, "Next", code_Delay_19, "Run")
   code_Start_1.Run();
});