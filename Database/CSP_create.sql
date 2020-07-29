USE [Zendesk]
GO


/********************
	DROP CONSTRAINTS
*********************/
ALTER TABLE [dbo].[CSP_Survey] DROP CONSTRAINT [DF_CSP_Survey_type_annual]
GO

ALTER TABLE [dbo].[CSP_Survey_User] DROP CONSTRAINT [FK_CSP_Survey_User_Users]
GO

ALTER TABLE [dbo].[CSP_Survey_User] DROP CONSTRAINT [FK_CSP_Survey_User_CSP_Survey]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_Survey_User]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_Question]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_good]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_passive]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_poor]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_good]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_passive]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_poor]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_good]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_passive]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_poor]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_good]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_passive]
GO

ALTER TABLE [dbo].[CSP_Response] DROP CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_poor]
GO


/********************
	DROP TABLES
*********************/
DROP TABLE [dbo].[CSP_Survey]
GO

DROP TABLE [dbo].[CSP_Survey_User]
GO

DROP TABLE [dbo].[CSP_Question]
GO

DROP TABLE [dbo].[CSP_Response]
GO

DROP TABLE [dbo].[CSP_V_Category]
GO


/********************
	CREATE TABLES
*********************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CSP_Survey](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[upload_date] [datetime] NOT NULL,
	[type_annual] [bit] NOT NULL,
 CONSTRAINT [PK_CSP_Survey] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[CSP_Survey_User](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[survey_id] [int] NOT NULL,
	[user_id] [bigint] NULL,
	[email] [nvarchar](200) NOT NULL,
	[end_date] [datetime] NOT NULL,
 CONSTRAINT [PK_CSP_Survey_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[CSP_Question](
	[id] [int] NOT NULL,
	[question] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_CSP_Question] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

CREATE TABLE [dbo].[CSP_V_Category](
	[id] [int] NOT NULL,
	[category] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CSP_V_Category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

CREATE TABLE [dbo].[CSP_Response](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[survey_user_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
	[score] [tinyint] NULL,
	[comment] [nvarchar](max) NULL,
	[v_itrs_good] [int] NULL,
	[v_itrs_passive] [int] NULL,
	[v_itrs_poor] [int] NULL,
	[v_product_good] [int] NULL,
	[v_product_passive] [int] NULL,
	[v_product_poor] [int] NULL,
	[v_support_good] [int] NULL,
	[v_support_passive] [int] NULL,
	[v_support_poor] [int] NULL,
	[v_docs_good] [int] NULL,
	[v_docs_passive] [int] NULL,
	[v_docs_poor] [int] NULL,
 CONSTRAINT [PK_CSP_Response] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


/********************
	ADD CONSTRAINTS
*********************/
ALTER TABLE [dbo].[CSP_Survey] ADD  CONSTRAINT [DF_CSP_Survey_type_annual]  DEFAULT ((1)) FOR [type_annual]
GO

ALTER TABLE [dbo].[CSP_Survey_User]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Survey_User_CSP_Survey] FOREIGN KEY([survey_id])
REFERENCES [dbo].[CSP_Survey] ([id])
GO
ALTER TABLE [dbo].[CSP_Survey_User] CHECK CONSTRAINT [FK_CSP_Survey_User_CSP_Survey]
GO

ALTER TABLE [dbo].[CSP_Survey_User]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Survey_User_Users] FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[CSP_Survey_User] CHECK CONSTRAINT [FK_CSP_Survey_User_Users]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_Question] FOREIGN KEY([question_id])
REFERENCES [dbo].[CSP_Question] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_Question]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_Survey_User] FOREIGN KEY([survey_user_id])
REFERENCES [dbo].[CSP_Survey_User] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_Survey_User]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_good] FOREIGN KEY([v_itrs_good])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_good]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_passive] FOREIGN KEY([v_itrs_passive])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_passive]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_poor] FOREIGN KEY([v_itrs_poor])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_itrs_poor]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_good] FOREIGN KEY([v_product_good])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_good]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_passive] FOREIGN KEY([v_product_passive])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_passive]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_poor] FOREIGN KEY([v_product_poor])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_product_poor]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_good] FOREIGN KEY([v_support_good])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_good]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_passive] FOREIGN KEY([v_support_passive])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_passive]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_poor] FOREIGN KEY([v_support_poor])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_support_poor]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_good] FOREIGN KEY([v_docs_good])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_good]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_passive] FOREIGN KEY([v_docs_passive])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_passive]
GO

ALTER TABLE [dbo].[CSP_Response]  WITH CHECK ADD  CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_poor] FOREIGN KEY([v_docs_poor])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO
ALTER TABLE [dbo].[CSP_Response] CHECK CONSTRAINT [FK_CSP_Response_CSP_V_Category_docs_poor]
GO


/********************
	ADD QUESTIONS
*********************/
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


/********************
	ADD CATEGORIES
*********************/
insert into CSP_V_Category values(1,'Hard to learn/use')
insert into CSP_V_Category values(2,'Bugs/crashes')
insert into CSP_V_Category values(3,'Roadmap/new features')
insert into CSP_V_Category values(4,'Support')
insert into CSP_V_Category values(5,'Price')
insert into CSP_V_Category values(6,'Documentation')
insert into CSP_V_Category values(7,'Performance')
insert into CSP_V_Category values(8,'Dashboards')
insert into CSP_V_Category values(9,'Bug resolution')
insert into CSP_V_Category values(10,'UI')
insert into CSP_V_Category values(11,'Difficult to get training')
insert into CSP_V_Category values(12,'Communication')
insert into CSP_V_Category values(13,'Trial support')
insert into CSP_V_Category values(14,'Sales')
insert into CSP_V_Category values(15,'Usability')
insert into CSP_V_Category values(16,'Best tool')
insert into CSP_V_Category values(17,'Flexibility')
insert into CSP_V_Category values(18,'Reliable')
insert into CSP_V_Category values(19,'Real time')
insert into CSP_V_Category values(20,'Automation')


