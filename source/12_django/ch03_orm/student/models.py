from django.db import models

# models.Model로부터 상속받은 클래스는 DB 테이블이 된다(테이블명: student_student).
# class를 이용한 객체 변수(instance)는 테이블 내의 row(레코드)
class Student(models.Model):
    id = models.AutoField(primary_key=True) # table 안의 column
    name = models.CharField(max_length=64, unique=True)
    major = models.CharField(max_length=64, null=True, blank=True)
    age = models.IntegerField(default=20)
    grade = models.IntegerField(default=1)
    def __str__(self):
        return "{}.{}님({}, {}학년 {}세)".format(
            self.id, self.name, self.major, self.grade, self.age
        )
    