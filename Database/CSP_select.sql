
select * from Organisation
select * from Users
select * from CSP_Question
select * from CSP_Survey
select * from CSP_Survey_User
select * from CSP_Response

select su.email, q.question, r.score, r.comment
from CSP_Response r
join CSP_Survey_User su on r.survey_user_id = su.id
join CSP_Question q on r.question_id = q.id
join CSP_Survey s on su.survey_id = s.id
where s.id = '49'
