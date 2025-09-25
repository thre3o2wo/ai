#sample_pac/cd/c.py

#python sample_pac/cd/c.py 실행할 때↓

# import sys
# sys.path.append(r'C:\ai\source\pylib')
# from sample_pac.ab import a

#python -m sample_pac.cd.c 실행할 때↓
from ..ab import a

def nice():
    print('sample_pac/cd/c 모듈의 nice')
    a.hello()

if __name__ == '__main__':
    nice()