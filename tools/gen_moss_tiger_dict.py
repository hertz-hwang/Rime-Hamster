import argparse
import os

def load_char_codes(moss_dict_path):
    """加载单字编码表"""
    char_codes = {}  # {字符: (编码, 权重)}
    
    with open(moss_dict_path, 'r', encoding='utf-8') as f:
        # 跳过文件头
        for line in f:
            if line.strip() == '...':
                break
                
        # 读取编码
        for line in f:
            line = line.strip()
            if not line:
                continue
            
            parts = line.split('\t')
            if len(parts) >= 3:
                char, code, weight = parts[0], parts[1], int(parts[2])
                # 只有当字符不存在,或新的权重更大时才更新
                if char not in char_codes or weight > char_codes[char][1]:
                    char_codes[char] = (code, weight)
    
    return char_codes

def process_dict_dict(dict_dict_path, char_codes):
    """处理词典"""
    entries = []
    
    with open(dict_dict_path, 'r', encoding='utf-8') as f:
        # 跳过文件头
        for line in f:
            if line.strip() == '...':
                break
                
        # 处理每个词条
        for line in f:
            word = line.strip()
            if not word:
                continue
                
            # 获取每个字的编码和权重
            codes = []
            weights = []  # 新增: 存储每个字的权重
            valid = True
            
            for char in word:
                if char in char_codes:
                    code, weight = char_codes[char]
                    codes.append(code)
                    weights.append(weight)  # 保存权重
                else:
                    valid = False
                    break
            
            if valid:
                code_str = ' '.join(codes)
                # 使用所有字中最小的权重作为词条权重
                min_weight = min(weights) if weights else 1
                entries.append((word, code_str, min_weight))
    
    return entries

def get_dict_name(dict_path):
    """从词典路径中提取名称"""
    # 获取文件名(不含路径和扩展名)
    base_name = os.path.splitext(os.path.basename(dict_path))[0]
    # 去掉 .dict 后缀（如果存在）
    if base_name.endswith('.dict'):
        base_name = base_name[:-5]  # 去掉 '.dict' 后缀
    # 提取最后一个点后面的部分作为核心名称
    core_name = base_name.split('.')[-1]
    # 添加 moss. 前缀
    return f'moss.{core_name}'

def write_output(output_path, entries, dict_name):
    """写入输出文件"""
    with open(output_path, 'w', encoding='utf-8') as f:
        # 写入文件头
        f.write('---\n')
        f.write(f'name: {dict_name}\n')
        f.write('version: "2024-11-24"\n')
        f.write('sort: by_weight\n')
        f.write('...\n\n')
        
        # 写入词条,权重统一为1
        for word, codes, _ in entries:  # 忽略原始权重
            f.write(f'{word}\t{codes}\t1\n')

def main():
    # 解析命令行参数
    parser = argparse.ArgumentParser(description='生成词典的编码')
    parser.add_argument('output', help='输出文件路径')
    parser.add_argument('--moss', default='../dicts/moss.base.dict.yaml', help='单字码表路径 (默认: ../dicts/moss.dict.yaml)')
    parser.add_argument('--dict', help='要处理的词典路径 (默认: ../dicts/moran.dict.dict.yaml)')
    
    args = parser.parse_args()
    
    # 检查输入文件是否存在
    if not os.path.exists(args.moss):
        print(f'错误: 单字码表文件不存在: {args.moss}')
        return
    if not os.path.exists(args.dict):
        print(f'错误: 词典文件不存在: {args.dict}')
        return
        
    # 创建输出目录(如果不存在)
    output_dir = os.path.dirname(args.output)
    if output_dir:  # 只在有目录部分时创建
        os.makedirs(output_dir, exist_ok=True)
    
    # 处理流程
    char_codes = load_char_codes(args.moss)
    entries = process_dict_dict(args.dict, char_codes)
    dict_name = get_dict_name(args.dict)
    write_output(args.output, entries, dict_name)
    
    print(f'处理完成! 输出文件: {args.output}')

if __name__ == '__main__':
    main()
