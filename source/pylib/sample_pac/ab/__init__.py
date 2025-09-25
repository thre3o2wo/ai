'''
sample_pac/ab/__init__.py
ab 패키지 import할 때 자동 실행
from sample_pac.ab import * 를 수행 시 a 모듈만 자동 import 되도록
(b는 직접 명시해 import 하도록)
__all__를 setting
'''
__all__ = ['a']
print('Now loaded sample_pac.ab package')