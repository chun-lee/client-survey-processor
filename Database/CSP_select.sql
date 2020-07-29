
select * from Organisation
select * from Users
select * from CSP_Question
select * from CSP_V_Category order by category
select * from CSP_Survey
select * from CSP_Survey_User
select * from CSP_Survey_User where survey_id = 1
select * from CSP_Response

-- VIEW SURVEY RESULTS
-- One row per question per user
select
	su.email, q.question, r.score, r.comment,
	r.v_itrs_good,		r.v_itrs_passive,	 r.v_itrs_poor,
	r.v_product_good,	r.v_product_passive, r.v_product_poor,
	r.v_support_good,	r.v_support_passive, r.v_support_poor,
	r.v_docs_good,		r.v_docs_passive,	 r.v_docs_poor
from CSP_Response r
join CSP_Survey_User su on r.survey_user_id = su.id
join CSP_Question q on r.question_id = q.id
join CSP_Survey s on su.survey_id = s.id
where s.id = 1

-- VIEW SURVEYS FOR USER
-- One row per survey responded to
select su.email, s.name, su.end_date
from CSP_Survey_User su
join CSP_Survey s on su.survey_id = s.id
where su.email = 'louis.louca@db.com'
