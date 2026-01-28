from django.db import models
from django.urls import reverse


# Create your models here.
STATUS_CHOICES = (
    ('d', 'Draft'),
    ('p', 'Published'),
    ('w', 'Withdrawn'),
)

class Article(models.Model): # article_article 테이블 생성
    title = models.CharField(
        verbose_name="Title",
        max_length=100,
    )
    body = models.TextField(
        verbose_name="Body",
    )
    status = models.CharField(
        max_length=1,
        choices=STATUS_CHOICES,
    ) #verbose_name 안 넣으면 변수명 그대로 들어감
    # photo # 파일 첨부
    def __str__(self):
        return f"{self.id}.{self.title}"
    def get_absolute_url(self): # create, update 후 이동할 url 지정
        return reverse("article:detail", args=[self.id]) # 해당 article 상세보기 페이지로
    class Meta:
        ordering = ['-id'] # id 내림차순 정렬