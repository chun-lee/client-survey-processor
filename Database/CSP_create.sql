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

ALTER TABLE [dbo].[CSP_V_Analysis] DROP CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Category]
GO

ALTER TABLE [dbo].[CSP_V_Analysis] DROP CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Area]
GO

ALTER TABLE [dbo].[CSP_V_Analysis] DROP CONSTRAINT [FK_CSP_V_Analysis_CSP_Response]
GO


/********************
	DROP TABLES
*********************/
DROP TABLE [dbo].[CSP_Product$]
GO

DROP TABLE [dbo].[CSP_Survey]
GO

DROP TABLE [dbo].[CSP_Survey_User]
GO

DROP TABLE [dbo].[CSP_Question]
GO

DROP TABLE [dbo].[CSP_Response]
GO

DROP TABLE [dbo].[CSP_V_Area]
GO

DROP TABLE [dbo].[CSP_V_Category]
GO

DROP TABLE [dbo].[CSP_V_Analysis]
GO


/********************
	CREATE TABLES
*********************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CSP_Product$](
	[Company] [nvarchar](255) NULL,
	[Domain] [nvarchar](255) NULL,
	[Product] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL
) ON [PRIMARY]
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
	[deleted] [bit] NULL,
 CONSTRAINT [PK_CSP_Survey_User] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CSP_Question](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[question] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_CSP_Question] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[CSP_Response](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[survey_user_id] [int] NOT NULL,
	[question_id] [int] NOT NULL,
	[score] [tinyint] NULL,
	[comment] [nvarchar](max) NULL,
	[deleted] [bit] NULL,
 CONSTRAINT [PK_CSP_Response] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[CSP_V_Area](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[area] [nvarchar](20) NOT NULL,
	[opinion] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_CSP_V_Area] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CSP_V_Category](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[category] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_CSP_V_Category] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CSP_V_Analysis](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[response_id] [int] NOT NULL,
	[area_id] [int] NOT NULL,
	[category_id] [int] NOT NULL,
 CONSTRAINT [PK_CSP_V_Analysis] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
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

ALTER TABLE [dbo].[CSP_V_Analysis]  WITH CHECK ADD  CONSTRAINT [FK_CSP_V_Analysis_CSP_Response] FOREIGN KEY([response_id])
REFERENCES [dbo].[CSP_Response] ([id])
GO

ALTER TABLE [dbo].[CSP_V_Analysis] CHECK CONSTRAINT [FK_CSP_V_Analysis_CSP_Response]
GO

ALTER TABLE [dbo].[CSP_V_Analysis]  WITH CHECK ADD  CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Area] FOREIGN KEY([area_id])
REFERENCES [dbo].[CSP_V_Area] ([id])
GO

ALTER TABLE [dbo].[CSP_V_Analysis] CHECK CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Area]
GO

ALTER TABLE [dbo].[CSP_V_Analysis]  WITH CHECK ADD  CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Category] FOREIGN KEY([category_id])
REFERENCES [dbo].[CSP_V_Category] ([id])
GO

ALTER TABLE [dbo].[CSP_V_Analysis] CHECK CONSTRAINT [FK_CSP_V_Analysis_CSP_V_Category]
GO


/********************
	ADD QUESTIONS
*********************/
insert into CSP_Question values('How likely is it that you would recommend ITRS Group to a friend or colleague?')
insert into CSP_Question values('How satisfied are you with ITRS Geneos?')
insert into CSP_Question values('How satisfied are you with ITRS OP5 Monitor?')
insert into CSP_Question values('How satisfied are you with the quality of support you receive from ITRS Group?')
insert into CSP_Question values('How satisfied are you with the revised online documentation at docs.itrsgroup.com?')
insert into CSP_Question values('What would you like to see improved?')
insert into CSP_Question values('How likely are you to buy from ITRS again?')
insert into CSP_Question values('How well does ITRS products strategy and roadmap meet your business needs?')
insert into CSP_Question values('How helpful do you find the online documentation at resources.itrsgroup.com?')
insert into CSP_Question values('How useful is ITRS move to an open architecture product? (Well defined APIs and interfaces to integrate, extend and customise)')


/********************
	ADD AREAS
*********************/
insert into CSP_V_Area values('ITRS','Good')
insert into CSP_V_Area values('ITRS','Passive')
insert into CSP_V_Area values('ITRS','Poor')
insert into CSP_V_Area values('Product','Good')
insert into CSP_V_Area values('Product','Passive')
insert into CSP_V_Area values('Product','Poor')
insert into CSP_V_Area values('Support','Good')
insert into CSP_V_Area values('Support','Passive')
insert into CSP_V_Area values('Support','Poor')
insert into CSP_V_Area values('Docs','Good')
insert into CSP_V_Area values('Docs','Passive')
insert into CSP_V_Area values('Docs','Poor')


/********************
	ADD CATEGORIES
*********************/
insert into CSP_V_Category values('Hard to learn/use')
insert into CSP_V_Category values('Bugs/crashes')
insert into CSP_V_Category values('Roadmap/new features')
insert into CSP_V_Category values('Support')
insert into CSP_V_Category values('Price')
insert into CSP_V_Category values('Documentation')
insert into CSP_V_Category values('Performance')
insert into CSP_V_Category values('Dashboards')
insert into CSP_V_Category values('Bug resolution')
insert into CSP_V_Category values('UI')
insert into CSP_V_Category values('Difficult to get training')
insert into CSP_V_Category values('Communication')
insert into CSP_V_Category values('Trial support')
insert into CSP_V_Category values('Sales')
insert into CSP_V_Category values('Usability')
insert into CSP_V_Category values('Best tool')
insert into CSP_V_Category values('Flexibility')
insert into CSP_V_Category values('Reliable')
insert into CSP_V_Category values('Real time')
insert into CSP_V_Category values('Automation')
insert into CSP_V_Category values('General')
insert into CSP_V_Category values('Outdated/behind')
insert into CSP_V_Category values('Examples')
insert into CSP_V_Category values('Licensing')
