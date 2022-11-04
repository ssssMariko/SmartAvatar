/*** light-js-config
***/

let sign = true;

light.update = function (deltaTime, entityManager, eventManager) {
	let head_base_entity = entityManager.getEntityByName("head_base");
	let head_base_transform = head_base_entity.getComponent("BasicTransform");
	let head_base_face3DComponent = head_base_entity.getComponent("Face3DComponent");

	let left_eyes_base_transform = entityManager.getEntityByName("base_left_eyeball").getComponent("BasicTransform");
	let left_eyes_transform = entityManager.getEntityByName("left_eyeball").getComponent("BasicTransform");
	let right_eyes_base_transform = entityManager.getEntityByName("base_right_eyeball").getComponent("BasicTransform");
	let right_eyes_transform = entityManager.getEntityByName("right_eyeball").getComponent("BasicTransform");
	let neck_transform = entityManager.getEntityByName("neck").getComponent("BasicTransform");
	let head_transform = entityManager.getEntityByName("avatar_v2.0_0811_3(prefab)").getComponent("BasicTransform");

	let head_bone_transform = entityManager.getEntityByName("Bone.head").getComponent("BasicTransform");

	let plane_transform = entityManager.getEntityByName("plane").getComponent("BasicTransform");

	head_bone_transform.SetRotation(head_base_transform.rotation);
	left_eyes_transform.SetRotation(left_eyes_base_transform.rotation);
	right_eyes_transform.SetRotation(right_eyes_base_transform.rotation);

  let pointInfoList = light.AIDataUtils.GetAIPointDataFromAIDataCenter(entityManager, "Face_Point");
  //显示真实背景
	if(plane_transform.enabled == false || plane_transform.objectEnabled == false){
		//隐藏脖子
		neck_transform.visible = false;
		//如果人脸未出镜，则隐藏头模。否则显示头模
		if (pointInfoList.size() != 0) {
			head_transform.visible = true;
		}else{
			head_transform.visible = false;
		}
		  //还要跟踪position属性
		var head_base_pos = head_base_transform.position;
		head_base_pos.y += 0.14;
		head_bone_transform.SetPosition(head_base_pos);

		var head_pos = head_transform.position;
    head_pos.y = -0.004775221;
    head_transform.SetPosition(head_pos);
    var head_scale = head_transform.scale;
    head_scale.x = 1.0;
    head_scale.y = 1.0;
    head_scale.z = 1.0;
    head_transform.SetScale(head_scale);

    //人头绕X轴旋转几度，因为正常拿手机时，手机不是完全竖直的，头套会显得是仰着头的
    var head_rotation = head_transform.rotation;
    //朝真人方向转5度，这个数值不能直接填5，具体怎么算的，要看js_binding_internal_components.h里面static Quat euler方法
    //或者在studio中调5度，保存一下，看template.json里面转换好的数值
    head_rotation.x = 0.043619;
    head_transform.SetRotation(head_rotation);

		//开启3D人头遮挡
		head_base_face3DComponent.showUserHead = true;
	}else{
	  //显示虚拟背景，人头和脖子始终出现
		head_transform.visible = true;
		neck_transform.visible = true;
	  //还原成默认坐标
    var animoj_boy_pos = head_bone_transform.position;
    animoj_boy_pos.x = 0;
    animoj_boy_pos.y = 0.096411578;
    animoj_boy_pos.z = -1e-9;
    head_bone_transform.SetPosition(animoj_boy_pos);

    var head_pos = head_transform.position;
    head_pos.y = -0.104775221;
    head_transform.SetPosition(head_pos);
    var head_scale = head_transform.scale;
    head_scale.x = 1.2;
    head_scale.y = 1.2;
    head_scale.z = 1.2;
    head_transform.SetScale(head_scale);
    //不需要人头遮挡
	  head_base_face3DComponent.showUserHead = false;

	  //人头旋转归位
	  var head_rotation = head_transform.rotation;
    head_rotation.x = 0;
    head_transform.SetRotation(head_rotation);

	  //没有检测到人脸时，让人头的rotation归位
	  if (pointInfoList.size() == 0) {
	    var head_rotation = head_bone_transform.rotation;
	    head_rotation.x = 0;
	    head_rotation.y = 0;
	    head_rotation.z = 0;
	    head_bone_transform.SetRotation(head_rotation);
	  }
	}
	return;
}

