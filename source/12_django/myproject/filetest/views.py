from django.shortcuts import render
from django.contrib import messages
from myproject import settings
import os

def upload_file(request):
  if request.method == 'POST':
    # 파일첨부 처리
    upload_file = request.FILES.get('file')
    MAX_FILE_SIZE = 10 * 1024 *1024 # 최대 업로드 사이즈 제한 : 10MB
    if upload_file and upload_file.size < MAX_FILE_SIZE:
      # 파일 첨부 and 10MB 미만
      upload_dir = os.path.join(settings.MEDIA_ROOT, "filetest")
      os.makedirs(upload_dir, exist_ok=True) # 폴더가 없을 경우 폴더 생성
      file_path = os.path.join(upload_dir, upload_file.name)
      print(file_path, "에 저장함")
      with open(file_path, "wb") as f:
        for chunk in upload_file.chunks(): # 큰 파일 업로드 시 조금씩 나눠서 저장
          f.write(chunk)
      return render(request, "filetest/result.html")
    elif upload_file and upload_file.size >= MAX_FILE_SIZE:
      # 파일 첨부 and 10MB 이상
      messages.error(request, f"File Size({int(upload_file.size/1024)}KB) Cannot Exceed 10MB")
      messages.warning(request, "File Size Cannot Exceed 10MB")
    else:
      # 파일 첨부 안 함
      messages.success(request, "파일을 첨부하지 않았습니다.")
      messages.info(request, "파일 첨부를 하지 않았습니다.")
  return render(request, "filetest/fileupload.html")

import time
def predict(request):
  time.sleep(3) # predict 시간 sim
  return render(request, "filetest/predict.html", {"answer":"Hello, World!"})