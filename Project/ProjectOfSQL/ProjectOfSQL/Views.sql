create view Show_all_instructors
as
(
select * from Instructor 
)
select * from Show_all_instructors

create view Show_all_courses
as
(
select * from Course 
)
select * from Show_all_courses

--2->Show all Exams data
Create view Show_all_exams
as
(
select * from Exam_Details 
)
select * from show_all_exams

