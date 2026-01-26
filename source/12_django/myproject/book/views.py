from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse, reverse_lazy
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from .models import Book
from .forms import BookForm

# 1. form 없이 구현
# 2. form 객체 생성 후
# 3. DjangoGenericView 사용
# 4. GenericView 상속(ch7 내용) 

# def book_list(request):
    # return render(request, "book/book_list.html", {"book_list":Book.objects.all()})
def book_new(request):
    # GET : template 페이지(book/book_form.html)로 응답
    # POST : parameter 변수 받아 유효성 체크
        # 1) success : db에 save() → book:list로 이동
        # 2) fail : 오류메시지와 함께 입력 페이지로 재이동 (form 객체 이용)
    if request.method=="POST":
        # # parameter 받아서 ip까지 입력한 후 db에 저장
        # title = request.POST.get('title')
        # author = request.POST.get('author')
        # publisher = request.POST.get('publisher')
        # sales = int(request.POST.get('sales'))
        # ip = request.META['REMOTE_ADDR'] # client IP 주소
        # ip = request.META.get('REMOTE_ADDR', 'localhost')
        # book = Book(
        #     title=title, 
        #     author=author, 
        #     publisher=publisher, 
        #     sales=sales, 
        #     ip=ip,
        # )
        # book.save()
        # return redirect(book) 
        # # book.get_absolute_url() 호출됨 : reverse("book:list") (url string 반환)
        form = BookForm(request.POST)
        # print('유효성 검증 결과', form.is_valid())
        # print(form.cleaned_data)
        if form.is_valid(): # 유효성 검사
        #    book = Book(**form.cleaned_data)
            book = form.save(commit=False) # 지금은 저장 없이
            book.ip = request.META.get('REMOTE_ADDR', 'localhost')
            book.save()
            return redirect(book)
    elif request.method == 'GET':
        # return render(request, "book/book_form.html")
        form = BookForm()
    return render(request, "book/book_form.html", {'form':form})

def book_edit(request, pk):
    pass
def book_delete(request, pk):
    pass

book_list = ListView.as_view(model=Book)
# book_new = CreateView.as_view(
#     model=Book, 
#     fields=[
#         'title', 'author', 'publisher', 'sales',
#     ]
# )