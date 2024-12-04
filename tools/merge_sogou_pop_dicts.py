#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
from datetime import datetime

def read_dict_file(file_path):
    """读取词典文件,返回header和码表部分"""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # 分割header和码表部分
    parts = content.split('...\n\n')
    if len(parts) == 1:
        parts = content.split('...\n') 
    
    header = parts[0] + '...\n\n'
    codes = parts[1] if len(parts) > 1 else ''
    
    return header, codes

def update_version(header):
    """更新header中的version为当前日期"""
    today = datetime.now().strftime('%Y.%m.%d')
    return re.sub(r'version: "\d{4}\.\d{2}\.\d{2}"', f'version: "{today}"', header)

def merge_dicts():
    """合并两个词典文件"""
    # 读取目标文件
    target_header, target_codes = read_dict_file('./dicts/moss.sogou_pop.dict.yaml')
    
    # 读取源文件
    _, source_codes = read_dict_file('./moss.sogou_pop.dict.yaml')
    
    # 更新版本号
    updated_header = update_version(target_header)
    
    # 合并码表
    # 将码表转换为集合去重
    code_lines = set((target_codes + source_codes).splitlines())
    # 过滤空行
    code_lines = {line for line in code_lines if line.strip()}
    # 转回字符串,按行排序
    merged_codes = '\n'.join(sorted(code_lines))
    
    # 写入合并后的文件
    with open('./dicts/moss.sogou_pop.dict.yaml', 'w', encoding='utf-8') as f:
        f.write(updated_header)
        f.write(merged_codes)
        f.write('\n')  # 文件末尾加换行

if __name__ == '__main__':
    merge_dicts()
    print('词典合并完成!') 