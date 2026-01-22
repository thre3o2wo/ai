from django.db import models
import re
from django.forms import ValidationError
from django.utils import timezone

# Create your models here.

REGION_CHOICES = ( # PDF 교안 P.19 참조 ("db에 입력될 값", "form 태그에 출력될 값")
    ("Europe", "유럽"),
    ("Asia", "아시아"),
    ("Oceania", "오세아니아"),
    ("America", "아메리카"),
    ("Africa", "아프리카"),
)

def lnglat_validator(value):
    if not re.match(r'(\d+\.?\d*),(\d+\.?\d*)', value):
        raise ValidationError("경도,위도 타입이 아닙니다(ex. 125.2,38)")

class Tag(models.Model):
    name = models.CharField(max_length=50, unique=True)
    def __str__(self):
        return self.name

class Post(models.Model): # 테이블명: blog_post 생성
    # id = models.AutoField(primary_key=True) # sequenced id, PK가 없을 경우 자동 생성
    title = models.CharField(
        verbose_name='제목', # 표시 내용, form의 label 역할
        max_length=100, # 최대 문자 길이 반드시 지정 VARCHAR(100)
        help_text="기사 제목입니다. 100자 내외로 입력하세요.",
    )
    content = models.TextField("본문") # 첫 번째 매개변수: verbose_name # 최대 문자 길이 제한 없음 (oracle의 경우 CLOB 타입)
    create_at = models.DateField(auto_now_add=True) # 등록일 / 현재 시간 자동 저장
    update_at = models.DateTimeField(auto_now=True) # 등록/수정 날짜와 시간 자동 저장
    region = models.CharField(
        verbose_name="지역", 
        max_length=100,
        default="Asia",
        choices=REGION_CHOICES,
    )
    lnglat = models.CharField(
        verbose_name="위경도", 
        max_length=100,
        blank=True,
        null=True,
        help_text="경도,위도 포맷 ex) 37,125.5",
        validators=[lnglat_validator]
    )
    url = models.URLField(blank=True, null=True)
    tags = models.ManyToManyField(Tag, blank=True)

    def __str__(self): # 테이블의 한 레코드에 대해 작업 대상
        updated = timezone.localtime(self.update_at).strftime("%Y-%m-%d %H:%M")
        return "{}.제목:{} - {} 작성 | {} 최종 수정".format(self.id, self.title, self.create_at, updated)
    
    class Meta: # 테이블의 모든 레코드에 대해 작업 대상
        # db_table = "blog_post" # 테이블 이름
        ordering = ['-update_at'] # update_at 역순(내림차순-최신순) 정렬
        unique_together = [('title', 'content')] # title과 content 둘 모두 동일한 것은 insert 불가함

class Comment(models.Model): # Post의 댓글 내용 저장하는 테이블 blog_comment 생성 / post:comment = 1:N
    # id = models.AutoField(primary_key=True)
    post = models.ForeignKey(Post, on_delete=models.CASCADE) # Post의 해당 row 삭제되면 연결된 Comment의 row 자동 삭제
    author = models.CharField(
        verbose_name="댓글작성자",
        max_length=20,
        null=True,
        blank=True,
    )
    message = models.TextField(verbose_name="댓글")
    create_at = models.DateField(auto_now_add=True)
    update_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        updated = timezone.localtime(self.update_at).strftime("%Y-%m-%d %p %I:%M") # PM 1:30
        updated = updated.replace("AM", "오전").replace("PM", "오후")
        return "{}글의 댓글 {} (by {}, at{})".format(
            self.post.pk, self.message, self.author, updated
        )
    
    class Meta:
        ordering = ['-update_at']
        unique_together = [('post', 'author', 'message')] # 같은 사람이 같은 글에 같은 메시지 도배 방지
