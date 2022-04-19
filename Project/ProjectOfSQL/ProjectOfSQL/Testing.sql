exec  [dbo].[Insert_To_Student] 'Ali','Ali33@gmail.com','258',25,'Minia'
exec  [dbo].[Insert_To_Student] 'mona','mona@gmail.com','236',21,'cairo'
exec  [dbo].[Insert_To_Student] 'bebo','bebo33@gmail.com','159',25,'Alex'
exec  [dbo].[Insert_To_Student] 'Abdullah','Abdullah33@gmail.com','178',25,'Helwan'
exec  [dbo].[Insert_To_Student] 'sami','sami33@gmail.com','526',27,'Giza'
exec  [dbo].[Insert_To_Student] 'Rany','Ramy33@gmail.com','236',25,'bani suef'
exec  [dbo].[Insert_To_Student] 'Rania','Rania33@gmail.com','831',20,'minia'
--------------------------------------------------------------------------------------
use [ExamSystem]
exec [dbo].[Insert_To_INS] 'Ahmed','Ahmed33@gmail.com','136',30,'Sofag','0123452601'
exec [dbo].[Insert_To_INS] 'Maryam','Maryam33@gmail.com','258',29,'Cairo','01020361175'
exec [dbo].[Insert_To_INS] 'Safa','Safa33@gmail.com','1026',27,'Alex','01523648997'
exec [dbo].[Insert_To_INS] 'Mahmoud','Mahmoud33@gmail.com','01236',30,'Minia','01153667710'
-------------------------------------------------------------------------------------------
exec [dbo].[Insert_To_Course] 2,'C#',100,50,'.Net Track',1
--exec [dbo].[Insert_To_Course] 2,'C#',100,50,'.Net Track',1 error because This instructor Just teach this course
exec [dbo].[Insert_To_Course] 3,'C#',100,50,'.Net Track',2 
exec [dbo].[Insert_To_Course] 2,'Java',100,50,'.Net Track',3
exec [dbo].[Insert_To_Course] 2,'Html',100,50,'.Net Track',4
exec [dbo].[Insert_To_Course] 2,'Css',100,50,'.Net Track',5
exec [dbo].[Insert_To_Course] 2,'Sql',100,50,'.Net Track',6
----------------------------------------------------------------------------------------
exec [dbo].[Student_regist_Course] 1,1
exec [dbo].[Student_regist_Course] 2,1
exec [dbo].[Student_regist_Course] 2,2
---------------------------------------------------------------------
exec [dbo].[AddingQuestion_sp] 1,1,'MCQ','xx','a','b','c','d','d',1,5
exec [dbo].[AddingQuestion_sp] 1,2,'T&F','x','a','b',null,null,'b',2,5
-------------------------------------------------------------------------
exec [dbo].[add_new_exam] 1,1,1,'2022','2019-01-25 08:00:00:000','2019-01-25  09:00:00:000','Exam','1:00:00:000',null,null
------------------------------------------------------------------------
exec [dbo].[Add_Answer] 1,1,'a'
------------------------------------------------------------------------
exec [dbo].[disply_Result_Course] 1
------------------------------------------------------------------------
print getdate()
--------------------------------------------------------------------------






