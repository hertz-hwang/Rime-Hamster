# 🐯 Rime『胖虎』输入方案

## 简介

『胖虎』输入方案是一个基于 [Rime 输入法](https://rime.im/) 编写的强大中文输入解决方案，它结合了虎码的高效编码和语言模型技术，为用户提供快速、智能、多功能的输入体验。

## ✨ 特色功能

* 🤖 集成 AMZ 智能语言模型，支持高精度自动分词的虎单整句输入
* 🎯 支持五二顶功、五三顶功等高效输入模式
* 🌏 多语言无缝切换（中文、英文、日文）
* 🛠️ 强大的辅助工具（计算器、翻译、时间日期等）
* 🎨 优雅的、功能高度耦合的移动端键盘（[Hamster 输入法](https://github.com/imfuxiao/Hamster)）

## 📦 安装要求

### 必需组件

* [Rime 输入法](https://rime.im/)（请根据操作系统选择对应版本）
* [AMZ 语言模型](https://huggingface.co/hertz-hwang/amz-v1-5-zh-hans/)

### 可选组件

* [专用字体包](https://github.com/rimeinn/rime-tiger/releases/download/Fonts/Fonts.zip)（提供更好的显示效果）

## 📂 目录结构

```
Rime用户目录/
├── Fonts                  # 字体文件（可选）
├── dicts                  # 词库文件（包含核心词库和扩展词库）
├── lua                    # lua脚本（实现特殊功能）
├── opencc                 # opencc配置
├── README.md       
├── amz-v1-5-zh-hans.gram  # AMZ语言模型（必需）
└── ...
```

## 🚀 核心功能详解

### 1. 智能输入系统

#### 1.1 顶功系统

* **五二顶**：

  * 在第五码时自动顶出第一、二码对应的字
  * 大幅提高输入效率，减少击键次数
  * 示例：输入"世界"只需键入"laqjp + 空格"（"p"顶出"世(la)"）
* **五三顶**：

  * 类似五二顶，但是顶出第一、二、三码对应的字
  * 适合更复杂的组合输入，减少击键次数
  * 示例：输入"模型"只需键入"eloflpg + 空格"（"l"顶出"模(elo)"）

#### 1.2 整句输入

* **智能整句输入**：

  * 加入 AMZ 语言模型
  * 根据语境，模型全自动分词
  * 准确率显著高于传统八股文模型

### 2. 输入模式

#### 2.1 打词模式

* **九重鬼虎打词**（`G` 键启用）：

  * 123w 大词库，已修复原鬼虎词库中的错码
* **官方虎词打词**（`D` 键启用）：

  * 完全兼容官方虎词规则

#### 2.2 整句模式

* **智能虎单整句**（`H` 键启用）：

  * 结合语言模型的虎单整句输入模式
  * 自动优化候选项排序
  * 支持长句智能分词
* **官方虎词整句**（`F` 键启用）：

  * 传统虎词整句输入模式，保持虎词原有的输入习惯

### 3. 多语言支持系统

#### 3.1 英文输入（`'` 键启用）

* 智能英文分词
* 单词联想

#### 3.2 日文输入（`J` 键启用）

* 支持罗马音输入
* 平假名/片假名自动转换
* 常用日文词组联想

### 4. 实用工具集

#### 4.1 计算器功能

* 输入 `=` 启用
* 支持基础四则运算
* 支持科学计算功能
* 结果即时预览

#### 4.2 翻译功能

* `Ctrl + ;` 快速启用
* 支持中英双向翻译

#### 4.3 时间日期工具

* 支持多种日期格式显示
* 农历/公历自动转换
* 节气与节日提示

#### 4.4 特殊字符输入

* **Emoji 表情**：`Ctrl + i`
* **简繁转换**：`Ctrl + o`
* 支持 Unicode 全字符集
* 自定义特殊符号快速输入

### 5. 反查与注解系统

#### 5.1 多维度反查

* **拼音反查**：`` ` `` 键启用
* **部件反查**：`R` 键启用

#### 5.2 四重注解

* **四重注解**：`/` 键切换
* **第一重 - 字根拆分**：显示汉字虎码拆分
* **第二重 - 编码提示**：显示虎码编码
* **第三重 - 拼音显示**：显示汉字拼音
* **第四重 - 分区信息**：显示汉字 Unicode 字集归属

### 6. 词序优化系统

#### 6.1 虎单整句智能排序

* 自适应用户输入习惯
* 频率动态调整
* 上下文相关性分析

#### 6.2 快捷操作（来自魔然[『萬靈藥』](https://github.com/rimeinn/rime-moran/blob/main/lua/moran_pin.lua)）

* **候选项置顶**：`Ctrl + t`
* 最多支持 8 个置顶项
* 置顶项使用 📌 标记
* 支持置顶项管理

### 7. 造词系统

#### 7.1 基础造词（来自魔然[『萬靈藥』](https://github.com/rimeinn/rime-moran/blob/main/lua/moran_pin.lua)）

* 使用 `编码@词语` 快速添加
* 支持多音字智能识别
* 自动词频初始化

#### 7.2 高级造词（来自魔然[『萬靈藥』](https://github.com/rimeinn/rime-moran/blob/main/lua/moran_pin.lua)）

* 动态长词输入
* 实时预览
* 支持特殊字符
* 自定义词组分类

## 🎨 主题定制

### 预设主题

* iOS 风格界面
* 现代简约设计
* 高对比度显示
* 适配深色模式

### 自定义主题

* 使用 [hamster-tools](https://hertz-hwang.github.io/hamster-tools/) 在线设计（Fork from [王牌餅乾](https://github.com/lost-melody/Lost-Melody.github.io)）
* 支持自定义配色方案
* 可调整字体样式
* 界面布局个性化

## 📸 功能展示

### 移动端展示

![iOS 风格界面预览](/assets/iOS.jpg)

### 输入展示

https://github.com/user-attachments/assets/411b02af-181d-442b-a515-6147fe9adf8e

![鬼虎打词](/assets/agzh.png)
![整句示例 1](/assets/xhgj.png)
![整句示例 2](/assets/xhgj2.png)

### 多语言支持

![英文模式](/assets/lmvw.png)
![日文模式](/assets/orvw.png)

### 工具功能

![计算器](/assets/snrq.png)
![中英互译](/assets/tpsr.png)
![时间日期](/assets/pbwh.png)

### 反查功能

![拼音反查](/assets/xreo.png)

### 特殊功能

![简繁转换](/assets/raek.png)
![拼音滤镜](/assets/pinyin.png)
![字根拆分](/assets/chaifen.png)

### 造词功能

https://github.com/user-attachments/assets/11aebd07-cb3a-4520-ad57-c21defc1cdaf

## 🙏 鸣谢

* [虎码官网](https://tiger-code.com/) - 提供基础编码方案
* [魔然](https://github.com/rimeinn/rime-moran) - 提供造词功能支持
* [AMZ 语言模型](https://github.com/amzxyz/RIME-LMDG) - 提供智能编码分词支持
* [AMZ 万象词库](https://github.com/amzxyz/rime_wanxiang) - 提供扩展词库
* 感谢所有开源社区贡献者！

## 📝 更新日志

### 最新版本

* 调参优化语言模型性能
* 改进多语言切换
* 新增特殊符号支持
* 修复已知问题

## 📄 许可证

本项目采用 CC-BY-4.0 许可证 - 详见 [LICENSE](LICENSE) 文件

## 🤝 参与贡献

欢迎提交 Issue 和 Pull Request！

1. Fork 本仓库
2. 创建特性分支
3. 提交更改
4. 发起 Pull Request