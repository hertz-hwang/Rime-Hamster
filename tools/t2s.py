from opencc import OpenCC
import glob
import os

def convert_files():
    # 初始化转换器，使用繁体到简体的配置
    cc = OpenCC('t2s')
    
    # 确保输出目录存在
    output_dir = 'data/t2s'
    os.makedirs(output_dir, exist_ok=True)
    
    # 获取所有符合模式的文件
    input_files = glob.glob('data/moran/moran.*.dict.yaml')
    
    for input_file in input_files:
        try:
            # 生成输出文件名（保存到 data/ 目录）
            filename = os.path.basename(input_file)
            output_file = os.path.join(output_dir, filename)
            
            # 读取并转换内容
            with open(input_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            simplified_content = cc.convert(content)
            
            # 写入新文件
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(simplified_content)
                
            print(f'已完成 {input_file} 的转换，结果保存到 {output_file}')
            
        except FileNotFoundError:
            print(f'错误：找不到文件 {input_file}')
        except Exception as e:
            print(f'处理 {input_file} 时发生错误：{str(e)}')

if __name__ == '__main__':
    convert_files()
