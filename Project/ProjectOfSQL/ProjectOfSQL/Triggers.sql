Create Trigger Prevent_Update_in_Answer
on Answer
instead of Update
as 
begin
print  'you can not Allow to Change  in this table'
end


Create trigger Delate_More_Question_Data
on  [dbo].[Question_Exam]
after Delete
as 
begin
print  'You Are Lose Data from Tables Answer and Qusestions'
end