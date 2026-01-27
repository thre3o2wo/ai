from django.shortcuts import render, redirect, get_object_or_404
from django.urls import reverse, reverse_lazy
from django.views.generic import ListView, CreateView, UpdateView, DeleteView
from .models import Book
from .forms import BookModelForm

# 1. form 없이 구현
# 2. form 객체 생성 후 (ch6)
# 3. DjangoGenericView 사용 (ch7) 
# 4. GenericView 상속

# def book_list(request):
#     return render(
#         request, 
#         "book/book_list.html", 
#         {"book_list":Book.objects.all(), "object_list":Book.objects.all()}
#     )
book_list = ListView.as_view(model=Book) # GenericView!

def book_new_1n2(request): # 1번, 2번 방법
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
        form = BookModelForm(request.POST)
        print(form)
        print('유효성 검증 결과', form.is_valid())
        print(form.cleaned_data)
        if form.is_valid(): # 유효성 검사
        #    book = Book(**form.cleaned_data)
            book = form.save(commit=False) # 지금은 저장 없이
            book.ip = request.META.get('REMOTE_ADDR', 'localhost')
            book.save()
            return redirect(book)
    elif request.method == 'GET':
        # return render(request, "book/book_form.html")
        form = BookModelForm()
    return render(request, "book/book_form.html", {'form':form})

book_new_3 = CreateView.as_view( # 3번 방법
    model = Book,
    fields = ['title', 'author', 'publisher', 'sales'], # 입력 form 필드
) # book.ip에는 null이 지정됨 
# ip 정보가 중요하다면 genericView 못 씀. 상속(4) 방법으로 view 정의해야.

class BookCreateView(CreateView): # genericView 상속받기 
    model = Book
    fields = ['title', 'author', 'publisher', 'sales'] # 입력 form 필드
    # template_name = "book/book_form.html"
    def form_valid(self, form): # CreateView 내의 함수를 override(재정의)
        book = form.save(commit=False)
        book.ip = self.request.META.get('REMOTE_ADDR', 'localhost')
        book.save()
        return redirect(book)
    
book_new = BookCreateView.as_view() # 4번 방법

def book_edit_1(request, pk):
    # GET: 수정 template book 페이지만 응답
    # POST: parameter 받아 유효성 체크
        # 1) success: db에 update → book:list
        # 2) fail: 오류 메시지가 담긴 form 객체와 함께 수정 template으로 재이동
    book = get_object_or_404(Book, id=pk)
    if request.method=="POST":
        form = BookModelForm(request.POST, instance=book) # instance=book 없으면 insert
        if form.is_valid():
            # 수정 시에도 ip 입력
            # book = form.save(commit=False)
            # book.ip = request.META.get('REMOTE_ADDR', 'localhost')
            # book.save()
            # 수정 시 ip 변경 안 함
            book = form.save()
            return redirect(book)
    elif request.method=="GET":
        form = BookModelForm(instance=book)
    return render(request, "book/book_form.html", {"form":form})

book_edit = UpdateView.as_view(model=Book, fields = ['title', 'author', 'publisher', 'sales'])

def book_delete_1(request, pk):
    # book = get_object_or_404(Book, pk=pk)
    # book.delete()
    # return redirect(book)
    # GET: 삭제할지 물어보는 template으로 이동
    # POST: db에 delete
    book = get_object_or_404(Book, pk=pk)
    if request.method == 'POST':
        book.delete()
        return redirect(book)
    elif request.method == 'GET':
        return render(request, "book/book_confirm_delete.html", {'object':book})

book_delete = DeleteView.as_view(
    model=Book,
    success_url=reverse_lazy("book:list"), # delete 후에 변환하여 실행
    # template_name="", 
)