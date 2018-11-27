# ATReadingBookSDK

#### 项目介绍
ATReadingBookSDK

#### 软件架构
支持armv7 armv7s arm64架构


#### 安装教程

1. pod 'ATReadingBookSDK', '~> 0.2.7'

#### 使用说明

1. **0.2.6版为thin framework **

   > 只包含ABCtimeReadingBookSDK.framework
   >
   > 需要配合TALVoiceEvalSDK.framework+SingSound.Bundle及自定义包装的ATVoiceEvalManager类在宿主工程中使用
   >
   > **所属分支:master**

2. **0.2.7版为fat framework **

   >  pod install 之后会同时安装ABCtimeReadingBookSDK.framework, ATVoiceEvalManager.framework到宿主工程中
   >
   > **所属分支:updateTAL_framework**

3. **ATVoiceEvalManager.framework说明**

   > 包含TALVoiceEvalSDK.framework+SingSound.Bundle及自定义包装的ATVoiceEvalManager类的custom framework
   >
   > ATVoiceEvalManager.framework仓库链接:https://gitee.com/CaptainSpaino/ATVoiceEvalManager.git

