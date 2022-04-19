----------Creating DataBase-----------------
create database ExamSystem
------------------To Add FileGroups---------------------------
alter database ExamSystem 
add filegroup ExamUsers
alter database ExamSystem 
add filegroup Exam_File
alter database ExamSystem 
add filegroup Course_File
----------------------------
alter database ExamSystem 
add file 
(
	Name = StdFile,
	Filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\StdFile.ndf',
	SIZE = 20,
	MAXSIZE=100,
	FILEGROWTH=50
)to filegroup ExamUsers

alter database ExamSystem 
add file 
(
	Name = INSFile,
	Filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\INSFile.ndf',
	SIZE = 20,
	MAXSIZE=100,
	FILEGROWTH=50
)to filegroup ExamUsers

alter database ExamSystem 
add file 
(
	Name = CourseInfo,
	Filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\CourseInfo.ndf',
	SIZE = 20,
	MAXSIZE=100,
	FILEGROWTH=50
)to filegroup Course_File

alter database ExamSystem 
add file 
(
	Name = ExamInfo,
	Filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ExamInfo.ndf',
	SIZE = 20,
	MAXSIZE=100,
	FILEGROWTH=50
)to filegroup Exam_File
------------------------------------------------
alter database ExamSystem 
add file 
(
	Name = Exam_log,
	Filename ='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Exam_log.ldf',
	SIZE = 20,
	MAXSIZE=100,
	FILEGROWTH=50
)
------------------------ Creating Tables-------------------------
create table Student 
(
	S_ID int primary key identity(1,1),
	S_Name nvarchar(50),
	S_email nvarchar(50),
	S_password nvarchar(50),
	S_Age int,
	S_Address nvarchar(50)
)on ExamUsers

create table Instructor 
(
	I_ID int primary key identity(1,1),
	I_Name nvarchar(50),
	I_email nvarchar(50),
	I_password nvarchar(50),
	I_Age int,
	I_Address nvarchar(50),
	I_Phone nvarchar(11)
)on ExamUsers


create table Course 
(
	C_ID int primary key ,
	C_Name nvarchar(50),
	C_MaxDegree int,
	C_MinDegree int,
	C_Description nvarchar(50),
	I_ID int
	constraint Course_INS_FK foreign key (I_ID) references Instructor(I_ID)
)on Course_File
--------------------------------------------------------------
create table Exam_Details
(
	ED_ID int primary key,
	TotalDegree int,
	StartTime datetime not null,
	EndTime datetime not null,
	ExamType nvarchar(100) not null default 'Exam' check(ExamType in ('Exam','Corrective'))
	)on Exam_File
----------------------------------------------------------------
create table Exam
(
	E_ID int,
	C_ID int,
	I_ID int,
	[Year] date 
	constraint EX_PK primary key (E_ID,C_ID,I_ID),
	constraint E_EDetails_FK foreign key (E_ID) references Exam_Details(ED_ID),
	constraint E_Course_FK foreign key (C_ID) references Course(C_ID),
	constraint E_INS_FK foreign key (I_ID)references Instructor(I_ID) 
)on Exam_File
-----------------------------------------------------------------------------
create table Question 
(
	Q_ID int primary key identity(1,1),
	Q_Type nvarchar(200) default 'MCQ' check(Q_Type in('T&F','MCQ')),
	Q_Name nvarchar(MAX),
	Q_option1 nvarchar(50),
	Q_option2 nvarchar(50),
	Q_option3 nvarchar(50),
	Q_option4 nvarchar(50),
	Q_Degree int,
	CorrectAnswer nvarchar(MAX)
)on Exam_File
------------------------------------------------------------------------
create table Answer
(
	A_ID int identity(1,1) primary key,
	Student_Answer nvarchar(Max) not null,
	Q_id int not null,
	S_id int not null
	constraint Answer_Question_FK foreign key (Q_id) references Question(Q_ID),
	constraint Answer_Student_FK foreign key (S_id) references Student(S_ID),
)on Exam_File
-------------------------------------------------------------------------
create table Course_Student 
(
	St_id int,
	Course_id int,
	Course_result int,
	Statue nvarchar(50) not null check(Statue in('Pass','Faild','Not'))default 'Not'
	constraint Student_Course_PK primary key (St_id,Course_id),
	constraint SC_Student_FK foreign key (St_id) references Student(S_ID),
	constraint SC_Course_FK foreign key (Course_id) references Course(C_ID)
)on Course_File
-----------------------------------------------------------------------------------
create table Student_Exam 
(
	St_id int,
	E_id int,
	Exam_Result int
	constraint Student_Exam_PK primary key (St_id,E_id),
	constraint SE_Student_FK foreign key (St_id) references Student(S_ID),
	constraint SE_Exam_FK foreign key (E_id) references Exam_Details(ED_ID)
)on Exam_File
-----------------------------------------------------------------------------------
create table INS_Question
(
	id int primary key,
	actionType nvarchar(50) check (actionType in ('add','delete','update')) default ('add'),
	actiondate datetime,
	Q_id int ,
	Ins_id int,
	constraint INSQ_Question_FK foreign key (Q_id) references Question(Q_ID),
	constraint INSQ_Instructor_FK foreign key (Ins_id) references Instructor(I_ID)
)on Exam_File
-----------------------------------------------------------------------------------------
create table Question_Exam 
(
	Q_id int,
	E_id int,
	Question_degree int,
	constraint QE_PK primary key (Q_id,E_id),
	constraint QE_Question_FK foreign key (Q_id) references Question(Q_ID),
	constraint QE_Exam_FK foreign key (E_id) references Exam_Details(ED_ID),

)on Exam_File
------------------------------------- Create Some Stored procedures ----------------------------------------------------------
--==> Num 1
Create procedure [dbo].[Insert_To_Course] (@id int,@name nvarchar(50),@MaxDegree int,@MinDegree int,@Desc nvarchar(50),@ins_id int)
as
begin
	--declare @test bit
	if((select [I_ID] from [dbo].[Course] where [I_ID]=@ins_id)=0)
	begin
			insert into[dbo].[Course] values(@id,@name,@MaxDegree,@MinDegree,@Desc,@ins_id)
	end
	else
	begin
			print 'This instructor Just teach this course'
	end
end

-----------------------------------------------------------------
--==> Num 2 
Create procedure [dbo].[Insert_To_INS] (@std_name nvarchar(50),@email nvarchar(50),@pass nvarchar(50),@age int,@address nvarchar(50),@phone nvarchar(11))
as
begin
	insert into [dbo].[Instructor] values(@std_name,@email ,@pass,@age,@address,@phone)
end
-----------------------------------------------------------------------------
--==> Num 3
create procedure [dbo].[Insert_To_Student] (@std_name nvarchar(50),@email nvarchar(50),@pass nvarchar(50),@age int,@address nvarchar(50))
as
begin
	insert into [dbo].[Student] values(@std_name,@email ,@pass,@age,@address)
end
-------------------------------------------------------------------------------
---==>Num4
create procedure [dbo].[Student_regist_Course] (@Std_id int, @Course_id int )
as
begin
      if ((Select count([St_id]) from [dbo].[Course_Student] Where [St_id] =@Std_id and [Course_id]=@Course_id)=0)
	  begin
      insert into [dbo].[Course_Student]([dbo].[Course_Student].[St_id],[dbo].[Course_Student].Course_id) Values (@Std_id,@Course_id)
	  end
	  else
	  begin
	       print 'This Student Just registered That Course ';
	  end
end
--------------------------------------------------------------------------------------
--==>Num 5
create procedure AddingQuestion_sp(@ins_id int,@Q_id int,@Q_ActionType nvarchar(50),@Q_Name nvarchar(50),@Q_p1 nvarchar(50),@Q_p2 nvarchar(50),@Q_p3 nvarchar(50),@Q_p4 nvarchar(50),@Q_Answer nvarchar(50) ,@Cours_id int,@Q_Degree int)
as 
begin
	if ((select count(Course.C_ID) from [dbo].[Course] Where Course.C_ID=@Cours_id and Course.I_ID=@ins_id)>0 )
	begin
		if((select count(Question.Q_ID) from [dbo].[Question] Where Question.Q_ID=@Q_id) =0 )
		begin
			insert into [dbo].[Question] Values (@Q_id ,@Q_ActionType ,@Q_Name ,@Q_p1 ,@Q_p2 ,@Q_p3,@Q_p4,@Q_Degree,@Q_Answer)
			 insert into [dbo].[INS_Question] (Q_id,Ins_id,actionType,actiondate) Values (@Q_id,@ins_id,'Add',getDate())
		end
		else
		begin
			print 'This Question Just Found'
		end
	end
	else
	begin
		print 'This Instructor Not Allowed to Add in This Course'
	end
end
----------------------------------------------------------------------
--==>Num 6
create procedure UpdatingQuestion_sp(@ins_id int,@Q_id int,@Q_ActionType nvarchar(50),@Q_Name nvarchar(50),@Q_p1 nvarchar(50),@Q_p2 nvarchar(50),@Q_p3 nvarchar(50),@Q_p4 nvarchar(50),@Q_Answer nvarchar(50) ,@Cours_id int,@Q_Degree int)
as 
begin
	if ((select count(Course.C_ID) from [dbo].[Course] Where Course.C_ID=@Cours_id and Course.I_ID=@ins_id)>0 )
	begin
		if((select count(Question.Q_ID) from [dbo].[Question] Where Question.Q_ID=@Q_id) =0 )
		begin
			update  [dbo].[Question] set[Q_ID] = @Q_id ,[Q_Type]=@Q_ActionType ,Q_Name=@Q_Name ,Q_option1=@Q_p1 ,Q_option2=@Q_p2 ,Q_option3=@Q_p3,Q_option4=@Q_p4,[CorrectAnswer]= @Q_Answer 
			 insert into [dbo].[INS_Question] (Q_id,Ins_id,actionType,actiondate) Values (@Q_id,@ins_id,'Update',getDate())
		end
		else
		begin
			print 'This Question Just Found'
		end
	end
	else
	begin
		print 'This Instructor Not Allowed to Add in This Course'
	end
end
---------------------------------------------------------------------------------------
--==>Num7
create procedure DeletingQuestion(@ins_id int,@Q_id int,@Cours_id int)
as
begin
      if ((select count(Course.C_ID) from Course Where Course.C_ID=@Cours_id and Course.I_ID=@ins_id)>0 )
		begin
		     if((select count(Question.Q_ID) from Question Where[dbo].[Question].[C_id] =@Cours_id) >0 )
               begin

			   	 Delete from Answer   where Q_id=@Q_id;
		         Delete from INS_Question   where INS_Question.Q_id=@Q_id ;
				  Delete from Question  Where Q_ID= @Q_id  
				end
               else
			   begin
			        print 'This Questions in not in your Teatch Course  '
			   end
		end
	  else 
		begin
				print 'You Are not Allow To Delete Questions in this Course '
		end
end
------------------------------------------------------------------------------------------------
--==>Num 8
Create proc add_new_exam (@instractor_id int ,@course_id int ,@Exam_id int ,@year date,@start_time datetime,@end_time datetime ,@Exam_type nvarchar(50) ,@total_time datetime)
as
begin
declare @total_degree int 
set @total_degree= (select C_MaxDegree from Course Where C_ID=@course_id)
        if ((select COUNT(C_ID) from Course where C_ID =@course_id and I_ID=@instractor_id)>0)
		begin
		     if (@start_time>Getdate() and @end_time>@start_time) 
			 begin
			  insert into Exam_Details Values (@Exam_id,@total_degree,@start_time,@end_time,@Exam_type)
			  insert into Exam Values (@Exam_id,@course_id,@instractor_id,@year)
			 end
			 else 
			 begin
			  print 'You Have Error in Start Or End  Time Of The Exam '
			 end

		end
		else 
		begin
		print 'You Are Not Allow to Add Exams In This Course '
		end

end 
-----------------------------------------------------
--==>Num9
Create proc Calculate_Result(@Question_ID int,@Student_ID int,@Exam_ID int)
as
begin
declare @min_degree int, @Cours_ID int, @Question_Degree int, @Question_Answer nvarchar(200),@Student_Answer nvarchar(200),@result int,@Total_Result int,@statue nvarchar(20);
set @Question_Degree=( select Question_degree from Question_Exam Where E_id=@Exam_ID and Q_id=@Question_ID  )
set @Question_Answer=(select Question.CorrectAnswer from Question where Question.Q_ID=@Question_ID)
set @Student_Answer=(select Student_Answer from Answer where S_id=@Student_ID and Q_id=@Question_ID )
set @result=(select Exam_Result  from Student_Exam where St_id=@Student_ID and E_id=@Exam_ID)
set @Cours_ID =(Select C_ID from Exam Where E_ID=@Exam_ID)
set @statue =(select Statue from Course_Student,Exam where St_id=@Student_ID  and  Course_ID=@Cours_ID)
set @min_degree=(select C_Mindegree from Course where   C_ID=@Cours_ID)
if(@Question_Answer=@Student_Answer)
begin
set @Total_Result=@result+ @Question_Degree
 end
else
begin
set @Total_Result=@result
end
if( @Total_Result<@min_degree)
   begin
   set @statue='faild'
   end
   else 
   begin
    set @statue='pass'
   end
   update Student_Exam set Student_Exam.Exam_Result=@Total_Result where Student_Exam.St_id=@Student_ID and Student_Exam.E_id=@Exam_ID 
update Course_Student set Course_Student.Course_result=@Total_Result ,Statue=@statue where Course_Student.St_id=@Student_ID and Course_Student.Course_id=@Cours_ID
end
-------------------------------------------------------------------------------------
--==>Num 10
Create proc disply_Result_Student (@Student_id int )
as
begin
 select * from student ,Course_Student Where S_ID=@Student_id and Course_Student.St_id=@Student_id
end
--------------------------------------------------
--==>Num11
Create proc disply_Result_Course(@Course_id int )
as
begin
      select * from  course Right join student on Course.C_id=@Course_id
end
--------------------------------------------------
--==>Num 12
Create proc Add_Answer (@Student_id int, @Question_id int,@Answer nvarchar(200) )
as
begin
      
      if ((select count (Q_id) from Answer where Q_id=@Question_id and S_id=@Student_id )=0)
     begin
         insert into Answer (Student_Answer ,Q_id,S_id) Values (@Answer,@Question_id,@Student_id)
      end 
     else 
     begin
	   update Answer set Student_Answer =@Answer where  Q_id=@Question_id and S_id=@Student_id 
     end 
end
-----
---------------------------------------------------------------------
--==> Num 13
create procedure set_Questiont_in_Exam(@Exam_id int,@instractor_id int,@Course_id int ,@Q_id int ,@Q_degree int)
as 
begin
declare @E_Totaldegree int,@Current_Total int
set @Current_Total =(select sum(Question_degree) from Question_Exam Where E_id=@Exam_id )
if ((select count(Question_degree) from Question_Exam Where E_id=1) =0)begin  set @Current_Total=0 end 
set @E_Totaldegree=(select TotalDegree from Exam_Details Where ED_ID=@Exam_id)
           if ((select COUNT(c_id) from course where C_id =@course_id and I_id=@instractor_id)>0)
		   begin
		        if ((select COUNT(c_id) from  Exam where C_id =@course_id and I_ID=@instractor_id and E_ID=@Exam_id )>0)
		        begin 
				  if((select count(Q_ID) from Question where Q_ID=@Q_id and C_Id=@Course_id)>0)
				  begin
				      if((select count(Q_id) from Question_Exam where E_id=@Exam_id and Q_id=@Q_id)=0)
					  begin
				        if(@E_Totaldegree>(@Current_Total+@Q_degree))
						   begin
				           insert into Question_Exam Values (@Exam_id,@Q_id,@Q_degree)
						    print ('you must enter Questions degrees  = '+ CONVERT(VARCHAR, (@E_Totaldegree -@Current_Total-@Q_degree)))
						   end
						else
						begin
						     if(@E_Totaldegree=(@Current_Total+@Q_degree))
							    begin
							      insert into Question_Exam Values (@Exam_id,@Q_id,@Q_degree)
							      print 'oK Dont add Question agine'
							    end
							  else 
						        begin
			                       print 'Total Degree of Exam_id ='+ CONVERT(VARCHAR, @Exam_id)+' is '+ CONVERT(VARCHAR, @E_Totaldegree) +'your Question in this course after adddind this Question is '+ CONVERT(VARCHAR,(@Current_Total+@Q_degree))
						           print 'you must enter Questions degrees  = '+ CONVERT(VARCHAR, (@E_Totaldegree-@Current_Total))
						        end
						  end
				      end 
					  else
					  begin
					        print 'That Question Already Found in The Exam '
					  end
				  end
				      else
				       begin
				       print 'You Are Not Allow to deal whith  This Question'
				       end
		        end
				else
				begin
				    print 'You Are Not Allow to deal whith  This Exam '
				end
		   end
		   else 
		   begin
		       print 'You Are Not Allow to deal whith In This Course '
		   end
end

---------------------------------------------------------------------
--==> Num 14
create procedure set_Random_Questions_in_Exam(@Exam_id int,@instractor_id int,@Course_id int,@count_Questions int )
as 
begin
declare @E_Totaldegree int,@Current_Total int ,@Q_degree float 
declare @Current_ExamQuestions table(Question_id int)
insert into @Current_ExamQuestions select Q_id from Question_Exam Where E_id=@Exam_id 
set @Current_Total =(select sum(Question_degree) from Question_Exam Where E_id=@Exam_id )
if ((select count(Question_degree) from Question_Exam Where E_id=1) =0)begin  set @Current_Total=0 end 
set @E_Totaldegree=(select TotalDegree from Exam_Details Where ED_ID=@Exam_id)

		if ((select COUNT(c_id) from course where C_id =@course_id and I_id=@instractor_id)>0)
		begin
		      if ((select COUNT(c_id) from  Exam where C_id =@course_id and I_ID=@instractor_id and E_ID=@Exam_id )>0)
			  begin
			       if(@E_Totaldegree=@Current_Total)
				   begin
				   print 'You Cantnot Add Question :->The Sum Degrees Of Question In Your Exam Equal Total Degree Of The Exam '
				   end
				   else 
				   begin

				   set @Q_degree =(@E_Totaldegree-@Current_Total)/@count_Questions
				   insert into  Question_Exam  select top(@count_Questions) @Exam_id,Question.Q_ID,@Q_degree  from Question , @Current_ExamQuestions  Where Question.Q_ID != [@Current_ExamQuestions].Question_id and  C_id=@Course_id ORDER BY NEWID()
				   end
			  end
			  else
			  begin
			       print 'You Are Not Allow to deal whith  This Exam '
			  end
		end
		else
		begin
			print 'You Are Not Allow to deal whith In This Course '
		end
end
---------------------------------------------------------------------------------
ALTER proc [dbo].[add_new_exam] (@instractor_id int ,@course_id int ,@Exam_id int ,@year date,@start_time datetime,@end_time datetime ,@Exam_type nvarchar(50) ,@total_time datetime,@track nvarchar(50),@Branch nvarchar(50))
as
begin
declare @total_degree int 
set @total_degree= (select C_MaxDegree from Course Where C_ID=@course_id)
        if ((select COUNT(C_ID) from Course where C_ID =@course_id and I_ID=@instractor_id)>0)
		begin
		     if (@start_time>Getdate() and @end_time>@start_time) 
			 begin
			  insert into Exam_Details Values (@Exam_id,@total_degree,@start_time,@end_time,@Exam_type)
			  insert into Exam Values (@Exam_id,@course_id,@instractor_id,@year,@track,@Branch)
			 end
			 else 
			 begin
			  print 'You Have Error in Start Or End  Time Of The Exam '
			 end

		end
		else 
		begin
		print 'You Are Not Allow to Add Exams In This Course '
		end

end 

alter table [dbo].[Exam] add branch nvarchar(50)