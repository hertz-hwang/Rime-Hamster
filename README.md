## 仿 iOS 配色

![iOS](/assets/iOS.jpg)

## 使用方法

下载最新[hamster_keyboards_candy.yaml](https://github.com/hertz-hwang/Rime-Hamster/releases/latest/download/hamster_keyboards_candy.yaml)后，下面方法二选一：

- a. 通过仓输入法“键盘布局”-“+”来导入；

- b. 写入自定义配置 hamster.custom.yaml 来引入。（[参考](https://github.com/hertz-hwang/Rime-Hamster/blob/3acea50b60caa20fa5e98c0e5ec624d81f31df63/hamster.custom.yaml#L2-L5)）

```yaml
patch:
  # ...
  "keyboards":
    __include: hamster_keyboards_candy:/keyboards
  "keyboard/colorSchemas":
    __include: hamster_keyboards_candy:/colorSchemas
  # ...
```

## Themes & Layouts

主题&布局设计工具：[hamster-tools](https://hertz-hwang.github.io/hamster-tools/) （Forked from [饼干](https://github.com/lost-melody/Lost-Melody.github.io)）

### Layouts

| 键位      | 动作 | 功能            |
| ----------- | ------ | ----------------- |
|         | 点击 | 左移            |
|         | 下划 | 行首            |
|         | 点击 | 打开QQ          |
|         | 点击 | 打开微信        |
|         | 点击 | Perplexity搜索  |
|         | 点击 | Google搜索      |
|         | 点击 | 右移            |
|         | 下划 | 行尾            |
| A         | 下划 | 全选            |
| Z         | 下划 | 反查（小鹤）     |
| X         | 下划 | 剪切            |
| C         | 下划 | 复制            |
| C         | 长按 | 常用语          |
| V         | 下划 | 粘贴            |
| V         | 长按 | 剪贴板          |
| F         | 下划 | 脚本            |
| I         | 下划 | 编码中开关Emoji |
| O         | 下划 | 编码中简繁切换  |
| P         | 下划 | 编码中显示拼音  |
| J         | 上划 | 通配符         |
| J         | 下划 | 编码中显示拆分  |
| K         | 下划 | 快符引导       |
| M         | 下划 | 命令引导        |
| Shift     | 上划 | Tab制表符       |
| Backspace | 上划 | 重做            |
| Backspace | 左划 | 清空编码        |
| Enter     | 上划 | 换行            |