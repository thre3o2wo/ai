from django.shortcuts import render
from django.views.generic import ListView, CreateView, UpdateView, DeleteView, DetailView
from .models import Article
from django.core.paginator import Paginator
from django.urls import reverse_lazy

# Create your views here.
# article_list = lambda req: None # 함수 아니면 에러

# /article : 1페이지, /article?page=3 : 3페이지
def article_list(request):
    a_list = Article.objects.all()
    paginator = Paginator(a_list, 3)
    page_number = request.Get.get('page', '1') # page 안 넣으면 1로
    page_object = paginator.get_page(page_number)
    return render(
        request, 
        "article/article_list.html", 
        {"article_list":page_object, "page_obj":page_object},
    )

article_list = ListView.as_view(
    model=Article,
    paginate_by=3, # 한 페이지에 3행씩 표시
)

article_new = CreateView.as_view(model=Article, fields="__all__")
article_edit = UpdateView.as_view(model=Article, fields="__all__")
article_delete = DeleteView.as_view(model=Article, success_url=reverse_lazy("article:list"))
article_detail = DetailView.as_view(model=Article)