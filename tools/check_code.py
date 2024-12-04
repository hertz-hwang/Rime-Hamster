import yaml
import re
import argparse
import os

def load_dict_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        # 分割header和数据部分
        parts = content.split('\n---\n')
        if len(parts) > 1:
            data = parts[1]
        else:
            data = parts[0]
    return data

def parse_single_char_codes(content):
    """解析单字码表，返回字符到编码的映射，当有重复字符时优先选择权重最大且第二位不为0的编码"""
    char_to_codes = {}  # 存储每个字符的所有编码和权重
    char_to_code = {}   # 最终结果
    
    # 第一遍遍历：收集所有字符的编码和权重
    for line in content.splitlines():
        line = line.strip()
        if line and not line.startswith('#'):
            parts = line.split('\t')
            if len(parts) >= 2:
                char = parts[0]
                if len(char) == 1:  # 只处理单字
                    code = parts[1]
                    weight = float(parts[2]) if len(parts) > 2 else 0
                    if char not in char_to_codes:
                        char_to_codes[char] = []
                    char_to_codes[char].append((code, weight))
    
    # 第二遍处理：为每个字符选择最合适的编码
    for char, codes in char_to_codes.items():
        # 按权重降序排序
        codes.sort(key=lambda x: x[1], reverse=True)
        
        # 首先尝试找到权重最大且第二位不为'0'的编码
        selected_code = None
        for code, _ in codes:
            if len(code) >= 2 and code[1] != '0':
                selected_code = code
                break
        
        # 如果没找到合适的编码（所有编码第二位都是'0'或编码长度不足），就使用权重最大的编码
        if selected_code is None and codes:
            selected_code = codes[0][0]
            
        if selected_code:
            char_to_code[char] = selected_code
    
    return char_to_code

def generate_word_code(word, char_to_code, target_length=4):
    """根据词长生成正确的编码
    target_length: 目标编码长度，可以是2、3或4
    """
    if not all(char in char_to_code for char in word):
        return None
        
    length = len(word)
    
    if target_length == 2:
        # 两位编码：取前两字的首码
        if length >= 2:
            return ''.join(char_to_code[char][0] for char in word[:2])
        return None
    elif target_length == 3:
        # 三位编码：取前三字的首码
        if length >= 3:
            return ''.join(char_to_code[char][0] for char in word[:3])
        return None
    else:  # target_length == 4
        if length == 2:
            # 二字词：取第一字前两码+第二字前两码
            return char_to_code[word[0]][:2] + char_to_code[word[1]][:2]
        elif length == 3:
            # 三字词：第一字首码+第二字首码+第三字前两码
            return (char_to_code[word[0]][0] + char_to_code[word[1]][0] + 
                    char_to_code[word[2]][:2])
        elif length == 4:
            # 四字词：每字首码
            return ''.join(char_to_code[char][0] for char in word)
        elif length >= 5:
            # 五字及以上词：前三字首码+末字首码
            return (''.join(char_to_code[char][0] for char in word[:3]) + 
                    char_to_code[word[-1]][0])
    return None

def main():
    # 设置命令行参数
    parser = argparse.ArgumentParser(description='检查并修复码表编码')
    parser.add_argument('--base-code', required=True,
                      help='基础单字码表文件路径 (如 tiger_core.dict.yaml)')
    parser.add_argument('--rime-dict', required=True,
                      help='待检查的词条码表文件路径 (如 onitiger_ci.dict.yaml)')
    parser.add_argument('--output', '-o',
                      help='输出文件路径，默认为原文件名加上.fixed后缀')
    
    args = parser.parse_args()
    
    # 检查输入文件是否存在
    if not os.path.exists(args.base_code):
        print(f'错误：单字码表文件不存在 - {args.base_code}')
        return
    if not os.path.exists(args.rime_dict):
        print(f'错误：词条码表文件不存在 - {args.rime_dict}')
        return
    
    # 设置输出文件路径
    if args.output:
        output_file = args.output
    else:
        base, ext = os.path.splitext(args.rime_dict)
        output_file = f'{base}.fixed{ext}'
    
    # 读取单字码表
    core_content = load_dict_file(args.base_code)
    char_to_code = parse_single_char_codes(core_content)
    
    # 读取需要检查的词条文件
    ci_content = load_dict_file(args.rime_dict)
    
    # 处理并输出结果
    output_lines = []
    fixed_count = 0
    error_count = 0
    skipped_count = 0
    
    for line in ci_content.splitlines():
        line = line.strip()
        if not line or line.startswith('#'):
            output_lines.append(line)
            continue
            
        parts = line.split('\t')
        if len(parts) >= 3:  # 必须至少有三列
            word = parts[0]
            weight = parts[1]  # 第二列是权重
            code = parts[2]    # 第三列是编码
            
            # 根据编码长度决定处理方式
            code_length = len(code)
            if code_length < 2:  # 跳过少于2位的编码
                output_lines.append(line)
                skipped_count += 1
                continue
            
            if len(word) >= 2:  # 只处理多字词
                # 根据原编码长度生成相应长度的新编码
                correct_code = generate_word_code(word, char_to_code, 
                                               target_length=code_length)
                if correct_code:
                    if code != correct_code:
                        # 保持权重不变，只更新编码
                        new_line = f'{word}\t{weight}\t{correct_code}'
                        output_lines.append(new_line)
                        fixed_count += 1
                    else:
                        output_lines.append(line)
                else:
                    print(f'警告：无法生成编码 - {word}')
                    output_lines.append(line)
                    error_count += 1
            else:
                output_lines.append(line)
        else:
            # 如果列数不足，保持原样
            output_lines.append(line)
    
    # 写入修复后的文件
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('# 自动修复的词条码表\n---\n')
        f.write('\n'.join(output_lines))
    
    print(f'处理完成：')
    print(f'输入文件：{args.rime_dict}')
    print(f'单字码表：{args.base_code}')
    print(f'输出文件：{output_file}')
    print(f'修复的编码数：{fixed_count}')
    print(f'跳过的短编码数：{skipped_count}')
    print(f'无法处理的条目：{error_count}')

if __name__ == '__main__':
    main() 