import re
import yaml
import os
import sys
from pathlib import Path

def get_rime_user_dir():
    """获取Rime用户目录"""
    # Windows
    if os.name == 'nt':
        return os.path.expanduser('~/AppData/Roaming/Rime')
    # macOS
    elif sys.platform == 'darwin':
        return os.path.expanduser('~/Library/Rime')
    # Linux
    else:
        return os.path.expanduser('~/.config/ibus/rime')

def parse_spelling_data(yaml_file):
    # 读取YAML文件
    with open(yaml_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 分离元数据和数据部分
    data_section = content.split('...')[1].strip()
    
    # 创建存储结果的字典
    result = {}
    
    # 解析每一行
    for line in data_section.split('\n'):
        if not line.strip() or line.startswith('#'):
            continue
            
        # 使用正则表达式提取汉字和拆分码
        match = re.match(r'(.)\t\[(.*?),.*?\]', line)
        if match:
            char = match.group(1)  # 汉字
            spelling = match.group(2)  # 拆分码
            
            # 只处理单个汉字的条目
            if len(char) == 1:
                result[char] = spelling

    return result

def generate_lua_table(data, output_file):
    # 生成Lua表格式的内容
    lua_content = 'return {\n'
    
    # 按汉字排序
    for char in sorted(data.keys()):
        # 转义引号
        spelling = data[char].replace('"', '\\"')
        lua_content += f'    ["{char}"] = "{spelling}",\n'
    
    lua_content += '}\n'
    
    # 写入文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(lua_content)

def main():
    # 获取Rime用户目录
    user_dir = get_rime_user_dir()
    
    # 构建输入输出文件的完整路径
    input_file = os.path.join(user_dir, 'tiger_spelling_pseudo.dict.yaml')
    output_file = os.path.join(user_dir, 'lua', 'tiger', 'spelling_table.lua')
    
    # 确保输出目录存在
    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    
    # 解析YAML文件
    spelling_data = parse_spelling_data(input_file)
    
    # 生成Lua表文件
    generate_lua_table(spelling_data, output_file)
    
    print(f"已处理 {len(spelling_data)} 个字符")
    print(f"转换后的文件已保存到: {output_file}")

if __name__ == '__main__':
    main()