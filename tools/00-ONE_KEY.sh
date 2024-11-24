python 01-pinyin_to_moss.py 

python 02-schemagen.py --auxiliary-code=user update-compact-dict --rime-dict=./data/moss.txt > ./data/moss_tiger.txt

python 03-convert_to_yaml_dict.py

python 04-gen_moss_tiger_dict.py ../dicts/moss.basic.dict.yaml --dict data/moran.basic.dict.yaml
python 04-gen_moss_tiger_dict.py ../dicts/moss.phrase.dict.yaml --dict data/phrase.dict.yaml
python 04-gen_moss_tiger_dict.py ../dicts/moss.words.dict.yaml --dict data/moran.words.dict.yaml
python 04-gen_moss_tiger_dict.py ../dicts/moss.tencent.dict.yaml --dict data/moran.tencent.dict.yaml
python 04-gen_moss_tiger_dict.py ../dicts/moss.computer.dict.yaml --dict data/moran.computer.dict.yaml
python 04-gen_moss_tiger_dict.py ../dicts/moss.moe.dict.yaml --dict data/moran.moe.dict.yaml
