from django.test import TestCase
import re

# Create your tests here.
lnglat = re.match(r'(\d+\.?\d*),(\d+\.?\d*)','38,125') # 실수,정수 / 정수,실수 / 실수,실수 / 정수,정수

if not lnglat: # 정규표현식과 불일치하면, (불일치는 None)
    print('정규표현식과 일치하지 않음')
else:
    print(lnglat.group(0), lnglat.group(1), lnglat.group(2))