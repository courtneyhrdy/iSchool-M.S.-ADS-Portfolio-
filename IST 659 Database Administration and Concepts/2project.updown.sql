
if not exists(select * from sys.databases where name = 'icba659')
    create database icba659

GO

use icba659

GO 

--DOWN 

if exists(select * from sys.foreign_keys where name = 'fk_icba_bank_contacts_contact_bank_id')
    alter table icba_bank_contacts drop constraint fk_icba_bank_contacts_contact_bank_id

if exists(select * from sys.foreign_keys where name = 'fk_icba_portfolios_portfolio_bank_id')
    alter table icba_bank_portfolios drop constraint fk_icba_portfolios_portfolio_bank_id

if exists(select * from sys.foreign_keys where name = 'fk_icba_portfolios_portfolio_bank_contact_id')
    alter table icba_bank_portfolios drop constraint fk_icba_portfolios_portfolio_bank_contact_id

if exists(select * from sys.foreign_keys where name = 'fk_icba_portfolios_portfolio_bank_analysts_id')
    alter table icba_bank_portfolios drop constraint fk_icba_portfolios_portfolio_bank_analysts_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME = 'fk_promotions_promotion_id')
    alter table portfolio_promotions drop constraint fk_promotions_promotion_id

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    where CONSTRAINT_NAME = 'fk_portfolios_portfolio_id')
    alter table portfolio_promotions drop constraint fk_portfolios_portfolio_id

if exists(select * from sys.objects where name='p_icba_portfolio_bank')
	drop view p_icba_portfolio_bank
if exists(select * from sys.objects where name='icba_bank_portfolios')
	drop table icba_bank_portfolios
if exists(select * from sys.objects where name='icba_bank_contacts')
	drop table icba_bank_contacts
if exists(select * from sys.objects where name='icba_banks')
	drop table icba_banks
if exists(select * from sys.objects where name='icba_analysts')
	drop table icba_analysts
if exists(select * from sys.objects where name='icba_promotions')
	drop table icba_promotions
if exists(select * from sys.objects where name='portfolio_promotions')
	drop table portfolio_promotions 
GO
 

--UP
CREATE TABLE [dbo].[icba_banks](
	[bank_id] [int] NOT NULL,
	[bank_name] [varchar](50) NOT NULL,
	[bank_city] [varchar](50) NOT NULL,
	[bank_state] [varchar](2) NOT NULL,
 CONSTRAINT [pk_icba_banks_bank_id] PRIMARY KEY ([bank_id] )
)
GO 
create table icba_bank_contacts 
(
    bank_contact_id int identity not null,
    bank_contact_firstname varchar(50) not null, 
    bank_contact_lastname varchar(50) not null, 
    bank_contact_email varchar(50) not null, 
    bank_contact_number varchar(10) not null, 
    bank_contact_bank_id int not NULL,
    constraint pk_icba_bank_contacts_contact_id primary key (bank_contact_id), 
    constraint fk_icba_bank_contacts_contact_bank_id foreign key (bank_contact_bank_id) references icba_banks(bank_id)
)
GO 
create table icba_analysts 
(
    analyst_id int not null, 
    analyst_firstname varchar(50) not null, 
    analyst_lastname varchar(50) not null, 
    analyst_email varchar(50) not null, 
    analyst_number varchar(10) not null
    constraint pk_icba_analysts_analyst_id primary key (analyst_id)
)
GO
create table icba_bank_portfolios
(
	portfolio_id int identity not null,
    portfolio_bank_id int not null,
    portfolio_bank_contact_id int not null, 
    portfolio_assigned_bank_id int null,
    portfolio_total_number_consumer_checking_acct int not null,
    portfolio_total_number_business_checking_acct int not null,
    portfolio_cofi int not null, 
    portfolio_cc_expense int not null, 
    portfolio_q1 varchar(max) not null, 
    portfolio_q2 varchar(max) not null,
    promotion_option_visa bit, 
    promotion_option_mastercard bit, 
    promotion_option_employee_benefits bit, 
    promotion_option_internal bit,
	constraint pk_icba_portfolios_portfolio_id primary key (portfolio_id),
	constraint fk_icba_portfolios_portfolio_bank_id foreign key (portfolio_bank_id) references icba_banks(bank_id),
    CONSTRAINT fk_icba_portfolios_portfolio_bank_contact_id foreign key (portfolio_bank_contact_id) references icba_bank_contacts(bank_contact_id), 
    CONSTRAINT fk_icba_portfolios_portfolio_assigned_bank_id foreign key (portfolio_assigned_bank_id) references icba_banks(bank_id)
)
GO


create view p_icba_portfolio_bank as 
    select p.*, b.*
    from icba_bank_portfolios p 
    join icba_banks b on p.portfolio_bank_id = b.bank_id

GO 
select * from p_icba_portfolio_bank

GO
create table icba_promotions 
(
    promotion_id int not null, 
    promotion_option_visa varchar(20) null, 
    promotion_option_mastercard varchar(20) null, 
    promotion_option_employee_benefits varchar(20) null, 
    promotion_option_internal varchar(20) null,
    constraint pk_icba_promotions_promotion_id primary key (promotion_id)
)
GO

create table portfolio_promotions 
(
    portfolio_id int not null, 
    promotion_id int not null,
    constraint pk_portfolios_portfolio_promotion_id primary key (portfolio_id, promotion_id)
    
)
GO

alter table portfolio_promotions 
    add constraint fk_portfolios_portfolio_id foreign key (portfolio_id)
    references icba_bank_portfolios(portfolio_id)

alter table portfolio_promotions
    add constraint fk_promotions_promotion_id foreign key (promotion_id)
    references icba_promotions (promotion_id)


INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (1, 'Union Bank', 'Washington', 'DC')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (2, 'Georgetown Bank', 'Washington', 'DC')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (3, 'Spring Valley Bank', 'Bethesda', 'MD')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (4, 'National Capital Bank', 'Rockville', 'MD')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (5, 'NOVA Bank', 'Arlington', 'VA')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (6, 'Great Falls Bank', 'McLean', 'VA')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (7, 'Anacostia Bank', 'Washington', 'DC')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (8, 'Capitol Hill Bank', 'Washington', 'DC')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (9, 'Montgomery Bank', 'Bethesda', 'MD')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (10, 'Wheaton Bank', 'Rockville', 'MD')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (11, 'Pentagon City Bank', 'Arlington', 'VA')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (12, 'Langley Bank', 'McLean', 'VA')
INSERT [dbo].[icba_banks] ([bank_id], [bank_name], [bank_city], [bank_state]) VALUES (13, 'CCS Bank', 'McLean', 'VA')

INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (1, 'Jamie', 'Smith', 'gs@icba.com', '202235690')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (2, 'Dorothy', 'King', 'dk@icba.com', '2029876433')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (3, 'Michelle', 'Lire', 'ml@icba.com', '2029341234')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (4, 'Kevin', 'Kullen', 'kk@icba.com', '2029023489')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (5, 'Kyle', 'Tyler', 'kt@icba.com', '2021094321')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (6, 'Kate', 'Taylor', 'kt@icba.com', '2029083456')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (7, 'Brady', 'George', 'bg@icba.com', '2029043215')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (8, 'Joseph', 'Curry', 'jc@icba.com', '2020985678')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (9, 'Olivia', 'Peters', 'bb@icba.com', '2021543298')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (10, 'Martha', 'Washington', 'mw@icba.com', '2020945672')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (11, 'Virginia', 'Brothers', 'vb@icba.com', '2020934561')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (12, 'Grace', 'Opp', 'go@icba.com', '2028905432')
INSERT [dbo].[icba_analysts] ([analyst_id], [analyst_firstname], [analyst_lastname], [analyst_email], [analyst_number]) VALUES (13, 'Hannah', 'Williams', 'hw@icba.com', '2028903456')


INSERT [dbo].[icba_promotions] ([promotion_id], [promotion_option_visa], [promotion_option_mastercard], [promotion_option_employee_benefits], [promotion_option_internal]) VALUES (1, 'VISA', 'MASTERCARD', 'EMPLOYEE BENEFITS', 'INTERNAL')

select * from icba_banks

select * from icba_analysts

select * from icba_promotions 

select * from icba_bank_contacts 