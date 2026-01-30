from django.urls import path
from . import views

# file/         DB에 저장 없이 파일 첨부받기 (name=file:upload_file)
# file/predict/ 예측 결과 출력하기 (name=file:predict)
app_name = "file"
urlpatterns = [
  path("", views.upload_file, name="upload_file"),
  path("predict/", views.predict, name="predict")
]