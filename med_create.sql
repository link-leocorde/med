use master
go

create database med
go

use med
go

/****************
* CREATE SCHEMA *
****************/

create schema hist;
go

create schema ref;
go

create schema xwlk;
go

--Person Status
create table ref.PersonStatus (
	PersonStatusId int identity not null
	,StatusCode varchar(25) not null
	,StatusDescription varchar(255)
	,constraint pk_PersonStatus_PersonStatusId primary key clustered (PersonStatusId)
	,constraint uq_PersonStatus_StatusCode unique (StatusCode)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonStatus));
go

--Person
create table dbo.Person (
	PersonId int identity not null
	,NPI bigint
	,IsProvider bit not null
	,PersonStatusId int
	,FirstName varchar(255)
	,MiddleName varchar(255)
	,LastName varchar(255)
	,DateOfBirth date
	,Photo varbinary(max)
	,Bio varchar(255)
	,Hyperlink varchar(255)
	,StartDate date not null
	,TermDate date
	,constraint pk_Person_PersonId primary key clustered (PersonId)
	,constraint fk_Person_PersonStatusId foreign key (PersonStatusId)
	references ref.PersonStatus (PersonStatusId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Person));
go

--Person Education
create table dbo.PersonEducation (
	PersonEducationId int identity not null
	,PersonId int
	,Institution varchar(255)
	,Degree varchar(255)
	,EffectiveDate date
	,constraint pk_PersonEdication_PersonEducationId primary key clustered (PersonEducationId)
	,constraint uq_PersonEducation_NoDups unique (PersonId,Institution,Degree,EffectiveDate)
	,constraint fk_PersonEducation_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonEducation));
go

--Person Credential
create table dbo.PersonCredential (
	PersonCredentialId int identity not null
	,PersonId int
	,CredentialCode varchar(25)
	,CredentialDescription varchar(255)
	,StartDate date not null
	,TermDate date
	,constraint pk_PersonEdication_PersonCredentialId primary key clustered (PersonCredentialId)
	,constraint fk_PersonCredential_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on delete set null
	on update cascade
	,constraint uq_PersonCredential_PersonCredentialCode unique (PersonId,CredentialCode)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonCredential));
go

--Practice
create table dbo.Practice (
	PracticeId int identity not null
	,TIN bigint not null
	,NPI bigint
	,PracticeName varchar(255) not null
	,Website varchar(255)
	,StartDate date not null
	,TermDate date
	,constraint pk_Practice_PracticeId primary key clustered (PracticeId)
	,constraint uq_Practice_TIN unique (TIN)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Practice));
go

--TeleHealth
create table ref.TeleHealth (
	TeleHealthId int identity not null
	,TeleHealthName varchar(255) not null
	,TeleHealthDescription varchar(255)
	,constraint pk_TeleHealth_TeleHealthId primary key clustered (TeleHealthId)
	,constraint uq_TeleHealth_TeleHealthName unique (TeleHealthName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.TeleHealth));
go

--Location
create table dbo.[Location] (
	LocationId int identity not null
	,PracticeId int
	,TIN bigint
	,NPI bigint
	,LocationName varchar(255) not null
	,Street1 varchar(255)
	,Street2 varchar(255)
	,City varchar(255)
	,[State] varchar(2)
	,ZipCode varchar(10)
	,TeleHealthId int
	,StartDate date not null
	,TermDate date
	,constraint pk_Location_LocationId primary key clustered (LocationId)
	,constraint fk_Location_PracticeId foreign key (PracticeId)
	references dbo.Practice (PracticeId)
	on delete set null
	on update cascade
	,constraint fk_Location_TeleHealthId foreign key (TeleHealthId)
	references ref.TeleHealth (TeleHealthId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.[Location]));
go

--Location Schedule
create table dbo.LocationSchedule (
	LocationScheduleId int identity not null
	,LocationId int
	,[DayOfWeek] int
	,StartTime time
	,EndTime time
	,constraint pk_LocationSchedule_LocationScheduleId primary key clustered (LocationScheduleId)
	,constraint fk_LocationSchedule_LocationId foreign key (LocationId)
	references dbo.[Location] (LocationId)
	on delete set null
	on update cascade
	,constraint chk_LocationSchedule_DayOfWeek check ([DayOfWeek] between 1 and 7)
	,constraint uq_LocationSchedule_LocationDayOfWeek unique (LocationId,[DayOfWeek])
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.LocationSchedule));
go

--Specialty
create table ref.Specialty (
	SpecialtyId int identity not null
	,SpecialtyName varchar(255) not null
	,SpecialtyDescription varchar(255)
	,constraint pk_Specialty_SpecialtyId primary key clustered (SpecialtyId)
	,constraint uq_Specialty_SpecialtyName unique (SpecialtyName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Specialty));
go

--Specialty Type
create table ref.SpecialtyType (
	SpecialtyTypeId int identity not null
	,SpecialtyTypeName varchar(255) not null
	,SpecialtyTypeDescription varchar(255)
	,constraint pk_SpecialtyType_SpecialtyTypeId primary key clustered (SpecialtyTypeId)
	,constraint uq_SpecialtyType_SpecialtyTypeName unique (SpecialtyTypeName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.SpecialtyType));
go

--Location Specialty
create table xwlk.LocationSpecialty (
	LocationId int
	,SpecialtyId int
	,SpecialtyTypeId int
	,constraint pk_LocationSpecialty_LocationSpecialtyId primary key clustered (LocationId,SpecialtyId)
	,constraint fk_LocationSpecialty_LocationId foreign key (LocationId)
	references dbo.[Location] (LocationId)
	on update cascade
	,constraint fk_LocationSpecialty_SpecialtyId foreign key (SpecialtyId)
	references ref.Specialty (SpecialtyId)
	on update cascade
	,constraint fk_LocationSpecialty_SpecialtyTypeId foreign key (SpecialtyTypeId)
	references ref.SpecialtyType (SpecialtyTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.LocationSpecialty));
go

--Person Specialty
create table xwlk.PersonSpecialty (
	PersonId int
	,SpecialtyId int
	,SpecialtyTypeId int
	,constraint pk_PersonSpecialty_PersonSpecialtyId primary key clustered (PersonId,SpecialtyId)
	,constraint fk_PersonSpecialty_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on update cascade
	,constraint fk_PersonSpecialty_SpecialtyId foreign key (SpecialtyId)
	references ref.Specialty (SpecialtyId)
	on update cascade
	,constraint fk_PersonSpecialty_SpecialtyTypeId foreign key (SpecialtyTypeId)
	references ref.SpecialtyType (SpecialtyTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonSpecialty));
go

--Role
create table ref.[Role] (
	RoleId int identity not null
	,RoleName varchar(255) not null
	,RoleDescription varchar(255)
	,constraint pk_Role_RoleId primary key clustered (RoleId)
	,constraint uq_Role_RoleName unique (RoleName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.[Role]));
go

--Location People
create table xwlk.LocationPeople (
	LocationId int
	,PersonId int
	,RoleId int
	,constraint pk_LocationPeople_LocationPeopleId primary key clustered (LocationId,PersonId,RoleId)
	,constraint fk_LocationPeople_LocationId foreign key (LocationId)
	references dbo.[Location] (LocationId)
	on update cascade
	,constraint fk_LocationPeople_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on update cascade
	,constraint fk_LocationPeople_RoleId foreign key (RoleId)
	references ref.[Role] (RoleId)
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.LocationPeople));
go

--Contact Type
create table ref.ContactType (
	ContactTypeId int identity not null
	,ContactTypeName varchar(255) not null
	,ContactTypeDescription varchar(255)
	,constraint pk_ContactType_ContactTypeId primary key clustered (ContactTypeId)
	,constraint uq_ContactType_ContactTypeName unique (ContactTypeName)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.ContactType));
go

--Phone
create table dbo.Phone (
	PhoneId int identity not null
	,CountryCode smallint
	,AreaCode int
	,PhoneNumber int
	,Extension int
	,constraint pk_Phone_PhoneId primary key clustered (PhoneId)
	,constraint uq_Phone_PhoneNumber unique (CountryCode,AreaCode,PhoneNumber,Extension)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Phone));
go

--Person Phone
create table xwlk.PersonPhone (
	PersonId int
	,PhoneId int
	,ContactTypeId int
	,constraint pk_PersonPhone_PersonPhoneId primary key clustered (PersonId,PhoneId)
	,constraint fk_PersonPhone_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on update cascade
	,constraint fk_PersonPhone_PhoneId foreign key (PhoneId)
	references dbo.Phone (PhoneId)
	on update cascade
	,constraint fk_PersonPhone_ContactTypeId foreign key (ContactTypeId)
	references ref.ContactType (ContactTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonPhone));
go

--Location Phone
create table xwlk.LocationPhone (
	LocationId int
	,PhoneId int
	,ContactTypeId int
	,constraint pk_LocationPhone_LocationPhoneId primary key clustered (LocationId,PhoneId)
	,constraint fk_LocationPhone_LocationId foreign key (LocationId)
	references dbo.[Location] (LocationId)
	on update cascade
	,constraint fk_LocationPhone_PhoneId foreign key (PhoneId)
	references dbo.Phone (PhoneId)
	on update cascade
	,constraint fk_LocationPhone_ContactTypeId foreign key (ContactTypeId)
	references ref.ContactType (ContactTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.LocationPhone));
go

--Email
create table dbo.Email (
	EmailId int identity not null
	,Email varchar(255) not null
	,constraint pk_Email_EmailId primary key clustered (EmailId)
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.Email));
go

--Person Email
create table xwlk.PersonEmail (
	PersonId int
	,EmailId int
	,ContactTypeId int
	,constraint pk_PersonEmail_PersonEmailId primary key clustered (PersonId,EmailId)
	,constraint fk_PersonEmail_PersonId foreign key (PersonId)
	references dbo.Person (PersonId)
	on update cascade
	,constraint fk_PersonEmail_EmailId foreign key (EmailId)
	references dbo.Email (EmailId)
	on update cascade
	,constraint fk_PersonEmail_ContactTypeId foreign key (ContactTypeId)
	references ref.ContactType (ContactTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.PersonEmail));
go

--Location Email
create table xwlk.LocationEmail (
	LocationId int
	,EmailId int
	,ContactTypeId int
	,constraint pk_LocationEmail_LocationEmailId primary key clustered (LocationId,EmailId)
	,constraint fk_LocationEmail_LocationId foreign key (LocationId)
	references dbo.[Location] (LocationId)
	on update cascade
	,constraint fk_LocationEmail_EmailId foreign key (EmailId)
	references dbo.Email (EmailId)
	on update cascade
	,constraint fk_LocationEmail_ContactTypeId foreign key (ContactTypeId)
	references ref.ContactType (ContactTypeId)
	on delete set null
	on update cascade
	,ValidFrom datetime2 generated always as row start not null
	,ValidTo datetime2 generated always as row end not null
	,period for system_time (ValidFrom,ValidTo)
) with (system_versioning = on (history_table = hist.LocationEmail));
go

/***************
* CREATE VIEWS *
***************/

create or alter view dbo.vwPersonInfo as
select
	p.PersonId
	,p.NPI
	,p.IsProvider
	,ps.StatusCode
	,p.FirstName
	,p.MiddleName
	,p.LastName
	,p.DateOfBirth
	,p.Photo
	,p.Bio
	,p.Hyperlink
	,p.StartDate PersonStart
	,p.TermDate PersonTerm
	,pe.Institution
	,pe.Degree
	,pe.EffectiveDate
	,pc.CredentialCode
	,pc.CredentialDescription
	,pc.StartDate CredentialStart
	,pc.TermDate CredentialTerm
from dbo.Person p
left join ref.PersonStatus ps
	on ps.PersonStatusId=p.PersonStatusId
left join dbo.PersonEducation pe
	on pe.PersonId=p.PersonId
left join dbo.PersonCredential pc
	on pc.PersonId=p.PersonId;
go

create or alter view dbo.vwPracticeLocations as
select
	p.PracticeId
	,p.TIN PracticeTIN
	,p.NPI PracticeNPI
	,p.PracticeName
	,p.Website
	,p.StartDate PracticeStart
	,p.TermDate PracticeTerm
	,l.LocationId
	,l.TIN LocationTIN
	,l.NPI LocationNPI
	,l.LocationName
	,t.TeleHealthName
	,l.Street1
	,l.Street2
	,l.City
	,l.[State]
	,l.ZipCode
	,l.StartDate LocationStart
	,l.TermDate LocationTerm
from dbo.Practice p
left join dbo.[Location] l
	on l.PracticeId=p.PracticeId
left join ref.TeleHealth t
	on t.TeleHealthId=l.TeleHealthId;
go

create or alter view dbo.vwLocationSchedules as
select
	l.LocationId
	,l.LocationName
	,l.TIN
	,l.NPI
	,s.[DayOfWeek]
	,s.StartTime
	,s.EndTime
from dbo.[Location] l
left join dbo.LocationSchedule s
	on s.LocationId=l.LocationId;
go

create or alter view dbo.vwLocationSpecialties as
select
	l.LocationId
	,l.LocationName
	,l.TIN
	,l.NPI
	,s.SpecialtyName
	,s.SpecialtyDescription
	,st.SpecialtyTypeName
	,st.SpecialtyTypeDescription
from dbo.[Location] l
left join xwlk.LocationSpecialty ls
	on ls.LocationId=l.LocationId
left join ref.Specialty s
	on s.SpecialtyId=ls.SpecialtyId
left join ref.SpecialtyType st
	on st.SpecialtyTypeId=ls.SpecialtyTypeId;
go

create or alter view dbo.vwPersonSpecialties as
select
	p.PersonId
	,p.NPI
	,p.IsProvider
	,p.FirstName
	,p.MiddleName
	,p.LastName
	,s.SpecialtyName
	,s.SpecialtyDescription
	,st.SpecialtyTypeName
	,st.SpecialtyTypeDescription
from dbo.Person p
left join xwlk.PersonSpecialty ps
	on ps.PersonId=p.PersonId
left join ref.Specialty s
	on s.SpecialtyId=ps.SpecialtyId
left join ref.SpecialtyType st
	on st.SpecialtyTypeId=ps.SpecialtyTypeId;
go

create or alter view dbo.vwLocationPeople as
select
	l.LocationId
	,l.LocationName
	,l.TIN
	,l.NPI LocationNPI
	,p.PersonId
	,p.NPI PersonNPI
	,p.IsProvider
	,p.FirstName
	,p.MiddleName
	,p.LastName
	,r.RoleName
	,r.RoleDescription
from dbo.[Location] l
left join xwlk.LocationPeople lp
	on lp.LocationId=l.LocationId
left join dbo.Person p
	on p.PersonId=lp.PersonId
left join ref.[Role] r
	on r.RoleId=lp.RoleId;
go