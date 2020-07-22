
select * from Organisation
select * from Users
select * from CSP_Question
select * from CSP_Survey
select * from CSP_Survey_User
select * from CSP_Response

-- VIEW SURVEY RESULTS
-- One row per question per user
select su.email, q.question, r.score, r.comment, r.v_docs_good, r.v_itrs_good
from CSP_Response r
join CSP_Survey_User su on r.survey_user_id = su.id
join CSP_Question q on r.question_id = q.id
join CSP_Survey s on su.survey_id = s.id
where s.name = '181018 ITRS Client Survey Analysis Sep18'

-- VIEW SURVEYS FOR USER
-- One row per survey responded to
select distinct su.email, s.name, su.end_date
from CSP_Survey_User su
join CSP_Survey s on su.survey_id = s.id
where su.email = 'louis.louca@db.com'
