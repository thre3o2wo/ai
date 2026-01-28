from django.urls import path
from . import views

from django.views.generic import ListView, CreateView, UpdateView, DeleteView, DetailView
from .models import Article
from django.urls import reverse_lazy

# 기사 목록 /aritcle/            aritcle:list
# 기사 추가 /aritcle/new/        aritcle:new
# 기사 수정 /aritcle/1/edit      aritcle:edit
# 기사 삭제 /aritcle/1/delete    aritcle:delete
# 기사 상세 /aritcle/1/detail    aritcle:detail

# v1. w/o 검색기능

app_name = "article"
urlpatterns = [
    # path("", views.article_list, name="list"),
    # path("new/", views.article_new, name="new"),
    # path("<int:pk>/edit/", views.article_edit, name="edit"),
    # path("<int:pk>/delete/", views.article_delete, name="delete"),
    # path("<int:pk>/detail/", views.article_detail, name="detail"),
    path("", ListView.as_view(model=Article, paginate_by=3), name="list"),
    path("new/", CreateView.as_view(model=Article, fields="__all__"), name="new"),
    path("<int:pk>/edit/", UpdateView.as_view(model=Article, fields="__all__"), name="edit"),
    path("<int:pk>/delete/", DeleteView.as_view(model=Article, success_url=reverse_lazy("article:list")), name="delete"),
    path("<int:pk>/detail/", DetailView.as_view(model=Article), name="detail"),
]