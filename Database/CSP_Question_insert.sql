begin tran
--

select * from CSP_Question

insert into CSP_Question values(1,'How likely is it that you would recommend ITRS Group to a friend or colleague?')
insert into CSP_Question values(2,'How satisfied are you with ITRS Geneos?')
insert into CSP_Question values(3,'How satisfied are you with ITRS OP5 Monitor?')
insert into CSP_Question values(4,'How satisfied are you with the quality of support you receive from ITRS Group?')
insert into CSP_Question values(5,'How satisfied are you with the revised online documentation at docs.itrsgroup.com?')
insert into CSP_Question values(6,'What would you like to see improved?')
insert into CSP_Question values(7,'How likely are you to buy from ITRS again?')
insert into CSP_Question values(8,'How well does ITRS products strategy and roadmap meet your business needs?')
insert into CSP_Question values(9,'How helpful do you find the online documentation at resources.itrsgroup.com?')
insert into CSP_Question values(10,'How useful is ITRS move to an open architecture product? (Well defined APIs and interfaces to integrate, extend and customise)')

select * from CSP_Question

--
rollback tran
commit tran
