def load_mapping():
    # 声母映射
    initials = {
        'b': 'v', 'p': 'c', 'm': 'x', 'f': 'z',
        'd': 's', 't': 'a', 'n': 'g', 'l': 'l',
        'g': 'u', 'k': 'i', 'h': 'o',
        'j': 'r', 'q': 'e', 'x': 'w',
        'zh': 'j', 'ch': 'h', 'sh': 'd',
        'r': 'y',
        'z': 'n', 'c': 'm', 's': 'p',
        'y': 'f', 'w': 'k'
    }
    
    # 零声母映射
    zero_initials = {
        'a': 'to', 'o': 'tv', 'e': 'td',
        'ang': 'ts', 'eng': 'tc', 'ao': 'tl',
        'ou': 'ti', 'er': 'tk', 'ai': 'tg',
        'ei': 'tz', 'an': 'tf', 'en': 'tx'
    }
    
    # 韵母映射
    finals = {
        'a': 'o', 'o': 'v', 'e': 'd', 'i': 'k',
        'u': 'j', 'v': 'b', 'ai': 'g', 'ei': 'z',
        'ui': 'e', 'ao': 'l', 'ou': 'i', 'iu': 'm',
        'ie': 'n', 'ue': 'e', 've': 'e', 'er': 'k',
        'an': 'f', 'en': 'x', 'in': 'p', 'un': 't',
        'ang': 's', 'eng': 'c', 'ing': 'u', 'ong': 'a',
        'iang': 'w', 'iong': 'i', 'ian': 'h', 'iao': 'y',
        'uai': 'q', 'uan': 'r', 'uang': 'w', 'ia': 'q',
        'ua': 'b', 'uo': 'v'
    }
    
    return initials, zero_initials, finals

def pinyin_to_shuangpin(pinyin, initials, zero_initials, finals):
    # 首先检查是否完全匹配零声母表中的拼音
    if pinyin in zero_initials:
        return zero_initials[pinyin]
    
    # 处理特殊的零声母情况
    for zero_initial, code in sorted(zero_initials.items(), key=lambda x: len(x[0]), reverse=True):
        if pinyin.startswith(zero_initial):
            rest = pinyin[len(zero_initial):]
            if not rest:  # 如果完全匹配零声母
                return code
            if rest in finals:
                return code[0] + finals[rest]
    
    # 处理正常声母韵母情况
    for initial, code in sorted(initials.items(), key=lambda x: len(x[0]), reverse=True):
        if pinyin.startswith(initial):
            final = pinyin[len(initial):]
            if final in finals:
                return code + finals[final]
    
    return pinyin  # 如果无法转换则返回原始拼音

def convert_dict(input_file, output_file):
    initials, zero_initials, finals = load_mapping()
    
    with open(input_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    results = []
    for line in lines:
        line = line.strip()
        if not line or line.startswith('#') or '...' in line or 'name:' in line or 'version:' in line or 'sort:' in line:
            continue
            
        parts = line.split()
        if len(parts) >= 2:
            char = parts[0]
            pinyin = parts[1]
            weight = parts[2] if len(parts) > 2 else "1"
            
            shuangpin = pinyin_to_shuangpin(pinyin, initials, zero_initials, finals)
            if len(shuangpin) == 2:  # 只保留正确转换的结果
                results.append(f"{char}\t{shuangpin}\t{weight}")
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(results))

convert_dict('data/pinyin.txt', 'data/moss.txt')
